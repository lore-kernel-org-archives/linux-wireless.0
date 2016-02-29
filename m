Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbcB2WF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:56 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 050/113] rtl8xxxu: Initial functionality to handle C2H events for 8723bu
Date: Mon, 29 Feb 2016 17:04:48 -0500
Message-Id: <1456783551-28315-51-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230845_136426_F332E739)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The 64 bit mailbox commands also provide a different method for
mailbox command responses (C2H events).

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 34 ++++++++++++++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 54 ++++++++++++++++++++++++
 2 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index b1b3e14..35e2522 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6815,6 +6815,36 @@ static int rtl8723bu_parse_rx_desc(struct rtl8xxxu_priv *priv,
 	return rx_type;
 }
 
+static void rtl8723bu_handle_c2h(struct rtl8xxxu_priv *priv,
+				 struct sk_buff *skb)
+{
+	struct rtl8723bu_c2h *c2h = (struct rtl8723bu_c2h *)skb->data;
+	struct device *dev = &priv->udev->dev;
+	int len;
+
+	len = skb->len - 2;
+
+	pr_info("%s: C2H ID %02x seq %02x, len %02x %02x\n", __func__,
+		c2h->id, c2h->seq, len, c2h->bt_info.response_source);
+
+	switch(c2h->id) {
+	case C2H_8723B_BT_INFO:
+		if (c2h->bt_info.response_source >
+		    BT_INFO_SRC_8723B_BT_ACTIVE_SEND)
+			dev_info(dev, "C2H_BT_INFO WiFi only firmware\n");
+		else
+			dev_info(dev, "C2H_BT_INFO BT/WiFi coexist firmware\n");
+
+		if (c2h->bt_info.bt_has_reset)
+			dev_info(dev, "BT has been reset\n");
+
+		break;
+	default:
+		pr_info("%s: Unhandled C2H event %02x\n", __func__, c2h->id);
+		break;
+	}
+}
+
 static void rtl8xxxu_rx_complete(struct urb *urb)
 {
 	struct rtl8xxxu_rx_urb *rx_urb =
@@ -6843,8 +6873,10 @@ static void rtl8xxxu_rx_complete(struct urb *urb)
 
 		if (rx_type == RX_TYPE_DATA_PKT)
 			ieee80211_rx_irqsafe(hw, skb);
-		else
+		else {
+			rtl8723bu_handle_c2h(priv, skb);
 			dev_kfree_skb(skb);
+		}
 
 		skb = NULL;
 		rx_urb->urb.context = NULL;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 4a3afe3..e4d5c4b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -899,6 +899,60 @@ struct h2c_cmd {
 	};
 };
 
+enum c2h_evt_8723b {
+	C2H_8723B_DEBUG = 0,
+	C2H_8723B_TSF = 1,
+	C2H_8723B_AP_RPT_RSP = 2,
+	C2H_8723B_CCX_TX_RPT = 3,
+	C2H_8723B_BT_RSSI = 4,
+	C2H_8723B_BT_OP_MODE = 5,
+	C2H_8723B_EXT_RA_RPT = 6,
+	C2H_8723B_BT_INFO = 9,
+	C2H_8723B_HW_INFO_EXCH = 10,
+	C2H_8723B_BT_MP_INFO = 11,
+	C2H_8723B_FW_DEBUG = 0xff,
+};
+
+enum bt_info_src_8723b {
+	BT_INFO_SRC_8723B_WIFI_FW = 0x0,
+        BT_INFO_SRC_8723B_BT_RSP = 0x1,
+        BT_INFO_SRC_8723B_BT_ACTIVE_SEND = 0x2,
+};
+
+struct rtl8723bu_c2h {
+	u8 id;
+	u8 seq;
+	union {
+		struct {
+			u8 payload[0];
+		} __packed raw;
+		struct {
+			u8 response_source:4;
+			u8 dummy0_0:4;
+
+			u8 bt_info;
+
+			u8 retry_count:4;
+			u8 dummy2_0:1;
+			u8 bt_page:1;
+			u8 tx_rx_mask:1;
+			u8 dummy2_2:1;
+
+			u8 rssi;
+
+			u8 basic_rate:1;
+			u8 bt_has_reset:1;
+			u8 dummy4_1:1;;
+			u8 ignore_wlan:1;
+			u8 auto_report:1;
+			u8 dummy4_2:3;
+
+			u8 a4;
+			u8 a5;
+		} __packed bt_info;
+	};
+};
+
 struct rtl8xxxu_fileops;
 
 struct rtl8xxxu_priv {
-- 
2.5.0

