Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54072 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751495AbeDXJok (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 05:44:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>,
        Rajat Jain <rajatja@google.com>
Subject: Re: [PATCH 09/12] iwlwifi: pcie: remove non-responsive device
References: <20180422082745.9743-1-luca@coelho.fi>
        <20180422082745.9743-10-luca@coelho.fi>
Date: Tue, 24 Apr 2018 12:44:32 +0300
In-Reply-To: <20180422082745.9743-10-luca@coelho.fi> (Luca Coelho's message of
        "Sun, 22 Apr 2018 11:27:42 +0300")
Message-ID: <87h8o1os5b.fsf@codeaurora.org> (sfid-20180424_114444_327139_57424F9D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Luca Coelho <luciano.coelho@intel.com>
>
> If we fail to to grab NIC access because the device is not responding
> (i.e. CSR_GP_CNTRL returns 0xFFFFFFFF), remove the device from the PCI
> bus, to avoid any further damage, and to let the user space rescan.
>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Signed-off-by: Rajat Jain <rajatja@google.com>

The commit log doesn't mention anything about the module parameter nor
about the kobject uevent.

> +static void iwl_trans_pcie_removal_wk(struct work_struct *wk)
> +{
> +	struct iwl_trans_pcie_removal *removal =
> +		container_of(wk, struct iwl_trans_pcie_removal, work);
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

So is the uevent some standard thing or what? At least grepping
INACCESSIBLE for didn't tell me anything.

-- 
Kalle Valo
