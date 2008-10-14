Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:55911 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbYJNWG5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 18:06:57 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: Does not connect reliably on 2.6.27
References: <87iqrvgm7b.fsf@denkblock.local>
	<40f31dec0810141011y265275a8nc083764889d699f1@mail.gmail.com>
Date: Wed, 15 Oct 2008 00:01:28 +0200
Message-ID: <87iqruj0p3.fsf@denkblock.local> (sfid-20081015_000700_755580_57D3B626)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Nick Kossifidis" <mickflemm@gmail.com> wrote:
> 2008/10/14 Elias Oltmanns <eo@nebensachen.de>:
>> Hi all,
>
>>
>> after a cold boot into 2.6.27, ath5k doesn't work on my machine. The
>> sequence
>>
>> # ifconfig ath0 up
>> # iwlist ath0 ap
>>
>> results in a message informing me that no list of APs is available for
>> that device.
[...]
>> The minimal patch to fix the issue for me is attached. However, I am
>> wondering whether the preceding writes to register 0xa228 should be
>> dropped or at least adjusted somehow. Perhaps those of you who know the
>> recently released HAL from Atheros can throw some light on the matter.
>>
>> Regards,
>>
>> Elias
>> ---
>> diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
>> index dc51b84..b1cec2a 100644
>> --- a/drivers/net/wireless/ath5k/hw.c
>> +++ b/drivers/net/wireless/ath5k/hw.c
>> @@ -862,7 +862,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
>>                        data = 0;
>>
>>                        /* Just write 0x9b5 ? */
>> -                       /* ath5k_hw_reg_write(ah, 0x000009b5, 0xa228); */
>> +                       ath5k_hw_reg_write(ah, 0x000009b5, 0xa228);
>>                        ath5k_hw_reg_write(ah, 0x0000000f, AR5K_SEQ_MASK);
>>                        ath5k_hw_reg_write(ah, 0x00000000, 0xa254);
>>                        ath5k_hw_reg_write(ah, 0x0000000e, AR5K_PHY_SCAL);
>>
>
> I think i've fixed that (it's a buggy mask some lines above) on an
> earlier patch (the one that introduced AR2425 support) but i'll look
> into it again ;-)

Can you drop me a link or a commit + tree so I can test it?

Regards,

Elias
