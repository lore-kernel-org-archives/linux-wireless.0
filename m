Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:49046 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932417AbZFKKyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 06:54:25 -0400
Date: Thu, 11 Jun 2009 13:54:11 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Do not try to associate with an empty SSID
Message-ID: <20090611105411.GA13825@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks like some programs (e.g., NM) are setting an empty SSID with
SIOCSIWESSID in some cases. This seems to trigger mac80211 to try to
associate with an invalid configuration (wildcard SSID) which will
result in failing associations (or odd issues, potentially including
kernel panic with some drivers) if the AP were to actually accept this
anyway).

Only start association process if the SSID is actually set. This
speeds up connection with NM in number of cases and avoids sending out
broken association request frames.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/mlme.c |    8 ++++++++
 1 file changed, 8 insertions(+)

It is unclear when this was broken, but I think we need to get this into
2.6.31. The kernel panic (hopefully due to cleanup changes after 2.6.30)
can be worked around in the driver, I would assume, but it would be
better if we do not get into this odd state with associations since it
is not clear what various drivers will do with this kind of
configuration.


--- wireless-testing.orig/net/mac80211/mlme.c	2009-06-11 13:38:01.000000000 +0300
+++ wireless-testing/net/mac80211/mlme.c	2009-06-11 13:45:44.000000000 +0300
@@ -2436,6 +2436,14 @@ void ieee80211_sta_req_auth(struct ieee8
 	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
 		return;
 
+	if (ifmgd->ssid_len == 0) {
+		/*
+		 * Only allow association to be started if a valid SSID is
+		 * configured.
+		 */
+		return;
+	}
+
 	if ((ifmgd->flags & (IEEE80211_STA_BSSID_SET |
 			     IEEE80211_STA_AUTO_BSSID_SEL)) &&
 	    (ifmgd->flags & (IEEE80211_STA_SSID_SET |

-- 
Jouni Malinen                                            PGP id EFC895FA
