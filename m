Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:44778 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228AbZBEIpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 03:45:11 -0500
Date: Thu, 5 Feb 2009 10:44:07 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, Samuel Ortiz <samuel@sortiz.org>,
	John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFC] mac80211: Filter scan results
Message-ID: <20090205084407.GA11126@jm.kir.nu> (sfid-20090205_094519_457032_C0D1E591)
References: <20090204150857.GA5069@sortiz.org> <1233789837.24227.19.camel@localhost.localdomain> <1233790539.7390.23.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1233790539.7390.23.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 05, 2009 at 12:35:39AM +0100, Johannes Berg wrote:
> On Wed, 2009-02-04 at 18:23 -0500, Dan Williams wrote:
> > On Wed, 2009-02-04 at 16:08 +0100, Samuel Ortiz wrote:
> > > "print_scanning_info: Allocation failed". wpa_supplicant fails as well, after
> > > reallocating the scan result buffer several times, up to 132 Kbytes:
> > > 	[snip]
> > > 	Scan results did not fit - trying larger buffer (131072 bytes)
> > > 	ioctl[SIOCGIWSCAN]: Argument list too long


> > A somewhat more acceptable, but still unacceptable hack would be to
> > figure out when the returned scan results buffer would be too large, and
> > automatically filter the IEs when it would be to large.
> 
> Nope, that doesn't even work. You'd filter even before the app decided
> to no longer reallocate the scan buffer.

There are number of issues here and I would agree that the proposed
patch is not the way to go. However, I think that there could be
something here that could be done to help this situation with WEXT
(while agreeing that the cfg80211/nl80211 scan is going to be the proper
fix for the issue).

Trying to use 131072 byte buffer is actually a bug in wpa_supplicant and
even the previous attempt of 65536 is not valid. I did not realize
this before, but it was pointed out to me some time ago that the length
field in struct iw_point is only 16 bits, so there is actually a strict
limit of 65535 bytes of data available through SIOCGIWSCAN.

65536 ends up being truncated into zero, so I would assume the largest
buffer wpa_supplicant tries to use in practice is 32768 bytes. I'll fix
this so that the next doubling is actually limited to 65535 (assuming it
works with WEXT code in kernel). I would hope that this helps quite a
bit as far as wpa_supplicant is concerned (almost doubling the maximum
results buffers).

As far as a possible workaround in kernel code is concerned,
length=65535 could be considered a special case. Since it is clear that
userspace cannot provide a larger buffer, there is not much point in
returning -E2BIG. Instead, the results could be truncated after the last
BSS that fit into the buffer and that would be returned to userspace.
This is likely going to be much more useful than not being able to
receive any result.

-- 
Jouni Malinen                                            PGP id EFC895FA
