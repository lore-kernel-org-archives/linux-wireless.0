Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p02c11o148.mxlogic.net ([208.65.144.81]:34957 "EHLO
	p02c11o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbaE0Qtz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 12:49:55 -0400
Message-ID: <5384C00C.4020507@nltinc.com> (sfid-20140527_185000_255060_105ABAC7)
Date: Tue, 27 May 2014 18:40:44 +0200
From: Christophe Prevotaux <cprevotaux@nltinc.com>
Reply-To: <cprevotaux@nltinc.com>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>,
	Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix a memory leak on sta rate selection table
References: <1400866194-62234-1-git-send-email-nbd@openwrt.org> <5384BEAF.1030803@candelatech.com>
In-Reply-To: <5384BEAF.1030803@candelatech.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

In terms of OpenWRT world, at least backfire, did not go further back in 
checking. I suspect it is much older than this though :) But I did
put on my spelunking head lamp and I am afraid of the dark :)

Maybe Felix would know ?

Regards

Christophe

On 05/27/2014 06:34 PM, Ben Greear wrote:
> On 05/23/2014 10:29 AM, Felix Fietkau wrote:
>> Cc: stable@vger.kernel.org
>> Reported-by: Christophe Prévotaux <cprevotaux@nltinc.com>
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>
> Any idea how far back this should be applied?
>
> Thanks,
> Ben
>
>> ---
>>   net/mac80211/sta_info.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
>> index 632d372..8b42f49 100644
>> --- a/net/mac80211/sta_info.c
>> +++ b/net/mac80211/sta_info.c
>> @@ -227,6 +227,7 @@ struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
>>    */
>>   void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
>>   {
>> +	struct ieee80211_sta_rates *rates;
>>   	int i;
>>
>>   	if (sta->rate_ctrl)
>> @@ -238,6 +239,10 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
>>   		kfree(sta->tx_lat);
>>   	}
>>
>> +	rates = rcu_dereference_protected(sta->sta.rates, true);
>> +	if (rates)
>> +		kfree(rates);
>> +
>>   	sta_dbg(sta->sdata, "Destroyed STA %pM\n", sta->sta.addr);
>>
>>   	kfree(sta);
>>
>
>


-- 
Christophe Prévotaux

cprevotaux@nltinc.com  +1 416 425 6559 [ext 240]

Northern Light Technologies
33 Laird Drive
M4G 3S9, Toronto, ON
Canada

http://www.nltinc.com
