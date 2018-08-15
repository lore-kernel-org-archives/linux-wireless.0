Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:7323 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726044AbeHOD0J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 23:26:09 -0400
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Subject: [PATCH 2/3] mac80211: Add support to notify ftm responder configuration to the driver
Date: Tue, 14 Aug 2018 17:30:17 -0700
Message-Id: <1534293018-4930-3-git-send-email-pradeepc@codeaurora.org> (sfid-20180815_023634_011709_97230FF7)
In-Reply-To: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
References: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New bss param ftm_responder is used to notify the driver to
enable or disable fine timing request (FTM) responder role in AP mode.

Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
---
 include/net/mac80211.h | 4 ++++
 net/mac80211/cfg.c     | 4 ++++
 net/mac80211/util.c    | 3 +++
 3 files changed, 11 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5790f55c241d..6593c611655b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -308,6 +308,8 @@ struct ieee80211_vif_chanctx_switch {
  * @BSS_CHANGED_KEEP_ALIVE: keep alive options (idle period or protected
  *	keep alive) changed.
  * @BSS_CHANGED_MCAST_RATE: Multicast Rate setting changed for this interface
+ * @BSS_CHANGED_FTM_RESPONDER: fime timing reasurement request responder
+ *	functionality changed for this BSS (AP mode).
  *
  */
 enum ieee80211_bss_change {
@@ -337,6 +339,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_MU_GROUPS		= 1<<23,
 	BSS_CHANGED_KEEP_ALIVE		= 1<<24,
 	BSS_CHANGED_MCAST_RATE		= 1<<25,
+	BSS_CHANGED_FTM_RESPONDER	= 1<<26,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -611,6 +614,7 @@ struct ieee80211_bss_conf {
 	bool allow_p2p_go_ps;
 	u16 max_idle_period;
 	bool protected_keep_alive;
+	int ftm_responder;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d25da0e66da1..75e314b826fb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -964,6 +964,10 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow |=
 					IEEE80211_P2P_OPPPS_ENABLE_BIT;
 
+	sdata->vif.bss_conf.ftm_responder = params->ftm_responder;
+	if (params->ftm_responder >= 0)
+		changed |= BSS_CHANGED_FTM_RESPONDER;
+
 	err = ieee80211_assign_beacon(sdata, &params->beacon, NULL);
 	if (err < 0) {
 		ieee80211_vif_release_channel(sdata);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 88efda7c9f8a..835fcf01fabc 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2076,6 +2076,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		case NL80211_IFTYPE_AP:
 			changed |= BSS_CHANGED_SSID | BSS_CHANGED_P2P_PS;
 
+			if (sdata->vif.bss_conf.ftm_responder >= 0)
+				changed |= BSS_CHANGED_FTM_RESPONDER;
+
 			if (sdata->vif.type == NL80211_IFTYPE_AP) {
 				changed |= BSS_CHANGED_AP_PROBE_RESP;
 
-- 
1.9.1
