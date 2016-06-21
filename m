Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43266 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbcFUORd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 10:17:33 -0400
Message-ID: <57694C77.5090203@candelatech.com> (sfid-20160621_161916_123953_FE57EFFC)
Date: Tue, 21 Jun 2016 07:17:27 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>, Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k: Support 4.9Ghz channels on AR9580 adapter.
References: <CAGRGNgWOScCrLPyqRNus2319BPOehv3awQChoHw=RRMcSDUqzQ@mail.gmail.com> <1466470940-25229-1-git-send-email-julian.calaby@gmail.com> <20160621094146.GA3196@w1.fi>
In-Reply-To: <20160621094146.GA3196@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/21/2016 02:41 AM, Jouni Malinen wrote:
> On Tue, Jun 21, 2016 at 11:02:20AM +1000, Julian Calaby wrote:
>> I've only done this work as I hate to see people's efforts go to
>> waste and I feel that there's enough roadblocks in the way of
>> actually using this functionality that casual idiots won't be able
>> to.
>
> Are these really ready to go to the upstream kernel in this state and
> without the other changes that would be needed to operate correctly?
> What is the use case for these and how have these been tested?

More patches are needed to make this work properly.  My full patchset, with
modifications to supplicant, *has* been tested, including against a Cisco
AP running 5Mhz channels.


>> This is compile tested only as I cannot test this for real as I lack
>> both the hardware and license required.
>
> I don't think this is sufficient when touching this type of area. I
> would not apply these without proper testing and full set of
> functionality being available. I see no point in ath9k defining
> additional channels if all those new channels can cause is harm and not
> correct functionality. This channel list addition looks like the easiest
> part to handle compared to the other patches needed for 4.9 GHz and this
> would be the last patch on my list to get accepted..
>
>
>> diff --git a/drivers/net/wireless/ath/ath9k/common-init.c b/drivers/net/wireless/ath/ath9k/common-init.c
>> +#ifdef ATH9K_49_GHZ_CHAN
>> +	/* 4.9Ghz channels, public safety channels, license is required in US
>> +	 * and most other regulatory domains!
>> +	 */
>> +	CHAN5G(4915, 38), /* Channel 183 */
>> +	CHAN5G(4920, 39), /* Channel 184 */
>> +	CHAN5G(4925, 40), /* Channel 185 */
>> +	CHAN5G(4935, 41), /* Channel 187 */
>> +	CHAN5G(4940, 42), /* Channel 188 */
>> +	CHAN5G(4945, 43), /* Channel 189 */
>> +	CHAN5G(4960, 44), /* Channel 192 */
>> +	CHAN5G(4970, 45), /* Channel 194 */
>> +	CHAN5G(4980, 46), /* Channel 196 */
>
> Where are these channels defined and are these really correct
> frequencies for them? Please note that many of the 4.9 GHz channels have
> channel starting frequencies like 4.9375 GHz and 4.0025 GHz, i.e.,
> fractional MHz.. While US public safety may not have all those cases,
> even there are some 0.5 MHz cases. In addition, those channel numbers
> sound more like some of the channels defined in Japan rather than US
> public safety operating class. In addition, some of these channels seem
> to be outside the US public safety range.

I got these from WiKi pedia.  There is a later patch that adds the 5Mhz
channels that Cisco uses.  I figured that since this is all restricted anyway,
that users of it would know how to make it work (and they would have to hack
regdb in order to use any of them anyway).

> Is this trying to add 4.9 GHz channels in general for multiple different
> use cases? And if so, what are those use cases? Or is this only for some
> public safety cases? And if so, for which regulatory domains?
>
> To be frank, I really don't see how this would be even close to a state
> that should be accepted into the upstream tree.

It was a starting point, and posted mainly to let folks know how to get started.

As I said, I don't have interest in trying to push all the changes upstream,
but they are in my kernel tree on dmz2.candelatech.com and hostap tree on
github, so maybe someone who has interest in dealing with upstreaming them
can take them over.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
