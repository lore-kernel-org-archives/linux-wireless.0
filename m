Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab1HMSS2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 43/60] iwlagn: fix compile warnings when CONFIG_PM_SLEEP is not set
Date: Sat, 13 Aug 2011 10:38:19 -0700
Message-Id: <1313257116-2697-44-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201838_393198_EDB01DB5)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Halperin <dhalperi@cs.washington.edu>

  CC [M]  drivers/net/wireless/iwlwifi/iwl-pci.o
  drivers/net/wireless/iwlwifi/iwl-pci.c:506: warning: iwl_pci_suspend defined but not used
  drivers/net/wireless/iwlwifi/iwl-pci.c:519: warning: iwl_pci_resume defined but not used

These are only used if CONFIG_PM_SLEEP is enabled. CONFIG_PM depends
(CONFIG_PM_SLEEP || CONFIG_PM_RUNTIME), so it can be set without
CONFIG_PM_SLEEP selected.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 17f3fb2..62c35a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -506,7 +506,7 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 	iwl_pci_down(bus);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
 static int iwl_pci_suspend(struct device *device)
 {
-- 
1.7.0.4

