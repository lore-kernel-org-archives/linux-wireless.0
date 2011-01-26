Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43444 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab1AZSjL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 13:39:11 -0500
Message-ID: <4D406A48.7060503@candelatech.com>
Date: Wed, 26 Jan 2011 10:39:04 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211:  Optimize scans on current operating channel.
References: <1295633142-7437-1-git-send-email-greearb@candelatech.com> <1296056188.3635.36.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296056188.3635.36.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2011 07:36 AM, Johannes Berg wrote:
> On Fri, 2011-01-21 at 10:05 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This should decrease un-necessary flushes, on/off channel work,
>> and channel changes in cases where the only scanned channel is
>> the current operating channel.
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>> ---
>>
>> v2:  Check channels instead of flag when determining if we should
>>    do a channel change in scan_completed_finish.
>
> Can you look at work.c -- where we call
> ieee80211_offchannel_stop_beaconing etc.
>
> In this patch, you're moving the call to
> ieee80211_offchannel_stop_beaconing next to
> ieee80211_offchannel_stop_station in scan.c.

The offchannel_stop_beaconing doesn't actually change
state, it just calls

  	ieee80211_bss_info_change_notify(
				sdata, BSS_CHANGED_BEACON_ENABLED);

That method will disable beaconing if SCAN_SW_SCANNING is set,
regardless of current channel.

So, if that work.c logic is happening during a scan, we
will always disable scanning, but if we are not SW scanning,
then that offchannel_stop_beaconing won't actually do
anything useful.

My first inclination is to add another check in bss_info_change_notify
to test if we are really off-channel:

		if (local->quiescing || !ieee80211_sdata_running(sdata) ||
		    (test_bit(SCAN_SW_SCANNING, &local->scanning) &&
		     test_bit(SCAN_OFF_CHANNEL, &local->scanning)) {
			sdata->vif.bss_conf.enable_beacon = false;

And either set the SCAN_OFF_CHANNEL flag before calling offchannel_stop_beaconing,
or perhaps set that flag in offchannel_stop_beaconing.  The first might be
less risky, but that leaves the work.c logic funky in my opinion, since if
we are not actually scanning, beacons will still be enabled.

I could use some suggestions on how to proceed.  I am overly tempted to
start changing everything in sight, but that is likely to cause all sorts
of bugs, subtle and otherwise....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

