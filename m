Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60042 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3KGTPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Nov 2013 14:15:13 -0500
Date: Thu, 7 Nov 2013 14:11:23 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: future of prism2_usb (aka wlan-ng) in staging tree
Message-ID: <20131107191122.GD2002@tuxdriver.com> (sfid-20131107_201532_948331_6431EAE4)
References: <20131107160522.GA12612@shaftnet.org>
 <527BC04F.2080000@lwfinger.net>
 <20131107163719.GC12612@shaftnet.org>
 <20131107175201.GA2002@tuxdriver.com>
 <20131107185714.GD12612@shaftnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131107185714.GD12612@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 07, 2013 at 01:57:14PM -0500, Solomon Peachy wrote:
> On Thu, Nov 07, 2013 at 12:52:02PM -0500, John W. Linville wrote:
> > I haven't looked at the driver in question in a long time.  Are there
> > actually any users?
> 
> I honestly don't know who all uses it these days, since it's 
> 802.11b-only and being USB, eminantly replacable with something more 
> modern.
> 
> Still, the driver and hardware works, and it's no more obsolete than the 
> likes of hostap, orinoco, aironet, zd1201, and others -- All of which 
> live on under net/wireless even though they still lack cfg80211 support.

And all of which were nominated by someone (possibly me) to be shuffled
out of the tree due to lack of users and unknown functional status...

> BTW, this is my current WIP diffstat:
> 
>  drivers/staging/wlan-ng/Makefile           |    2
>  drivers/staging/wlan-ng/hfa384x.h          |    2 
>  drivers/staging/wlan-ng/hfa384x_usb.c      |   67 ++----
>  drivers/staging/wlan-ng/p80211conv.c       |   70 ------
>  drivers/staging/wlan-ng/p80211metadef.h    |    3 
>  drivers/staging/wlan-ng/p80211metastruct.h |    9 
>  drivers/staging/wlan-ng/p80211netdev.c     |   79 +++----
>  drivers/staging/wlan-ng/p80211netdev.h     |   35 ---
>  drivers/staging/wlan-ng/prism2fw.c         |   86 +++----
>  drivers/staging/wlan-ng/prism2mgmt.c       |  126 ++++-------
>  drivers/staging/wlan-ng/prism2mib.c        |   64 ++---
>  drivers/staging/wlan-ng/prism2sta.c        |  118 ++++------
>  drivers/staging/wlan-ng/p80211ioctl.h      |   89 -------
>  drivers/staging/wlan-ng/p80211req.c        |  251 ----------------------
>  drivers/staging/wlan-ng/p80211req.h        |   53 ----
>  drivers/staging/wlan-ng/p80211wep.c        |  301 ---------------------------
>  16 files changed, 248 insertions(+), 1107 deletions(-)
> 
> Aside from fixing up a boatload of checkpatch warnings, I've been 
> stripping out more legacy cruft (eg custom ioctl, host-side WEP, more 
> plumbing) that's not relevant any longer.

I don't want to discourage anyone from working on something that
scratches their itch, especially if you have working hardware and
some users.  OTOH, I'd rather not add a long term support burden to
the kernel if nobody is going to use it...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
