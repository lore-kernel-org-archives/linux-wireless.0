Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37631 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab0ECTgu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 15:36:50 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	proski@gnu.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2] compat: backport usb_alloc_coherent() and  usb_free_coherent()
Date: Mon,  3 May 2010 21:36:41 +0200
Message-Id: <1272915401-7431-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1272913838.2607.5.camel@mj>
References: <1272913838.2607.5.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 v2: Add arguments to define

 include/linux/compat-2.6.35.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
index 9132ecb..9c6e696 100644
--- a/include/linux/compat-2.6.35.h
+++ b/include/linux/compat-2.6.35.h
@@ -20,6 +20,9 @@ static inline wait_queue_head_t *sk_sleep(struct sock *sk)
 	return sk->sk_sleep;
 }
 
+#define usb_alloc_coherent(dev, size, mem_flags, dma) usb_buffer_alloc(dev, size, mem_flags, dma)
+#define usb_free_coherent(dev, size, addr, dma) usb_buffer_free(dev, size, addr, dma)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)) */
 
 #endif /* LINUX_26_35_COMPAT_H */
-- 
1.7.0.4

