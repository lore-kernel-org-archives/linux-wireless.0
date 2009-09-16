Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:60383 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZIPNgT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 09:36:19 -0400
Received: by ewy2 with SMTP id 2so1417983ewy.17
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 06:36:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909161220.11538.hs4233@mail.mn-solutions.de>
References: <200909161220.11538.hs4233@mail.mn-solutions.de>
Date: Wed, 16 Sep 2009 16:36:20 +0300
Message-ID: <40f31dec0909160636j6a2022eaxdfef4889e6aafec@mail.gmail.com>
Subject: Re: question: ATH5K, antenna-mode and fall-throught in
	ath5k_hw_set_fast_div()
From: Nick Kossifidis <mickflemm@gmail.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/9/16 Holger Schurig <hs4233@mail.mn-solutions.de>:
> Hi !
>
> I have a device (fork-lift-terminal) where there is a PCCARD with
> an Atheros chip inside it. The PCCARD has an built-in antenna and
> a socket, where a cable goes to the external antenna.
>
> Using madwifi, I always did:
>
>        echo 2 >/proc/sys/dev/wifi0/rxantenna
>        echo 2 >/proc/sys/dev/wifi0/txantenna
>        echo 0 >/proc/sys/dev/wifi0/diversity
>
> Now, with ath5k I'm planning to do this:
>
> --- linux-wl.orig/drivers/net/wireless/ath/ath5k/base.c 2009-09-16 10:43:45.000000000 +0200
> +++ linux-wl/drivers/net/wireless/ath/ath5k/base.c      2009-09-16 10:44:10.000000000 +0200
> @@ -2850,5 +2850,5 @@ ath5k_config(struct ieee80211_hw *hw, u3
>         * then we must allow the user to set how many tx antennas we
>         * have available
>         */
> -       ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_DEFAULT);
> +       ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_FIXED_B);
>
>
> ... as long as there is no offical interface for setting antenna
> mode. A bit crude, but ... :-)
>

An official interface is on the way, until then that's indeed the way
to switch to a fixed antenna ;-)

>
> However, when looking for the antenna-related code-paths, I found
> this:
>
> ath5k_hw_set_fast_div(struct ath5k_hw *ah, u8 ee_mode, bool enable)
> {
>        switch (ee_mode) {
>        case AR5K_EEPROM_MODE_11G:
>                /* XXX: This is set to
>                 * disabled on initvals !!! */
>        case AR5K_EEPROM_MODE_11A:
>        ...
>
>
> In my case, ee_mode happens to be AR5K_EEPROM_MODE_11G, but I don't
> understand the implication of this comment. Is the XXX something
> to worry?  My card is a B/G only card, so I wonder if the
> fall-through into the MODE_11A case is ok ?!?
>

As you see there is no break there so we treat G and A modes (OFDM)
the same, comment is there to let developers know that
AR5K_PHY_AGCCTL_OFDM_DIV_DIS is already disabled on initvals for G
mode (however AR5K_PHY_FAST_ANT_DIV_EN is enabled so diversity is
enabled) but it doesn't seem to make a difference anyway.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
