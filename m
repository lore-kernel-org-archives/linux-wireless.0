Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42733 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660Ab3CTAu4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 20:50:56 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3] mac80211:  Don't restart sta-timer if not associated.
Date: Tue, 19 Mar 2013 17:50:50 -0700
Message-Id: <1363740650-1626-1-git-send-email-greearb@candelatech.com> (sfid-20130320_015059_926495_E4689B53)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

I found another crash when deleting lots of virtual stations
in a congested environment.  I think the problem is that
the ieee80211_mlme_notify_scan_completed could call
ieee80211_restart_sta_timer for a stopped interface
that was about to be deleted.

With the following patch I am unable to reproduce the
crash.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
v3:  Just check for sdata-is-running once at top of method
  instead of worrying about if it is associated or not.

:100644 100644 aec786d... 74a8c5f... M	net/mac80211/mlme.c
 net/mac80211/mlme.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index aec786d..74a8c5f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2933,6 +2933,9 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 {
 	u32 flags;
 
+	if (!ieee80211_sdata_running(sdata))
+		return;
+
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		__ieee80211_stop_poll(sdata);
 
-- 
1.7.3.4

