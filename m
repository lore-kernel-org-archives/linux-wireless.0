Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48314 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab1ERXYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 19:24:36 -0400
Received: by iwn34 with SMTP id 34so1714226iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 16:24:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201105182025.05979.IvDoorn@gmail.com>
References: <201105182025.05979.IvDoorn@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 19 May 2011 09:24:15 +1000
Message-ID: <BANLkTim7MSG7NYJ8Kk7Nm=1V=bx=55z60Q@mail.gmail.com> (sfid-20110519_012439_609548_3911751F)
Subject: Re: [PATCH 1/7] rt2x00: Enable PA_PE bits in TX_PIN_CFG according to
 active band.
To: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gertjan, Ivo,

Minor nit

On Thu, May 19, 2011 at 04:25, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 93fb674..1cad89e 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -1795,8 +1795,10 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
>
>        /* Turn on unused PA or LNA when not using 1T or 1R */
>        if (rt2x00dev->default_ant.tx_chain_num == 2) {
> -               rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A1_EN, 1);
> -               rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN, 1);
> +               rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A1_EN,
> +                                  rf->channel > 14);
> +               rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN,
> +                                  rf->channel <= 14);

Aren't there better ways to determine the band from the channel?

I recall that there were some patches floating around relating to
supporting Japanese channels (802.11j ?) which (IIRC) use channel 14
in both bands - I'm not sure if this is applicable here, but would it
not be better to get the actual band from mac/cfg80211 and switch
based on that instead of on the channel number?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
