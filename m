Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:50010 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbaJWK51 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 06:57:27 -0400
Message-ID: <5448DF0B.2090906@openwrt.org> (sfid-20141023_125740_231153_FC2A9BF7)
Date: Thu, 23 Oct 2014 12:57:15 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: add SURVEY_INFO_IN_USE for current channel on
 survey
References: <1413996362-44397-1-git-send-email-nbd@openwrt.org> <87k33rqmwq.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87k33rqmwq.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-10-23 09:13, Kalle Valo wrote:
> Felix Fietkau <nbd@openwrt.org> writes:
> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>>  drivers/net/wireless/ath/ath10k/mac.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index 4670930..bc440dc 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -3975,6 +3975,9 @@ static int ath10k_get_survey(struct ieee80211_hw *hw, int idx,
>>  
>>  	survey->channel = &sband->channels[idx];
>>  
>> +	if (ar->rx_channel == survey->channel)
>> +		survey->filled |= SURVEY_INFO_IN_USE;
>> +
> 
> Why? Does this fix a visible bug? What changes from user space point of
> view? I'm asking because I want to add something to the commit log.
When user space requests survey info, it is useful to know which of the
survey data refers to the channel that is currently actively being used.
One of the use cases is getting the current channel noise for status output.
Without this flag you would have to look up the channel separately and
then compare it against the frequency in the survey output in user space.

- Felix
