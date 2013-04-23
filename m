Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49951 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab3DWQmg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 12:42:36 -0400
Message-ID: <1366735340.8385.20.camel@jlt4.sipsolutions.net> (sfid-20130423_184250_298456_36DFEC36)
Subject: Re: [RFC] cfg80211: Android P2P-Device workaround
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 23 Apr 2013 18:42:20 +0200
In-Reply-To: <EC4E16A7-2F9E-4E59-A561-88C85A459BCA@holtmann.org>
References: <1366721149-5440-1-git-send-email-johannes@sipsolutions.net>
	 <EC4E16A7-2F9E-4E59-A561-88C85A459BCA@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-04-23 at 07:50 -0700, Marcel Holtmann wrote:

> > +config CFG80211_ANDROID_P2P_HACK
> > +	bool "Android P2P netdevice hack"
> > +	depends on CFG80211
> > +	depends on !CFG80211_WEXT
> > +	help
> > +	  Enable this option for Android P2P w/ P2P Device.
> > +
> 
> do you really think this is a good idea? Wouldn't it be better if
> Android just gets its userspace fixed. This way, they never will and
> you carry this workaround forever.

Well, I'm about 50/50 on whether to merge this. On the one hand, it's a
very simple patch to carry out of tree, on the other hand more than one
person will need it.

> Has anybody actually looked into what it would take to just fix
> Android userspace to use nl80211 to bring up P2P. I just see tons of
> #ifdef added to the kernel.

Yes, I did :-)

However, for any system running Jelly Bean that's not really an option,
and I have no idea if/how K-whatever is coming, so it might not be
possible there either. Additionally, fairly large changes are needed in
wpa_supplicant to actually support the P2P-Device with only nl82011
APIs.

This gives us a transition path while making changes to the other parts
of the stack.

> > +			if (!dev
> > +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> > +			    || (wdev->iftype == NL80211_IFTYPE_P2P_DEVICE &&
> > +				info->genlhdr->cmd != NL80211_CMD_SET_INTERFACE)
> > +#endif
> > +			) {
> > 				mutex_unlock(&cfg80211_mutex);
> > 				if (rtnl)
> > 					rtnl_unlock();
> 
> And doing an #ifdef in the middle of if-clause doesn't ring any alarm
> bells that this might be a really bad idea ;)

Well, I could put an #ifdef into each and every command instead which I
didn't want to, which incidentally is the reason for not allowing this
with WEXT, WEXT ioctls on the P2P-Device netdev just cause crashes :)

Basically this way also reduces the surface of this patch to make it
easier to use out of tree.

> When I am looking at the USB gadget handling, I see a lot of progress
> in establishing a standard kernel interface and changing Android
> userspace to work with that instead.

"progress" doesn't really help, at least in this case it's pretty much
an either-or situation and changing the userspace will take a long time.

johannes

