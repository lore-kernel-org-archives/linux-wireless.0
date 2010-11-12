Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47983 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932584Ab0KLXWu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 18:22:50 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: add missing rename for CONFIG_IWL4965
Date: Sat, 13 Nov 2010 00:22:39 +0100
Message-Id: <1289604160-13383-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/08-rename-iwl4965-config.patch |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/patches/08-rename-iwl4965-config.patch b/patches/08-rename-iwl4965-config.patch
index 32b7f59..d3bf221 100644
--- a/patches/08-rename-iwl4965-config.patch
+++ b/patches/08-rename-iwl4965-config.patch
@@ -39,6 +39,15 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
  iwlagn-$(CONFIG_IWL5000) += iwl-6000.o
 --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
+@@ -3969,7 +3969,7 @@ static int iwl_pci_probe(struct pci_dev
+ #ifdef CONFIG_IWL5000
+ 		iwlagn_hw_ops.hw_scan = NULL;
+ #endif
+-#ifdef CONFIG_IWL4965
++#ifdef CONFIG_COMPAT_IWL4965
+ 		iwl4965_hw_ops.hw_scan = NULL;
+ #endif
+ 	}
 @@ -4337,10 +4337,10 @@ static void __devexit iwl_pci_remove(str
  
  /* Hardware specific file defines the PCI IDs table for that hardware module */
-- 
1.7.1

