Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:44471 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934183Ab3DGRqq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Apr 2013 13:46:46 -0400
Received: by mail-wg0-f53.google.com with SMTP id c11so5041947wgh.8
        for <linux-wireless@vger.kernel.org>; Sun, 07 Apr 2013 10:46:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365346495.79596.YahooMailNeo@web193506.mail.sg3.yahoo.com>
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
Date: Sun, 7 Apr 2013 10:46:45 -0700
Message-ID: <CAJ-VmomAYEXiDxC=RinVU-Ze85iESomT4Z+iOEErWkmc9Tw4SA@mail.gmail.com> (sfid-20130407_194701_994528_7A57CF15)
Subject: Re: [ath9k-devel] AR9287 ; 2-wire coexistence expected behavior
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 April 2013 07:54, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
> Hello Mr.Adrian and Mr.Sujith,
>     Thanks for your responses. In order to ensure that all of us are on the
> same page and referring to the same code base, some queries:
>
> 1. Please let me know you are referring to freebsd.org or linuxwireless.org
> drivers? Because you are referring to Kite & Kiwi which are in FreeBSD.
>    FreeBSD --> http://svn.freebsd.org/base/head/sys/
>    Ath9k --> http://linuxwireless.org/en/users/Drivers/ath9k
>    Because currently I am using ath9k drivers only from linuxwireless.org.

Kite = AR9285
Kiwi = AR9287

I know ath9k enough to be (somewhat) helpful and dangerous. But I'm
the FreeBSD guy here; I know the HAL and FreeBSD code much better.

The FreeBSD code is closer to what our reference driver does / did
than Linux, at least for the legacy chipset support.

> 2. Which version of ath9k driver is stable & complete from 2-wire/3-wire
> coexistence? The reason for this query is that I downloaded
> compat-wireless-3.6.8-1 which contains the function ath9k_start_btcoex() in
> which the Weight register is initialized. But this function is not available
> in some of the stable versions of ath9k which I am using.

Not unsurprising. ath9k's btcoex code is (relatively) recent. it
sounds like you've been using an older kernel.

> 3. What exactly are Kite and Kiwi? Are these third party modules using
> AR9287 Atheros chipsets? I did not see this in linuxwireless.org but only in
> FreeBSD.

They're chip names. AR9285 = Kite, AR9287 = Kiwi.

> 4. Just wanted to confirm if the address of the weight register that you are
> mentioning below for 2-wire coexistence is : AR_BT_COEX_WEIGHT (0x8174)

Yup. That's what it is for AR5146 -> AR9287. AR9380 changed this.

> 5. Just wanted to cross check if the weight register mentioned is for 2-wire
> coexistence? The reason for this doubt is I see bt_freq, bt_prio bits
>    in BT weight register and these bits are relevant to BT_FREQUENCY and
> BT_PRIORITY lines which are relevant for 3-wire coexistence?

The weight register is still used. I just don't quite know what the
table mapping is.

But specifically, as you're effectively trying to implement "bluetooth
stomps everything", what you really want is a table where bt wins each
round, except perhaps for beacon interval (so you send out beacons
reliably.) There should already be static stomp register values for
"BT wins all" and "Wifi wins all." That's all you should need to write
into that register.




Adrian
