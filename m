Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sipsolutions.net ([144.76.43.152]:49686 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758089Ab3DXIbs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 04:31:48 -0400
Message-ID: <1366792305.11111.4.camel@jlt4.sipsolutions.net> (sfid-20130424_103202_642130_ED744E50)
Subject: Re: [RFC] cfg80211: Android P2P-Device workaround
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org
Date: Wed, 24 Apr 2013 10:31:45 +0200
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

> >> When I am looking at the USB gadget handling, I see a lot of progress
> >> in establishing a standard kernel interface and changing Android
> >> userspace to work with that instead.
> >
> > "progress" doesn't really help, at least in this case it's pretty much
> > an either-or situation and changing the userspace will take a long time.
> 
> As long as changing the user-space is done eventually, right.

Separate subthread for this ...

What do we even consider to be the "right" changes? Android really only
wants a "p2p0" control/monitor socket in wpa_supplicant, it doesn't
really care about anything else (apart from the stupidity about wanting
a p2p0 netdev to set it UP) whether you use P2P-Device in the kernel or
not.

So I would say that using the "standard kernel interface" is actually
more of a wpa_supplicant thing, I think it should simply allow the
option of
 a) use the P2P-Device internally (as David Spinadel's patches do)
 b) be able to create a separate control/monitor P2P socket, regardless
of
    whether there's a P2P-Device or not

Alternatively, Android could presumably use the regular socket for P2P,
but I'm not sure what the reason is for not doing so?

johannes

