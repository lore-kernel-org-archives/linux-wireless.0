Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:39010 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751861AbeAZHrJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 02:47:09 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/10] rtlwifi: add efuse ops for other components
Date: Fri, 26 Jan 2018 15:46:43 +0800
Message-ID: <20180126074645.27201-9-pkshih@realtek.com> (sfid-20180126_084714_449571_92FA808C)
In-Reply-To: <20180126074645.27201-1-pkshih@realtek.com>
References: <20180126074645.27201-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The new component phydm need to access efuse content, so we prepare ops
for reference.

Signed-off-by: Tsang-Shian Lin <thlin@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/efuse.c | 13 +++++++++++++
 drivers/net/wireless/realtek/rtlwifi/efuse.h |  2 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c   |  1 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h  |  7 +++++++
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
index 35b50be633f1..fd13d4ef53b8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
@@ -50,6 +50,11 @@ static const struct efuse_map RTL8712_SDIO_EFUSE_TABLE[] = {
 	{11, 0, 0, 28}
 };
 
+static const struct rtl_efuse_ops efuse_ops = {
+	.efuse_onebyte_read = efuse_one_byte_read,
+	.efuse_logical_map_read = efuse_shadow_read,
+};
+
 static void efuse_shadow_read_1byte(struct ieee80211_hw *hw, u16 offset,
 				    u8 *value);
 static void efuse_shadow_read_2byte(struct ieee80211_hw *hw, u16 offset,
@@ -1364,3 +1369,11 @@ void rtl_fill_dummy(u8 *pfwbuf, u32 *pfwlen)
 	*pfwlen = fwlen;
 }
 EXPORT_SYMBOL_GPL(rtl_fill_dummy);
+
+void rtl_efuse_ops_init(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	rtlpriv->efuse.efuse_ops = &efuse_ops;
+}
+EXPORT_SYMBOL_GPL(rtl_efuse_ops_init);
diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.h b/drivers/net/wireless/realtek/rtlwifi/efuse.h
index 952fdc288f0e..dfa31c13fc7a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.h
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.h
@@ -116,5 +116,5 @@ void rtl_fill_dummy(u8 *pfwbuf, u32 *pfwlen);
 void rtl_fw_page_write(struct ieee80211_hw *hw, u32 page, const u8 *buffer,
 		       u32 size);
 void rtl_fw_block_write(struct ieee80211_hw *hw, const u8 *buffer, u32 size);
-
+void rtl_efuse_ops_init(struct ieee80211_hw *hw);
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 01ccf8884831..2437422625bf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2238,6 +2238,7 @@ int rtl_pci_probe(struct pci_dev *pdev,
 	rtlpriv->cfg = (struct rtl_hal_cfg *)(id->driver_data);
 	rtlpriv->intf_ops = &rtl_pci_ops;
 	rtlpriv->glb_var = &rtl_global_var;
+	rtl_efuse_ops_init(hw);
 
 	/* MEM map */
 	err = pci_request_regions(pdev, KBUILD_MODNAME);
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 2e9a20273a2d..0e8aae0c05c1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -1812,6 +1812,7 @@ struct rtl_dm {
 #define	EFUSE_MAX_LOGICAL_SIZE			512
 
 struct rtl_efuse {
+	const struct rtl_efuse_ops *efuse_ops;
 	bool autoLoad_ok;
 	bool bootfromefuse;
 	u16 max_physical_size;
@@ -1917,6 +1918,12 @@ struct rtl_efuse {
 	u8 channel_plan;
 };
 
+struct rtl_efuse_ops {
+	int (*efuse_onebyte_read)(struct ieee80211_hw *hw, u16 addr, u8 *data);
+	void (*efuse_logical_map_read)(struct ieee80211_hw *hw, u8 type,
+				       u16 offset, u32 *value);
+};
+
 struct rtl_tx_report {
 	atomic_t sn;
 	u16 last_sent_sn;
-- 
2.15.1
