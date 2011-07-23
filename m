Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54953 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1GWEqY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 00:46:24 -0400
Date: Sat, 23 Jul 2011 10:16:32 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	<ath9k-devel@venema.h4ckr.net>, <camilo@mesias.co.uk>,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Adrian Chadd <adrian@freebsd.org>
Subject: Re: [RFC/RFT 4/6] ath9k: use common PCIe ASPM definces instead of
 custom ones
Message-ID: <20110723044631.GA828@vmraj-lnx.users.atheros.com> (sfid-20110723_064634_502162_8BC236A4)
References: <1311341512-2882-1-git-send-email-sgruszka@redhat.com>
 <1311341512-2882-5-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1311341512-2882-5-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 22, 2011 at 03:31:50PM +0200, Stanislaw Gruszka wrote:
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/ath/ath9k/hw.h  |    4 ----
>  drivers/net/wireless/ath/ath9k/pci.c |   11 ++++++-----
>  2 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
> index 2f25577..3f941f0 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.h
> +++ b/drivers/net/wireless/ath/ath9k/hw.h
> @@ -1028,10 +1028,6 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning);
>  void ath9k_hw_proc_mib_event(struct ath_hw *ah);
>  void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan);
>  
> -#define ATH_PCIE_CAP_LINK_CTRL	0x70
> -#define ATH_PCIE_CAP_LINK_L0S	1
> -#define ATH_PCIE_CAP_LINK_L1	2
> -
>  #define ATH9K_CLOCK_RATE_CCK		22
>  #define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
>  #define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
> diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
> index 480e25b..29eba63 100644
> --- a/drivers/net/wireless/ath/ath9k/pci.c
> +++ b/drivers/net/wireless/ath/ath9k/pci.c
> @@ -16,6 +16,7 @@
>  
>  #include <linux/nl80211.h>
>  #include <linux/pci.h>
> +#include <linux/pci-aspm.h>
>  #include <linux/ath9k_platform.h>
>  #include "ath9k.h"
>  
> @@ -99,9 +100,9 @@ static void ath_pci_bt_coex_prep(struct ath_common *common)
>  	if (!pci_is_pcie(pdev))
>  		return;
>  
> -	pci_read_config_byte(pdev, ATH_PCIE_CAP_LINK_CTRL, &aspm);
> -	aspm &= ~(ATH_PCIE_CAP_LINK_L0S | ATH_PCIE_CAP_LINK_L1);
> -	pci_write_config_byte(pdev, ATH_PCIE_CAP_LINK_CTRL, aspm);
> +	pci_read_config_byte(pdev, PCI_EXP_LNKCTL, &aspm);
> +	aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
> +	pci_write_config_byte(pdev, PCI_EXP_LNKCTL, aspm);
>  }
>
There seems to be where address diff b/w ATH_PCIE_CAP_LINK_CTRL &
PCI_EXP_LNKCTL. It has to be like pcie_config_aspm_dev. Isn't it?

>  static void ath_pci_extn_synch_enable(struct ath_common *common)
> @@ -139,8 +140,8 @@ static void ath_pci_check_aspm(struct ath_softc *sc)
>  	if (WARN_ON(!parent))
>  		return;
>  
> -	pci_read_config_byte(parent, ATH_PCIE_CAP_LINK_CTRL, &aspm);
> -	if (aspm & (ATH_PCIE_CAP_LINK_L0S | ATH_PCIE_CAP_LINK_L1))
> +	pci_read_config_byte(parent, PCI_EXP_LNKCTL, &aspm);
Same as above.

--
Rajkumar
