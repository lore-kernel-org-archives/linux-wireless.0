Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46981 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab0FXVAM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 17:00:12 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: activate iwmc3200wifi and WL1271_SDIO
Date: Thu, 24 Jun 2010 23:00:05 +0200
Message-Id: <1277413205-6753-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1277413205-6753-1-git-send-email-hauke@hauke-m.de>
References: <1277413205-6753-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

netdev_ops for iwmc3200wifi is backported now.
CONFIG_WL1271_SDIO does not depend on ARM any more in mainline, but it
needs at least kernel 2.6.32.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/config.mk b/config.mk
index 04a6f7e..e8ec458 100644
--- a/config.mk
+++ b/config.mk
@@ -433,7 +433,7 @@ CONFIG_SSB_SDIOHOST=y
 CONFIG_B43_SDIO=y
 CONFIG_WL1251_SDIO=m
 
-ifneq ($(CONFIG_ARM),)
+ifndef CONFIG_COMPAT_KERNEL_32
 CONFIG_WL1271_SDIO=m
 endif
 
@@ -445,12 +445,8 @@ CONFIG_LIBERTAS_SDIO=m
 NEED_LIBERTAS=y
 endif
 
-# Activate iwmc3200wifi support only on kernel >= 2.6.29.
-# iwmc3200wifi uses new netdev_ops api no supported by old kernel.
-ifndef CONFIG_COMPAT_KERNEL_29
 CONFIG_IWM=m
 # CONFIG_IWM_DEBUG=y
-endif
 
 endif # end of SDIO driver list
 
-- 
1.7.0.4

