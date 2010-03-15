Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41591 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965869Ab0COXzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 19:55:22 -0400
Received: by pva4 with SMTP id 4so230739pva.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 16:55:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4B9EC85B.8070800@openwrt.org>
References: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
	<20100315214338.GB4000@tux> <43e72e891003151625t795b8ecdr2ce2e6927e8632a4@mail.gmail.com>
	<20100315234909.GA2662@tux> <4B9EC85B.8070800@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 15 Mar 2010 16:55:02 -0700
Message-ID: <43e72e891003151655i7dc051d0lc1da26267e9c706@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] ath9k_hw: complete support for AR9271
To: Felix Fietkau <nbd@openwrt.org>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 15, 2010 at 4:52 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2010-03-16 12:49 AM, Luis R. Rodriguez wrote:
>> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
>> index 00570fb..867cfaf 100644
>> --- a/drivers/net/wireless/ath/ath9k/hw.c
>> +++ b/drivers/net/wireless/ath/ath9k/hw.c
>> @@ -807,6 +804,10 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
>>               acktimeout += 64 - sifstime - ah->slottime;
>>
>>       ath9k_hw_setslottime(ah, slottime);
>> +
>> +     if (AR_SREV_9271(ah))
>> +             return;
>> +
>>       ath9k_hw_set_ack_timeout(ah, acktimeout);
>>       ath9k_hw_set_cts_timeout(ah, acktimeout);
>>       if (ah->globaltxtimeout != (u32) -1)
>
> Why leave out the ACK/CTS timeout setting? How does the hw handle ACK
> and CTS timeouts?

Right, so that's why I originally removed this hunk completely, I was
under the impression you latest fix would have addressed any issues
but it does not, we get association time outs. I think we'll have to
review this further in order to support coverage class.

  Luis
