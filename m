Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60591 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1EWAa6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 20:30:58 -0400
Received: by qyk7 with SMTP id 7so563668qyk.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 May 2011 17:30:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DD63D65.5060308@create-net.org>
References: <BANLkTin6ettB1nhnrAjDncX1MrahfS4Z6g@mail.gmail.com> <4DD63D65.5060308@create-net.org>
From: Matteo Croce <matteo@openwrt.org>
Date: Mon, 23 May 2011 02:30:17 +0200
Message-ID: <BANLkTimJqQpimg3xZwORV89kukZcBVuhrQ@mail.gmail.com> (sfid-20110523_023102_316353_66C2CFE0)
Subject: Re: [PATCH 1/2]: mac80211: set tx rate and retries when injecting
To: Roberto Riggio <roberto.riggio@create-net.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/5/20 Roberto Riggio <roberto.riggio@create-net.org>:
> Shouldn't the patch bypass the rate control algo and specifically
> this piece of code in tx.c:
>
>    if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
>        CALL_TXH(ieee80211_tx_h_rate_ctrl);
>
> Thanks
>
> Il 20/05/2011 01:13, Matteo Croce ha scritto:
>>
>> Allow to set the tx rate and retries when injecting:
>> read the information from the radiotap header and populate the retry chain
>>
>> Signed-off-by: Matteo Croce<matteo@openwrt.org>
>>
>> --- a/net/mac80211/tx.c 2011-05-20 00:22:56.250640264 +0200
>> +++ b/net/mac80211/tx.c 2011-05-20 00:24:14.010640270 +0200
>> @@ -1092,6 +1092,44 @@
>>                                tx->flags |= IEEE80211_TX_FRAGMENTED;
>>                        break;
>>
>> +               case IEEE80211_RADIOTAP_RATE: {
>> +                       info->control.rates[0].idx = 0;
>> +                       if (*iterator.this_arg) {
>> +                               int i;
>> +                               for (i = 0; i<  sband->n_bitrates; i++)
>> +                                       if (sband->bitrates[i].bitrate ==
>> +                                               *iterator.this_arg * 5) {
>> +                                               info->control.rates[0].idx
>> = i;
>> +                                               break;
>> +                                       }
>> +                       }
>> +                       info->control.rates[0].flags = 0;
>> +                       info->control.rates[1].idx = -1;
>> +                       info->control.rates[2].idx = -1;
>> +                       info->control.rates[3].idx = -1;
>> +                       info->control.rates[4].idx = -1;
>> +                       break;
>> +               }
>> +
>> +               case IEEE80211_RADIOTAP_DATA_RETRIES:
>> +                       info->control.rates[0].count = *iterator.this_arg;
>> +                       break;
>> +
>> +               case IEEE80211_RADIOTAP_MCS: {
>> +                       u8 flags = iterator.this_arg[1];
>> +                       u8 mcs = iterator.this_arg[2];
>> +                       info->control.rates[0].idx = mcs;
>> +                       info->control.rates[0].flags |=
>> +                               IEEE80211_TX_RC_MCS;
>> +                       if (flags&  IEEE80211_RADIOTAP_MCS_BW_40)
>> +                               info->control.rates[0].flags |=
>> +                               IEEE80211_TX_RC_40_MHZ_WIDTH;
>> +                       if (flags&  IEEE80211_RADIOTAP_MCS_SGI)
>> +                               info->control.rates[0].flags |=
>> +                               IEEE80211_TX_RC_SHORT_GI;
>> +                       break;
>> +               }
>> +
>>                /*
>>                 * Please update the file
>>                 * Documentation/networking/mac80211-injection.txt
>> --- a/net/mac80211/ieee80211_i.h        2011-05-20 00:22:56.240640264
>> +0200
>> +++ b/net/mac80211/ieee80211_i.h        2011-05-20 00:24:14.010640270
>> +0200
>> @@ -1217,6 +1217,10 @@
>>        u8 padding_for_rate;
>>        __le16 tx_flags;
>>        u8 data_retries;
>> +       /*HT info*/
>> +       u8 ht_known;
>> +       u8 ht_flag;
>> +       u8 ht_mcs;
>>  } __packed;
>>
>>
>> --- a/net/wireless/radiotap.c   2011-05-20 00:22:56.270640264 +0200
>> +++ b/net/wireless/radiotap.c   2011-05-20 00:24:14.010640270 +0200
>> @@ -40,6 +40,7 @@
>>        [IEEE80211_RADIOTAP_TX_FLAGS] = { .align = 2, .size = 2, },
>>        [IEEE80211_RADIOTAP_RTS_RETRIES] = { .align = 1, .size = 1, },
>>        [IEEE80211_RADIOTAP_DATA_RETRIES] = { .align = 1, .size = 1, },
>> +       [IEEE80211_RADIOTAP_MCS] = { .align = 1, .size = 3, },
>>        /*
>>         * add more here as they are defined in radiotap.h
>>         */
>> --- a/include/net/mac80211.h    2011-05-20 00:22:56.210640264 +0200
>> +++ b/include/net/mac80211.h    2011-05-20 00:24:14.020640270 +0200
>> @@ -2278,7 +2278,7 @@
>>   * The TX headroom reserved by mac80211 for its own tx_status functions.
>>   * This is enough for the radiotap header.
>>   */
>> -#define IEEE80211_TX_STATUS_HEADROOM   13
>> +#define IEEE80211_TX_STATUS_HEADROOM   16
>>
>>  /**
>>   * ieee80211_sta_set_tim - set the TIM bit for a sleeping station
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> --------------------------------------------------------
> Roberto Riggio, Ph.D.
> CREATE-NET
> Network&  Security Solutions for Pervasive Computing Systems (iNSPIRE)
> Senior Researcher
> Via alla Cascata 56/D - 38123 Povo Trento (Italy)
> e-mail: roberto.riggio@create-net.org
> Tel: (+39) 0461 408400 - interno/extension 708
> Fax: (+39) 0461 421157
> www.create-net.org/~rriggio
> --------------------------------------------------------
>
> The information transmitted is intended only for the person or entity to
> which it is addressed and may contain confidential and/or privileged
> material. Any review, retransmission, dissemination or other use of, or
> taking of any action in reliance upon, this information by persons or
> entities other than the intended recipient is prohibited according to
> the Italian Law 196/2003 of the Legislature. If you received this in
> error, please contact the sender and delete the material from any
> computer.
>
> Le informazioni contenute in questo messaggio di posta elettronica e nei
> file allegati sono da considerarsi strettamente riservate. Il loro
> utilizzo e' consentito esclusivamente al destinatario del messaggio, per
> le finalita' indicate nel messaggio stesso. Qualora riceveste questo
> messaggio senza esserne il destinatario, Vi preghiamo cortesemente di
> darcene notizia via e-mail e di procedere alla cancellazione del
> messaggio stesso dal Vostro sistema. Trattenere il messaggio stesso,
> divulgarlo anche in parte, distribuirlo ad altri soggetti, copiarlo,
> od utilizzarlo per finalita' diverse, costituisce comportamento
> contrario ai principi dettati dal D. Lgs. 196/2003.
>
>

I'm not sure that the rate control is used in monitor mode

-- 
Matteo Croce
OpenWrt Developer
 _______                     ________        __
|       |.-----.-----.-----.|  |  |  |.----.|  |_
|   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
|_______||   __|_____|__|__||________||__|  |____|
         |__| W I R E L E S S   F R E E D O M
ATTITUDE ADJUSTMENT (bleeding edge) --------------
 * 1/4 oz Vodka      Pour all ingredents into mixing
 * 1/4 oz Gin        tin with ice, strain into glass.
 * 1/4 oz Amaretto
 * 1/4 oz Triple sec
 * 1/4 oz Peach schnapps
 * 1/4 oz Sour mix
 * 1 splash Cranberry juice
-----------------------------------------------------
