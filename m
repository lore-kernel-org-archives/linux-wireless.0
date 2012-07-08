Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52796 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2GHX1a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 19:27:30 -0400
Received: by lbbgm6 with SMTP id gm6so19003858lbb.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 16:27:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341585556-9992-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1341585556-9992-1-git-send-email-mohammed@qca.qualcomm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 9 Jul 2012 09:27:09 +1000
Message-ID: <CAGRGNgVpk4tk0aCyb77_jE4Dg6d_DRW5MzKacr0CTVZE+1O2sg@mail.gmail.com> (sfid-20120709_012734_450971_44EDA8DE)
Subject: Re: [PATCH v2 1/2] ath9k: Fix MCI cleanup
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohammed,

On Sat, Jul 7, 2012 at 12:39 AM, Mohammed Shafi Shajakhan
<mohammed@qca.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>
> We are doing MCI cleanup eventhough BTCOEX is not enabled
> via module parameter. This means we do ath_mci_cleanup
> though we skipped calling ath_mci_setup. Yet it does not
> causes any issues now  as we free the DMA buffer allocated
> only when it is allocated during ath_mci_setup.
>
> Reviewed-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/gpio.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
> index 5eac4d1..43557c2 100644
> --- a/drivers/net/wireless/ath/ath9k/gpio.c
> +++ b/drivers/net/wireless/ath/ath9k/gpio.c
> @@ -387,11 +387,13 @@ void ath9k_stop_btcoex(struct ath_softc *sc)
>
>  void ath9k_deinit_btcoex(struct ath_softc *sc)
>  {
> +       struct ath_hw *ah = sc->sc_ah;
> +

Why introduce a new variable if you only use it once?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
