Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43139 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab0FMT5A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jun 2010 15:57:00 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: backport sdio_writeb_readb
Date: Sun, 13 Jun 2010 21:56:49 +0200
Message-Id: <1276459009-17168-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1276459009-17168-1-git-send-email-hauke@hauke-m.de>
References: <1276459009-17168-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed by wl1251_sdio.c
Use sdio_readb instead of sdio_writeb_readb as long as sdio_writeb_readb was not realy backported.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.35.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
index 886815d..c6e7136 100644
--- a/include/linux/compat-2.6.35.h
+++ b/include/linux/compat-2.6.35.h
@@ -23,6 +23,8 @@ static inline wait_queue_head_t *sk_sleep(struct sock *sk)
 	return sk->sk_sleep;
 }
 
+#define sdio_writeb_readb(func, write_byte, addr, err_ret) sdio_readb(func, addr, err_ret)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)) */
 
 #endif /* LINUX_26_35_COMPAT_H */
-- 
1.7.0.4

