Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41363 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab1KILMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 06:12:48 -0500
Received: by wyh15 with SMTP id 15so1475415wyh.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Nov 2011 03:12:47 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: init CMD_TEMPL_KLV to sizeof(ieee80211_qos_hdr)
Date: Wed,  9 Nov 2011 13:12:45 +0200
Message-Id: <1320837165-11935-1-git-send-email-eliad@wizery.com> (sfid-20111109_121251_739193_F3694FA2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The keep alive template should have a max size of
sizeof(struct ieee80211_qos_hdr).

Additionally, Remove the redundant wl12xx_qos_null_data_template
struct.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/init.c         |    6 +++---
 drivers/net/wireless/wl12xx/wl12xx_80211.h |    5 -----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index c413abd..88891cd 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -65,7 +65,7 @@ int wl1271_init_templates_config(struct wl1271 *wl)
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_QOS_NULL_DATA, NULL,
 				      sizeof
-				      (struct wl12xx_qos_null_data_template),
+				      (struct ieee80211_qos_hdr),
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
@@ -114,8 +114,8 @@ int wl1271_init_templates_config(struct wl1271 *wl)
 
 	for (i = 0; i < CMD_TEMPL_KLV_IDX_MAX; i++) {
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_KLV, NULL,
-					      WL1271_CMD_TEMPL_DFLT_SIZE, i,
-					      WL1271_RATE_AUTOMATIC);
+					      sizeof(struct ieee80211_qos_hdr),
+					      i, WL1271_RATE_AUTOMATIC);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/drivers/net/wireless/wl12xx/wl12xx_80211.h b/drivers/net/wireless/wl12xx/wl12xx_80211.h
index f7971d3..8f0ffaf 100644
--- a/drivers/net/wireless/wl12xx/wl12xx_80211.h
+++ b/drivers/net/wireless/wl12xx/wl12xx_80211.h
@@ -116,11 +116,6 @@ struct wl12xx_ps_poll_template {
 	u8 ta[ETH_ALEN];
 } __packed;
 
-struct wl12xx_qos_null_data_template {
-	struct ieee80211_header header;
-	__le16 qos_ctl;
-} __packed;
-
 struct wl12xx_arp_rsp_template {
 	struct ieee80211_hdr_3addr hdr;
 
-- 
1.7.6.401.g6a319

