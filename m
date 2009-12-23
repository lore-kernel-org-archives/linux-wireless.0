Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41938 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbZLWMV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 07:21:58 -0500
Message-Id: <20091223121416.544404600@sipsolutions.net>
Date: Wed, 23 Dec 2009 13:12:05 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	562016-quiet@bugs.debian.org
Subject: [PATCH 2.6.33 3/3] cfg80211: fix race between deauth and assoc
 response
References: <20091223121202.581948600@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joseph Nahmias reported, in http://bugs.debian.org/562016,
that he was getting the following warning (with some log
around the issue):

  ath0: direct probe to AP 00:11:95:77:e0:b0 (try 1)
  ath0: direct probe responded
  ath0: authenticate with AP 00:11:95:77:e0:b0 (try 1)
  ath0: authenticated
  ath0: associate with AP 00:11:95:77:e0:b0 (try 1)
  ath0: deauthenticating from 00:11:95:77:e0:b0 by local choice (reason=3)
  ath0: direct probe to AP 00:11:95:77:e0:b0 (try 1)
  ath0: RX AssocResp from 00:11:95:77:e0:b0 (capab=0x421 status=0 aid=2)
  ath0: associated
  ------------[ cut here ]------------
  WARNING: at net/wireless/mlme.c:97 cfg80211_send_rx_assoc+0x14d/0x152 [cfg80211]()
  Hardware name: 7658CTO
  ...
  Pid: 761, comm: phy0 Not tainted 2.6.32-trunk-686 #1
  Call Trace:
   [<c1030a5d>] ? warn_slowpath_common+0x5e/0x8a
   [<c1030a93>] ? warn_slowpath_null+0xa/0xc
   [<f86cafc7>] ? cfg80211_send_rx_assoc+0x14d/0x152
  ...
  ath0: link becomes ready
  ath0: deauthenticating from 00:11:95:77:e0:b0 by local choice (reason=3)
  ath0: no IPv6 routers present
  ath0: link is not ready
  ath0: direct probe to AP 00:11:95:77:e0:b0 (try 1)
  ath0: direct probe responded
  ath0: authenticate with AP 00:11:95:77:e0:b0 (try 1)
  ath0: authenticated
  ath0: associate with AP 00:11:95:77:e0:b0 (try 1)
  ath0: RX ReassocResp from 00:11:95:77:e0:b0 (capab=0x421 status=0 aid=2)
  ath0: associated

It is not clear to me how the first "direct probe" here
happens, but this seems to be a race condition, if the
user requests to deauth after requesting assoc, but before
the assoc response is received. In that case, it may
happen that mac80211 tries to report the assoc success to
cfg80211, but gets blocked on the wdev lock that is held
because the user is requesting the deauth.

The result is that we run into a warning. This is mostly
harmless, but maybe cause an unexpected event to be sent
to userspace; we'd send an assoc success event although
userspace was no longer expecting that.

To fix this, remove the warning and check whether the
race happened and in that case abort processing.

Reported-by: Joseph Nahmias <joe@nahmias.net>
Cc: stable@kernel.org
Cc: 562016-quiet@bugs.debian.org
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/mlme.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/wireless/mlme.c	2009-12-22 12:11:24.000000000 +0100
+++ wireless-testing/net/wireless/mlme.c	2009-12-22 12:26:26.000000000 +0100
@@ -93,7 +93,18 @@ void cfg80211_send_rx_assoc(struct net_d
 			}
 		}
 
-		WARN_ON(!bss);
+		/*
+		 * We might be coming here because the driver reported
+		 * a successful association at the same time as the
+		 * user requested a deauth. In that case, we will have
+		 * removed the BSS from the auth_bsses list due to the
+		 * deauth request when the assoc response makes it. If
+		 * the two code paths acquire the lock the other way
+		 * around, that's just the standard situation of a
+		 * deauth being requested while connected.
+		 */
+		if (!bss)
+			goto out;
 	} else if (wdev->conn) {
 		cfg80211_sme_failed_assoc(wdev);
 		/*


