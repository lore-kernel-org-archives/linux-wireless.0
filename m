Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56954 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156Ab1EPRnk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 13:43:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] compat: backport rcu_dereference_protected
Date: Mon, 16 May 2011 19:43:35 +0200
Message-Id: <1305567815-73528-3-git-send-email-nbd@openwrt.org> (sfid-20110516_194350_560357_93FF7F8D)
In-Reply-To: <1305567815-73528-2-git-send-email-nbd@openwrt.org>
References: <1305567815-73528-1-git-send-email-nbd@openwrt.org>
 <1305567815-73528-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/linux/compat-2.6.34.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index f6ffde0..d1f9d80 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -246,6 +246,8 @@ static inline int usb_disable_autosuspend(struct usb_device *udev)
 #define MMC_PM_KEEP_POWER	(1 << 0)	/* preserve card power during suspend */
 #define sdio_set_host_pm_flags(a, b) 0
 
+#define rcu_dereference_protected(p, c) (p)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34)) */
 
 #endif /* LINUX_26_34_COMPAT_H */
-- 
1.7.3.2

