Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:64328 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbYE1Nab (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 09:30:31 -0400
Subject: Re: [PATCH 3/5] hostap: remove private "monitor" ioctl
From: Pavel Roskin <proski@gnu.org>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <20080526094406.GI4932@jm.kir.nu>
References: <20080523015442.16636.92254.stgit@dv.roinet.com>
	 <20080523015454.16636.44068.stgit@dv.roinet.com>
	 <20080526094406.GI4932@jm.kir.nu>
Content-Type: text/plain
Date: Wed, 28 May 2008 09:30:29 -0400
Message-Id: <1211981429.31989.29.camel@dv> (sfid-20080528_153035_014954_E76598CA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-05-26 at 12:44 +0300, Jouni Malinen wrote:
> On Thu, May 22, 2008 at 09:54:54PM -0400, Pavel Roskin wrote:
> > This is an ioctl obsoleted by the monitor mode years ago.  Using it
> > would trigger a deprecation warning.  As the wireless drivers
> > standardize on the radiotap standard, the "monitor" ioctl cannot be
> > preserved to work as obsolete software expects.
> 
> I don't follow the login here... Why "cannot be preserved"? I might go
> with "we do not want to preserve this", but I do not see any technical
> reason that would prevent us from supporting existing user space
> interface that has been used in the past and may still be in use.

The old ioctl was supporting bare 802.11, prism and AVS headers.  I want
to replace all three of them with radiotap.  I had to leave bare 802.11
support for the AP interface (wlan0ap) for hostapd compatibility, but
the main interface should only support radiotap.

Suppose we want to support the old ioctl.  All three types of headers
that could be requested are going away now.  Can we expect the software
that doesn't know of "iwconfig mode monitor" to know radiotap headers?
I don't think so.

> Since
> this may break existing user space programs, I do not think this should
> go in. Obviously, same goes for removal of the actual use of this
> parameter and support for different header formats in patch 5/5. Adding
> support for radiotap format is of course reasonable, but I would be more
> careful with removing existing functionality which may still be in use.

OK, if that's what you prefer, I can do it.

-- 
Regards,
Pavel Roskin
