Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:40090 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3AQFeR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 00:34:17 -0500
Date: Wed, 16 Jan 2013 23:34:13 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] Fixes for problems with off-channel powersave
Message-ID: <20130117053413.GB31449@thinkpad-t410> (sfid-20130117_063421_512663_EE3D98C2)
References: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
 <20130109134059.GC18778@thinkpad-t410>
 <1358379163.15012.69.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1358379163.15012.69.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 17, 2013 at 12:32:43AM +0100, Johannes Berg wrote:
> On Wed, 2013-01-09 at 07:40 -0600, Seth Forshee wrote:
> 
> > > It turns out that fixing problem #1 (i.e. patch 2) probably isn't
> > > necessary with the other changes, as no frames should be sent while
> > > off-channel PS is enabled. Does this still seem like a problem worth
> > > fixing?
> > 
> > This is incorrect. We actually do need patch 2 for some hardware. I
> > forgot that when I was testing with BCM43224 I found that PM gets
> > actively set or cleared based on the device configuration. It's
> > impossible to enable PS at the AP without informing the driver.
> 
> Hm, don't understand. If we're not sending any packets to the AP, why
> does this matter?
> 
> Or are you saying it wants nullfunc frames generated in software, but
> then changes the PM bit in them?

Exactly. At least that's what it looks like to me. I lack detailed
knowledge of how to handle powersave on Broadcom, but I do know that the
PM bit is under the control of the MCTL_HPS field.  Experimentally it
appears that the hardware actively clears PM when this field is 0 and
actively sets it when this field is 1, for all frames including
nullfuncs.

Seth
