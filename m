Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8559 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2FKNRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 09:17:08 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20437.61328.931380.948942@gargle.gargle.HOWL> (sfid-20120611_151713_302463_3DC7E85B)
Date: Mon, 11 Jun 2012 18:46:00 +0530
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath9k: defer btcoex scheme update
In-Reply-To: <1339418354-1843-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1339418354-1843-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> As btcoex scheme updation might sleep, remove the function call
> from tasklet context and queue it up as a separate work.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
>  drivers/net/wireless/ath/ath9k/main.c  |    3 +++
>  drivers/net/wireless/ath/ath9k/mci.c   |   14 +++++++++++---
>  3 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index 02fc1c1..a8c0500 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -698,6 +698,7 @@ struct ath_softc {
>  #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
>  	struct ath_btcoex btcoex;
>  	struct ath_mci_coex mci_coex;
> +	struct work_struct mci_work;
>  #endif
>  
>  	struct ath_descdma txsdma;
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index e655f2a..c618414 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -188,6 +188,9 @@ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
>  
>  	ath9k_debug_samp_bb_mac(sc);
>  	ath9k_hw_disable_interrupts(ah);
> +#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
> +	cancel_work_sync(&sc->mci_work);
> +#endif

I think this should go inside __ath_cancel_work(), otherwise there is a
chance that this would not be cleaned up properly when stopping the
interface or unloading the driver.

Sujith
