Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.unikorn.me ([176.9.143.13]:35956 "EHLO mail.unikorn.me"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751019AbeC0Ky1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 06:54:27 -0400
Message-ID: <1522148065.12122.5.camel@unikorn.me> (sfid-20180327_125431_196161_CD3BDF8A)
Subject: Re: [PATCH] iwlwifi: add device ID for Rivet Networks Killer
 Wireless-AC 1550
From: Izzy Kulbe <kernel@unikorn.me>
To: kvalo@codeaurora.org, luciano.coelho@intel.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Mar 2018 12:54:25 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nvm the last message, attached the wrong file using the 9270 instead of the 9260 firmware, which obviously wouldn't work. Here's the working patch:


Add support for Rivet Networks Killer Wireless-AC 1550 chipset, 
which is using the Intel Wireless-AC 9260 chip

Signed-off-by: Izzy Kulbe <kernel@unikorn.me>

---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c /drivers/net/wireless/intel/iwlwifi/pcie/drv.c
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -543,6 +543,7 @@ static const struct pci_device_id iwl_hw_card_ids[]
= {
 	{IWL_PCI_DEVICE(0x2526, 0x1210, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x1410, iwl9270_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x1420, iwl9460_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x2526, 0x1550, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x1610, iwl9270_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x4010, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x4030, iwl9560_2ac_cfg)},
