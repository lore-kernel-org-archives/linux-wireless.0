Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47591 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab3DWTpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 15:45:00 -0400
Message-ID: <5176E442.7070907@candelatech.com> (sfid-20130423_235840_069200_671FF8E6)
Date: Tue, 23 Apr 2013 12:42:58 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/2] mac80211:  Add vif hash for multi-station RX performance.
References: <1365007698-25295-1-git-send-email-greearb@candelatech.com>   (sfid-20130403_184908_772897_29241D1E) <1365501478.8465.17.camel@jlt4.sipsolutions.net>  <516455CA.6070504@candelatech.com> <1365671968.8272.35.camel@jlt4.sipsolutions.net>
In-Reply-To: <1365671968.8272.35.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2013 02:19 AM, Johannes Berg wrote:
> On Tue, 2013-04-09 at 10:54 -0700, Ben Greear wrote:
>
>>>> +struct sta_info *sta_info_get_by_vif(struct ieee80211_local *local,
>>>> +				     const u8 *vif_addr, const u8 * sta_addr) {
>>>> +	struct sta_info *sta;
>>>> +
>>>> +	sta = rcu_dereference_check(local->sta_vhash[STA_HASH(vif_addr)],
>>>> +				    lockdep_is_held(&local->sta_mtx));
>>>> +	while (sta) {
>>>> +		if (ether_addr_equal(sta->sdata->vif.addr, vif_addr) &&
>>>> +		    ether_addr_equal(sta->sta.addr, sta_addr))
>>>> +			break;
>>>> +		sta = rcu_dereference_check(sta->vnext,
>>>> +					    lockdep_is_held(&local->sta_mtx));
>>>
>>> Almost all of your rcu_dereference_check() invocations should be
>>> rcu_dereference_protected(). See include/linux/rcupdate.h :)
>>
>> Now this, I'm not so sure of.  That rcu_dereference_protected seems to
>> be only used for the 'update-side' use.  I was under the impression
>> that when the mac80211 rx logic is called we are only protected by rcu,
>> not the update mutex.
>
> Ah, yes, I was reading this the wrong way, sorry. Here the _check() is
> correct of course -- you want to be either under RCU protection or hold
> the sta_mtx.
>
>> I also struggle to understand RCU properly...so maybe I'm just
>> wrong about all that...
>>
>> The other methods to get sta_info around that code use the _check() variant,
>> by the way...
>
> Yeah ... :)
>
> Another question: Have you thought about hashing the virtual interfaces
> instead of the stations, and then hashing the stations inside each
> virtual interface? That would make it a bit of a two-level thing:
>
> A1 (in the frame) -> virtual interface
>      A2 (frame) -> station
>
> But it would address the TX side efficiently without "some_sta" since
> you know the virtual interface there already, and could potentially have
> less impact on the code? On TX it'd actually even be more efficient if
> you have more than 1 station per interface (right now you don't though)

This idea suddenly looks a lot more interesting.  The ieee80211_tx_status method needs
to find the remote station & sdata, but in the AP case, the station hash works best,
and in my many-sta-vif case, the VIF hash works best.  I don't see any way to guess
which hash to use in this case.

But, if we first hashed to find sdata, and then had a vif hash in the sdata
object, the lookup should be fast for cases where the hash function works
well.

I'll give this a try...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

