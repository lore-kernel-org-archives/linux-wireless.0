Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50054 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751089AbeBWMyw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 07:54:52 -0500
Subject: Re: [PATCH 4/4] mac80211: support station 4-addr mode fast-rx
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20180223090606.55726-1-nbd@nbd.name>
 <20180223090606.55726-4-nbd@nbd.name>
 <1519385092.2231.6.camel@sipsolutions.net>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <17978383-8eec-e407-c0b8-168f8181b524@nbd.name> (sfid-20180223_135456_928059_3CFDEFD7)
Date: Fri, 23 Feb 2018 13:54:50 +0100
MIME-Version: 1.0
In-Reply-To: <1519385092.2231.6.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-02-23 12:24, Johannes Berg wrote:
> On Fri, 2018-02-23 at 10:06 +0100, Felix Fietkau wrote:
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> ---
>>  net/mac80211/cfg.c |  2 --
>>  net/mac80211/rx.c  | 11 +++++++----
>>  2 files changed, 7 insertions(+), 6 deletions(-)
>> 
>> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
>> index 6f9d5beec73e..72b5a2ec4e94 100644
>> --- a/net/mac80211/cfg.c
>> +++ b/net/mac80211/cfg.c
>> @@ -160,7 +160,6 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
>>  	if (type == NL80211_IFTYPE_AP_VLAN &&
>>  	    params && params->use_4addr == 0) {
>>  		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
>> -		ieee80211_check_fast_rx_iface(sdata);
>>  	} else if (type == NL80211_IFTYPE_STATION &&
>>  		   params && params->use_4addr >= 0) {
>>  		sdata->u.mgd.use_4addr = params->use_4addr;
>> @@ -1575,7 +1574,6 @@ static int ieee80211_change_station(struct wiphy *wiphy,
>>  			}
>>  
>>  			rcu_assign_pointer(vlansdata->u.vlan.sta, sta);
>> -			__ieee80211_check_fast_rx_iface(vlansdata);
>>  		}
>>  
>>  		if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
> 
> I'm not convinced this is right - don't you have to recheck to modify
> the station data? Otherwise you'd just drop all the frames to the
> slowpath again due to the first patch in the series, no?You're right and I forgot to take those out before sending. Will
resubmit this one.

Thanks,

- Felix
