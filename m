Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:56749 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab1HFK4C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Aug 2011 06:56:02 -0400
Received: by mail-iy0-f170.google.com with SMTP id 16so5329995iye.1
        for <linux-wireless@vger.kernel.org>; Sat, 06 Aug 2011 03:56:02 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 2/2] rtlwifi: Remove raw read/write routines from header
Date: Sat,  6 Aug 2011 05:55:19 -0500
Message-Id: <1312628119-12640-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110806_125609_103478_1B6783CF)
In-Reply-To: <1312628119-12640-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1312628119-12640-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that the driver no longer uses the raw r/w routines, remove their definitions.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/pci.h |   26 --------------------------
 1 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.h b/drivers/net/wireless/rtlwifi/pci.h
index c53c620..a24e505 100644
--- a/drivers/net/wireless/rtlwifi/pci.h
+++ b/drivers/net/wireless/rtlwifi/pci.h
@@ -212,7 +212,6 @@ struct mp_adapter {
 	u16 pcibridge_vendorid;
 	u16 pcibridge_deviceid;
 
-	u32 pcicfg_addrport;
 	u8 num4bytes;
 
 	u8 pcibridge_pciehdr_offset;
@@ -273,29 +272,4 @@ static inline void pci_write32_async(struct rtl_priv *rtlpriv,
 	writel(val, (u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
 }
 
-static inline void rtl_pci_raw_write_port_ulong(u32 port, u32 val)
-{
-	outl(val, port);
-}
-
-static inline void rtl_pci_raw_write_port_uchar(u32 port, u8 val)
-{
-	outb(val, port);
-}
-
-static inline void rtl_pci_raw_read_port_uchar(u32 port, u8 *pval)
-{
-	*pval = inb(port);
-}
-
-static inline void rtl_pci_raw_read_port_ushort(u32 port, u16 *pval)
-{
-	*pval = inw(port);
-}
-
-static inline void rtl_pci_raw_read_port_ulong(u32 port, u32 *pval)
-{
-	*pval = inl(port);
-}
-
 #endif
-- 
1.7.3.4

