Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38629 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab1HDSxR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2011 14:53:17 -0400
Date: Thu, 04 Aug 2011 13:53:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC] rtlwifi: Fix build failures due to raw port access
Message-ID: <4e3aea9b.T53ak5bZ1r+a9cJM%Larry.Finger@lwfinger.net> (sfid-20110804_205320_848803_16EAD2E6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When rtlwifi is built for the sh4 architecture, build errors of the following
type occur. As these raw port accesses are specific to the X86 architecture,
their usage is restricted and dummy routines are substituted for all other
platforms.

    v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:290: error: implicit declaration of function 'outl': 4 errors in 2 logs
    v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:295: error: implicit declaration of function 'outb': 4 errors in 2 logs
    v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:300: error: implicit declaration of function 'inb': 4 errors in 2 logs
    v3.0/sh4/sh-allmodconfig v3.0/sh4/sh-allyesconfig
src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h:305: error: implicit declaration of function 'inw': 4 errors in 2 logs

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.h
@@ -273,6 +273,7 @@ static inline void pci_write32_async(str
 	writel(val, (u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
 }
 
+#ifdef CONFIG_X86
 static inline void rtl_pci_raw_write_port_ulong(u32 port, u32 val)
 {
 	outl(val, port);
@@ -288,14 +289,29 @@ static inline void rtl_pci_raw_read_port
 	*pval = inb(port);
 }
 
-static inline void rtl_pci_raw_read_port_ushort(u32 port, u16 *pval)
+static inline void rtl_pci_raw_read_port_ulong(u32 port, u32 *pval)
+{
+	*pval = inl(port);
+}
+#else
+/* define dummy routines if not X86 architecture */
+static inline void rtl_pci_raw_write_port_ulong(u32 port, u32 val)
+{
+}
+
+static inline void rtl_pci_raw_write_port_uchar(u32 port, u8 val)
 {
-	*pval = inw(port);
+}
+
+static inline void rtl_pci_raw_read_port_uchar(u32 port, u8 *pval)
+{
+	*pval = 0;
 }
 
 static inline void rtl_pci_raw_read_port_ulong(u32 port, u32 *pval)
 {
-	*pval = inl(port);
+	*pval = 0;
 }
+#endif /* ifdef CONFIG_X86 */
 
 #endif
