Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60167 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3AYVed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 16:34:33 -0500
Message-ID: <1359149696.4655.22.camel@jlt4.sipsolutions.net> (sfid-20130125_223446_116809_1D1BC09D)
Subject: Re: [RFC] Fixes for problems with off-channel powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 25 Jan 2013 22:34:56 +0100
In-Reply-To: <20130117053528.GD31449@thinkpad-t410>
References: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
	 <1358382542.15012.109.camel@jlt4.sipsolutions.net>
	 <20130117053528.GD31449@thinkpad-t410>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-16 at 23:35 -0600, Seth Forshee wrote:

> > I'll address powersave another day, but it also needs major rework.
> 
> I can't completely ignore powersave if I want to get brcmsmac working
> properly. The hardware seems to be actively setting or clearing PM based
> on its configuration, so I need a way to tell the driver that PM should
> be set. Making off-channel an explicit powersave state lets me do this,
> and while it doesn't fix any of the other powersave problems I do think
> it make the code clearer than the psuedo-state used now for off-channel.
> 
> What I've got locally now for this is code to expand the PS config flag
> to two bits to support three PS states: disabled, enabled, and
> off-channel. Doing this is working well enough with the two machines
> I've been testing with (brcmsmac and ath9k). There's an odd side effect
> on brcmsmac of having PM set in probe request frames during scans, but
> according to the spec PM should be reserved in those frames anyway.

I'm a little confused by this. What frames are we sending to the AP
while we are in powersave? Doesn't the scan code flush etc., and then
the stop-reason thing would prevent other frames from going out?

> I pushed the changes to the following if you're interested in taking a
> look:
> 
>   git://kernel.ubuntu.com/sforshee/linux.git mac80211-offchannel
> 
> I'm possibly still missing some driver updates that would need to be
> done, but otherwise the changes should be fairly complete. A major
> rework of the powersave code is likely to take some time, so is there
> any chance of getting something like this in place to fix things in the
> short term?

Totally, sure. I can hardly lay powersave rewrite on your shoulders :-)

(Nor would I reject it if you did it though, somebody has to do it
eventually and given how we don't use this code at all for our device I
can't really justify doing it myself)

johannes

