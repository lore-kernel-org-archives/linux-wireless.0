Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44423 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab3DHI6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 04:58:45 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so5433336wgg.0
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 01:58:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365398445.32740.YahooMailNeo@web193504.mail.sg3.yahoo.com>
References: <CAJ-VmomdLY-APqZKTcW9GpfokkrPqDGVoTavj=wwjZpj_yL14A@mail.gmail.com>
	<515A0847.7000306@gmail.com>
	<1365088789.89181.YahooMailNeo@web193504.mail.sg3.yahoo.com>
	<CAJ-VmoksRR8Xd4wEM_obENyP1mFqbgKDm+DEjLS=W8WAPBPLRg@mail.gmail.com>
	<1365131280.68622.YahooMailNeo@web193506.mail.sg3.yahoo.com>
	<CAJ-VmokqjXqkJEN1cwgsOcJ7p8cvCsRxUG8Qc9gE8fWXaq+E0g@mail.gmail.com>
	<1365148844.61162.YahooMailNeo@web193503.mail.sg3.yahoo.com>
	<CAJ-VmonhbW06GU30S9oKYTEvbum2WbY63Y07tvS=ZQJcB6o+Dg@mail.gmail.com>
	<1365152761.13005.YahooMailNeo@web193505.mail.sg3.yahoo.com>
	<20830.46610.23754.783231@gargle.gargle.HOWL>
	<1365175482.75704.YahooMailNeo@web193505.mail.sg3.yahoo.com>
	<CAJ-VmomFi1fq6GY2dCpJCGN-sfmaH+FEu0V1nCjc7MymT6f3Rg@mail.gmail.com>
	<CAJ-Vmo=uvZbUtKE5Pk=saipVLRfmrU6jQeEvCg2kULP6F+d6cg@mail.gmail.com>
	<CAJ-VmomYF3ziqhykXMK5U+SJPYiNWmijdf0VhKDK33BVbSKNrQ@mail.gmail.com>
	<1365346495.79596.YahooMailNeo@web193506.mail.sg3.yahoo.com>
	<CAJ-VmomAYEXiDxC=RinVU-Ze85iESomT4Z+iOEErWkmc9Tw4SA@mail.gmail.com>
	<1365398445.32740.YahooMailNeo@web193504.mail.sg3.yahoo.com>
Date: Mon, 8 Apr 2013 01:58:43 -0700
Message-ID: <CAJ-VmomXWAE7H1AsCJWYkNLQqvtub=yZzeK=6N=8AXaN=JExdQ@mail.gmail.com> (sfid-20130408_105849_349103_690D2911)
Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

I'd first double-check that you've correctly configured the btactive
GPIO pin to be an input and the mux config makes it be BT_ACTIVE.

I can't really help you more than this right now; I haven't sat down
and actually tried this. :-(

But it doesn't look like much else needs to happen besides configuring
the GPIOs right, enabling BTCOEX and setting the weights.

Thanks,


Adrian

On 7 April 2013 22:20, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
> Hello Mr.Adrian & Mr.Sujith,
>     Started doing some experiments with different settings but there wasn't
> any good progress. Need your help further in analysis & recommendation,
> please. I monitor WLAN_ACTIVE (GPIO5) and BT_ACTIVE (GPIO6) on the
> oscilloscope. There were always a lot of pulse trains on WLAN_ACTIVE. On
> BT_ACTIVE, I initially pulled it high and also tested with a periodic pulse
> train (450ms On and 450ms Off). The following were the different settings
> with which I tested; the difference across each test case is marked in
> underline/bold:
>
> 1. In ath9k_hw_btcoex_enable_2wire(), I added the following code:
>     ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT, AR_STOMP_LOW_WLAN_WGHT);
>     REG_WRITE(ah, AR_BT_COEX_WEIGHT, btcoex_hw->bt_coex_weights);
>     Result: WLAN_ACTIVE pulse trains observed during BT_ACTIVE high.
>
> 2. In ath9k_hw_btcoex_enable_2wire(), I added the following code:
>     ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT, AR_STOMP_ALL_WLAN_WGHT);
>     REG_WRITE(ah, AR_BT_COEX_WEIGHT, btcoex_hw->bt_coex_weights);
>     Result: WLAN_ACTIVE pulse trains observed during BT_ACTIVE high.
>
> 3. In ath9k_hw_btcoex_enable_2wire(), I added the following code:
>     ath9k_hw_btcoex_set_weight(ah, 0xFFFF, 0x0000);
>     REG_WRITE(ah, AR_BT_COEX_WEIGHT, btcoex_hw->bt_coex_weights);
>     Result: WLAN_ACTIVE pulse trains observed during BT_ACTIVE high.
>
> In the next test cases, I realized that there are two registers
> (AR_BT_COEX_MODE, AR_BT_COEX_MODE2) for setting the coexistence mode. The
> following is the code and the test results:
>
> 4. In ath9k_hw_btcoex_enable_2wire(), I added the following code:
>     REG_WRITE(ah, AR_BT_COEX_MODE, btcoex_hw->bt_coex_mode);
>     REG_WRITE(ah, AR_BT_COEX_MODE2, btcoex_hw->bt_coex_mode);
>     ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT, AR_STOMP_LOW_WLAN_WGHT);
>     REG_WRITE(ah, AR_BT_COEX_WEIGHT, btcoex_hw->bt_coex_weights);
>     Result: WLAN_ACTIVE pulse trains observed during BT_ACTIVE high.
>
>
>     Result: WLAN_ACTIVE pulse trains observed during BT_ACTIVE high.
>
> 5.    Next I changed different enum for BT coex modes i.e ath_bt_mode.
> Changed from ATH_BT_COEX_MODE_SLOTTED, ATH_BT_COEX_MODE_UNSLOTTED and
> ATH_BT_COEX_MODE_LEGACY. I used again the above settings. But there still
> there were pulse trains observed.
>
> Please help to further solve these problems, please.
> Regards
> Sandeep Suresh.
> From: Adrian Chadd <adrian@freebsd.org>
> To: sandeep suresh <sandeep.suresh@yahoo.co.in>
> Cc: Sujith Manoharan <sujith@msujith.org>; ath9k-devel
> <ath9k-devel@lists.ath9k.org>; "linux-wireless@vger.kernel.org"
> <linux-wireless@vger.kernel.org>
> Sent: Sunday, 7 April 2013 11:16 PM
>
> Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
>
> On 7 April 2013 07:54, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
>> Hello Mr.Adrian and Mr.Sujith,
>>    Thanks for your responses. In order to ensure that all of us are on the
>> same page and referring to the same code base, some queries:
>>
>> 1. Please let me know you are referring to freebsd.org or
>> linuxwireless.org
>> drivers? Because you are referring to Kite & Kiwi which are in FreeBSD.
>>    FreeBSD --> http://svn.freebsd.org/base/head/sys/
>>    Ath9k --> http://linuxwireless.org/en/users/Drivers/ath9k
>>    Because currently I am using ath9k drivers only from linuxwireless.org.
>
> Kite = AR9285
> Kiwi = AR9287
>
> I know ath9k enough to be (somewhat) helpful and dangerous. But I'm
> the FreeBSD guy here; I know the HAL and FreeBSD code much better.
>
> The FreeBSD code is closer to what our reference driver does / did
> than Linux, at least for the legacy chipset support.
>
>> 2. Which version of ath9k driver is stable & complete from 2-wire/3-wire
>> coexistence? The reason for this query is that I downloaded
>> compat-wireless-3.6.8-1 which contains the function ath9k_start_btcoex()
>> in
>> which the Weight register is initialized. But this function is not
>> available
>> in some of the stable versions of ath9k which I am using.
>
> Not unsurprising. ath9k's btcoex code is (relatively) recent. it
> sounds like you've been using an older kernel.
>
>> 3. What exactly are Kite and Kiwi? Are these third party modules using
>> AR9287 Atheros chipsets? I did not see this in linuxwireless.org but only
>> in
>> FreeBSD.
>
> They're chip names. AR9285 = Kite, AR9287 = Kiwi.
>
>> 4. Just wanted to confirm if the address of the weight register that you
>> are
>> mentioning below for 2-wire coexistence is : AR_BT_COEX_WEIGHT (0x8174)
>
> Yup. That's what it is for AR5146 -> AR9287. AR9380 changed this.
>
>> 5. Just wanted to cross check if the weight register mentioned is for
>> 2-wire
>> coexistence? The reason for this doubt is I see bt_freq, bt_prio bits
>>    in BT weight register and these bits are relevant to BT_FREQUENCY and
>> BT_PRIORITY lines which are relevant for 3-wire coexistence?
>
> The weight register is still used. I just don't quite know what the
> table mapping is.
>
> But specifically, as you're effectively trying to implement "bluetooth
> stomps everything", what you really want is a table where bt wins each
> round, except perhaps for beacon interval (so you send out beacons
> reliably.) There should already be static stomp register values for
> "BT wins all" and "Wifi wins all." That's all you should need to write
> into that register.
>
>
>
>
> Adrian
>
>
