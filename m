Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43196 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1BBV21 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 16:28:27 -0500
Subject: Re: [PATCH v9] mac80211: Optimize scans on current operating
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4D49AEFA.6090202@candelatech.com>
References: <1296670694-28596-1-git-send-email-greearb@candelatech.com>
	 <1296672941.5671.38.camel@jlt3.sipsolutions.net>
	 <4D49AEFA.6090202@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 22:28:23 +0100
Message-ID: <1296682103.5671.41.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-02 at 11:22 -0800, Ben Greear wrote:

> > Based on the powersave comments I had earlier, maybe we should remove
> > that bit for now? Work items here require powersave is disabled, but we
> > won't do that right now if we're on the same channel.
> 
> The problem is, if we leave the work_work() in the original
> manner, the on/off channel state changes are not properly
> tracked because work blindly assumes it goes off/on channel.
> This breaks assumptions about when we must call the return-to-channel
> logic.  I think if we do not religiously track the on/off channel
> state changes it would be too easy to get in a state where we think
> we are on-channel but haven't actually re-enabled xmit queues, etc.

But if we pretend all work is off-channel, won't it be OK to return from
off-channel, even if it isn't really another channel?

> I think I would rather change the work logic to expressly disable/enable
> powersave.  That wouldn't be difficult, would it?

Probably not -- but the code you modified regarding powersave probably
needs adjustment then.

> I don't think it does anything if we are scanning on-channel
> with my patch.
> The enable/disable logic is now in the offchannel code...
> 
> Do we need to disable it if we are scanning on channel?  If so,
> I can add that explicitly to the scanning code.

Yes, I think we do need to do that, since otherwise we won't actually
receive any beacons other than from our own AP.

> While we are on that topic, it seems the conf.flags are set
> opposite to what I expect.  Is that code below correct?

I think so.

> /* inform AP that we are awake again, unless power save is enabled */

When we return from scanning, we're awake, but the AP thinks we're
asleep.

> static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
> {
> 	struct ieee80211_local *local = sdata->local;
> 
> 	if (!local->ps_sdata)
> 		ieee80211_send_nullfunc(local, sdata, 0);

So in the case we shouldn't go to sleep we just tell the AP that we woke
up again.

> 	else if (local->offchannel_ps_enabled) {
> 		/*
> 		 * In !IEEE80211_HW_PS_NULLFUNC_STACK case the hardware
> 		 * will send a nullfunc frame with the powersave bit set
> 		 * even though the AP already knows that we are sleeping.
> 		 * This could be avoided by sending a null frame with power
> 		 * save bit disabled before enabling the power save, but
> 		 * this doesn't gain anything.
> 		 *
> 		 * When IEEE80211_HW_PS_NULLFUNC_STACK is enabled, no need
> 		 * to send a nullfunc frame because AP already knows that
> 		 * we are sleeping, let's just enable power save mode in
> 		 * hardware.
> 		 */
> 		local->hw.conf.flags |= IEEE80211_CONF_PS;

And in the other case we really go to sleep.

johannes

johannes

