Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55406 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab0IOD3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 23:29:01 -0400
Received: by wyf22 with SMTP id 22so8146875wyf.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 20:28:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201009151216.32430.br1@einfach.org>
References: <AANLkTim+Q773KvA7Et1s2Zf8yMx36RGS2LsoJsX1Wtt9@mail.gmail.com>
 <201009151130.15165.br1@einfach.org> <AANLkTi=uaJd3VTZ8cT0YHdE5awsmJaiO+607OLTWrt1E@mail.gmail.com>
 <201009151216.32430.br1@einfach.org>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Wed, 15 Sep 2010 13:28:36 +1000
Message-ID: <AANLkTiniROJatam4yA4sss3qjczT-6=jSP9QxvmDo2dq@mail.gmail.com>
Subject: Re: [ath5k-devel] [ath5k] Incorrect value for ACK_TIMEOUT
To: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 1:16 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Wed September 15 2010 12:01:50 Jonathan Guerin wrote:
>> On Wed, Sep 15, 2010 at 12:30 PM, Bruno Randolf <br1@einfach.org> wrote:
>> > On Wed September 15 2010 10:56:32 Jonathan Guerin wrote:
>> >> According to the 802.11-2007 spec document, the ACKTimeout value is
>> >> (Section 9.2.8 ACK procedure):
>> >> ACKTimeout = aSIFSTime + aSlotTime + aPHY-RX-START-Delay
>> >>
>> >> >From Table 17-15—OFDM PHY characteristics, the values are:
>> >> aSIFSTime = 16
>> >> aSlotTime = 9
>> >> aPHY-RX-START-Delay = 25
>> >>
>> >> Therefore, ACKTimeout = 50
>> >>
>> >> In the driver source, this appears to be initialised to:
>> >>
>> >> $$ ath5k.h
>> >> #define AR5K_INIT_ACK_CTS_TIMEOUT             1024
>> >>
>> >> $$ reg.h
>> >> /*
>> >>  * ACK/CTS timeout register
>> >>  */
>> >> #define AR5K_TIME_OUT         0x8014                  /* Register
>> >> Address */ #define AR5K_TIME_OUT_ACK     0x00001fff      /* ACK timeout
>> >> mask */ #define AR5K_TIME_OUT_ACK_S   0
>> >> #define AR5K_TIME_OUT_CTS     0x1fff0000      /* CTS timeout mask */
>> >> #define AR5K_TIME_OUT_CTS_S   16
>> >>
>> >> Taking the value of the register (1024), masking it with the ACK
>> >> Timeout Mask (0x1fff) and dividing it by the clock rate (40), we get a
>> >> much smaller ACK Timeout value:
>> >> 1024 & 0x1fff = 1024
>> >> 1024/40 = 25us
>> >>
>> >>
>> >> Am I understanding this right? Is the driver actually setting the ACK
>> >> Timeout to be much smaller than even a DIFS, let alone matching the
>> >> spec?
>> >
>> > thanks for looking into this! i think you are right in that there is a
>> > mistake here, but AR5K_INIT_ACK_CTS_TIMEOUT is just used for AR5210
>> > chips for setting the AR5K_SLOT_TIME. so this is wrong, but it probably
>> > does not affect you (or
>>
>> I did realise after posting my message that the value was being
>> written into the SLOT_TIME register, rather than the TIME_OUT one. My
>> bad, I should've done a more thorough search...
>
> probably writing this to SLOT_TIME is wrong too? anyhow 5210 is kind of broken
> and not so important, imho. but it would be good to fix it too.
>
>> We have a 5213 chip - does this default to the 5212 branch inside ath5k?
>
> yes. anything higher than 5212 is treated as 5212, generally.
>
>> > this is all confusing and i think we should replace the initvals by
>> > calling the function ath5k_hw_set_ack_timeout().
>>
>> Should all of the init be changed to use these functions, along with
>> #define init values?
>
> i think it would be best if we could remove the initvals alltoghether and use
> the function to set the ack timeout. but i'm not sure if we need to have them
> initialized to some value at the beginning. in this case can we just override
> them later using the function. or just update the initvals numerically (but no
> defines).

If there are no initvals, changing the mode won't init them to default
values, will it? Or are you saying that values should not be
initialised until the mode is set?

>
> it's great that you review this! i think no-one has looked at this since the
> original import, so there may be really old bugs here.

I've been a bit scared to post here until I had more information
rather than a generic "uhh guys, something's not working". It's been
causing me massive headaches with my work as I'm relying on the spec
for timing values, but finding that the driver is doing something
much, much different. I'm more than happy to post these things, but
I'm not a good enough programmer to just give you patches without
discussing the fact that I may just not be understanding what's really
happening.

Thanks for the help, it's greatly appreciated!

>
> thanks,
> bruno
>
