Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33552 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab2HFLGk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 07:06:40 -0400
Received: by eeil10 with SMTP id l10so781783eei.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 04:06:39 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] compat: backport PCIe register definitions
Date: Mon,  6 Aug 2012 14:06:33 +0300
Message-Id: <1344251193-18733-1-git-send-email-ozancag@gmail.com> (sfid-20120806_130643_932613_2DD9E421)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New DRM core in 3.6 needs these in order to detect the maximum
link speed of the underlying bus.

This backports:

	commit cdcac9cd7741af2c2b9255cbf060f772596907bb
	Author: Dave Airlie <airlied@redhat.com>
	Date:   Wed Jun 27 08:35:52 2012 +0100

	    pci_regs: define LNKSTA2 pcie cap + bits.

	    We need these for detecting the max link speed for drm drivers.

	    Acked-by: Bjorn Helgaas <bhelgass@google.com>
	    Signed-off-by: Dave Airlie <airlied@redhat.com>

[root@ozan linux-2.6]# git describe --contains cdcac9cd
v3.6-rc1~83^2~26

Trying kernel 3.5.0-030500-generic [OK]
Trying kernel 3.4.4-030404-generic [OK]
Trying kernel 3.3.7-030307-generic [OK]
Trying kernel 3.2.2-030202-generic [OK]
Trying kernel 3.1.10-030110-generic [OK]
Trying kernel 3.0.18-030018-generic [OK]
Trying kernel 2.6.39-02063904-generic [OK]
Trying kernel 2.6.38-02063808-generic [OK]
Trying kernel 2.6.37-02063706-generic [OK]
Trying kernel 2.6.36-02063604-generic [OK]
Trying kernel 2.6.35-02063512-generic [OK]
Trying kernel 2.6.34-02063410-generic [OK]
Trying kernel 2.6.33-02063305-generic [OK]
Trying kernel 2.6.32-02063255-generic [OK]
Trying kernel 2.6.31-02063113-generic [OK]
Trying kernel 2.6.30-02063010-generic [OK]
Trying kernel 2.6.29-02062906-generic [OK]
Trying kernel 2.6.28-02062810-generic [OK]
Trying kernel 2.6.27-020627-generic [OK]
Trying kernel 2.6.26-020626-generic [OK]
Trying kernel 2.6.25-020625-generic [OK]
Trying kernel 2.6.24-020624-generic [OK]

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 include/linux/compat-3.6.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/compat-3.6.h b/include/linux/compat-3.6.h
index 0b36ca0..466975b 100644
--- a/include/linux/compat-3.6.h
+++ b/include/linux/compat-3.6.h
@@ -5,6 +5,27 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(3,6,0))
 
+/**
+ * Backports
+ *
+ * commit cdcac9cd7741af2c2b9255cbf060f772596907bb
+ * Author: Dave Airlie <airlied@redhat.com>
+ * Date:   Wed Jun 27 08:35:52 2012 +0100
+ *
+ * 	pci_regs: define LNKSTA2 pcie cap + bits.
+ *
+ * 	We need these for detecting the max link speed for drm drivers.
+ *
+ * 	Acked-by: Bjorn Helgaas <bhelgass@google.com>
+ * 	Signed-off-by: Dave Airlie <airlied@redhat.com>
+ */
+
+#define  PCI_EXP_LNKCAP2 		44	/* Link Capability 2 */
+#define  PCI_EXP_LNKCAP2_SLS_2_5GB 	0x01	/* Current Link Speed 2.5GT/s */
+#define  PCI_EXP_LNKCAP2_SLS_5_0GB 	0x02	/* Current Link Speed 5.0GT/s */
+#define  PCI_EXP_LNKCAP2_SLS_8_0GB 	0x04	/* Current Link Speed 8.0GT/s */
+#define  PCI_EXP_LNKCAP2_CROSSLINK 	0x100 /* Crosslink supported */
+
 #include <net/genetlink.h>
 #include <linux/etherdevice.h>
 
-- 
1.7.10.4

