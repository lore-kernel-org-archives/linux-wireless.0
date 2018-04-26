Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14980 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753351AbeDZHz3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 03:55:29 -0400
Message-ID: <96cc315fceadadb2a8bc08376c0000dc2149264d.camel@intel.com> (sfid-20180426_095533_358574_1F0101E2)
Subject: Re: [PATCH v2 12/12] iwlwifi: pcie: remove non-responsive device
From: Luciano Coelho <luciano.coelho@intel.com>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Rajat Jain <rajatja@google.com>
Date: Thu, 26 Apr 2018 10:55:26 +0300
In-Reply-To: <20180426075345.22169-1-luca@coelho.fi>
References: <20180422082745.9743-10-luca@coelho.fi>
         <20180426075345.22169-1-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ooops, I obviously meant "PATCH v2 09/12" in the subject.

--
Luca.


On Thu, 2018-04-26 at 10:53 +0300, Luca Coelho wrote:
> From: Luca Coelho <luciano.coelho@intel.com>
> 
> If we fail to to grab NIC access because the device is not responding
> (i.e. CSR_GP_CNTRL returns 0xFFFFFFFF), remove the device from the
> PCI
> bus, to avoid any further damage, and to let the user space rescan.
> 
> In order to inform the userspace that a rescan is needed, we send a
> kobject uevent with "INACCESSIBLE".
> 
> This functionality is disabled by default, but can be enabled via a
> new module parameter called "remove_when_gone".  In the future we may
> change this module parameter to include 3 modes instead: do nothing;
> auto-rescan or; send uevent.
> 
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Signed-off-by: Rajat Jain <rajatja@google.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  6 ++
>  .../wireless/intel/iwlwifi/iwl-modparams.h    |  2 +
>  .../wireless/intel/iwlwifi/pcie/internal.h    |  5 ++
>  .../net/wireless/intel/iwlwifi/pcie/trans.c   | 74
> ++++++++++++++++++-
>  4 files changed, 84 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> index 4f451a6f20b9..c59ce4f8a5ed 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> @@ -1850,3 +1850,9 @@ MODULE_PARM_DESC(d0i3_timeout, "Timeout to D0i3
> entry when idle (ms)");
>  
>  module_param_named(disable_11ac, iwlwifi_mod_params.disable_11ac,
> bool, 0444);
>  MODULE_PARM_DESC(disable_11ac, "Disable VHT capabilities (default:
> false)");
> +
> +module_param_named(remove_when_gone,
> +		   iwlwifi_mod_params.remove_when_gone, bool,
> +		   0444);
> +MODULE_PARM_DESC(remove_when_gone,
> +		 "Remove dev from PCIe bus if it is deemed
> inaccessible (default: false)");
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
> b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
> index a41c46e63eb1..a7dd8a8cddf9 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
> @@ -122,6 +122,7 @@ enum iwl_uapsd_disable {
>   * @lar_disable: disable LAR (regulatory), default = 0
>   * @fw_monitor: allow to use firmware monitor
>   * @disable_11ac: disable VHT capabilities, default = false.
> + * @remove_when_gone: remove an inaccessible device from the PCIe
> bus.
>   */
>  struct iwl_mod_params {
>  	int swcrypto;
> @@ -143,6 +144,7 @@ struct iwl_mod_params {
>  	bool lar_disable;
>  	bool fw_monitor;
>  	bool disable_11ac;
> +	bool remove_when_gone;
>  };
>  
>  #endif /* #__iwl_modparams_h__ */
> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
> b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
> index cda66340d357..45ea32796cda 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
> @@ -383,6 +383,8 @@ struct iwl_self_init_dram {
>   * @hw_init_mask: initial unmasked hw causes
>   * @fh_mask: current unmasked fh causes
>   * @hw_mask: current unmasked hw causes
> + * @in_rescan: true if we have triggered a device rescan
> + * @scheduled_for_removal: true if we have scheduled a device
> removal
>   */
>  struct iwl_trans_pcie {
>  	struct iwl_rxq *rxq;
> @@ -464,6 +466,9 @@ struct iwl_trans_pcie {
>  	u32 fh_mask;
>  	u32 hw_mask;
>  	cpumask_t affinity_mask[IWL_MAX_RX_HW_QUEUES];
> +	u16 tx_cmd_queue_size;
> +	bool in_rescan;
> +	bool scheduled_for_removal;
>  };
>  
>  static inline struct iwl_trans_pcie *
> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> index 623476603cd4..6e9a9ecfb11c 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> @@ -75,6 +75,7 @@
>  #include <linux/gfp.h>
>  #include <linux/vmalloc.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/module.h>
>  
>  #include "iwl-drv.h"
>  #include "iwl-trans.h"
> @@ -1935,6 +1936,29 @@ static void iwl_trans_pcie_set_pmi(struct
> iwl_trans *trans, bool state)
>  		clear_bit(STATUS_TPOWER_PMI, &trans->status);
>  }
>  
> +struct iwl_trans_pcie_removal {
> +	struct pci_dev *pdev;
> +	struct work_struct work;
> +};
> +
> +static void iwl_trans_pcie_removal_wk(struct work_struct *wk)
> +{
> +	struct iwl_trans_pcie_removal *removal =
> +		container_of(wk, struct iwl_trans_pcie_removal,
> work);
> +	struct pci_dev *pdev = removal->pdev;
> +	char *prop[] = {"EVENT=INACCESSIBLE", NULL};
> +
> +	dev_err(&pdev->dev, "Device gone - attempting removal\n");
> +	kobject_uevent_env(&pdev->dev.kobj, KOBJ_CHANGE, prop);
> +	pci_lock_rescan_remove();
> +	pci_dev_put(pdev);
> +	pci_stop_and_remove_bus_device(pdev);
> +	pci_unlock_rescan_remove();
> +
> +	kfree(removal);
> +	module_put(THIS_MODULE);
> +}
> +
>  static bool iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans,
>  					   unsigned long *flags)
>  {
> @@ -1977,11 +2001,55 @@ static bool
> iwl_trans_pcie_grab_nic_access(struct iwl_trans *trans,
>  			   (BIT(trans->cfg->csr-
> >flag_mac_clock_ready) |
>  			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP),
> 15000);
>  	if (unlikely(ret < 0)) {
> -		iwl_trans_pcie_dump_regs(trans);
> -		iwl_write32(trans, CSR_RESET,
> CSR_RESET_REG_FLAG_FORCE_NMI);
> +		u32 cntrl = iwl_read32(trans, CSR_GP_CNTRL);
> +
>  		WARN_ONCE(1,
>  			  "Timeout waiting for hardware access
> (CSR_GP_CNTRL 0x%08x)\n",
> -			  iwl_read32(trans, CSR_GP_CNTRL));
> +			  cntrl);
> +
> +		iwl_trans_pcie_dump_regs(trans);
> +
> +		if (iwlwifi_mod_params.remove_when_gone && cntrl ==
> ~0U) {
> +			struct iwl_trans_pcie_removal *removal;
> +
> +			if (trans_pcie->scheduled_for_removal)
> +				goto err;
> +
> +			IWL_ERR(trans, "Device gone - scheduling
> removal!\n");
> +
> +			/*
> +			 * get a module reference to avoid doing
> this
> +			 * while unloading anyway and to avoid
> +			 * scheduling a work with code that's being
> +			 * removed.
> +			 */
> +			if (!try_module_get(THIS_MODULE)) {
> +				IWL_ERR(trans,
> +					"Module is being unloaded -
> abort\n");
> +				goto err;
> +			}
> +
> +			removal = kzalloc(sizeof(*removal),
> GFP_ATOMIC);
> +			if (!removal) {
> +				module_put(THIS_MODULE);
> +				goto err;
> +			}
> +			/*
> +			 * we don't need to clear this flag, because
> +			 * the trans will be freed and reallocated.
> +			*/
> +			trans_pcie->scheduled_for_removal = true;
> +
> +			removal->pdev = to_pci_dev(trans->dev);
> +			INIT_WORK(&removal->work,
> iwl_trans_pcie_removal_wk);
> +			pci_dev_get(removal->pdev);
> +			schedule_work(&removal->work);
> +		} else {
> +			iwl_write32(trans, CSR_RESET,
> +				    CSR_RESET_REG_FLAG_FORCE_NMI);
> +		}
> +
> +err:
>  		spin_unlock_irqrestore(&trans_pcie->reg_lock,
> *flags);
>  		return false;
>  	}
