Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50816 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1F2TQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 15:16:44 -0400
Date: Wed, 29 Jun 2011 15:02:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jon Mason <jdmason@kudzu.us>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 18/19] iwlwifi: remove unnecessary read of PCI_CAP_ID_EXP
Message-ID: <20110629190209.GB14425@tuxdriver.com> (sfid-20110629_211648_440092_A16C7E96)
References: <1309196969-16348-1-git-send-email-jdmason@kudzu.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1309196969-16348-1-git-send-email-jdmason@kudzu.us>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 27, 2011 at 12:49:29PM -0500, Jon Mason wrote:
> The PCIE capability offset is saved during PCI bus walking.  It will
> remove an unnecessary search in the PCI configuration space if this
> value is referenced instead of reacquiring it.
> 
> Signed-off-by: Jon Mason <jdmason@kudzu.us>
> ---
>  drivers/net/wireless/iwlwifi/iwl-pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
> index 7328fbf..60d9140 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-pci.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
> @@ -93,7 +93,7 @@ static u16 iwl_pciexp_link_ctrl(struct iwl_bus *bus)
>  	u16 pci_lnk_ctl;
>  	struct pci_dev *pci_dev = IWL_BUS_GET_PCI_DEV(bus);
>  
> -	pos = pci_find_capability(pci_dev, PCI_CAP_ID_EXP);
> +	pos = pci_pcie_cap(priv->pci_dev);
>  	pci_read_config_word(pci_dev, pos + PCI_EXP_LNKCTL, &pci_lnk_ctl);
>  	return pci_lnk_ctl;
>  }
> -- 
> 1.7.5.4

  CC [M]  drivers/net/wireless/iwlwifi/iwl-pci.o
drivers/net/wireless/iwlwifi/iwl-pci.c: In function ‘iwl_pciexp_link_ctrl’:
drivers/net/wireless/iwlwifi/iwl-pci.c:96:21: error: ‘priv’ undeclared (first use in this function)
drivers/net/wireless/iwlwifi/iwl-pci.c:96:21: note: each undeclared identifier is reported only once for each function it appears in
make[2]: *** [drivers/net/wireless/iwlwifi/iwl-pci.o] Error 1
make[1]: *** [drivers/net/wireless/iwlwifi] Error 2
make: *** [drivers/net/wireless/] Error 2

Please do make sure to compile patches before sending them to the list.

JOhn
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
