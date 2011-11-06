Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55261 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab1KFVZP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Nov 2011 16:25:15 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] comapt: add skb_frag_size() and hex_byte_pack()
Date: Sun,  6 Nov 2011 22:25:04 +0100
Message-Id: <1320614704-28855-2-git-send-email-hauke@hauke-m.de> (sfid-20111106_222520_636207_D5794B35)
In-Reply-To: <1320614704-28855-1-git-send-email-hauke@hauke-m.de>
References: <1320614704-28855-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.26.h |    3 +++
 include/linux/compat-3.2.h    |   12 ++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.26.h b/include/linux/compat-2.6.26.h
index 9a67e9d..177792a 100644
--- a/include/linux/compat-2.6.26.h
+++ b/include/linux/compat-2.6.26.h
@@ -447,6 +447,9 @@ static inline u64 div_u64(u64 dividend, u32 divisor)
 #endif
 /* source: include/math64.h */
 
+#define hex_asc_lo(x)	hex_asc((x) & 0x0f)
+#define hex_asc_hi(x)	hex_asc(((x) & 0xf0) >> 4)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,26)) */
 
 #endif /* LINUX_26_26_COMPAT_H */
diff --git a/include/linux/compat-3.2.h b/include/linux/compat-3.2.h
index 859a2e3..ceaaecc 100644
--- a/include/linux/compat-3.2.h
+++ b/include/linux/compat-3.2.h
@@ -60,6 +60,18 @@ static inline dma_addr_t skb_frag_dma_map(struct device *dev,
 
 #define ETH_P_TDLS	0x890D          /* TDLS */
 
+static inline unsigned int skb_frag_size(const skb_frag_t *frag)
+{
+	return frag->size;
+}
+
+static inline char *hex_byte_pack(char *buf, u8 byte)
+{
+	*buf++ = hex_asc_hi(byte);
+	*buf++ = hex_asc_lo(byte);
+	return buf;
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)) */
 
 #endif /* LINUX_3_2_COMPAT_H */
-- 
1.7.4.1

