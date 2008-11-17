Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48167 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbYKQPwa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 10:52:30 -0500
Subject: Re: [Orinoco-devel] Agere PCMCIA sometimes takes very long time to
	associate with 9.48 FW
From: Dan Williams <dcbw@redhat.com>
To: Dave <kilroyd@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <491FEF89.3040100@gmail.com>
References: <200810191436.13298.arvidjaar@mail.ru>
	 <491349BC.8090606@gmail.com> <49134F66.4020608@gmail.com>
	 <200811151115.48750.arvidjaar@mail.ru>
	 <20081115145655.GB31553@tuxdriver.com>  <491FEF89.3040100@gmail.com>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 10:50:10 -0500
Message-Id: <1226937010.10028.28.camel@localhost.localdomain> (sfid-20081117_165234_134554_D5620C9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-11-16 at 10:01 +0000, Dave wrote:
> John W. Linville wrote:
> > On Sat, Nov 15, 2008 at 11:15:47AM +0300, Andrey Borzenkov wrote:
> > 
> >> - we should not be doing it in ->open. It is technically legal to set
> >> wireless parameters before "icfonfig up" and we lose all of them. I will
> >> try next week with similar patch in orinoco_stop().
> > 
> > That seems wrong...
> > 
> >> - I am still not even sure we should do it at all. What is sematic of
> >> ifconfig up/down w.r.t. wireless parameters? I.e. is "ifconfig down"
> >> expected to clean all device state and start from scratch?
> > 
> > No.  Unfortunately, it is mostly a matter of opinion as to what
> > wireless extensions expects.
> 
> Agreed with all the above. I'll discard the driver patch.
> 
> There are two other things I can think of:
> 
> 1. make sure wpa_supplicant is shut down before ifconfig ethX down, and
> restart it on resume.

Drivers shouldn't really care about what userspace is driving them; they
need to either return an error for invalid requests, or handle the
request.  Userspace (wpa_supplicant) then needs to be smart enough to
know about device events, which it already does.

> From the data you've provided it looks like your distribution brings the
> device down, but may leave wpa_supplicant running. I've noticed that

That's still a valid case that both the driver and supplicant should
handle.

> every time wpa_supplicant shuts down it removes most configuration
> settings. Or has that changed?

Hasn't changed, on shutdown the supplicant will clear keys and reset
countermeasures and whatnot.

> 2. Does the driver need to send a dissociation event (or something) to
> userspace on ifconfig down?

If the association with the AP is no longer valid, then yes.  Most of
the other drivers do this already, I think.

Dan


