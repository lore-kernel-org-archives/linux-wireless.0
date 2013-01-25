Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60174 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3AYVgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 16:36:17 -0500
Message-ID: <1359149801.4655.24.camel@jlt4.sipsolutions.net> (sfid-20130125_223620_649803_CC21D1ED)
Subject: Re: [RFC] Fixes for problems with off-channel powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 25 Jan 2013 22:36:41 +0100
In-Reply-To: <20130117053413.GB31449@thinkpad-t410>
References: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
	 <20130109134059.GC18778@thinkpad-t410>
	 <1358379163.15012.69.camel@jlt4.sipsolutions.net>
	 <20130117053413.GB31449@thinkpad-t410>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-16 at 23:34 -0600, Seth Forshee wrote:
> On Thu, Jan 17, 2013 at 12:32:43AM +0100, Johannes Berg wrote:
> > On Wed, 2013-01-09 at 07:40 -0600, Seth Forshee wrote:
> > 
> > > > It turns out that fixing problem #1 (i.e. patch 2) probably isn't
> > > > necessary with the other changes, as no frames should be sent while
> > > > off-channel PS is enabled. Does this still seem like a problem worth
> > > > fixing?
> > > 
> > > This is incorrect. We actually do need patch 2 for some hardware. I
> > > forgot that when I was testing with BCM43224 I found that PM gets
> > > actively set or cleared based on the device configuration. It's
> > > impossible to enable PS at the AP without informing the driver.
> > 
> > Hm, don't understand. If we're not sending any packets to the AP, why
> > does this matter?
> > 
> > Or are you saying it wants nullfunc frames generated in software, but
> > then changes the PM bit in them?
> 
> Exactly. At least that's what it looks like to me. I lack detailed
> knowledge of how to handle powersave on Broadcom, but I do know that the
> PM bit is under the control of the MCTL_HPS field.  Experimentally it
> appears that the hardware actively clears PM when this field is 0 and
> actively sets it when this field is 1, for all frames including
> nullfuncs.

Hm maybe that also answers my other question :-)

Maybe for the benefit of such drivers instead of splitting the powersave
state it would be easier to introduce a "PM bit state"? I don't know ...

johannes

