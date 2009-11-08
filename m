Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35626 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554AbZKHW1c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 17:27:32 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/4] Fix two warnings
Date: Sun,  8 Nov 2009 23:27:09 +0100
Message-Id: <1257719231-2031-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1257719231-2031-1-git-send-email-hauke@hauke-m.de>
References: <1257719231-2031-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes these two warnings:
drivers/net/wireless/ath/ath5k/base.c:202: warning: ‘ath5k_pci_suspend_compat’ defined but not used
drivers/net/wireless/ath/ath5k/base.c:216: warning: ‘ath5k_pci_resume_compat’ defined but not used

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/patches/11-dev-pm-ops.patch |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/compat/patches/11-dev-pm-ops.patch b/compat/patches/11-dev-pm-ops.patch
index a1937a9..fc4de8f 100644
--- a/compat/patches/11-dev-pm-ops.patch
+++ b/compat/patches/11-dev-pm-ops.patch
@@ -14,7 +14,6 @@ calls on compat code with only slight modifications.
  static int		ath5k_pci_suspend(struct device *dev);
  static int		ath5k_pci_resume(struct device *dev);
 +#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
-+#endif
 +static int ath5k_pci_suspend_compat(struct pci_dev *pdev, pm_message_t state)
 +{
 +	int r;
@@ -40,6 +39,7 @@ calls on compat code with only slight modifications.
 +
 +	return ath5k_pci_resume(&pdev->dev);
 +}
++#endif
  
  SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend, ath5k_pci_resume);
  #define ATH5K_PM_OPS	(&ath5k_pm_ops)
-- 
1.6.3.3

