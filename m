Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34337 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2DLHZD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 03:25:03 -0400
Message-ID: <4F868345.2010009@openwrt.org> (sfid-20120412_092508_883706_52745B08)
Date: Thu, 12 Apr 2012 09:24:53 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix an issue in ieee80211_tx_info count field
 management
References: <CAA2SeNJNan7uwJ_VELCb-rDX4ddq+=K0Ud3n5mrv6MJ+O-Bb9w@mail.gmail.com>  (sfid-20120406_204847_916462_26A238BC) <1334203438.3788.11.camel@jlt3.sipsolutions.net>
In-Reply-To: <1334203438.3788.11.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-04-12 6:03 AM, Johannes Berg wrote:
> On Fri, 2012-04-06 at 20:48 +0200, Lorenzo Bianconi wrote:
>> Hi,
>> 
>> I noticed a possible issue in the status count field management of the
>> ieee80211_tx_info data structure. In particular, when the AGGR
>> processing is employed,
>> status.rates[].count is set just for the first frame and not for
>> others belonging to the same burst, leading to wrong statistic data in
>> the mac80211 debug file system.
>> 
>> Regards
>> 
>> Lorenzo
>> 
>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
>> ---
>> --- a/net/mac80211/status.c
>> +++ b/net/mac80211/status.c
>> @@ -355,7 +355,13 @@
>>  	int rtap_len;
>> 
>>  	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
>> -		if (info->status.rates[i].idx < 0) {
>> +		if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
>> +		    !(info->flags & IEEE80211_TX_STAT_AMPDU)) {
>> +			/* just the first aggr frame carry status info */
>> +			info->status.rates[i].idx = -1;
>> +			info->status.rates[i].count = 0;
>> +			break;
>> +		} else if (info->status.rates[i].idx < 0) {
> 
> Is that really the way all drivers do it? I know ath9k seems to do it
> that way, but I don't think all drivers do. ath9k is probably the
> exception rather than the rule, at least today
At least minstrel_ht expects it this way. If I understand iwlwifi
correctly, it reports tx status in a similar way - on completion in
iwlagn_rx_reply_compressed_ba(), the first subframe carries the
information for an entire A-MPDU, the other subframes are not touched.

- Felix
