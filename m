Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33578 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2GBOWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 10:22:23 -0400
Received: by eaak11 with SMTP id k11so2110016eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jul 2012 07:22:22 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 1/5] compat: Make use of the vga_switcheroo_register_client
Date: Mon,  2 Jul 2012 17:22:10 +0300
Message-Id: <1341238934-30855-1-git-send-email-ozancag@gmail.com> (sfid-20120702_162227_253947_92565CA0)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If kernel version is older than 3.5, call vga_switcheroo_register_client
with the old parameters using a compat_ wrapper.

.reprobe was added in 2.6.38 so before that do not pass it to the
underlying vga_switcheroo_register_client() function.

Trying kernel  3.4.0-030400-generic [OK]
Trying kernel  3.3.7-030307-generic [OK]
Trying kernel  3.2.2-030202-generic [OK]
Trying kernel  3.1.10-030110-generic [OK]
Trying kernel  3.0.18-030018-generic [OK]
Trying kernel  2.6.39-02063904-generic [OK]
Trying kernel  2.6.38-02063808-generic [OK]
Trying kernel  2.6.37-02063706-generic [OK]
Trying kernel  2.6.36-02063604-generic [OK]
Trying kernel  2.6.35-02063512-generic [OK]
Trying kernel  2.6.34-02063410-generic [OK]
Trying kernel  2.6.33-02063305-generic [OK]
Trying kernel  2.6.32-02063255-generic [OK]
Trying kernel  2.6.31-02063113-generic [OK]
Trying kernel  2.6.30-02063010-generic [OK]
Trying kernel  2.6.29-02062906-generic [OK]
Trying kernel  2.6.28-02062810-generic [OK]
Trying kernel  2.6.27-020627-generic [OK]
Trying kernel  2.6.26-020626-generic [OK]
Trying kernel  2.6.25-020625-generic [OK]
Trying kernel  2.6.24-020624-generic [OK]

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 include/linux/compat-3.5.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/compat-3.5.h b/include/linux/compat-3.5.h
index 74c8176..7855ac9 100644
--- a/include/linux/compat-3.5.h
+++ b/include/linux/compat-3.5.h
@@ -93,6 +93,24 @@ struct vga_switcheroo_client_ops {
     void (*reprobe)(struct pci_dev *dev);
     bool (*can_switch)(struct pci_dev *dev);
 };
+
+/* Wrap around the old code and redefine vga_switcheroo_register_client()
+ * for older kernels < 3.5.0.
+ */
+static inline int compat_vga_switcheroo_register_client(struct pci_dev *dev,
+		const struct vga_switcheroo_client_ops *ops) {
+
+	return vga_switcheroo_register_client(dev,
+					      ops->set_gpu_state,
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,38))
+					      ops->reprobe,
+#endif
+					      ops->can_switch);
+}
+
+#define vga_switcheroo_register_client(_dev, _ops) \
+	compat_vga_switcheroo_register_client(_dev, _ops)
+
 #endif
 
 /*
-- 
1.7.10.4

