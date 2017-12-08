Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:52935 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751001AbdLHBAg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 20:00:36 -0500
Date: Fri, 8 Dec 2017 12:00:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ihab Zhaika <ihab.zhaika@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: linux-next: manual merge of the wireless-drivers-next tree with the
 wireless-drivers tree
Message-ID: <20171208120034.499e1a65@canb.auug.org.au> (sfid-20171208_020054_487789_428FCC22)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Today's linux-next merge of the wireless-drivers-next tree got a
conflict in:

  drivers/net/wireless/intel/iwlwifi/pcie/drv.c

between commit:

  567deca8e72d ("iwlwifi: add new cards for 9260 and 22000 series")

from the wireless-drivers tree and commit:

  2f7a3863191a ("iwlwifi: rename the temporary name of A000 to the official 22000")

from the wireless-drivers-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

-- 
Cheers,
Stephen Rothwell

diff --cc drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index ccd7c33c4c28,5ed89d7ac4b2..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@@ -652,20 -651,19 +652,20 @@@ static const struct pci_device_id iwl_h
  	{IWL_PCI_DEVICE(0xA370, 0x4034, iwl9560_2ac_cfg_soc)},
  	{IWL_PCI_DEVICE(0xA370, 0x40A4, iwl9462_2ac_cfg_soc)},
  
- /* a000 Series */
- 	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwla000_2ac_cfg_hr_cdb)},
- 	{IWL_PCI_DEVICE(0x34F0, 0x0310, iwla000_2ac_cfg_jf)},
- 	{IWL_PCI_DEVICE(0x2720, 0x0000, iwla000_2ax_cfg_hr)},
- 	{IWL_PCI_DEVICE(0x34F0, 0x0070, iwla000_2ax_cfg_hr)},
- 	{IWL_PCI_DEVICE(0x2720, 0x0078, iwla000_2ax_cfg_hr)},
- 	{IWL_PCI_DEVICE(0x2720, 0x0070, iwla000_2ac_cfg_hr_cdb)},
- 	{IWL_PCI_DEVICE(0x2720, 0x0030, iwla000_2ac_cfg_hr_cdb)},
- 	{IWL_PCI_DEVICE(0x2720, 0x1080, iwla000_2ax_cfg_hr)},
- 	{IWL_PCI_DEVICE(0x2720, 0x0090, iwla000_2ac_cfg_hr_cdb)},
- 	{IWL_PCI_DEVICE(0x2720, 0x0310, iwla000_2ac_cfg_hr_cdb)},
- 	{IWL_PCI_DEVICE(0x40C0, 0x0000, iwla000_2ax_cfg_hr)},
- 	{IWL_PCI_DEVICE(0x40C0, 0x0A10, iwla000_2ax_cfg_hr)},
- 	{IWL_PCI_DEVICE(0xA0F0, 0x0000, iwla000_2ax_cfg_hr)},
+ /* 22000 Series */
+ 	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwl22000_2ac_cfg_hr_cdb)},
+ 	{IWL_PCI_DEVICE(0x34F0, 0x0310, iwl22000_2ac_cfg_jf)},
+ 	{IWL_PCI_DEVICE(0x2720, 0x0000, iwl22000_2ax_cfg_hr)},
+ 	{IWL_PCI_DEVICE(0x34F0, 0x0070, iwl22000_2ax_cfg_hr)},
+ 	{IWL_PCI_DEVICE(0x2720, 0x0078, iwl22000_2ax_cfg_hr)},
+ 	{IWL_PCI_DEVICE(0x2720, 0x0070, iwl22000_2ac_cfg_hr_cdb)},
+ 	{IWL_PCI_DEVICE(0x2720, 0x0030, iwl22000_2ac_cfg_hr_cdb)},
+ 	{IWL_PCI_DEVICE(0x2720, 0x1080, iwl22000_2ax_cfg_hr)},
+ 	{IWL_PCI_DEVICE(0x2720, 0x0090, iwl22000_2ac_cfg_hr_cdb)},
+ 	{IWL_PCI_DEVICE(0x2720, 0x0310, iwl22000_2ac_cfg_hr_cdb)},
+ 	{IWL_PCI_DEVICE(0x40C0, 0x0000, iwl22000_2ax_cfg_hr)},
+ 	{IWL_PCI_DEVICE(0x40C0, 0x0A10, iwl22000_2ax_cfg_hr)},
++	{IWL_PCI_DEVICE(0xA0F0, 0x0000, iwl22000_2ax_cfg_hr)},
  
  #endif /* CONFIG_IWLMVM */
  
