Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0082.outbound.protection.outlook.com ([104.47.34.82]:40832
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754091AbeEaJLT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 05:11:19 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: [PATCH 2/6] qtnfmac: enable source MAC address randomization support
Date: Thu, 31 May 2018 12:10:58 +0300
Message-Id: <20180531091102.28666-3-sergey.matyukevich.os@quantenna.com> (sfid-20180531_111128_351013_F83CA3B5)
In-Reply-To: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
References: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrey Shevchenko <ashevchenko@quantenna.com>

Enable support for source MAC address randomization of probe request
frames. Pass addr/mask randomization parameters to firmware.

Signed-off-by: Andrey Shevchenko <ashevchenko@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c |  3 +++
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 25 +++++++++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 20 ++++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 220e2b710208..23366be9e394 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -1014,6 +1014,9 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 	if (hw_info->hw_capab & QLINK_HW_CAPAB_STA_INACT_TIMEOUT)
 		wiphy->features |= NL80211_FEATURE_INACTIVITY_TIMER;
 
+	if (hw_info->hw_capab & QLINK_HW_CAPAB_SCAN_RANDOM_MAC_ADDR)
+		wiphy->features |= NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
+
 	if (hw_info->hw_capab & QLINK_HW_CAPAB_REG_UPDATE) {
 		wiphy->regulatory_flags |= REGULATORY_STRICT_REG |
 			REGULATORY_CUSTOM_REG;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 5eb143667539..710806466bd9 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2234,6 +2234,22 @@ static void qtnf_cmd_channel_tlv_add(struct sk_buff *cmd_skb,
 	qchan->chan.flags = cpu_to_le32(flags);
 }
 
+static void qtnf_cmd_randmac_tlv_add(struct sk_buff *cmd_skb,
+				     const u8 *mac_addr,
+				     const u8 *mac_addr_mask)
+{
+	struct qlink_random_mac_addr *randmac;
+	struct qlink_tlv_hdr *hdr =
+		skb_put(cmd_skb, sizeof(*hdr) + sizeof(*randmac));
+
+	hdr->type = cpu_to_le16(QTN_TLV_ID_RANDOM_MAC_ADDR);
+	hdr->len = cpu_to_le16(sizeof(*randmac));
+	randmac = (struct qlink_random_mac_addr *)hdr->val;
+
+	memcpy(randmac->mac_addr, mac_addr, ETH_ALEN);
+	memcpy(randmac->mac_addr_mask, mac_addr_mask, ETH_ALEN);
+}
+
 int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
 {
 	struct sk_buff *cmd_skb;
@@ -2291,6 +2307,15 @@ int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
 		}
 	}
 
+	if (scan_req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
+		pr_debug("MAC%u: scan with random addr=%pM, mask=%pM\n",
+			 mac->macid,
+			 scan_req->mac_addr, scan_req->mac_addr_mask);
+
+		qtnf_cmd_randmac_tlv_add(cmd_skb, scan_req->mac_addr,
+					 scan_req->mac_addr_mask);
+	}
+
 	ret = qtnf_cmd_send(mac->bus, cmd_skb, &res_code);
 
 	if (unlikely(ret))
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index f85deda703fb..4a32967d0479 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -69,11 +69,14 @@ struct qlink_msg_header {
  *	associated STAs due to inactivity. Inactivity timeout period is taken
  *	from QLINK_CMD_START_AP parameters.
  * @QLINK_HW_CAPAB_DFS_OFFLOAD: device implements DFS offload functionality
+ * @QLINK_HW_CAPAB_SCAN_RANDOM_MAC_ADDR: device supports MAC Address
+ *	Randomization in probe requests.
  */
 enum qlink_hw_capab {
 	QLINK_HW_CAPAB_REG_UPDATE		= BIT(0),
 	QLINK_HW_CAPAB_STA_INACT_TIMEOUT	= BIT(1),
 	QLINK_HW_CAPAB_DFS_OFFLOAD		= BIT(2),
+	QLINK_HW_CAPAB_SCAN_RANDOM_MAC_ADDR	= BIT(3),
 };
 
 enum qlink_iface_type {
@@ -1089,6 +1092,7 @@ enum qlink_tlv_id {
 	QTN_TLV_ID_HW_ID		= 0x0405,
 	QTN_TLV_ID_CALIBRATION_VER	= 0x0406,
 	QTN_TLV_ID_UBOOT_VER		= 0x0407,
+	QTN_TLV_ID_RANDOM_MAC_ADDR	= 0x0408,
 };
 
 struct qlink_tlv_hdr {
@@ -1360,4 +1364,20 @@ struct qlink_sta_stats {
 	u8 rsvd[1];
 };
 
+/**
+ * struct qlink_random_mac_addr - data for QTN_TLV_ID_RANDOM_MAC_ADDR TLV
+ *
+ * Specifies MAC address mask/value for generation random MAC address
+ * during scan.
+ *
+ * @mac_addr: MAC address used with randomisation
+ * @mac_addr_mask: MAC address mask used with randomisation, bits that
+ *	are 0 in the mask should be randomised, bits that are 1 should
+ *	be taken from the @mac_addr
+ */
+struct qlink_random_mac_addr {
+	u8 mac_addr[ETH_ALEN];
+	u8 mac_addr_mask[ETH_ALEN];
+} __packed;
+
 #endif /* _QTN_QLINK_H_ */
-- 
2.11.0
