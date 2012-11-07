Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36521 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab2KGIJm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 03:09:42 -0500
Received: by mail-we0-f174.google.com with SMTP id t9so581846wey.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Nov 2012 00:09:41 -0800 (PST)
Date: Wed, 7 Nov 2012 09:09:54 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: eddie@ehuk.net, stable@vger.kernel.org, florian@reitmeir.org,
	linux-wireless@vger.kernel.org, j@w1.fi, mcgrof@gmail.com
Subject: Re: Linux 3.6.5
Message-ID: <20121107080954.GA7105@kroah.com> (sfid-20121107_090956_458202_C7DED897)
References: <509838F4.4010301@ehuk.net>
 <1352188621.9440.4.camel@jlt4.sipsolutions.net>
 <50992E0E.3040606@ehuk.net>
 <1352217244.9440.16.camel@jlt4.sipsolutions.net>
 <50995E25.6080601@ehuk.net>
 <1352229634.8814.8.camel@jlt4.sipsolutions.net>
 <5099669E.2040301@ehuk.net>
 <1352233894.8814.10.camel@jlt4.sipsolutions.net>
 <20121107073634.GA6560@kroah.com>
 <1352274814.9854.5.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1352274814.9854.5.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 07, 2012 at 08:53:34AM +0100, Johannes Berg wrote:
> On Wed, 2012-11-07 at 08:36 +0100, Greg KH wrote:
> 
> > > Great, thanks. I'm not really sure which one to apply, and if we apply
> > > the 8877 one we'll also want to update the reg db (that you aren't
> > > using). A lot of people are in Barcelona right now though, so that might
> > > be a week or so until we can close this.
> > 
> > I'm in Barcelona all this week, but a nice summary of what I'm supposed
> > to do here for the stable tree would be great to have when ever you
> > figure it out, don't wait for me to return, my email queues up just fine :)
> 
> Sure :)
> So first of all, I'm sure (even without Eddie having tested it) that the
> bug affects 3.7-rc as well, not just 3.6 stable, since the same patch
> was applied there. Therefore, we're looking for a fix for that as well.
> 
> There are two possible fixes (that I can think of right now), both of
> which Eddie tested.
> 
> One is a change to my old change, to make it only adhere to the
> regulatory rules that the *driver* asked for, which will still fix the
> iwlwifi problem of crashing the firmware in situations like Eddie's.
> However, it's a bit strange to be ignoring our regulatory rules.
> 
> The other fix is a relaxation of the regulatory rules to allow 40 MHz
> operation involving channels 12 and 13 (like in Eddie's setup, where
> channel 9 HT40+ is used, which means the effective channel spans from
> the bottom of channel 6 to the top of channel 13.) This seems like a
> much cleaner solution, but the change needs to be done in two places
> (both the kernel's idea of the "world roaming" regulatory domain, and
> userspace's).
> 
> I prefer the second fix, but want to run it by somebody more familiar
> with regulatory rules.
> 
> Ultimately, I'll apply either one for 3.7, and tag it with Cc stable.

Wonderful, thanks for the summary, and the work on this, I'll just take
it through the normal cc: stable process.

greg k-h
