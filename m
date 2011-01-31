Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46371 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1AaLQl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 06:16:41 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so5465134fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 03:16:41 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 02/10] wl12xx: AP-mode - fix race condition on sta connection
Date: Mon, 31 Jan 2011 13:16:21 +0200
Message-Id: <1296472589-26401-3-git-send-email-arik@wizery.com>
In-Reply-To: <1296472589-26401-1-git-send-email-arik@wizery.com>
References: <1296472589-26401-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a sta starts transmitting immediately after authentication, sometimes
the FW deauthenticates it. Fix this by marking the sta "in-connection"
in FW before sending the autentication response.

The "in-connection" entry is automatically removed when connection
succeeds or after a timeout.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c |   25 +++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/acx.h |    9 +++++++++
 drivers/net/wireless/wl12xx/tx.c  |   19 +++++++++++++++++++
 3 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index afdc601..feba40a 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1476,3 +1476,28 @@ out:
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
index 4bbaf04..85f3c95 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -1136,6 +1136,13 @@ struct wl1271_acx_max_tx_retry {
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
@@ -1194,6 +1201,7 @@ enum {
 	ACX_COEX_ACTIVITY           = 0x0059,
 	ACX_SET_DCO_ITRIM_PARAMS    = 0x0061,
 	ACX_MAX_TX_FAILURE          = 0x0072,
+	ACX_UPDATE_INCONNECTION_STA_LIST = 0x0073,
 	DOT11_RX_MSDU_LIFE_TIME     = 0x1004,
 	DOT11_CUR_TX_PWR            = 0x100D,
 	DOT11_RX_DOT11_MODE         = 0x1012,
@@ -1269,5 +1277,6 @@ int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index, u16 ssn,
 				       bool enable);
 int wl1271_acx_tsf_info(struct wl1271 *wl, u64 *mactime);
 int wl1271_acx_max_tx_retry(struct wl1271 *wl);
+int wl1271_acx_set_inconnection_sta(struct wl1271 *wl, u8 *addr);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index ce9a19b..820f455 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -70,6 +70,22 @@ static void wl1271_free_tx_id(struct wl1271 *wl, int id)
 	}
 }
 
+static void wl1271_tx_ap_update_inconnection_sta(struct wl1271 *wl,
+						 struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr;
+
+	/*
+	 * add the station to the known list before transmitting the
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

