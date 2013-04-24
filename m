Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sipsolutions.net ([144.76.43.152]:49690 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756672Ab3DXIdd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 04:33:33 -0400
Message-ID: <1366792108.11111.0.camel@jlt4.sipsolutions.net> (sfid-20130424_103338_896774_AE8859DB)
Subject: Re: [RFC] cfg80211: Android P2P-Device workaround
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org
Date: Wed, 24 Apr 2013 10:28:28 +0200
In-Reply-To: <51779434.4010709@broadcom.com>
References: <1366721149-5440-1-git-send-email-johannes@sipsolutions.net>
	 <EC4E16A7-2F9E-4E59-A561-88C85A459BCA@holtmann.org>
	 <1366735340.8385.20.camel@jlt4.sipsolutions.net>
	 <51779434.4010709@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-24 at 10:13 +0200, Arend van Spriel wrote:

> If android is moving to 3.8 kernel with KLP (key lime pie), you could 
> say that it requires middleware/wifi-framework to deal with the new 
> kernel API. However, it mostly involves wpa_supplicant regardless of 
> using it on android or not. So this is more a wpa_supplicant P2P hack.

There's no driver in 3.8 though that even uses P2P-Device. :-)

> >>> +#ifdef CONFIG_CFG80211_ANDROID_P2P_HACK
> >>> +			    || (wdev->iftype == NL80211_IFTYPE_P2P_DEVICE &&
> >>> +				info->genlhdr->cmd != NL80211_CMD_SET_INTERFACE)
> >>> +#endif
> >>> +			) {
> >>> 				mutex_unlock(&cfg80211_mutex);
> >>> 				if (rtnl)
> >>> 					rtnl_unlock();
> >>
> >> And doing an #ifdef in the middle of if-clause doesn't ring any alarm
> >> bells that this might be a really bad idea ;)
> >
> > Well, I could put an #ifdef into each and every command instead which I
> > didn't want to, which incidentally is the reason for not allowing this
> > with WEXT, WEXT ioctls on the P2P-Device netdev just cause crashes :)
> 
> I dislike these kind of constructs as well so I would like this to be 
> made somewhat cleaner (conditional helper function?).

Actually I had to change it anyway, see the v2 patch, to fix a crash
when removing the p2p-device again.

johannes

