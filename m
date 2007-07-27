Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:51787 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759193AbXG0RNy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 13:13:54 -0400
Date: Fri, 27 Jul 2007 10:13:01 -0700
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: Re: [PATCH] remove duplicated ioctl entries in compat_ioctl.c
Message-ID: <20070727171301.GA16210@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" wrote :
> On Mon, Jul 09, 2007 at 07:54:39PM +0900, Masakazu Mokuno wrote:
> > This patch removes some duplicated wireless ioctl entries in the array
> > 'struct ioctl_trans ioctl_start[]' of fs/compat_ioctl.c
> > 
> > These entries are registered twice like:
> > 
> > 	COMPATIBLE_IOCTL(SIOCGIWPRIV)
> > 
> > and
> > 
> > 	HANDLE_IOCTL(SIOCGIWPRIV, do_wireless_ioctl)
> > 
> > 
> > Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
> > ---
> >  fs/compat_ioctl.c |    3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > --- a/fs/compat_ioctl.c
> > +++ b/fs/compat_ioctl.c
> > @@ -3156,12 +3156,9 @@ COMPATIBLE_IOCTL(SIOCSIWSENS)
> >  COMPATIBLE_IOCTL(SIOCGIWSENS)
> >  COMPATIBLE_IOCTL(SIOCSIWRANGE)
> >  COMPATIBLE_IOCTL(SIOCSIWPRIV)
> > -COMPATIBLE_IOCTL(SIOCGIWPRIV)
> >  COMPATIBLE_IOCTL(SIOCSIWSTATS)
> > -COMPATIBLE_IOCTL(SIOCGIWSTATS)
> >  COMPATIBLE_IOCTL(SIOCSIWAP)
> >  COMPATIBLE_IOCTL(SIOCGIWAP)
> > -COMPATIBLE_IOCTL(SIOCSIWSCAN)
> >  COMPATIBLE_IOCTL(SIOCSIWRATE)
> >  COMPATIBLE_IOCTL(SIOCGIWRATE)
> >  COMPATIBLE_IOCTL(SIOCSIWRTS)
> 
> As I read the code in compat_ioctl.c, it looks to me like the
> COMPATIBLE_IOCTL definitions are the ones that are actually being
> used today.  Do you agree?

	Actually, you are wrong, and Masakazu is right. All those
ioctls contains a pointer and should go through the pointer
conversion.
	The reason why Masakazu sent that patch is that he actually
stumbled on the problem and tested it.

> Given the...stability...of the wireless extensions API, if we are going
> to remove one or the other of these not-quite-duplicate definitions,
> shouldn't we remove the HANDLE_IOCTL defintions instead?

	I don't understand, you are in favor of breaking the API ?

	Regards,

	Jean
