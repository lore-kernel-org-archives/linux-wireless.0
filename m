Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3007 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935103AbXG0TmA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 15:42:00 -0400
Date: Fri, 27 Jul 2007 15:10:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jean Tourrilhes <jt@hpl.hp.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Re: [PATCH] remove duplicated ioctl entries in compat_ioctl.c
Message-ID: <20070727191053.GA7572@tuxdriver.com>
References: <20070727171301.GA16210@bougret.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070727171301.GA16210@bougret.hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 27, 2007 at 10:13:01AM -0700, Jean Tourrilhes wrote:
> "John W. Linville" wrote :
> > On Mon, Jul 09, 2007 at 07:54:39PM +0900, Masakazu Mokuno wrote:
> > > This patch removes some duplicated wireless ioctl entries in the array
> > > 'struct ioctl_trans ioctl_start[]' of fs/compat_ioctl.c
> > > 
> > > These entries are registered twice like:
> > > 
> > > 	COMPATIBLE_IOCTL(SIOCGIWPRIV)
> > > 
> > > and
> > > 
> > > 	HANDLE_IOCTL(SIOCGIWPRIV, do_wireless_ioctl)
> > > 
> > > 
> > > Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>

> > As I read the code in compat_ioctl.c, it looks to me like the
> > COMPATIBLE_IOCTL definitions are the ones that are actually being
> > used today.  Do you agree?
> 
> 	Actually, you are wrong, and Masakazu is right. All those
> ioctls contains a pointer and should go through the pointer
> conversion.

Masakazu replied in agreement that the COMPATIBLE_IOCTL entries are
the effective ones i.e. the code currently uses those entries and
the others are currently just wasting space.

Perhaps the HANDLE_IOCTL entries are indeed the correct and intended ones.  You seem to be indicating so.

> 	The reason why Masakazu sent that patch is that he actually
> stumbled on the problem and tested it.

The only problem stated is the not-quite-duplicate entries.  If there
is an actual problem (and not just sloppy code) then that makes the
situation more clear.

What is the manifestation of the problem?

> > Given the...stability...of the wireless extensions API, if we are going
> > to remove one or the other of these not-quite-duplicate definitions,
> > shouldn't we remove the HANDLE_IOCTL defintions instead?
> 
> 	I don't understand, you are in favor of breaking the API ?

I'm not sure how an honest reading could imply that.

If this fixes a bug, then fine.  If we are trading the one "duplicate"
entry we have been using for one that hasn't been in use, it doesn't
make much sense.

John
-- 
John W. Linville
linville@tuxdriver.com
