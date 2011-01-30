Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42550 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1A3Bq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Jan 2011 20:46:26 -0500
Received: by iyj18 with SMTP id 18so3767105iyj.19
        for <linux-wireless@vger.kernel.org>; Sat, 29 Jan 2011 17:46:25 -0800 (PST)
From: Larry.Finger@lwfinger.net
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	'Zhaoming_Li' <chaoming_li@realsil.com.cn>
Subject: [PATCH] rtlwifi: Fix sparse messages
Date: Sat, 29 Jan 2011 19:46:47 -0600
Message-Id: <1296352007-27543-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>

Sparse yields the following messages:

drivers/net/wireless/rtlwifi/efuse.c:238:40: error: bad constant expression
drivers/net/wireless/rtlwifi/efuse.c:248:24: error: bad constant expression
drivers/net/wireless/rtlwifi/pci.c:1966:36: warning: incorrect type in argument 2 (different address spaces)
drivers/net/wireless/rtlwifi/pci.c:1966:36:    expected void [noderef] <asn:2>*<noident>
drivers/net/wireless/rtlwifi/pci.c:1966:36:    got void *<noident>
drivers/net/wireless/rtlwifi/pci.c:2018:36: warning: incorrect type in argument 2 (different address spaces)
drivers/net/wireless/rtlwifi/pci.c:2018:36:    expected void [noderef] <asn:2>*<noident>
drivers/net/wireless/rtlwifi/pci.c:2018:36:    got void *<noident>
drivers/net/wireless/rtlwifi/pci.h:272:54: warning: incorrect type in argument 2 (different address spaces)
drivers/net/wireless/rtlwifi/pci.h:272:54:    expected void volatile [noderef] <asn:2>*addr
drivers/net/wireless/rtlwifi/pci.h:272:54:    got unsigned char [usertype] *
drivers/net/wireless/rtlwifi/pci.h:278:54: warning: incorrect type in argument 2 (different address spaces)
drivers/net/wireless/rtlwifi/pci.h:278:54:    expected void volatile [noderef] <asn:2>*addr
drivers/net/wireless/rtlwifi/pci.h:278:54:    got unsigned char [usertype] *
drivers/net/wireless/rtlwifi/pci.h:284:54: warning: incorrect type in argument 2 (different address spaces)
drivers/net/wireless/rtlwifi/pci.h:284:54:    expected void volatile [noderef] <asn:2>*addr
drivers/net/wireless/rtlwifi/pci.h:284:54:    got unsigned char [usertype] *
drivers/net/wireless/rtlwifi/pci.h:257:62: warning: incorrect type in argument 1 (different address spaces)
drivers/net/wireless/rtlwifi/pci.h:257:62:    expected void const volatile [noderef] <asn:2>*addr
drivers/net/wireless/rtlwifi/pci.h:257:62:    got unsigned char [usertype] *
drivers/net/wireless/rtlwifi/pci.h:262:55: warning: incorrect type in argument 1 (different address spaces)
drivers/net/wireless/rtlwifi/pci.h:262:55:    expected void const volatile [noderef] <asn:2>*addr
drivers/net/wireless/rtlwifi/pci.h:262:55:    got unsigned char [usertype] *
drivers/net/wireless/rtlwifi/pci.h:267:55: warning: incorrect type in argument 1 (different address spaces)
drivers/net/wireless/rtlwifi/pci.h:267:55:    expected void const volatile [noderef] <asn:2>*addr
drivers/net/wireless/rtlwifi/pci.h:267:55:    got unsigned char [usertype] *

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: 'Zhaoming_Li' <chaoming_li@realsil.com.cn>
---

John,

This patch should be applied after "rtlwifi: rtl8192ce: Modify core for
inclusion of additional drivers" that I sent earlier today. This material
is for 2.6.39.

Thanks,

Larry
---
 drivers/net/wireless/rtlwifi/efuse.c |    4 ++--
 drivers/net/wireless/rtlwifi/pci.c   |    4 ++--
 drivers/net/wireless/rtlwifi/pci.h   |   12 ++++++------
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/efuse.c b/drivers/net/wireless/rtlwifi/efuse.c
index e48626e..4a64a80 100644
--- a/drivers/net/wireless/rtlwifi/efuse.c
+++ b/drivers/net/wireless/rtlwifi/efuse.c
@@ -235,7 +235,7 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
-	u8 efuse_tbl[rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]];
+	u8 efuse_tbl[256];
 	u8 rtemp8[1];
 	u16 efuse_addr = 0;
 	u8 offset, wren;
@@ -245,7 +245,7 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 		rtlpriv->cfg->maps[EFUSE_MAX_SECTION_MAP];
 	const u32 efuse_real_content_len =
 		rtlpriv->cfg->maps[EFUSE_REAL_CONTENT_SIZE];
-	u16 efuse_word[efuse_max_section][EFUSE_MAX_WORD_UNIT];
+	u16 efuse_word[32][4];
 	u16 efuse_utilized = 0;
 	u8 efuse_usage;
 
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 2a68284..4ebbbcf 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1965,7 +1965,7 @@ fail3:
 	ieee80211_free_hw(hw);
 
 	if (rtlpriv->io.pci_mem_start != 0)
-		pci_iounmap(pdev, (void *)rtlpriv->io.pci_mem_start);
+		pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);
 
 fail2:
 	pci_release_regions(pdev);
@@ -2017,7 +2017,7 @@ void rtl_pci_disconnect(struct pci_dev *pdev)
 	}
 
 	if (rtlpriv->io.pci_mem_start != 0) {
-		pci_iounmap(pdev, (void *)rtlpriv->io.pci_mem_start);
+		pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);
 		pci_release_regions(pdev);
 	}
 
diff --git a/drivers/net/wireless/rtlwifi/pci.h b/drivers/net/wireless/rtlwifi/pci.h
index e823c6b..d498e9a 100644
--- a/drivers/net/wireless/rtlwifi/pci.h
+++ b/drivers/net/wireless/rtlwifi/pci.h
@@ -254,34 +254,34 @@ int rtl_pci_resume(struct pci_dev *pdev);
 
 static inline u8 pci_read8_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
-	return 0xff & readb((u8 *) rtlpriv->io.pci_mem_start + addr);
+	return 0xff & readb((u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
 }
 
 static inline u16 pci_read16_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
-	return readw((u8 *) rtlpriv->io.pci_mem_start + addr);
+	return readw((u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
 }
 
 static inline u32 pci_read32_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
-	return readl((u8 *) rtlpriv->io.pci_mem_start + addr);
+	return readl((u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
 }
 
 static inline void pci_write8_async(struct rtl_priv *rtlpriv, u32 addr, u8 val)
 {
-	writeb(val, (u8 *) rtlpriv->io.pci_mem_start + addr);
+	writeb(val, (u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
 }
 
 static inline void pci_write16_async(struct rtl_priv *rtlpriv,
 				     u32 addr, u16 val)
 {
-	writew(val, (u8 *) rtlpriv->io.pci_mem_start + addr);
+	writew(val, (u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
 }
 
 static inline void pci_write32_async(struct rtl_priv *rtlpriv,
 				     u32 addr, u32 val)
 {
-	writel(val, (u8 *) rtlpriv->io.pci_mem_start + addr);
+	writel(val, (u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
 }
 
 static inline void rtl_pci_raw_write_port_ulong(u32 port, u32 val)
-- 
1.7.1

