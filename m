Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55811 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab0I1PW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 11:22:26 -0400
Message-ID: <4CA2082D.3040907@candelatech.com>
Date: Tue, 28 Sep 2010 08:22:21 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath9k:  Check for identical channels when changing
 channels.
References: <1285632457-27539-1-git-send-email-greearb@candelatech.com> <4CA1AC8F.6000802@openwrt.org> <4CA1EF94.9060508@candelatech.com> <4CA1F641.5090300@openwrt.org>
In-Reply-To: <4CA1F641.5090300@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/28/2010 07:05 AM, Felix Fietkau wrote:
> On 2010-09-28 3:37 PM, Ben Greear wrote:
>> On 09/28/2010 01:51 AM, Felix Fietkau wrote:
>>> On 2010-09-28 2:07 AM, greearb@candelatech.com wrote:
>>>> From: Ben Greear<greearb@candelatech.com>
>>>>
>>>> Don't do un-needed work.  Should be useful when scanning on
>>>> only the working channel.
>>>>
>>>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>>>> ---
>>>> :100644 100644 a133878... 4d34ba5... M	drivers/net/wireless/ath/ath9k/main.c
>>>>    drivers/net/wireless/ath/ath9k/main.c |    5 +++++
>>>>    1 files changed, 5 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>>>> index a133878..4d34ba5 100644
>>>> --- a/drivers/net/wireless/ath/ath9k/main.c
>>>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>>>> @@ -1602,6 +1602,11 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
>>>>    		struct ieee80211_channel *curchan = hw->conf.channel;
>>>>    		int pos = curchan->hw_value;
>>>>
>>>> +		/* If channels are the same, then don't actually do anything.
>>>> +		 */
>>>> +		if (sc->sc_ah->curchan ==&sc->sc_ah->channels[pos])
>>>> +			goto skip_chan_change;
>>>> +
>>> NACK. This ignores off-channel flag changes, which are important for
>>> calibration.
>>
>> Is it enough to just add a check to make sure no changes were made to
>> the SC_OP_OFFCHANNEL flag?
> Shouldn't this check be done in mac80211 then?

Maybe so...I was curious why the check wasn't already in place,
and assumed that maybe some drivers needed it, or maybe the calling
code doesn't always know the driver's current channel?

Thanks,
Ben

>
> - Felix


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
