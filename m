Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10258 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab1GWFLX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 01:11:23 -0400
Date: Sat, 23 Jul 2011 10:41:30 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	<ath9k-devel@venema.h4ckr.net>, <camilo@mesias.co.uk>,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Adrian Chadd <adrian@freebsd.org>
Subject: Re: [RFC/RFT 6/6] ath9k: always initialize hw registers related to
 PCIe PM
Message-ID: <20110723051129.GC828@vmraj-lnx.users.atheros.com> (sfid-20110723_071127_664019_59FE3D84)
References: <1311341512-2882-1-git-send-email-sgruszka@redhat.com>
 <1311341512-2882-7-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1311341512-2882-7-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 22, 2011 at 03:31:52PM +0200, Stanislaw Gruszka wrote:
> We might not initialize registers if ah->aspm_enabled == false, assure
> we do this.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/ath/ath9k/hw.c  |    5 +----
>  drivers/net/wireless/ath/ath9k/pci.c |    4 ++++
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index 4ef7313..7084bb5 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -595,10 +595,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
>  
>  	ath9k_hw_init_mode_regs(ah);
>  
> -
> -	if (ah->is_pciexpress)
> -		ath9k_hw_configpcipowersave(ah, false);
> -	else
> +	if (!ah->is_pciexpress)
>  		ath9k_hw_disablepcie(ah);
>  
>  	if (!AR_SREV_9300_20_OR_LATER(ah))
> diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
> index 835a50a..d1c75ec 100644
> --- a/drivers/net/wireless/ath/ath9k/pci.c
> +++ b/drivers/net/wireless/ath/ath9k/pci.c
> @@ -118,6 +118,10 @@ static void ath_pci_aspm_init(struct ath_softc *sc)
>  	if (!pci_is_pcie(pdev))
>  		return;
>  
> +	/* initalize PCIe PM registers if device introduce itself as PCIe */
> +	if (ah->is_pciexpress)
> +		ath9k_hw_ops(ah)->config_pci_powersave(ah, false);
> +
Use ath9k_hw_configpcipowersave wrapper instead. And ensure that there is no
sideeffect by changing SERDES config from __ath9k_hw_init to pci_probe.

--
Rajkumar
>  	parent = pdev->bus->self;
>  
>  	if (ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE) {
> -- 
> 1.7.1
> 
