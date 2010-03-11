Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47362 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab0CKVdF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 16:33:05 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: backport PCMCIA_DEVICE_PROD_ID3
Date: Thu, 11 Mar 2010 22:32:43 +0100
Message-Id: <1268343167-2961-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1268343167-2961-1-git-send-email-hauke@hauke-m.de>
References: <1268343167-2961-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.34.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index d189bee..1cb3e06 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -155,6 +155,13 @@ static inline void device_unlock(struct device *dev)
 	up(&dev->sem);
 }
 
+#if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)
+#define PCMCIA_DEVICE_PROD_ID3(v3, vh3) { \
+	.match_flags = PCMCIA_DEV_ID_MATCH_PROD_ID3, \
+	.prod_id = { NULL, NULL, (v3), NULL },  \
+	.prod_id_hash = { 0, 0, (vh3), 0 }, }
+#endif
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34)) */
 
 #endif /* LINUX_26_34_COMPAT_H */
-- 
1.6.3.3

