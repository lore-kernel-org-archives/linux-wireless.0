Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2KGHxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 02:53:05 -0500
Message-ID: <1352274814.9854.5.camel@jlt4.sipsolutions.net> (sfid-20121107_085318_829108_05D58678)
Subject: Re: Linux 3.6.5
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: eddie@ehuk.net, stable@vger.kernel.org, florian@reitmeir.org,
	linux-wireless@vger.kernel.org, j@w1.fi, mcgrof@gmail.com
Date: Wed, 07 Nov 2012 08:53:34 +0100
In-Reply-To: <20121107073634.GA6560@kroah.com> (sfid-20121107_083631_140669_0317FD6F)
References: <50979D38.6010002@ehuk.net>
	 <1352116868.9466.2.camel@jlt4.sipsolutions.net> <509838F4.4010301@ehuk.net>
	 <1352188621.9440.4.camel@jlt4.sipsolutions.net> <50992E0E.3040606@ehuk.net>
	 <1352217244.9440.16.camel@jlt4.sipsolutions.net>
	 <50995E25.6080601@ehuk.net> <1352229634.8814.8.camel@jlt4.sipsolutions.net>
	 <5099669E.2040301@ehuk.net>
	 <1352233894.8814.10.camel@jlt4.sipsolutions.net>
	 <20121107073634.GA6560@kroah.com> (sfid-20121107_083631_140669_0317FD6F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-07 at 08:36 +0100, Greg KH wrote:

> > Great, thanks. I'm not really sure which one to apply, and if we apply
> > the 8877 one we'll also want to update the reg db (that you aren't
> > using). A lot of people are in Barcelona right now though, so that might
> > be a week or so until we can close this.
> 
> I'm in Barcelona all this week, but a nice summary of what I'm supposed
> to do here for the stable tree would be great to have when ever you
> figure it out, don't wait for me to return, my email queues up just fine :)

Sure :)
So first of all, I'm sure (even without Eddie having tested it) that the
bug affects 3.7-rc as well, not just 3.6 stable, since the same patch
was applied there. Therefore, we're looking for a fix for that as well.

There are two possible fixes (that I can think of right now), both of
which Eddie tested.

One is a change to my old change, to make it only adhere to the
regulatory rules that the *driver* asked for, which will still fix the
iwlwifi problem of crashing the firmware in situations like Eddie's.
However, it's a bit strange to be ignoring our regulatory rules.

The other fix is a relaxation of the regulatory rules to allow 40 MHz
operation involving channels 12 and 13 (like in Eddie's setup, where
channel 9 HT40+ is used, which means the effective channel spans from
the bottom of channel 6 to the top of channel 13.) This seems like a
much cleaner solution, but the change needs to be done in two places
(both the kernel's idea of the "world roaming" regulatory domain, and
userspace's).

I prefer the second fix, but want to run it by somebody more familiar
with regulatory rules.

Ultimately, I'll apply either one for 3.7, and tag it with Cc stable.

johannes

