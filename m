Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34392 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab1KUGGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 01:06:19 -0500
Received: by wwe5 with SMTP id 5so9870291wwe.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 22:06:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn0K6ALfXercrdtZ5LePPAoGR70kd+h4RxQqbRYr95wkmQ@mail.gmail.com>
References: <1321836540-5325-1-git-send-email-mar.kolya@gmail.com>
	<1321836540-5325-4-git-send-email-mar.kolya@gmail.com>
	<CAD2nsn0K6ALfXercrdtZ5LePPAoGR70kd+h4RxQqbRYr95wkmQ@mail.gmail.com>
Date: Mon, 21 Nov 2011 01:06:18 -0500
Message-ID: <CALGY4fuzgyrZw3mu9WjWMD9s5b3+tcu=RVMpqENxRkwTcyuQGg@mail.gmail.com> (sfid-20111121_070623_438178_F8C33992)
Subject: Re: [PATCH 3/4] ath9k: use config.enable_ani to check if ani should
 be performed
From: Nikolay Martynov <mar.kolya@gmail.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

2011/11/21 Mohammed Shafi <shafi.wireless@gmail.com>:
> instead of doing checks like the above , can we just prevent
> ath_ani_calibrate being not executed at all by doing something like
> this, please verify if i had missed something

 Please see my response to [PATCH 0/4].
 Before my patch the 'ath_ani_calibrate' was executed for all
devices. But for certain devices I think the intent was to not execute
'ath9k_hw_ani_monitor' ('ANI-ANI' from my previous email) and execute
everything else.
 Considering this your patch seems wrong since it'll disable
'ath_ani_calibrate' completely for certain devices.

 Please let me know if I'm missing something.
 Thanks.

>
> diff --git a/drivers/net/wireless/ath/ath9k/init.c
> b/drivers/net/wireless/ath/ath9k/init.c
> index e046de9..e0ebccd 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -500,7 +500,9 @@ static void ath9k_init_misc(struct ath_softc *sc)
>  {
>        struct ath_common *common = ath9k_hw_common(sc->sc_ah);
>        int i = 0;
> -       setup_timer(&common->ani.timer, ath_ani_calibrate, (unsigned long)sc);
> +
> +       if (sc->sc_ah->config.enable_ani)
> +               setup_timer(&common->ani.timer, ath_ani_calibrate,
> (unsigned long)sc);
>
>        sc->config.txpowlimit = ATH_TXPOWER_MAX;

--
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
