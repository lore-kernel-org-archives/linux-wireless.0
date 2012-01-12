Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:56662 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478Ab2ALUjB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 15:39:01 -0500
From: Antonio Quartulli <ordex@autistici.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH 1/2] mac80211: send the Auth frame in IBSS
Date: Thu, 12 Jan 2012 21:36:55 +0100
Message-Id: <1326400616-1109-1-git-send-email-ordex@autistici.org> (sfid-20120112_213919_225705_C035B8FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now in IBSS mode, each station sends a Auth frame each time it finds a new
station that is joining the IBSS

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---

This patch is based on the not yet committed patch
"mac80211: fix IBSS auth frame DA"


 net/mac80211/ibss.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 9b70689..a7564e3 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -289,6 +289,14 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta)
 		    addr, sdata->name);
 #endif
 
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+	printk(KERN_DEBUG "TX Auth SA=%pM DA=%pM BSSID=%pM"
+	       "(auth_transaction=1)\n", sdata->vif.addr,
+	       sdata->u.ibss.bssid, addr);
+#endif
+	ieee80211_send_auth(sdata, 1, WLAN_AUTH_OPEN, NULL, 0,
+			    addr, sdata->u.ibss.bssid, NULL, 0, 0);
+
 	sta_info_move_state(sta, IEEE80211_STA_AUTH);
 	sta_info_move_state(sta, IEEE80211_STA_ASSOC);
 	sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
-- 
1.7.3.4

