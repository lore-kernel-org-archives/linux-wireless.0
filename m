Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56112 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab3DIRyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 13:54:25 -0400
Message-ID: <516455CA.6070504@candelatech.com> (sfid-20130409_195429_657963_27AC6895)
Date: Tue, 09 Apr 2013 10:54:18 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/2] mac80211:  Add vif hash for multi-station RX performance.
References: <1365007698-25295-1-git-send-email-greearb@candelatech.com>  (sfid-20130403_184908_772897_29241D1E) <1365501478.8465.17.camel@jlt4.sipsolutions.net>
In-Reply-To: <1365501478.8465.17.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/2013 02:57 AM, Johannes Berg wrote:
> On Wed, 2013-04-03 at 09:48 -0700, greearb@candelatech.com wrote:

>> +++ b/net/mac80211/sta_info.c
>> @@ -77,19 +77,42 @@ static int sta_info_hash_del(struct ieee80211_local *local,
>>   	s = rcu_dereference_protected(local->sta_hash[STA_HASH(sta->sta.addr)],
>>   				      lockdep_is_held(&local->sta_mtx));
>>   	if (!s)
>> -		return -ENOENT;
>> +		goto try_lhash;
>
> Does this make sense? If the station doesn't exist in the regular hash,
> it really shouldn't be in the vif hash either, no?

It shouldn't be in the new vif hash, so I could add a short-cut
as you suggest.  I had left it in for reasons of paranoia.

>> +	s = rcu_dereference_protected(local->sta_vhash[STA_HASH(sta->sdata->vif.addr)],
>> +				      lockdep_is_held(&local->sta_mtx));
>> +	if (!s)
>> +		return -ENONET;
>
> You probably want -ENOENT, not -ENONET.

Yes, and in fact, I need to return just the rv from the old
hash logic since otherwise we get false failure results since
the new hash only has vifs.  This was the cause of that splat
I posted a week or two ago...

>> +struct sta_info *sta_info_get_by_vif(struct ieee80211_local *local,
>> +				     const u8 *vif_addr, const u8 * sta_addr) {
>> +	struct sta_info *sta;
>> +
>> +	sta = rcu_dereference_check(local->sta_vhash[STA_HASH(vif_addr)],
>> +				    lockdep_is_held(&local->sta_mtx));
>> +	while (sta) {
>> +		if (ether_addr_equal(sta->sdata->vif.addr, vif_addr) &&
>> +		    ether_addr_equal(sta->sta.addr, sta_addr))
>> +			break;
>> +		sta = rcu_dereference_check(sta->vnext,
>> +					    lockdep_is_held(&local->sta_mtx));
>
> Almost all of your rcu_dereference_check() invocations should be
> rcu_dereference_protected(). See include/linux/rcupdate.h :)

Now this, I'm not so sure of.  That rcu_dereference_protected seems to
be only used for the 'update-side' use.  I was under the impression
that when the mac80211 rx logic is called we are only protected by rcu,
not the update mutex.

I also struggle to understand RCU properly...so maybe I'm just
wrong about all that...

The other methods to get sta_info around that code use the _check() variant,
by the way...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

