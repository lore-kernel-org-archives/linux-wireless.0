Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53320 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab0IBNdN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 09:33:13 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/4] compat-wireless: replace name CONFIG_IWLWIFI
Date: Thu,  2 Sep 2010 15:32:55 +0200
Message-Id: <1283434377-26210-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1283434377-26210-1-git-send-email-hauke@hauke-m.de>
References: <1283434377-26210-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 8c8113109f6916c4926413aa3416cefffaa5d9b8 one CONFIG_IWLWIFI
was not renamed to CONFIG_COMPAT_IWLWIFI.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/08-rename-iwl4965-config.patch |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/patches/08-rename-iwl4965-config.patch b/patches/08-rename-iwl4965-config.patch
index 28cd39e..7930bf3 100644
--- a/patches/08-rename-iwl4965-config.patch
+++ b/patches/08-rename-iwl4965-config.patch
@@ -3,6 +3,17 @@ module, but now it is directly included in the iwlagn.
 
 CONFIG_IWL4965 has to be set to y, to build correctly.
 
+--- a/drivers/net/wireless/Makefile
++++ b/drivers/net/wireless/Makefile
+@@ -40,7 +40,7 @@ obj-$(CONFIG_ADM8211)	+= adm8211.o
+ 
+ obj-$(CONFIG_MWL8K)	+= mwl8k.o
+ 
+-obj-$(CONFIG_IWLWIFI)	+= iwlwifi/
++obj-$(CONFIG_COMPAT_IWLWIFI)	+= iwlwifi/
+ obj-$(CONFIG_RT2X00)	+= rt2x00/
+ 
+ obj-$(CONFIG_P54_COMMON)	+= p54/
 --- a/drivers/net/wireless/iwlwifi/Makefile
 +++ b/drivers/net/wireless/iwlwifi/Makefile
 @@ -1,4 +1,4 @@
@@ -22,7 +33,7 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
  iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
 --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
-@@ -4450,10 +4450,10 @@ static void __devexit iwl_pci_remove(str
+@@ -4625,10 +4625,10 @@ static void __devexit iwl_pci_remove(str
  
  /* Hardware specific file defines the PCI IDs table for that hardware module */
  static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
-- 
1.7.0.4

