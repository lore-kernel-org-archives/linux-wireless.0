Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:32563 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759034AbZJPM3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 08:29:05 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n9GCRKYX027080
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 15:27:35 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: kalle.valo@nokia.com, juuso.oikarinen@nokia.com
Subject: [RFC 2/3] wl1271: WIP - use operating BSSID for joining and disconnecting
Date: Fri, 16 Oct 2009 15:27:21 +0300
Message-Id: <1255696042-28413-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255696042-28413-1-git-send-email-luciano.coelho@nokia.com>
References: <1255696042-28413-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wl1271 firmware requires the BSSID on which we are interested
(ie. associating or associated with) to be passed in the join command, which
is also used to switch to different channels.  Unfortunately the wl1271 chip
doesn't have the concept of being listening to one channel without a specific
BSSID to listen to.

This patch uses the new IEEE80211_CONF_CHANGE_OPER_BSSID flag to find out
which BSSID we are associating with.  When the operating BSSID changes to
zero, we know that we have to disconnect.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   38 +++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 86132bb..3077509 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1114,10 +1114,12 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
 
-	wl1271_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d",
+	wl1271_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d "
+		     "bssid %pM",
 		     channel,
 		     conf->flags & IEEE80211_CONF_PS ? "on" : "off",
-		     conf->power_level);
+		     conf->power_level,
+		     conf->oper_bssid);
 
 	mutex_lock(&wl->mutex);
 
@@ -1141,6 +1143,27 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	if (ret < 0)
 		goto out_sleep;
 
+	if (changed & IEEE80211_CONF_CHANGE_OPER_BSSID) {
+		if (is_zero_ether_addr(conf->oper_bssid)) {
+			wl1271_debug(DEBUG_MAC80211, "gone to idle");
+
+			ret = wl1271_cmd_disconnect(wl);
+			if (ret < 0) {
+				wl1271_error("failed to disconnect");
+				goto out_sleep;
+			}
+			memset(wl->bssid, 0, ETH_ALEN);
+		} else if (memcmp(wl->bssid, conf->oper_bssid, ETH_ALEN)) {
+			wl1271_debug(DEBUG_MAC80211, "oper_bssid changed");
+
+			memcpy(wl->bssid, conf->oper_bssid, ETH_ALEN);
+
+			ret = wl1271_cmd_join(wl);
+			if (ret < 0)
+				goto out_sleep;
+		}
+	}
+
 	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested) {
 		wl1271_info("psm enabled");
 
@@ -1474,6 +1497,17 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
+	if ((changed & BSS_CHANGED_BSSID) &&
+	    memcmp(wl->bssid, bss_conf->bssid, ETH_ALEN)) {
+		wl1271_debug(DEBUG_MAC80211, "bssid changed");
+
+		memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
+
+		ret = wl1271_cmd_join(wl);
+		if (ret < 0)
+			goto out_sleep;
+	}
+
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
 			wl->aid = bss_conf->aid;
-- 
1.5.6.5

