Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:45677 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbaJYWa3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 18:30:29 -0400
Message-ID: <544C2466.1030709@openwrt.org> (sfid-20141026_003034_342091_32AAA55B)
Date: Sun, 26 Oct 2014 00:29:58 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add support for driver tx power reporting
References: <1413993458-62517-1-git-send-email-nbd@openwrt.org> <1414161186.2326.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1414161186.2326.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-10-24 16:33, Johannes Berg wrote:
> On Wed, 2014-10-22 at 17:57 +0200, Felix Fietkau wrote:
>> The configured tx power is often limited by hardware capabilities,
>> channel settings, antenna configuration, etc.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>>  include/net/mac80211.h | 5 +++++
>>  net/mac80211/cfg.c     | 3 +++
>>  2 files changed, 8 insertions(+)
>> 
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index 0ad1f47..41b0e60 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -2838,6 +2838,9 @@ enum ieee80211_roc_type {
>>   * @get_expected_throughput: extract the expected throughput towards the
>>   *	specified station. The returned value is expressed in Kbps. It returns 0
>>   *	if the RC algorithm does not have proper data to provide.
>> + *
>> + * @get_txpower: get current maximum tx power (in dBm) based on configuration
>> + *	and hardware limits.
>>   */
>>  struct ieee80211_ops {
>>  	void (*tx)(struct ieee80211_hw *hw,
>> @@ -3039,6 +3042,8 @@ struct ieee80211_ops {
>>  	int (*join_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
>>  	void (*leave_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
>>  	u32 (*get_expected_throughput)(struct ieee80211_sta *sta);
>> +	int (*get_txpower)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>> +			   int *dbm);
>>  };
>>  
>>  /**
>> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
>> index fb6a150..7cb31a8 100644
>> --- a/net/mac80211/cfg.c
>> +++ b/net/mac80211/cfg.c
>> @@ -2081,6 +2081,9 @@ static int ieee80211_get_tx_power(struct wiphy *wiphy,
>>  	struct ieee80211_local *local = wiphy_priv(wiphy);
>>  	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
>>  
>> +	if (local->ops->get_txpower)
>> +		return local->ops->get_txpower(&local->hw, &sdata->vif, dbm);
> 
> Might be good to have tracing?
Sending v2.

> And when this is supported, maybe there should be a cop-out for the
> driver to say "please use your value"? OTOH it can access the data that
> mac80211 currently reports so that's probably not needed?
I don't see the point in having that, since the driver can just take it
from the hw/bss conf directly.

- Felix
