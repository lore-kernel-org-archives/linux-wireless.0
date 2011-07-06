Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60346 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab1GFH6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 03:58:14 -0400
Received: by wwe5 with SMTP id 5so6678179wwe.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 00:58:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110706023943.GA11178@vmraj-lnx.users.atheros.com>
References: <BANLkTikByepHZoEE2b65CrgUmpBmcxiTgw@mail.gmail.com>
	<BANLkTimUs65_Sw=pwF-J8gPjyrNcs2qnOw@mail.gmail.com>
	<20110701173237.GC7125@alittletooquiet.net>
	<20110704052410.GA1364@vmraj-lnx.users.atheros.com>
	<20110704095341.GA1380@vmraj-lnx.users.atheros.com>
	<20110705124914.GC26882@alittletooquiet.net>
	<CAD2nsn0-FQuo7bT3nb3jJLDe1XwbMw4J-Gr8qFkY5zzY1O-vxg@mail.gmail.com>
	<20110705143029.GA28091@alittletooquiet.net>
	<CAD2nsn1r7cW7KZ2W_z+SURHRpaTvuC_bd42yN9S+y9JrYMkS4w@mail.gmail.com>
	<20110705172022.GB28091@alittletooquiet.net>
	<20110706023943.GA11178@vmraj-lnx.users.atheros.com>
Date: Wed, 6 Jul 2011 03:58:13 -0400
Message-ID: <CAD2nsn0HFgm6Puuzuy4gghdDvpb05WaQtETS4=mfQ63mFzo--Q@mail.gmail.com> (sfid-20110706_095817_357403_73EB8DA1)
Subject: Re: ath9k_htc fails to initialize TL-WN721N with compat-wireless 3.0-rc4-1
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Forest Bond <forest@alittletooquiet.net>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Forest,
>
> To avoid multi reg writes please apply the following change
>
> diff --git a/drivers/net/wireless/ath/ath9k/wmi.h
> b/drivers/net/wireless/ath/ath9k/wmi.h
> index fde6da6..0878add 100644
> --- a/drivers/net/wireless/ath/ath9k/wmi.h
> +++ b/drivers/net/wireless/ath/ath9k/wmi.h
> @@ -124,7 +124,7 @@ enum wmi_event_id {
>        WMI_TXSTATUS_EVENTID,
>         };
>
>          -#define MAX_CMD_NUMBER 62
>          +#define MAX_CMD_NUMBER 1
>
>            struct register_write {
>                    __be32 reg;
> --

Hi Forest,

did you try in your system the simple hack Raj had suggested?
it seems to solve ths issue, but we encountered some soft lock ups due
to the LED stuff is moved to mac80211 with the recent code base,
we will take a look at this to fix this, probably requires some backporting.

in order to recreate the issue, we installed Ubuntu 8.04- the Hardy
Heron - released in April 2008.
as expected the issue is perfectly reproducible. thanks to Raj for his
help and suggestions.

*please obtain the stable compat-wireless-2.6.36-4
http://linuxwireless.org/en/users/Download/stable/#compat-wireless_2.6.36_stable_releases
*download the old firmware
http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=blob_plain;f=ar9271.fw;hb=HEAD
(history http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=history;f=ar9271.fw;h=d0ee74a1c8dccb7cc21f5be90f1d4048fa9dbf9e;hb=HEAD)
with this your USB card will be up and running, we did some basic testing.
*I used  usbmodeswitch-0.9.4

we also recommend you upgrade to latest kernel available for your distribution,
because we may still face some other issues as ath9k_htc very much new
compared to ath9k
please also read
http://wireless.kernel.org/en/users/Download/compat-wireless-old

-- 
shafi
