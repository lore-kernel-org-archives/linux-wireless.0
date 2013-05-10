Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51301 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab3EJVVy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 17:21:54 -0400
Message-ID: <518D64E6.8000102@candelatech.com> (sfid-20130510_232157_394787_39DA03B8)
Date: Fri, 10 May 2013 14:21:42 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mac80211:  3.9.0+:  Invalid WDS/flush state and non-connecting
 station.
References: <5182C38B.7060107@candelatech.com>   (sfid-20130502_215043_578677_76592D19) <1367526288.11375.2.camel@jlt4.sipsolutions.net>  <5182D078.4020605@candelatech.com> <518A7AD4.2060100@candelatech.com> <1368035937.8279.25.camel@jlt4.sipsolutions.net> <518A9618.1020107@candelatech.com>
In-Reply-To: <518A9618.1020107@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/2013 11:14 AM, Ben Greear wrote:
> On 05/08/2013 10:58 AM, Johannes Berg wrote:
>> On Wed, 2013-05-08 at 09:18 -0700, Ben Greear wrote:
>>
>>> Ok, I reproduced this with yet more debugging printouts in the kernel.
>>>
>>> The symptom is this:
>>>
>>> The sme_state is SME_CONNECTED, so it bails out below before sending the
>>> 'connected' message to user-space.
>>
>> Is your system being really really really slow and/or are threads
>> getting pre-empted a lot? This maybe seem like a bit of a stretch, but
>> it seems possible that this happens:
>>
>> ieee80211_sta_rx_queued_mgmt() is running, possibly on one CPU, and is
>> somewhere between printing "associated" and calling
>> cfg80211_send_rx_assoc() (or in the call already, before taking the lock
>> though.)
>>
>> Then your interface is set down at the same time, possibly on a
>> different CPU. Here's where the scenario gets stretched, clearly your
>> interface is getting set down over a minute later, I don't see how you
>> could have stalled the other thread for that long.
>>
>> But if you did, then that thread is still processing things while the
>> interface is going down, cfg80211 didn't know anything about the
>> association having completed so it won't have disconnected, etc.
>>
>> So far, I haven't found any other scenario, nor a solution.
>
> It is not that slow or overloaded (at least most of the time,
> and in particular, I only had 20 virtual stations up on this system
> not doing much traffic...it easily handles 100's of stations).
>
> And, once it gets in this state..it stays there (overnight,
> with my app resetting the port (via 'ip link set down' and
> poking at wpa_supplicant) every minute or so in this case.
>
> I was wondering..in the cfg80211_mlme_down method (or perhaps
> some place similar), should we force sme state to IDLE
> with a big WARN_ON_ONCE or similar.
>
> That way, if it does get stuck somehow, we can recover by
> downing the interface and bringing it back up?
>

Here's some more debug info..hit it again today:

I added this debug code (on top of all my other patches and 3.9.1+).

void cfg80211_mlme_down(struct cfg80211_registered_device *rdev,
			struct net_device *dev)
{
	struct wireless_dev *wdev = dev->ieee80211_ptr;
	struct cfg80211_deauth_request req;
	u8 bssid[ETH_ALEN];

	ASSERT_WDEV_LOCK(wdev);

	printk("mlme_down: %s: type: %i  sme_state: %i current-bss: %p\n",
                dev->name, (int)(wdev->iftype), (int)(wdev->sme_state),
	       wdev->current_bss);

I see this printout for the stuck station (this is dmesg | grep sta74,
so it skips errors about other interfaces that are also hung).

I am guessing we should never be calling mlme_down with state
of CFG80211_SME_CONNECTED when bss is NULL?

I'm hoping I can get by with some sort of work-around patch
for the 3.9 kernel instead of trying to patch in your big
locking changes....


sta74: authenticate with 00:de:ad:1d:ea:00
sta74: send auth to 00:de:ad:1d:ea:00 (try 1/3)
sta74: authenticated
sta74: associate with 00:de:ad:1d:ea:00 (try 1/3)
sta74: RX AssocResp from 00:de:ad:1d:ea:00 (capab=0x1 status=0 aid=67)
IPv6: ADDRCONF(NETDEV_CHANGE): sta74: link becomes ready
sta74: associated
connect_result: sta74: type: 2  sme_state: 2
__cfg80211_disconnect: sta74: type: 2  sme_state: 2  conn-state: -1
mlme_down: sta74: type: 2  sme_state: 2 current-bss:           (null)
mlme_down: sta74: type: 2  sme_state: 2 current-bss:           (null)
sta74: Invalid WDS/flush state, type: 2  WDS: 5  flushed: 1
IPv6: ADDRCONF(NETDEV_UP): sta74: link is not ready
__cfg80211_disconnect: sta74: type: 2  sme_state: 2  conn-state: -1
mlme_down: sta74: type: 2  sme_state: 2 current-bss:           (null)
mlme_down: sta74: type: 2  sme_state: 2 current-bss:           (null)
IPv6: ADDRCONF(NETDEV_UP): sta74: link is not ready
sta74: authenticate with 00:de:ad:1d:ea:00
sta74: send auth to 00:de:ad:1d:ea:00 (try 1/3)
sta74: authenticated
sta74: associate with 00:de:ad:1d:ea:00 (try 1/3)
sta74: RX AssocResp from 00:de:ad:1d:ea:00 (capab=0x1 status=0 aid=67)
sta74: associated
connect_result: sta74: type: 2  sme_state: 2
IPv6: ADDRCONF(NETDEV_CHANGE): sta74: link becomes ready


> For what it's worth, I don't recall ever seeing this problem
> in 5.7, but it's way to rare to be able to bisect...
>
> Thanks,
> Ben
>
>>
>> johannes
>>
>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

