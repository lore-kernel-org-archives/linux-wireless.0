Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbXGGVaN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2007 17:30:13 -0400
Subject: Re: Errors when firmware is missing
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jon Smirl <jonsmirl@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1183826476.3779.42.camel@johannes.berg>
References: <9e4733910707070927l37bdf79cpd1fc672909fb0bb3@mail.gmail.com>
	 <1183826476.3779.42.camel@johannes.berg>
Content-Type: text/plain
Date: Sat, 07 Jul 2007 17:34:34 -0400
Message-Id: <1183844074.16396.3.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-07-07 at 18:41 +0200, Johannes Berg wrote:
> On Sat, 2007-07-07 at 12:27 -0400, Jon Smirl wrote:
> > I have a new Broadcom 4318 adapter (which has exactly the same issues
> > with promiscuous mode).
> 
> Huh? That's really weird.
> 
> > I didn't have the right firmware down for it
> > and I received this error message when I did "ifconfig wlan up"
> > SIOCSIFFLAGS: No such file or directory.  This is not the most user
> > friendly error message, but I did receive a log entry.
> > 
> > I tried the same thing with the zd1211. In this case the wlan0 device
> > didn't get created.
> > 
> > Does it make sense to specify consistent behavior when the firmware is missing?
> 
> It does, and I believe we've talked about it at the wireless summits,
> but I'm not aware that we've reached a conclusion. It would probably be
> nice to have an error message -EFIRMWARE or something; that for zd1211
> no device is created is probably counter-productive, that way userspace
> will never know that a wireless adapter is plugged in.

Drivers should be returning -ENOENT (the error from request_firmware()
when the firmware isn't found) when userspace sets IFF_UP on the device,
so that userspace has the faintest hope of intelligently informing the
user.

Dan


