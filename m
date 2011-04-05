Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42372 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab1DEU2y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 16:28:54 -0400
Subject: Re: [RFC] cfg80211: Let mgmt_tx accept frames destined for its own
 stack.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Thomas Pedersen <thomas@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
In-Reply-To: <BANLkTinLaWXVVQLnjr=UuoNpOQ5QmioM_Q@mail.gmail.com>
References: <1301969218-9878-1-git-send-email-javier@cozybit.com>
	 <1301987234.3831.2.camel@jlt3.sipsolutions.net>
	 <BANLkTinLaWXVVQLnjr=UuoNpOQ5QmioM_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 22:28:52 +0200
Message-ID: <1302035332.4968.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-05 at 11:05 -0700, Javier Cardona wrote:

> We would like to preserve the ability to join an open mesh without a
> daemon, in the same way that a station can associate with an AP
> without one.

Keep in mind that even the station case on an open or WEP network is
pretty useless since it will not reconnect if the connection drops, or
do any sort of roaming.

> With that goal in mind, the alternatives are to
> duplicate the MPM in userspace or to reuse the in-kernel MPM with only
> AMPE in userspace.  Considering that AMPE uses MPM frames and state
> machines, reusing the in-kernel MPM is a significantly lower effort
> alternative.  Furthermore, while working on AMPE we can also bring the
> in-kernel MPM up to spec.
> Of course this requires agreeing on a suitable API between MPM and
> AMPE.  If you don't like the generic one I proposed we can try to
> define a mesh-specific alternative.  But first, setting aside the API change
> proposal, do you object to this AMPE-in-userspace/MPM-in-kernel partition?

After thinking about this more, yes, I think I do object. Not only is
the design strange with passing frames back and forth, but also it seems
like a rather slippery slope, at some point I fear somebody will attempt
to "fake" MPM to take advantage of that kernel code even when it's not
really fitting.

Since practically speaking, wpa_supplicant is already required for
almost everything, I don't see any real disadvantages to duplicating the
MPM state machine there, and starting to deprecate the one in the kernel
over time with new features only available in userspace one, maybe even
removing it at some point. I realise this is a little more short-term
effort, but I think the long-term benefit probably outweighs it.

johannes

