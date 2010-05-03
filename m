Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47666 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab0ECSgU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 14:36:20 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: backport usb_alloc_coherent() and  usb_free_coherent()
Date: Mon,  3 May 2010 20:36:13 +0200
Message-Id: <1272911773-18486-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.35.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
index 9132ecb..62c54cf 100644
--- a/include/linux/compat-2.6.35.h
+++ b/include/linux/compat-2.6.35.h
@@ -19,6 +19,8 @@ static inline wait_queue_head_t *sk_sleep(struct sock *sk)
 {
 	return sk->sk_sleep;
 }
+#define usb_alloc_coherent usb_buffer_alloc
+#define usb_free_coherent usb_buffer_free
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)) */
 
-- 
1.7.0.4

