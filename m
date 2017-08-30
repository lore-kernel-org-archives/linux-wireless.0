Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0042.outbound.protection.outlook.com ([104.47.42.42]:15280
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751872AbdH3Bpo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 21:45:44 -0400
Subject: Re: [PATCH 02/27] qtnfmac: make "Channel change" event report full
 channel info
To: sergey.matyukevich.os@quantenna.com
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
 <20170825023024.10565-3-igor.mitsyanko.os@quantenna.com>
 <20170829143146.ersgkofruzdpta6y@bars>
Cc: linux-wireless@vger.kernel.org, avinashp@quantenna.com,
        johannes@sipsolutions.net
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <6e393e69-3297-4300-c82a-fea0243d6bcc@quantenna.com> (sfid-20170830_034549_265317_CFFAA694)
Date: Tue, 29 Aug 2017 18:45:36 -0700
MIME-Version: 1.0
In-Reply-To: <20170829143146.ersgkofruzdpta6y@bars>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/29/2017 07:31 AM, Sergey Matyukevich wrote:
>>   static int
>>   qtnf_event_handle_sta_assoc(struct qtnf_wmac *mac, struct qtnf_vif *vif,
>> @@ -358,41 +359,36 @@ qtnf_event_handle_freq_change(struct qtnf_wmac *mac,
>>   			      u16 len)
>>   {
>>   	struct wiphy *wiphy = priv_to_wiphy(mac);
>> -	struct cfg80211_chan_def chandef;
>> -	struct ieee80211_channel *chan;
>> +	struct cfg80211_chan_def chdef;
>>   	struct qtnf_vif *vif;
>> -	int freq;
>>   	int i;
> 
> Original variable name 'chandef' was easier to spell on the phone :)

Will return)

> 
> ...
> 
>> +	qlink_chandef_q2cfg(wiphy, &data->chan, &chdef);
>> +
>> +	if (!cfg80211_chandef_valid(&chdef)) {
>> +		pr_err("MAC%u: bad channel freq1=%u bw=%u\n", mac->macid,
>> +		       chdef.center_freq1, chdef.width);
>>   		return -EINVAL;
>>   	}
> 
> Lets keep both freq1 and freq2 in error message.

Ok

> 
> ...
> 
>> +void qlink_chandef_q2cfg(struct wiphy *wiphy,
>> +			 const struct qlink_chandef *qch,
>> +			 struct cfg80211_chan_def *chdef)
>> +{
>> +	chdef->center_freq1 = le16_to_cpu(qch->center_freq1);
>> +	chdef->center_freq2 = le16_to_cpu(qch->center_freq2);
>> +	chdef->width = qlink_chanwidth_to_nl(qch->width);
>> +
>> +	switch (chdef->width) {
>> +	case NL80211_CHAN_WIDTH_20_NOHT:
>> +	case NL80211_CHAN_WIDTH_20:
>> +	case NL80211_CHAN_WIDTH_5:
>> +	case NL80211_CHAN_WIDTH_10:
>> +		chdef->chan = ieee80211_get_channel(wiphy, chdef->center_freq1);
>> +		break;
>> +	case NL80211_CHAN_WIDTH_40:
>> +	case NL80211_CHAN_WIDTH_80:
>> +	case NL80211_CHAN_WIDTH_80P80:
>> +	case NL80211_CHAN_WIDTH_160:
>> +		chdef->chan = ieee80211_get_channel(wiphy,
>> +						    chdef->center_freq1 - 10);
> 
> Do we have the same formula for 40MHz and 80MHz center frequency ?
> I thought we should be using the channel number for the left-most 20MHz band.

Here it should be no difference which channel number we're using as long 
as it falls within specified bandwidth. I mean, we can take (freq - 10), 
(freq + 10) for 40MHz, or (freq - 30) (freq + 30) for 80 MHz etc.

I don't see how we can identify which 20MHz channel is primary, with a 
chandef structure.

> 
>> +		break;
>> +	default:
>> +		chdef->chan = NULL;
>> +		break;
>> +	}
>> +}
> 
> Regards,
> Sergey
> 
