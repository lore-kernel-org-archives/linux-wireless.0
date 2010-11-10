Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65142 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab0KJCV4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:56 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5749qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:56 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 37/44] compat/2.6.2{7,8}: fix definition for IEEE80211_HT_CAP_DSSSCCK40
Date: Tue,  9 Nov 2010 21:20:19 -0500
Message-Id: <1289355626-25373-38-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.27.h |    3 ---
 include/linux/compat-2.6.28.h |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/compat-2.6.27.h b/include/linux/compat-2.6.27.h
index b9d7029..fa2dbd6 100644
--- a/include/linux/compat-2.6.27.h
+++ b/include/linux/compat-2.6.27.h
@@ -86,9 +86,6 @@ bool pci_pme_capable(struct pci_dev *dev, pci_power_t state);
 #define dma_mapping_error(pdev, dma_addr) dma_mapping_error(dma_addr)
 #define pci_dma_mapping_error(pdev, dma_addr) dma_mapping_error(pdev, dma_addr)
 
-/* This is from include/linux/ieee80211.h */
-#define IEEE80211_HT_CAP_DSSSCCK40		0x1000
-
 /* New link list changes added as of 2.6.27, needed for ath9k */
 
 static inline void __list_cut_position(struct list_head *list,
diff --git a/include/linux/compat-2.6.28.h b/include/linux/compat-2.6.28.h
index 1de39ad..4cd623b 100644
--- a/include/linux/compat-2.6.28.h
+++ b/include/linux/compat-2.6.28.h
@@ -234,6 +234,9 @@ extern void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page,
 extern int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 		       unsigned int cmd, unsigned long arg);
 
+/* This is from include/linux/ieee80211.h */
+#define IEEE80211_HT_CAP_DSSSCCK40		0x1000
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)) */
 
 #endif /* LINUX_26_28_COMPAT_H */
-- 
1.7.2.30.gc37d7.dirty

