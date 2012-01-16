Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45822 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab2APFIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 00:08:06 -0500
Received: by vcbfo1 with SMTP id fo1so818777vcb.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 Jan 2012 21:08:05 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH]  Add dma_zalloc_coherent to fix build with kernels older than 3.2
Date: Mon, 16 Jan 2012 00:07:55 -0500
Message-Id: <1326690475-9096-1-git-send-email-mar.kolya@gmail.com> (sfid-20120116_060814_048102_61835C73)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
---
 include/linux/compat-3.2.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-3.2.h b/include/linux/compat-3.2.h
index fb9ef68..a17c4ad 100644
--- a/include/linux/compat-3.2.h
+++ b/include/linux/compat-3.2.h
@@ -64,6 +64,15 @@ static inline char *hex_byte_pack(char *buf, u8 byte)
         module_driver(__platform_driver, platform_driver_register, \
                         platform_driver_unregister)
 
+static inline void *dma_zalloc_coherent(struct device *dev, size_t size,
+					dma_addr_t *dma_handle, gfp_t flag)
+{
+	void *ret = dma_alloc_coherent(dev, size, dma_handle, flag);
+	if (ret)
+		memset(ret, 0, size);
+	return ret;
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)) */
 
 #endif /* LINUX_3_2_COMPAT_H */
-- 
1.7.4.1

