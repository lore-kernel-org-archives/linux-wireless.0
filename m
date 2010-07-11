Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50749 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab0GKUXV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 16:23:21 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	philipp_subx@redfish-solutions.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: fix build of ath5k for CONFIG_PM_SLEEP=n
Date: Sun, 11 Jul 2010 22:23:11 +0200
Message-Id: <1278879791-12646-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

suspend and resume are activated in ath5k if CONFIG_PM_SLEEP is set and
not if just CONFIG_PM is set.

This should fix the problems reported by Philip Prindeville.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/11-dev-pm-ops.patch |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index 3e97ed9..688da84 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -49,7 +49,7 @@ calls on compat code with only slight modifications.
  	.remove		= __devexit_p(ath5k_pci_remove),
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
  	.driver.pm	= ATH5K_PM_OPS,
-+#elif defined(CONFIG_PM)
++#elif defined(CONFIG_PM_SLEEP)
 +	.suspend        = ath5k_pci_suspend_compat,
 +	.resume         = ath5k_pci_resume_compat,
 +#endif
-- 
1.7.0.4

