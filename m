Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58250 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1KUFP6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 00:15:58 -0500
Received: by wwe5 with SMTP id 5so9799169wwe.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 21:15:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321836540-5325-4-git-send-email-mar.kolya@gmail.com>
References: <1321836540-5325-1-git-send-email-mar.kolya@gmail.com>
	<1321836540-5325-4-git-send-email-mar.kolya@gmail.com>
Date: Mon, 21 Nov 2011 10:45:55 +0530
Message-ID: <CAD2nsn0K6ALfXercrdtZ5LePPAoGR70kd+h4RxQqbRYr95wkmQ@mail.gmail.com> (sfid-20111121_061602_525018_A194CEAC)
Subject: Re: [PATCH 3/4] ath9k: use config.enable_ani to check if ani should
 be performed
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 21, 2011 at 6:18 AM, Nikolay Martynov <mar.kolya@gmail.com> wrote:
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 ++-
>  drivers/net/wireless/ath/ath9k/hw.c           |   12 ++++++++----
>  drivers/net/wireless/ath/ath9k/main.c         |    4 ++--
>  3 files changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> index 0b9a0e8..f8983fd 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> @@ -808,7 +808,8 @@ void ath9k_htc_ani_work(struct work_struct *work)
>        }
>
>        /* Verify whether we must check ANI */
> -       if ((timestamp - common->ani.checkani_timer) >= ATH_ANI_POLLINTERVAL) {
> +       if (sc->sc_ah->config.enable_ani
> +            && (timestamp - common->ani.checkani_timer) >= ATH_ANI_POLLINTERVAL) {
>                aniflag = true;
>                common->ani.checkani_timer = timestamp;
>        }
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index 662ab7e..d6a2568 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -504,10 +504,10 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
>                return ecode;
>        }
>
> -       if (!AR_SREV_9100(ah) && !AR_SREV_9340(ah)) {
> -               ath9k_hw_ani_setup(ah);
> -               ath9k_hw_ani_init(ah);
> -       }
> +        if (ah->config.enable_ani) {
> +                ath9k_hw_ani_setup(ah);
> +                ath9k_hw_ani_init(ah);
> +        }
>
>        return 0;
>  }
> @@ -610,6 +610,10 @@ static int __ath9k_hw_init(struct ath_hw *ah)
>        if (!AR_SREV_9300_20_OR_LATER(ah))
>                ah->ani_function &= ~ATH9K_ANI_MRC_CCK;
>
> +        //disable ANI for 9100 and 9340

please change the comment style to
/*
*disable ANI for AR9100 and AR9340
*/

> +        if (AR_SREV_9100(ah) || AR_SREV_9340(ah))
> +                ah->config.enable_ani = false;
> +
>        ath9k_hw_init_mode_regs(ah);
>
>        if (!ah->is_pciexpress)
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 9ce3dff..4653538 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -581,8 +581,8 @@ void ath_ani_calibrate(unsigned long data)
>        }
>
>        /* Verify whether we must check ANI */
> -       if ((timestamp - common->ani.checkani_timer) >=
> -            ah->config.ani_poll_interval) {
> +       if (sc->sc_ah->config.enable_ani
> +            && (timestamp - common->ani.checkani_timer) >= ah->config.ani_poll_interval) {
>                aniflag = true;
>                common->ani.checkani_timer = timestamp;
>        }

instead of doing checks like the above , can we just prevent
ath_ani_calibrate being not executed at all by doing something like
this, please verify if i had missed something

diff --git a/drivers/net/wireless/ath/ath9k/init.c
b/drivers/net/wireless/ath/ath9k/init.c
index e046de9..e0ebccd 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -500,7 +500,9 @@ static void ath9k_init_misc(struct ath_softc *sc)
 {
        struct ath_common *common = ath9k_hw_common(sc->sc_ah);
        int i = 0;
-       setup_timer(&common->ani.timer, ath_ani_calibrate, (unsigned long)sc);
+
+       if (sc->sc_ah->config.enable_ani)
+               setup_timer(&common->ani.timer, ath_ani_calibrate,
(unsigned long)sc);

        sc->config.txpowlimit = ATH_TXPOWER_MAX;



> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
