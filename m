Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51176 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1APFmX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 00:42:23 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so4401170wwa.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Jan 2011 21:42:23 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 02/10] wl12xx: AP-mode - fix race condition on sta connection
Date: Sun, 16 Jan 2011 07:42:06 +0200
Message-Id: <1295156534-4178-3-git-send-email-arik@wizery.com>
In-Reply-To: <1295156534-4178-1-git-send-email-arik@wizery.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a sta starts transmitting immediately after authentication, sometimes
the FW deauthenticates it. Fix this by marking the sta "in-connection"
in FW before sending the autentication response.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c |   25 +++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h |    9 +++++++++
 drivers/net/wireless/wl12xx/tx.c  |   19 +++++++++++++++++++
 3 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 646d278..1b5a371 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1391,3 +1391,28 @@ out:
 	kfree(acx);
 	return ret;
 }
+
+int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr)
+{
+	struct wl1271_acx_inconnection_sta *acx = NULL;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx set inconnaction sta %pM", addr);
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx)
+		return -ENOMEM;
+
+	memcpy(acx->addr, addr, ETH_ALEN);
+
+	ret = wl1271_cmd_configure(wl, ACX_UPDATE_INCONNECTION_STA_LIST,
+				   acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx set inconnaction sta failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 89d3748..4ea3378 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1083,6 +1083,13 @@ struct wl1271_acx_max_tx_retry {
 	u8 padding_1[2];
 } __packed;
 
+struct wl1271_acx_inconnection_sta {
+	struct acx_header header;
+
+	u8 addr[ETH_ALEN];
+	u8 padding1[2];
+} __packed;
+
 enum {
 	ACX_WAKE_UP_CONDITIONS      = 0x0002,
 	ACX_MEM_CFG                 = 0x0003,
@@ -1141,6 +1148,7 @@ enum {
 	ACX_COEX_ACTIVITY           = 0x0059,
 	ACX_SET_DCO_ITRIM_PARAMS    = 0x0061,
 	ACX_MAX_TX_FAILURE          = 0x0072,
+	ACX_UPDATE_INCONNECTION_STA_LIST = 0x0073,
 	DOT11_RX_MSDU_LIFE_TIME     = 0x1004,
 	DOT11_CUR_TX_PWR            = 0x100D,
 	DOT11_RX_DOT11_MODE         = 0x1012,
@@ -1211,5 +1219,6 @@ int wl1271_acx_set_ht_information(struct wl1271 *wl,
 				   u16 ht_operation_mode);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 int wl1271_acx_max_tx_retry(struct wl1271 *wl);
+int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index fdec4a3..d3ba27c 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -70,6 +70,22 @@ static void wl1271_free_tx_id(struct wl1271 *wl, int id)
 	}
 }
 
+static void wl1271_tx_ap_update_inconnection_sta(struct wl1271 *wl,
+					      struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr;
+
+	/*
+	 * add the station to the known list before broadcasting the
+	 * authentication response. this way it won't get de-authed by FW
+	 * when transmitting too soon.
+	 */
+	hdr = (struct ieee80211_hdr *)(skb->data +
+				       sizeof(struct wl1271_tx_hw_descr));
+	if (ieee80211_is_auth(hdr->frame_control))
+		wl1271_acx_set_inconnection_sta(wl, hdr->addr1);
+}
+
 static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 				u32 buf_offset)
 {
@@ -238,6 +254,9 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 	if (ret < 0)
 		return ret;
 
+	if (wl->bss_type == BSS_TYPE_AP_BSS)
+		wl1271_tx_ap_update_inconnection_sta(wl, skb);
+
 	wl1271_tx_fill_hdr(wl, skb, extra, info);
 
 	/*
-- 
1.7.1

