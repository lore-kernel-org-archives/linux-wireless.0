Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lekensteyn.nl ([178.21.112.251]:48083 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730AbaIPSYy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2014 14:24:54 -0400
From: Peter Wu <peter@lekensteyn.nl>
To: linux-wireless@vger.kernel.org,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] iwlwifi: add 4c70 subdevice ID for 7260 series
Date: Tue, 16 Sep 2014 19:39:46 +0200
Message-Id: <1410889186-28991-1-git-send-email-peter@lekensteyn.nl> (sfid-20140916_202458_505409_473C1DBB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This card appears in an Asus TP300LA laptop (from Chris Mens). lspci
output:

    02:00.0 Network controller [0280]: Intel Corporation Wireless 7260
[8086:08b1] (rev cb)
        Subsystem: Intel Corporation Device [8086:4c70]

Verified against v3.10.54 and v3.17-rc5-13-g2324067.

Cc: <stable@vger.kernel.org> # 3.10+
Tested-by: Peter Wu <peter@lekensteyn.nl>
Signed-off-by: Peter Wu <peter@lekensteyn.nl>
---
Hi,

Without patch the iwlwifi/iwldvm driver does not accept the 7260 AC card in an
Asus TP300LA laptop of a friend. Another report can be found on
<https://answers.launchpad.net/ubuntu/+source/gnome-nettool/+question/254548>.

By the way, initially I tried to write '8086 08b1 8086 4c70' (and also just the
first two words) to /sys/bus/pci/drivers/iwlwifi/new_id, and '0000:02:00.0' to
/sys/bus/pci/drivers/iwlwifi/bind, but I got EINVAL and ENODEV respectively.
Why did this not work?

Kind regards,
Peter
---
 drivers/net/wireless/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index f0e722c..eb83c89f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -297,6 +297,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x08B1, 0x4560, iwl7260_2n_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0x4370, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B2, 0x4360, iwl7260_2n_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0x4c70, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x5070, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x5072, iwl7260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x08B1, 0x5170, iwl7260_2ac_cfg)},
-- 
2.1.0

