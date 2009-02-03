Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f26.google.com ([209.85.217.26]:57159 "EHLO
	mail-gx0-f26.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277AbZBCSGY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 13:06:24 -0500
Received: by gxk7 with SMTP id 7so1067406gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 10:06:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1233679287.11183.7.camel@maxim-laptop>
References: <20090131022310.GA3342@makis>
	 <1233670130.16539.5.camel@maxim-laptop>
	 <40f31dec0902030817h4afacc52uea4885d835444aac@mail.gmail.com>
	 <40f31dec0902030824s65b90222j13ac9b691593f19f@mail.gmail.com>
	 <1233679287.11183.7.camel@maxim-laptop>
Date: Tue, 3 Feb 2009 20:06:21 +0200
Message-ID: <40f31dec0902031006o6d0dd6ffkf6aae6d39cf078a5@mail.gmail.com> (sfid-20090203_190652_688741_3432A59D)
Subject: Re: [ath5k-devel] [PATCH 1/5] ath5k: PHY code cleanup
From: Nick Kossifidis <mickflemm@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/2/3 Maxim Levitsky <maximlevitsky@gmail.com>:
> On Tue, 2009-02-03 at 18:24 +0200, Nick Kossifidis wrote:
>> 2009/2/3 Nick Kossifidis <mickflemm@gmail.com>:
>> > 2009/2/3 Maxim Levitsky <maximlevitsky@gmail.com>:
>> >> I just tried your 5 patches, as they could fix hangs in the device,
>> >> that I experience occasionally, when resuming my aspire one from
>> ram.
>> >>
>> >> I applied the patches, and I got very unstable system, that tended
>> to
>> >> hang even before X.
>> >>
>> >> When it didn't hang, I tried suspend to ram cycle, but it hanged
>> then.
>> >>
>> >>
>> >> Best regards,
>> >>        Maxim Levitsky
>> >>
>> >>
>> >
>> > It's related to unhandled BMISS interrupts, Bob is working on it to
>> > see what triggers them. A quick solution is to disable them (as we
>> > don't handle them anyway) but it would be better to know the
>> problem.
>> >
>
> Acer aspire one.
>
> -wireless-testing tree + 5 patches
> I test without X running, maybe I could spot an oops or so,
> currently, system just hangs cold.
>

What's your AP, your RSSI etc ?

>
> PS:
>
> Atheros devices consist of MAC and PHY (which sometimes is called radio)
>
> It seems that my device has 2425 MAC, but what radio it has?
> It also seems that most of the driver treats it as a AR5112.
> I thought before that 5112 was the MAC and 2425 was the radio, but it
> doesn't seem to be true, can you explain this?
>
>

A card consists (among other things) of a MAC chip (includes PCU, QCU,
DCU, DMA unit), a radio chip (has synth, bias control etc) and in
between there is baseband (what's called PHY) that drives the radio
chip and provides data i/o to the MAC chip.

First Atheros cards (before 2413) have MAC and PHY on the same chip
and radio on a separate chip, MAC/BB chips are named AR52XX and radio
chips RF51XX.
Newer Atheros cards have all parts on the same chip, MAC is mostly the
same as AR5212 (that's why we mark them as AR5K_AR5212) but PHY and
(especially) RF change so the whole chip gets the name of the radio
chip (RFX4XX -> ARX4XX). So AR2425 has an AR5212 MAC with minor
modifications and an RF2425 radio chip. SREV register marks the whole
chip (since it's not only a MAC/BB chip anymore) so this might be
confusing.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
