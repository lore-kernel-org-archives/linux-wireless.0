Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:51519 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965855Ab0CPAFY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 20:05:24 -0400
Message-ID: <4B9ECB3E.3010802@openwrt.org>
Date: Tue, 16 Mar 2010 01:05:18 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 00/12] ath9k_hw: complete support for AR9271
References: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com> 	<20100315214338.GB4000@tux> <43e72e891003151625t795b8ecdr2ce2e6927e8632a4@mail.gmail.com> 	<20100315234909.GA2662@tux> <4B9EC85B.8070800@openwrt.org> <43e72e891003151655i7dc051d0lc1da26267e9c706@mail.gmail.com>
In-Reply-To: <43e72e891003151655i7dc051d0lc1da26267e9c706@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-03-16 12:55 AM, Luis R. Rodriguez wrote:
> On Mon, Mar 15, 2010 at 4:52 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> On 2010-03-16 12:49 AM, Luis R. Rodriguez wrote:
>>> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
>>> index 00570fb..867cfaf 100644
>>> --- a/drivers/net/wireless/ath/ath9k/hw.c
>>> +++ b/drivers/net/wireless/ath/ath9k/hw.c
>>> @@ -807,6 +804,10 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
>>>               acktimeout += 64 - sifstime - ah->slottime;
>>>
>>>       ath9k_hw_setslottime(ah, slottime);
>>> +
>>> +     if (AR_SREV_9271(ah))
>>> +             return;
>>> +
>>>       ath9k_hw_set_ack_timeout(ah, acktimeout);
>>>       ath9k_hw_set_cts_timeout(ah, acktimeout);
>>>       if (ah->globaltxtimeout != (u32) -1)
>>
>> Why leave out the ACK/CTS timeout setting? How does the hw handle ACK
>> and CTS timeouts?
> 
> Right, so that's why I originally removed this hunk completely, I was
> under the impression you latest fix would have addressed any issues
> but it does not, we get association time outs. I think we'll have to
> review this further in order to support coverage class.
Are you sure the slot time was set properly by the callback? Can you
print out the values that it's setting? The initvals for 9271 don't
really look all that different.

- Felix
