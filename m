Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:43256 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbYE1OtV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 10:49:21 -0400
Date: Wed, 28 May 2008 17:48:28 +0300
From: Jouni Malinen <j@w1.fi>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 3/5] hostap: remove private "monitor" ioctl
Message-ID: <20080528144828.GA6744@jm.kir.nu> (sfid-20080528_164924_873773_ECA35561)
References: <20080523015442.16636.92254.stgit@dv.roinet.com> <20080523015454.16636.44068.stgit@dv.roinet.com> <20080526094406.GI4932@jm.kir.nu> <1211981429.31989.29.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1211981429.31989.29.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 28, 2008 at 09:30:29AM -0400, Pavel Roskin wrote:

> The old ioctl was supporting bare 802.11, prism and AVS headers.  I want
> to replace all three of them with radiotap.  I had to leave bare 802.11
> support for the AP interface (wlan0ap) for hostapd compatibility, but
> the main interface should only support radiotap.
> 
> Suppose we want to support the old ioctl.  All three types of headers
> that could be requested are going away now.  Can we expect the software
> that doesn't know of "iwconfig mode monitor" to know radiotap headers?
> I don't think so.

Where is this "are going away now" statement coming from? I see no
technical reason for this apart from simplifying the implementation.

> > this may break existing user space programs, I do not think this should
> > go in. Obviously, same goes for removal of the actual use of this
> > parameter and support for different header formats in patch 5/5. Adding
> > support for radiotap format is of course reasonable, but I would be more
> > careful with removing existing functionality which may still be in use.
> 
> OK, if that's what you prefer, I can do it.

I'm not strongly against replacing the old formats with radiotap, but I
just do not follow the logic given as reasons for doing this as a simple
replacement instead of doing it in steps (add radiotap now; remove
deprecated formats later).

I do not know how common user space programs that do not support
radiotap, but would support one (or more) of the old formats (and
similarly for the private ioctl vs. generic mode ioctl). If these kinds
of cases are very rare, I could see better justification for simple
replacement. If such programs are still in active use in systems that
could be expected to upgrade to the new kernel version, there is much
more justification to keep the old formats available and just make it
clearer that they are deprecated and will be removed at a certain point
in the future.

-- 
Jouni Malinen                                            PGP id EFC895FA
