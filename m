Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49500 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930Ab1BBTWk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 14:22:40 -0500
Message-ID: <4D49AEFA.6090202@candelatech.com>
Date: Wed, 02 Feb 2011 11:22:34 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v9] mac80211: Optimize scans on current operating channel.
References: <1296670694-28596-1-git-send-email-greearb@candelatech.com> <1296672941.5671.38.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296672941.5671.38.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/02/2011 10:55 AM, Johannes Berg wrote:
> On Wed, 2011-02-02 at 10:18 -0800, greearb@candelatech.com wrote:
>
>> * Do no blindly go off/on channel in work.c  Instead, only call
>>    appropriate on/off code when we really need to change channels.
>
> Based on the powersave comments I had earlier, maybe we should remove
> that bit for now? Work items here require powersave is disabled, but we
> won't do that right now if we're on the same channel.

The problem is, if we leave the work_work() in the original
manner, the on/off channel state changes are not properly
tracked because work blindly assumes it goes off/on channel.
This breaks assumptions about when we must call the return-to-channel
logic.  I think if we do not religiously track the on/off channel
state changes it would be too easy to get in a state where we think
we are on-channel but haven't actually re-enabled xmit queues, etc.

I think I would rather change the work logic to expressly disable/enable
powersave.  That wouldn't be difficult, would it?

> Scan, on the other hand, will still disable powersave (right?)

I don't think it does anything if we are scanning on-channel
with my patch.
The enable/disable logic is now in the offchannel code...

Do we need to disable it if we are scanning on channel?  If so,
I can add that explicitly to the scanning code.


While we are on that topic, it seems the conf.flags are set
opposite to what I expect.  Is that code below correct?

/* inform AP that we are awake again, unless power save is enabled */
static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
{
	struct ieee80211_local *local = sdata->local;

	if (!local->ps_sdata)
		ieee80211_send_nullfunc(local, sdata, 0);
	else if (local->offchannel_ps_enabled) {
		/*
		 * In !IEEE80211_HW_PS_NULLFUNC_STACK case the hardware
		 * will send a nullfunc frame with the powersave bit set
		 * even though the AP already knows that we are sleeping.
		 * This could be avoided by sending a null frame with power
		 * save bit disabled before enabling the power save, but
		 * this doesn't gain anything.
		 *
		 * When IEEE80211_HW_PS_NULLFUNC_STACK is enabled, no need
		 * to send a nullfunc frame because AP already knows that
		 * we are sleeping, let's just enable power save mode in
		 * hardware.
		 */
		local->hw.conf.flags |= IEEE80211_CONF_PS;

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

