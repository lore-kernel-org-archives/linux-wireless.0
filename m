Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54326 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab2HTH3Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 03:29:25 -0400
Message-ID: <5031E74F.4010104@qca.qualcomm.com> (sfid-20120820_092929_074425_2DA0295D)
Date: Mon, 20 Aug 2012 10:29:19 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Thomas Pedersen <c_tpeder@qca.qualcomm.com>,
	<ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: protect firmware from excessive WoW pattern length
References: <1345076116-5053-1-git-send-email-c_tpeder@qca.qualcomm.com>  (sfid-20120816_021530_554431_E3CCD682) <1345446793.4504.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1345446793.4504.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/20/2012 10:13 AM, Johannes Berg wrote:
> On Wed, 2012-08-15 at 17:15 -0700, Thomas Pedersen wrote:
>> Don't accept WoW patterns longer than supported by firmware.
>>
>> Reported-by: Haijun Jin <nhjin@qca.qualcomm.com>
>> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/ath6kl/cfg80211.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
>> index bd003fe..ffa18f3 100644
>> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
>> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
>> @@ -1876,6 +1876,9 @@ static int ath6kl_wow_usr(struct ath6kl *ar, struct ath6kl_vif *vif,
>>  	/* Configure the patterns that we received from the user. */
>>  	for (i = 0; i < wow->n_patterns; i++) {
>>  
>> +		if (wow->patterns[i].pattern_len > WOW_MASK_SIZE)
>> +			return -EINVAL;
>> +
> 
> No objection, but doesn't nl80211 already validate that (assuming you
> give the right pattern_max_len, of course)?

And ath6kl even uses different define pattern_max_len:

	wiphy->wowlan.pattern_max_len = WOW_PATTERN_SIZE;

But the value is still same:

#define WOW_PATTERN_SIZE	 64
#define WOW_MASK_SIZE		 64

Thomas, can you please check this? Do we really need two different
defines? And which one is the correct one here?

I'll keep the patch applied but I'm happy to take followup patches to
clarify this part.

Kalle
