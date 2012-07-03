Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61547 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2GCP03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 11:26:29 -0400
Message-ID: <4FF30F1A.9020606@qca.qualcomm.com> (sfid-20120703_172633_245150_452184FC)
Date: Tue, 3 Jul 2012 20:56:18 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
CC: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: [RFC] ath9k: Fix MCI cleanup
References: <1341328678-13824-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1341328678-13824-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 03 July 2012 08:47 PM, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>
> We are doing MCI cleanup eventhough BTCOEX is not enabled
> via module parameter. This means we do ath_mci_cleanup
> though we skipped calling ath_mci_setup. Yet it does not
> causes any issues now  as we free the DMA buffer allocated
> only when it is allocated during ath_mci_setup.
>
> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath9k/gpio.c |    4 +++-
>   1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
> index 5eac4d1..43557c2 100644
> --- a/drivers/net/wireless/ath/ath9k/gpio.c
> +++ b/drivers/net/wireless/ath/ath9k/gpio.c
> @@ -387,11 +387,13 @@ void ath9k_stop_btcoex(struct ath_softc *sc)
>
>   void ath9k_deinit_btcoex(struct ath_softc *sc)
>   {
> +	struct ath_hw *ah = sc->sc_ah;
> +
>           if ((sc->btcoex.no_stomp_timer)&&
>   	ath9k_hw_get_btcoex_scheme(sc->sc_ah) == ATH_BTCOEX_CFG_3WIRE)
>   		ath_gen_timer_free(sc->sc_ah, sc->btcoex.no_stomp_timer);
>
> -	if (AR_SREV_9462(sc->sc_ah))
> +	if (ath9k_hw_mci_is_enabled(ah))
>   		ath_mci_cleanup(sc);
>   }
>

also we unnecessarily call ar9003_mci_cleanup.

-- 
thanks,
shafi
