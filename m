Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:40097 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab3AQFfb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 00:35:31 -0500
Date: Wed, 16 Jan 2013 23:35:28 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] Fixes for problems with off-channel powersave
Message-ID: <20130117053528.GD31449@thinkpad-t410> (sfid-20130117_063533_673424_A4AFA9E2)
References: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
 <1358382542.15012.109.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1358382542.15012.109.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 17, 2013 at 01:29:02AM +0100, Johannes Berg wrote:
> Ok and now that I've typed it all up, I think it points to how we can do
> it much more easily without a separate module and without really
> changing the drivers.
> 
> Do a few things:
>  * introduce IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL
>  * stop all queues, using the new reason, before going offchannel
>  * then flush
>  * then *directly* tell the driver to transmit the nulldata packets,
>    checking only if the driver has the queue stopped, in which case we
>    have IEEE80211_QUEUE_STOP_REASON_DRIVER set; if it does, fail going
>    off channel
>  * similarly, *directly* tell the driver to transmit probe requests and
>    offchannel packets from cfg80211, if it fails (stop reason driver)
>    then do nothing (probe request) or return a failure to userspace
>    (offchannel TX)
> 
> In fact the last two bullets should probably be implemented by passing
> some sort of "offchan_tx_ok" to ieee80211_tx_skb() and friends, and
> checking queue_stop_reasons more carefully in ieee80211_tx_frags().

That looks like it would work well. I'll start working on these changes.

> I'll address powersave another day, but it also needs major rework.

I can't completely ignore powersave if I want to get brcmsmac working
properly. The hardware seems to be actively setting or clearing PM based
on its configuration, so I need a way to tell the driver that PM should
be set. Making off-channel an explicit powersave state lets me do this,
and while it doesn't fix any of the other powersave problems I do think
it make the code clearer than the psuedo-state used now for off-channel.

What I've got locally now for this is code to expand the PS config flag
to two bits to support three PS states: disabled, enabled, and
off-channel. Doing this is working well enough with the two machines
I've been testing with (brcmsmac and ath9k). There's an odd side effect
on brcmsmac of having PM set in probe request frames during scans, but
according to the spec PM should be reserved in those frames anyway.

I pushed the changes to the following if you're interested in taking a
look:

  git://kernel.ubuntu.com/sforshee/linux.git mac80211-offchannel

I'm possibly still missing some driver updates that would need to be
done, but otherwise the changes should be fairly complete. A major
rework of the powersave code is likely to take some time, so is there
any chance of getting something like this in place to fix things in the
short term?

Seth
