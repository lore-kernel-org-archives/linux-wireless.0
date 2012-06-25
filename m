Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33412 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996Ab2FYQQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 12:16:16 -0400
Message-ID: <1340640972.27437.19.camel@jlt3.sipsolutions.net> (sfid-20120625_181620_114407_E2D6F840)
Subject: Re: [RFC 15/17] cfg80211: add P2P Device abstraction
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 25 Jun 2012 18:16:12 +0200
In-Reply-To: <CAB3XZEfpSxd6LC9XnwFDfVHx=EP2aypEuPhrvtAsJM4HxpJ8gg@mail.gmail.com> (sfid-20120625_180601_195477_41D41EAE)
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
	 <1340117456-10154-16-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEcWE46OHiigB24ezaDA3rRUYoKGtYcmvVxVgMizVK+d8w@mail.gmail.com>
	 <1340639295.27437.7.camel@jlt3.sipsolutions.net>
	 <CAB3XZEfpSxd6LC9XnwFDfVHx=EP2aypEuPhrvtAsJM4HxpJ8gg@mail.gmail.com>
	 (sfid-20120625_180601_195477_41D41EAE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-25 at 19:05 +0300, Eliad Peller wrote:
> On Mon, Jun 25, 2012 at 6:48 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Mon, 2012-06-25 at 18:20 +0300, Eliad Peller wrote:
> >
> >> > +void cfg80211_unregister_wdev(struct wireless_dev *wdev)
> >
> >> > +       case NL80211_IFTYPE_P2P_DEVICE:
> >> > +               if (wdev->p2p_started) {
> >> > +                       wdev->p2p_started = false;
> >> > +                       rdev->opencount--;
> >> > +               }
> >> any reason not calling stop_p2p_device() here as well?
> >
> > That would be circular? You're supposed to call this when
> > stop_p2p_device() gets called, or when you need to delete it for some
> > other reason, usually device unplug or such.
> >
> hmm... so where stop_p2p_device is being called when userspace doesn't call it?

Why should it be called? The stop can either originate from userspace,
or from the driver in case the device is unplugged etc. In that case,
the driver is expected to clean up its own status before it calls
unregister_wdev().

I guess this is a bit different from the netdevs where we do call the
relevant stop functions when the interface goes down, and it goes down
when it is unregistered, etc.

Then again, if we do call stop_p2p_device here, it's not actually that
circular because it will only happen the first time around. Hmm.

johannes

