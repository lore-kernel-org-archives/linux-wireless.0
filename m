Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10616 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1GWEvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 00:51:09 -0400
Date: Sat, 23 Jul 2011 10:21:01 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	<ath9k-devel@venema.h4ckr.net>, <camilo@mesias.co.uk>,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Adrian Chadd <adrian@freebsd.org>
Subject: Re: [RFC/RFT 5/6] ath9k: do btcoex ASPM disabling at initialization
 time
Message-ID: <20110723045100.GB828@vmraj-lnx.users.atheros.com> (sfid-20110723_065618_376990_F1B3F591)
References: <1311341512-2882-1-git-send-email-sgruszka@redhat.com>
 <1311341512-2882-6-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1311341512-2882-6-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 22, 2011 at 03:31:51PM +0200, Stanislaw Gruszka wrote:
> Disable ASPM in pci .probe, to do not change settings when
> pci_bus_sem is not held.
> 
> Disable ASPM on upstream (device) and downstream (PCIe port) component.
> According to e1000e driver authors this is required. I did not find that
> requirement in PCIe spec, but it seems to be logical for me.
> 
> This need to be fixed for CONFIG_PCIEASPM, that will be done later
> during merge common code into pcie core.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/ath/ath9k/hw.h   |    1 -
>  drivers/net/wireless/ath/ath9k/main.c |    2 -
>  drivers/net/wireless/ath/ath9k/pci.c  |   44 ++++++++++++++++++---------------
>  3 files changed, 24 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
> index 3f941f0..6abf26d 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.h
> +++ b/drivers/net/wireless/ath/ath9k/hw.h
> @@ -871,7 +871,6 @@ struct ath_bus_ops {
>  	enum ath_bus_type ath_bus_type;
>  	void (*read_cachesize)(struct ath_common *common, int *csz);
>  	bool (*eeprom_read)(struct ath_common *common, u32 off, u16 *data);
> -	void (*bt_coex_prep)(struct ath_common *common);
>  	void (*extn_synch_en)(struct ath_common *common);
>  };
>  
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 651f633..b0389c3 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1141,8 +1141,6 @@ static int ath9k_start(struct ieee80211_hw *hw)
>  					   AR_STOMP_LOW_WLAN_WGHT);
>  		ath9k_hw_btcoex_enable(ah);
>  
> -		if (common->bus_ops->bt_coex_prep)
> -			common->bus_ops->bt_coex_prep(common);
>  		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
>  			ath9k_btcoex_timer_resume(sc);
>  	}
> diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
> index 29eba63..835a50a 100644
> --- a/drivers/net/wireless/ath/ath9k/pci.c
> +++ b/drivers/net/wireless/ath/ath9k/pci.c
> @@ -88,23 +88,6 @@ static bool ath_pci_eeprom_read(struct ath_common *common, u32 off, u16 *data)
>  	return true;
>  }
>  
> -/*
> - * Bluetooth coexistance requires disabling ASPM.
> - */
> -static void ath_pci_bt_coex_prep(struct ath_common *common)
> -{
> -	struct ath_softc *sc = (struct ath_softc *) common->priv;
> -	struct pci_dev *pdev = to_pci_dev(sc->dev);
> -	u8 aspm;
> -
> -	if (!pci_is_pcie(pdev))
> -		return;
> -
> -	pci_read_config_byte(pdev, PCI_EXP_LNKCTL, &aspm);
> -	aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
> -	pci_write_config_byte(pdev, PCI_EXP_LNKCTL, aspm);
> -}
> -
>  static void ath_pci_extn_synch_enable(struct ath_common *common)
>  {
>  	struct ath_softc *sc = (struct ath_softc *) common->priv;
> @@ -120,11 +103,10 @@ static const struct ath_bus_ops ath_pci_bus_ops = {
>  	.ath_bus_type = ATH_PCI,
>  	.read_cachesize = ath_pci_read_cachesize,
>  	.eeprom_read = ath_pci_eeprom_read,
> -	.bt_coex_prep = ath_pci_bt_coex_prep,
>  	.extn_synch_en = ath_pci_extn_synch_enable,
>  };
>  
> -static void ath_pci_check_aspm(struct ath_softc *sc)
> +static void ath_pci_aspm_init(struct ath_softc *sc)
>  {
>  	struct ath_hw *ah = sc->sc_ah;
>  	struct pci_dev *pdev = to_pci_dev(sc->dev);
> @@ -137,6 +119,27 @@ static void ath_pci_check_aspm(struct ath_softc *sc)
>  		return;
>  
>  	parent = pdev->bus->self;
> +
> +	if (ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE) {
> +		/* Bluetooth coexistance requires disabling ASPM. */
> +		pci_read_config_byte(pdev, PCI_EXP_LNKCTL, &aspm);
> +		aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
> +		pci_write_config_byte(pdev, PCI_EXP_LNKCTL, aspm);
> +
> +		/*
> +		 * Both upstream and downstream PCIe components should
> +		 * have the same ASPM settings.
> +		 */
> +		if (WARN_ON(!parent))
> +			return;
> +
> +		pci_read_config_byte(parent, PCI_EXP_LNKCTL, &aspm);
> +		aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
> +		pci_write_config_byte(parent, PCI_EXP_LNKCTL, aspm);
> +
Why dont you use pci_disable_link_state instead?
> +		return;
> +	}
> +
>  	if (WARN_ON(!parent))
>  		return;
>  
> @@ -252,7 +255,8 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		goto err_init;
>  	}
>  
> -	ath_pci_check_aspm(sc);
> +	/* Need to be called after we discover hw capabilities */
> +	ath_pci_aspm_init(sc);
>  
>  	ath9k_hw_name(sc->sc_ah, hw_name, sizeof(hw_name));
>  	wiphy_info(hw->wiphy, "%s mem=0x%lx, irq=%d\n",
> -- 
> 1.7.1
> 
