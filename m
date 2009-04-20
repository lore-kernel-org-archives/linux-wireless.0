Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53376 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbZDTUPO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 16:15:14 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] [PATCH v2] [compat-2.6] Add include/linux/mmc/sdio_ids.h
Date: Mon, 20 Apr 2009 22:15:01 +0200
Message-Id: <1240258501-16789-1-git-send-email-hauke@hauke-m.de> (sfid-20090420_221520_339035_4F9C6B8F)
In-Reply-To: <43e72e890904161902x77b0505dh1696abbb32db7bbf@mail.gmail.com>
References: <43e72e890904161902x77b0505dh1696abbb32db7bbf@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sdio_ids.h only contains definitions, no structures. It is like the
linux/pci_ids.h file for SDIO devices.

If you do not like to include the file use this patch which adds the
needed definition to compat.h.

Hauke

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/compat/compat.h b/compat/compat.h
index 855a02c..f951a37 100644
--- a/compat/compat.h
+++ b/compat/compat.h
@@ -83,4 +83,16 @@ static inline void skb_queue_splice_tail_init(struct sk_buff_head *list,
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)) */
 
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30)) */
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31))
+
+#ifndef SDIO_DEVICE_ID_MARVELL_8688WLAN
+#define SDIO_DEVICE_ID_MARVELL_8688WLAN		0x9104
+#endif
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) */
+
 #endif /* LINUX_26_COMPAT_H */
-- 
1.6.2.1

