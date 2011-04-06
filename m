Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952Ab1DFOiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 10:38:06 -0400
Subject: Re: [RFC] cfg80211: Let mgmt_tx accept frames destined for its own
 stack.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Thomas Pedersen <thomas@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
In-Reply-To: <BANLkTinG4b9bzGhamHuF0zi0V=OQT5uBWQ@mail.gmail.com>
References: <1301969218-9878-1-git-send-email-javier@cozybit.com>
	 <1301987234.3831.2.camel@jlt3.sipsolutions.net>
	 <BANLkTinLaWXVVQLnjr=UuoNpOQ5QmioM_Q@mail.gmail.com>
	 <1302035332.4968.11.camel@jlt3.sipsolutions.net>
	 <BANLkTinG4b9bzGhamHuF0zi0V=OQT5uBWQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 16:38:03 +0200
Message-ID: <1302100683.4090.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-05 at 15:04 -0700, Javier Cardona wrote:

> > After thinking about this more, yes, I think I do object. Not only is
> > the design strange with passing frames back and forth, but also it seems
> > like a rather slippery slope, at some point I fear somebody will attempt
> > to "fake" MPM to take advantage of that kernel code even when it's not
> > really fitting.
> 
> The above seem to be concerns with the API itself and not with
> partitioning.  We could make the API specific for mesh peering frames
> in a way that cannot be used for any other purpose other than
> protecting mesh peering frames.

Well, it's a bit of both. I can just see somebody trying to implement a
new protocol and making it look like MPM in order to be able to feed it
back into the kernel, or something like that. More generally, I don't
much like the looping back of things.

> I know of a few mesh use cases where wpa_supplicant is not required,
> such as resource constrained embedded platforms like the ones used in
> sensor networks.  But hey, we'll re-evaluate the wpa_supplicant route
> and see if it is doable.

I think in that case it'd make some sense to make the code in the kernel
configurable? Can't be all that much overhead to have essentially the
same code outside the kernel?

johannes

