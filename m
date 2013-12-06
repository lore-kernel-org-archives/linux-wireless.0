Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44088 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab3LFD2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 22:28:15 -0500
Received: by mail-pd0-f179.google.com with SMTP id r10so226392pdi.38
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 19:28:14 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Subject: [PATCH] wcn36xx: enable the beaconing in mesh mode
Date: Fri,  6 Dec 2013 11:28:02 +0800
Message-Id: <1386300482-3352-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20131206_042818_649550_BBD51130)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable the beaconing in wnc36xx by tweaking the tim offset and
force the use of AP-style beaconing. Otherwise, beaconing is not
working. The tim offset is set to 256. Otherwise, this will
overwrite mesh beacon submitted by mac80211.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index f8c3a10..19f43de 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1134,14 +1134,14 @@ int wcn36xx_smd_config_bss(struct wcn36xx *wcn, struct ieee80211_vif *vif,
 		/* STA */
 		bss->oper_mode = 1;
 		bss->wcn36xx_hal_persona = WCN36XX_HAL_STA_MODE;
-	} else if (vif->type == NL80211_IFTYPE_AP) {
+	} else if (vif->type == NL80211_IFTYPE_AP ||
+		   vif->type == NL80211_IFTYPE_MESH_POINT) {
 		bss->bss_type = WCN36XX_HAL_INFRA_AP_MODE;
 
 		/* AP */
 		bss->oper_mode = 0;
 		bss->wcn36xx_hal_persona = WCN36XX_HAL_STA_SAP_MODE;
-	} else if (vif->type == NL80211_IFTYPE_ADHOC ||
-		   vif->type == NL80211_IFTYPE_MESH_POINT) {
+	} else if (vif->type == NL80211_IFTYPE_ADHOC) {
 		bss->bss_type = WCN36XX_HAL_IBSS_MODE;
 
 		/* STA */
@@ -1291,7 +1291,11 @@ int wcn36xx_smd_send_beacon(struct wcn36xx *wcn, struct ieee80211_vif *vif,
 	memcpy(msg_body.bssid, vif->addr, ETH_ALEN);
 
 	/* TODO need to find out why this is needed? */
-	msg_body.tim_ie_offset = tim_off+4;
+	if (vif->type == NL80211_IFTYPE_MESH_POINT)
+		/* mesh beacon don't need this, so push further down */
+		msg_body.tim_ie_offset = 256;
+	else
+		msg_body.tim_ie_offset = tim_off+4;
 	msg_body.p2p_ie_offset = p2p_off;
 	PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
 
-- 
1.7.9.5

