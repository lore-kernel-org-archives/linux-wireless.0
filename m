Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62413 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab1BDQB6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 11:01:58 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 08:01:37 -0800
Message-ID: <4D4C22ED.5070201@atheros.com>
Date: Fri, 4 Feb 2011 21:31:49 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: Fix parsing of MCS rates to radiotap
References: <1296833778-2912-1-git-send-email-mshajakhan@atheros.com> <1296833942.3671.12.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296833942.3671.12.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 04 February 2011 09:09 PM, Johannes Berg wrote:
> On Fri, 2011-02-04 at 21:06 +0530, Mohammed Shafi Shajakhan wrote:
>    
>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>
>> Previously the MCS rate elements were parsed at the wrong position
>>
>> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>> ---
>>   net/mac80211/rx.c |   31 ++++++++++---------------------
>>   1 files changed, 10 insertions(+), 21 deletions(-)
>>
>> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
>> index c08b8e9..27b4b1f 100644
>> --- a/net/mac80211/rx.c
>> +++ b/net/mac80211/rx.c
>> @@ -141,14 +141,16 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
>>
>>   	/* IEEE80211_RADIOTAP_RATE */
>>   	if (status->flag&  RX_FLAG_HT) {
>> -		/*
>> -		 * TODO: add following information into radiotap header once
>> -		 * suitable fields are defined for it:
>> -		 * - MCS index (status->rate_idx)
>> -		 * - HT40 (status->flag&  RX_FLAG_40MHZ)
>> -		 * - short-GI (status->flag&  RX_FLAG_SHORT_GI)
>> -		 */
>> -		*pos = 0;
>>      
> Alright, so I forgot to remove this comment, but what made you think
> that I added the code in the wrong place??
>
> totally NAK, this breaks radiotap. Removing the comment there is fine,
> replace it with
>    
Sure,thanks for the review .
> /*
>   * MCS information is a separate field in radiotap,
>   * added below.
>   */
>
> johannes
>
>    
