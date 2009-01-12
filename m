Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f13.google.com ([209.85.217.13]:42125 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbZALRFJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 12:05:09 -0500
Received: by gxk6 with SMTP id 6so70380gxk.5
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2009 09:05:07 -0800 (PST)
Message-ID: <40f31dec0901120857p5c34b38duae69662934cec309@mail.gmail.com> (sfid-20090112_180513_743817_2292CFCA)
Date: Mon, 12 Jan 2009 18:57:10 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Helmut Schaa" <helmut.schaa@googlemail.com>
Subject: Re: [PATCH] ath5k: discard 11g caps if reported by an ar5211 eeprom
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com
In-Reply-To: <200901121746.23260.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200901121304.07360.helmut.schaa@gmail.com>
	 <40f31dec0901120825i6ec6af4bq39e7e1be8459e846@mail.gmail.com>
	 <200901121746.23260.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/1/12 Helmut Schaa <helmut.schaa@googlemail.com>:
> Am Montag, 12. Januar 2009 schrieb Nick Kossifidis:
>> 2009/1/12 Helmut Schaa <helmut.schaa@googlemail.com>:
>> > At least one ar5211 card (GIGABYTE GN-WLMA101, 168c:0012 subsystem
>> > 1458:e800) reports itself as 11g capable which seems to be a bug in the
>> > eeprom. initvals.c assumes that ar5211 is only 11b capable and thus refuses
>> > to initialize this card. Hence this patch changes the probing for 11g
>> > capabilities to discard 11g capabilities for ar5211 cards which allows this
>> > specific card to work fine in 11b and 11a modes.
>> >
>> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>> > ---
>> >
>> > Is anybody aware of 11g-capable ar5211 cards which would be limited by
>> > this patch?
>
> [...]
>
>> This should be O.K. for now but i think AR5211 supports the so called
>> "pureg" mode which means ofdm only g (no cck headers etc).
>
> Sounds reasonable, yes.
>
>> It seems
>> radio (RF5111) supports g mode (it can be found on AR5212 abg cards)
>
> I guess you mean RF2111, right? RF5111 should be 11a.
>
> I've just found a product sheet at [1] that states that the RF2111
> supports "802.11g draft standard". I guess that's exactly what you've
> described as "pureg" mode.
>
> Thanks,
> Helmut
>
> [1] ftp://ftp.riss-telecom.ru/pub/wireless/doc/atheros/AR5001X.pdf
>

RF5111 is the RF chip, RF2111 is a frequency converter with cck
support, check this out..
http://www.hotchips.org/archives/hc14/3_Tue/16_mcfarland.pdf

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
