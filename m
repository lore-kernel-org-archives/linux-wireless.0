Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.250]:28302 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760450AbYJJTYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 15:24:49 -0400
Received: by hs-out-0708.google.com with SMTP id 4so249917hsl.5
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 12:24:46 -0700 (PDT)
Message-ID: <40f31dec0810101224p1345d180x61af4b7b10277a88@mail.gmail.com> (sfid-20081010_212453_168320_013FF087)
Date: Fri, 10 Oct 2008 22:24:45 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: ath5k: kernel timing screwed - due to unserialised register access?
Cc: "Elias Oltmanns" <eo@nebensachen.de>,
	"Jiri Slaby" <jirislaby@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0810101432540.3271@apollo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <87k5cm3ee2.fsf@denkblock.local>
	 <alpine.LFD.2.00.0810072042140.3166@apollo>
	 <87hc7ot804.fsf@denkblock.local> <87myhfnwne.fsf@denkblock.local>
	 <alpine.LFD.2.00.0810082203360.3237@apollo>
	 <alpine.LFD.2.00.0810091313380.3237@apollo>
	 <87k5cgg87j.fsf@denkblock.local>
	 <alpine.LFD.2.00.0810101127560.3271@apollo>
	 <87abdck6sn.fsf@denkblock.local>
	 <alpine.LFD.2.00.0810101432540.3271@apollo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/10 Thomas Gleixner <tglx@linutronix.de>:
> On Fri, 10 Oct 2008, Elias Oltmanns wrote:
>> That printk() has not been hit, I'm afraid. The output of
>> sysrq_timer_list_show() looks much the same but there is no message
>> about softirqs. Just for the record, I've switched to 2.6.27 because I'm
>> debugging something else at the same time, but it doesn't make any
>> difference.
>>
>> Now, here is another question: There are various snippets like the
>> following in the ath5k driver:
>>
>>       /* Wait until the noise floor is calibrated and read the value */
>>       for (i = 20; i > 0; i--) {
>>               mdelay(1);
>
> Uurgh. That's broken. mdelay sleeps so this should not be called in
> softirq context.
>
>>               noise_floor = ath5k_hw_reg_read(ah, AR5K_PHY_NF);
>>               noise_floor = AR5K_PHY_NF_RVAL(noise_floor);
>>               if (noise_floor & AR5K_PHY_NF_ACTIVE) {
>>                       noise_floor = AR5K_PHY_NF_AVAL(noise_floor);
>>
>>                       if (noise_floor <= AR5K_TUNE_NOISE_FLOOR)
>>                               break;
>>               }
>>       }
>>
>> This particular one is in
>> drivers/net/wireless/ath5k/phy.c:ath5k_hw_noise_floor_calibration()
>> which is called from ath5k_calibrate(), the callback executed every ten
>> seconds in softirq context. Could this have anything to do with our
>
> That makes sense. The timer expires early events are multiples of 10s
> apart.
>
> Thanks,
>
>        tglx

What should we use then ? udelay(1000) ?


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
