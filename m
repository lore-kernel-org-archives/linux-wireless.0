Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f45.google.com ([209.85.210.45]:61599 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab3C3G1A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Mar 2013 02:27:00 -0400
Received: by mail-da0-f45.google.com with SMTP id v40so448332dad.32
        for <linux-wireless@vger.kernel.org>; Fri, 29 Mar 2013 23:27:00 -0700 (PDT)
Message-ID: <5156859D.4030003@gmail.com> (sfid-20130330_072716_889659_80206866)
Date: Sat, 30 Mar 2013 14:26:37 +0800
From: Shuduo Sang <sangshuduo@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] iwlwifi: add new pci id for 6x35 series
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

some new thinkpad laptops use intel chip with new pci id need be added
lspci -vnn output:
 Network controller [0280]: Intel Corporation Centrino Advanced-N 6235
 [8086:088f] (rev 24)
 Subsystem: Intel Corporation Device [8086:5260]

Signed-off-by: Shuduo Sang <sangshuduo@gmail.com>
---
 drivers/net/wireless/iwlwifi/pcie/drv.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c
b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 7bc0fb9..d088a1b 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -243,6 +243,7 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x088F, 0x4260, iwl6035_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x088E, 0x4460, iwl6035_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x088E, 0x4860, iwl6035_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x088F, 0x5260, iwl6035_2agn_cfg)},

 /* 105 Series */
 	{IWL_PCI_DEVICE(0x0894, 0x0022, iwl105_bgn_cfg)},
-- 
1.7.10.4

