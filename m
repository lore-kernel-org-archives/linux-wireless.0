Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58903 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758462Ab1CaQV6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 12:21:58 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/4] compat: fix build for kernel < 2.6.29
Date: Thu, 31 Mar 2011 18:21:34 +0200
Message-Id: <1301588495-16583-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1301588495-16583-1-git-send-email-hauke@hauke-m.de>
References: <1301588495-16583-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

get_irq_desc_chip(), get_irq_desc_data(), get_irq_desc_chip_data() and
get_irq_desc_msi() are not available in kernel < 2.6.29.

Luis please add this into the linux-2.6.39.y branch.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.39.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.39.h b/include/linux/compat-2.6.39.h
index 2c62d90..104fce0 100644
--- a/include/linux/compat-2.6.39.h
+++ b/include/linux/compat-2.6.39.h
@@ -71,6 +71,8 @@ static inline void irq_set_probe(unsigned int irq)
 {
 	set_irq_probe(irq);
 }
+
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
 static inline struct irq_chip *irq_desc_get_chip(struct irq_desc *desc)
 {
 	return get_irq_desc_chip(desc);
@@ -89,6 +91,7 @@ static inline struct msi_desc *irq_desc_get_msi_desc(struct irq_desc *desc)
 {
 	return get_irq_desc_msi(desc);
 }
+#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29)) */
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39)) */
 
-- 
1.7.1

