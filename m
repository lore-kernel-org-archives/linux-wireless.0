Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38194 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541Ab0KLTVg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 14:21:36 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: fix compile error with iwl
Date: Fri, 12 Nov 2010 20:21:25 +0100
Message-Id: <1289589685-16372-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1289589685-16372-1-git-send-email-hauke@hauke-m.de>
References: <1289589685-16372-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The header file declares the const.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/11-dev-pm-ops.patch |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index 8931276..6f00db8 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -178,7 +178,7 @@ calls on compat code with only slight modifications.
 +EXPORT_SYMBOL(iwl_pci_resume_compat);
 +#endif
 +
-+SIMPLE_DEV_PM_OPS(iwl_pm_ops, iwl_pci_suspend, iwl_pci_resume);
++const SIMPLE_DEV_PM_OPS(iwl_pm_ops, iwl_pci_suspend, iwl_pci_resume);
 +
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
  EXPORT_SYMBOL(iwl_pm_ops);
-- 
1.7.1

