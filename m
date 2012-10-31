Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:60567 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934512Ab2JaOiz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 10:38:55 -0400
Message-ID: <509137FA.8070801@neratec.com> (sfid-20121031_153919_665182_3E19D0FE)
Date: Wed, 31 Oct 2012 15:38:50 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Hauke Mehrtens <hauke@hauke-m.de>, linville@tuxdriver.com,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com
Subject: Re: [PATCH] ath9k: [DFS] add pulse width tolerance for ETSI
References: <1351682581-30683-1-git-send-email-zefir.kurtisi@neratec.com> <5091287C.9030408@hauke-m.de> <50912E43.7070005@openwrt.org>
In-Reply-To: <50912E43.7070005@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/2012 02:57 PM, Felix Fietkau wrote:
> On 2012-10-31 2:32 PM, Hauke Mehrtens wrote:
>> On 10/31/2012 12:23 PM, Zefir Kurtisi wrote:
>>> Add 5% width tolerance for radar patterns defined by ETSI.
>>>
>>> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
>>> ---
>>>  .../net/wireless/ath/ath9k/dfs_pattern_detector.c  |    7 ++++++-
>>>  1 files changed, 6 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
>>> index 3b12914..24877b0 100644
>>> --- a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
>>> +++ b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
>>> @@ -42,10 +42,15 @@ struct radar_types {
>>>  #define MIN_PPB_THRESH	50
>>>  #define PPB_THRESH(PPB) ((PPB * MIN_PPB_THRESH + 50) / 100)
>>>  #define PRF2PRI(PRF) ((1000000 + PRF / 2) / PRF)
>>> +/* percentage of pulse width tolerance */
>>> +#define WIDTH_TOLERANCE 5
>>> +#define WIDTH_LOWER(X) ((X*(100-WIDTH_TOLERANCE)+50)/100)
>>> +#define WIDTH_UPPER(X) ((X*(100+WIDTH_TOLERANCE)+50)/100)
>>                                                    ^^^
>> Why are you adding 50 there? If you want to just add 5% tolerance, then
>> the +50 is wrong there, but I do not know anything about radar patterns
>> defined by ETSI.
> I think the 50 is correct here. It's not the tolerance (which is already
> included via WIDTH_TOLERANCE in that macro), it's to account for
> rounding issues.
> Having said that, I wonder if it shouldn't be -50 instead of +50 in
> WIDTH_LOWER().
> 
> - Felix
> 
Right (you were faster on clarifying, thanks ;)).

As for the -50: the macros do rounding to the nearest int, while your
proposal would resemble a floor(), which would result in the values
being decremented from their current value. Given that 5us would be
corrected to 4us, I think it is better to go for the round() approach to
keep detection balanced.

It is maybe not relevant at all for the lower ranges, I came up with the
modification since we had failures detecting type 4 patterns with
maximum pulse width including margin with a total of 31us.

(FYI, other than that, the DFS detector works well enough for
certification by ETSI.)


Cheers,
Zefir

