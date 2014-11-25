Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50331 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbaKYLEQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 06:04:16 -0500
Message-ID: <1416913453.2045.4.camel@sipsolutions.net> (sfid-20141125_120423_547649_CDE1F37B)
Subject: Re: [PATCH] mac80211: check if channels allow 80 MHz for VHT probe
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: YanBo <dreamfly281@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 25 Nov 2014 12:04:13 +0100
In-Reply-To: <CAFuUQkh-fX3rz9+FUBfF8GxbkxrZxP7-iJwmypo5EEANwODqzQ@mail.gmail.com> (sfid-20141125_120059_502403_E712C430)
References: <1416911009-22405-1-git-send-email-johannes@sipsolutions.net>
	 <CAFuUQkh-fX3rz9+FUBfF8GxbkxrZxP7-iJwmypo5EEANwODqzQ@mail.gmail.com>
	 (sfid-20141125_120059_502403_E712C430)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-11-25 at 19:00 +0800, YanBo wrote:
> On Tue, Nov 25, 2014 at 6:23 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > If there are no channels allowing 80 MHz to be used, then the
> > station isn't really VHT capable even if the driver and device
> > support it in general. In this case, exclude the VHT capability
> > IE from probe request frames.
> >
> 
> FYI, there are some new devices could support the VHT even at 20Mhz
> band 2.4G mode.

So in 2.4 GHz we typically don't have VHT anyway - and realistically you
can't support real "VHT" there, you can only support the new
modulations. I think this will require some custom (vendor-specific)
advertisement though, since VHT advertisement implies 80 MHz support.

IOW, I think at this point this patch isn't a problem. If we really need
to support VHT modulations in 2.4 GHz (or even have devices that have
VHT modulation support, but no 80 MHz support in 5 GHz) then some new
advertisement will have to be done.

OTOH, you could argue for that advertisement that on 2.4 GHz you can
never do 80 MHz anyway - but can't you? In theory there's enough
spectrum for exactly one 80 MHz channel ...

johannes

