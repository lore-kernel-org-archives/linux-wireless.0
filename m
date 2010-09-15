Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55663 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab0IODCK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 23:02:10 -0400
Received: by pzk34 with SMTP id 34so2603681pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 20:02:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201009151130.15165.br1@einfach.org>
References: <AANLkTim+Q773KvA7Et1s2Zf8yMx36RGS2LsoJsX1Wtt9@mail.gmail.com> <201009151130.15165.br1@einfach.org>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Wed, 15 Sep 2010 13:01:50 +1000
Message-ID: <AANLkTi=uaJd3VTZ8cT0YHdE5awsmJaiO+607OLTWrt1E@mail.gmail.com>
Subject: Re: [ath5k-devel] [ath5k] Incorrect value for ACK_TIMEOUT
To: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 12:30 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Wed September 15 2010 10:56:32 Jonathan Guerin wrote:
>> According to the 802.11-2007 spec document, the ACKTimeout value is
>> (Section 9.2.8 ACK procedure):
>> ACKTimeout = aSIFSTime + aSlotTime + aPHY-RX-START-Delay
>>
>> >From Table 17-15—OFDM PHY characteristics, the values are:
>> aSIFSTime = 16
>> aSlotTime = 9
>> aPHY-RX-START-Delay = 25
>>
>> Therefore, ACKTimeout = 50
>>
>> In the driver source, this appears to be initialised to:
>>
>> $$ ath5k.h
>> #define AR5K_INIT_ACK_CTS_TIMEOUT             1024
>>
>> $$ reg.h
>> /*
>>  * ACK/CTS timeout register
>>  */
>> #define AR5K_TIME_OUT         0x8014                  /* Register Address */
>> #define AR5K_TIME_OUT_ACK     0x00001fff      /* ACK timeout mask */
>> #define AR5K_TIME_OUT_ACK_S   0
>> #define AR5K_TIME_OUT_CTS     0x1fff0000      /* CTS timeout mask */
>> #define AR5K_TIME_OUT_CTS_S   16
>>
>> Taking the value of the register (1024), masking it with the ACK
>> Timeout Mask (0x1fff) and dividing it by the clock rate (40), we get a
>> much smaller ACK Timeout value:
>> 1024 & 0x1fff = 1024
>> 1024/40 = 25us
>>
>>
>> Am I understanding this right? Is the driver actually setting the ACK
>> Timeout to be much smaller than even a DIFS, let alone matching the
>> spec?
>>
>
> thanks for looking into this! i think you are right in that there is a mistake
> here, but AR5K_INIT_ACK_CTS_TIMEOUT is just used for AR5210 chips for setting
> the AR5K_SLOT_TIME. so this is wrong, but it probably does not affect you (or

I did realise after posting my message that the value was being
written into the SLOT_TIME register, rather than the TIME_OUT one. My
bad, I should've done a more thorough search...

> many people). 5211 and 5212 only use initvals:
>
>       /*         a         aTurbo        b       g (OFDM)    */
> 5211:
>        { AR5K_TIME_OUT,
>           { 0x04000400, 0x08000800, 0x20003000, 0x04000400 } },
>
> 5212:
>        { AR5K_TIME_OUT,
>           { 0x03e803e8, 0x06e006e0, 0x04200420, 0x08400840, 0x06e006e0 } },
>
> so on 5211 this is 1024 in A and G mode (i dont care about B and turbo), so
> same problem you described.
>
> on 5212 this is 1000 in A mode and 1760 in G mode, which would result in a
> timeout of 25 and 40.

We have a 5213 chip - does this default to the 5212 branch inside ath5k?

>
> this is all confusing and i think we should replace the initvals by calling
> the function ath5k_hw_set_ack_timeout().

Should all of the init be changed to use these functions, along with
#define init values?

>
> bruno
>

Thanks,

Jonathan
