Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:32982 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbbJTGqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 02:46:35 -0400
Received: by lbbec13 with SMTP id ec13so5354770lbb.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 23:46:33 -0700 (PDT)
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes.Sorensen@redhat.com
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [RFC 16/16] rtl8xxxu: rtl8188eu: Implement parse_efuse()
Date: Tue, 20 Oct 2015 08:45:46 +0200
Message-Id: <1445323546-12807-17-git-send-email-jsitnicki@gmail.com> (sfid-20151020_084654_363585_5C6C6647)
In-Reply-To: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As opposed to the vendor driver (rtl8188eu), extract from efuse only
these TX power values that are going to be of use later on.

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 35 +++++++++++++++++++++++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 24 ++++++++++++++++
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 344161b..90da707 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1900,7 +1900,40 @@ static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
 
 static int rtl8188eu_parse_efuse(struct rtl8xxxu_priv *priv)
 {
-	return -EOPNOTSUPP; /* Not implemented */
+	struct rtl8188eu_efuse *efuse = &priv->efuse_wifi.efuse8188;
+	struct rtl8188eu_tx_power *tx_power = &priv->tx_power.tx_power8188;
+
+	if (efuse->rtl_id != cpu_to_le16(0x8129))
+		return -EINVAL;
+
+	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
+
+	memcpy(tx_power->cck_index_A,
+	       efuse->tx_power.cck_index_A,
+	       sizeof(tx_power->cck_index_A));
+
+	memcpy(tx_power->ht40_1s_index_A,
+	       efuse->tx_power.ht40_1s_index_A,
+	       sizeof(tx_power->ht40_1s_index_A));
+
+	memcpy(tx_power->ht20_ofdm_index_diff,
+	       efuse->tx_power.ht20_ofdm_index_diff,
+	       sizeof(tx_power->ht20_ofdm_index_diff));
+
+	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
+		 efuse->vendor_name);
+	dev_info(&priv->udev->dev, "Product: %.11s\n",
+		 efuse->device_name);
+
+	/* XXX: Do we need to read the rf_regulatory flag? */
+
+	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_EFUSE) {
+		print_hex_dump_bytes("rtl8xxxu: ", DUMP_PREFIX_OFFSET,
+				     priv->efuse_wifi.raw,
+				     sizeof(priv->efuse_wifi.raw));
+	}
+
+	return 0;
 }
 
 static int
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 79f47e3..ec49504 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -507,6 +507,22 @@ struct rtl8192cu_efuse {
 	u8 customer_id;
 };
 
+struct rtl8188eu_efuse {
+	__le16 rtl_id;
+	u8 res0[0x0e];
+	struct {						/* 0x10 */
+		u8 cck_index_A[6];
+		u8 ht40_1s_index_A[5];
+		struct nibble_pair ht20_ofdm_index_diff[1];
+	} tx_power;
+	u8 res1[0xbb];
+	u8 mac_addr[ETH_ALEN];					/* 0xd7 */
+	u8 res2[0x02];
+	u8 vendor_name[7];					/* 0xdf */
+	u8 res3[0x02];
+	u8 device_name[11];					/* 0xe8 */
+};
+
 struct rtl8xxxu_reg8val {
 	u16 reg;
 	u8 val;
@@ -587,6 +603,12 @@ struct rtl8723au_tx_power {
 	struct nibble_pair ht20_max_offset[3];
 };
 
+struct rtl8188eu_tx_power {
+	u8 cck_index_A[6];
+	u8 ht40_1s_index_A[5];
+	struct nibble_pair ht20_ofdm_index_diff[1];
+};
+
 struct rtl8xxxu_priv {
 	struct ieee80211_hw *hw;
 	struct usb_device *udev;
@@ -607,6 +629,7 @@ struct rtl8xxxu_priv {
 	char chip_name[8];
 	union {
 		struct rtl8723au_tx_power tx_power8723;
+		struct rtl8188eu_tx_power tx_power8188;
 	} tx_power;
 	u32 chip_cut:4;
 	u32 rom_rev:4;
@@ -659,6 +682,7 @@ struct rtl8xxxu_priv {
 		u8 raw[EFUSE_MAP_LEN];
 		struct rtl8723au_efuse efuse8723;
 		struct rtl8192cu_efuse efuse8192;
+		struct rtl8188eu_efuse efuse8188;
 	} efuse_wifi;
 	u32 adda_backup[RTL8XXXU_ADDA_REGS];
 	u32 mac_backup[RTL8XXXU_MAC_REGS];
-- 
2.1.0

