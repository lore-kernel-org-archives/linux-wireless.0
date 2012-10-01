Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-5.exch022.serverdata.net ([206.225.164.188]:57687
	"EHLO HUB022-nj-5.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142Ab2JAOlB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 10:41:01 -0400
Message-ID: <5069AB7D.7060203@posedge.com> (sfid-20121001_164106_661836_F21EDECE)
Date: Mon, 1 Oct 2012 20:11:01 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] mac80211: VHT peer STA caps
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCF6D5B@mbx022-e1-nj-10.exch022.domain.local> <1349090417.10330.27.camel@jlt4.sipsolutions.net>
In-Reply-To: <1349090417.10330.27.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/1/2012 4:50 PM, Johannes Berg wrote:
> Hm, seems I missed this before:
>
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -498,6 +498,7 @@ enum station_parameters_apply_mask {
>>    * @plink_action: plink action to take
>>    * @plink_state: set the peer link state for a station
>>    * @ht_capa: HT capabilities of station
>> + * @vht_capa: VHT capabilities of station
>>    * @uapsd_queues: bitmap of queues configured for uapsd. same format
>>    *	as the AC bitmap in the QoS info field
>>    * @max_sp: max Service Period. same format as the MAX_SP in the
>> @@ -517,6 +518,7 @@ struct station_parameters {
>>   	u8 plink_action;
>>   	u8 plink_state;
>>   	struct ieee80211_ht_cap *ht_capa;
>> +	struct ieee80211_vht_cap *vht_capa;
>
>
> I don't think this should be part of this particular patch? Shouldn't
> there be a cfg80211/nl80211 patch to allow hostapd to set this
> information when adding a station, like for HT, and then that patch
> introduces this struct member?

I agree. I will give that as separate patch.

>
>> + * @vht_cap: VHT capabilities of this STA; Not restricting any capabilities
>> + * 	of remote STA. Taking as is.
>
> Thanks :)
>
>
>> -			2 + sizeof(struct ieee80211_vht_capabilities) + /* VHT */
>> +			2 + sizeof(struct ieee80211_vht_cap) + /* VHT */
>
> Maybe all this renaming (and the ieee80211.h change) could be a separate
> patch? Then this would be easier to read overall I think.
>

Ok. will do.

>
>> +#include <linux/ieee80211.h>
>> +#include <linux/export.h>
>
> export.h isn't needed here (yet)

sure, will remove it.

>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Thanks,
Mahesh
