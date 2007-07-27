Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MGW4.Sony.CO.JP ([137.153.0.46]:49894 "EHLO mgw4.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760650AbXG0Bft (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 21:35:49 -0400
Date: Fri, 27 Jul 2007 10:35:38 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] remove duplicated ioctl entries in compat_ioctl.c
Cc: linux-wireless@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	geoffrey.levand@am.sony.com
In-Reply-To: <20070726185029.GC6068@tuxdriver.com>
References: <20070709193744.D021.MOKUNO@sm.sony.co.jp> <20070726185029.GC6068@tuxdriver.com>
Message-Id: <20070727095654.3268.MOKUNO@sm.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 26 Jul 2007 14:50:29 -0400
"John W. Linville" <linville@tuxdriver.com> wrote:

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

Yes. The latter one in the array is silently ignored. In our case, 
HANDLE_IOCTL(SIOCGIWPRIV, do_wireless_ioctl) ignored.

> Given the...stability...of the wireless extensions API, if we are going
> to remove one or the other of these not-quite-duplicate definitions,
> shouldn't we remove the HANDLE_IOCTL defintions instead?

I'm not sure which is better to keep. 
We can keep COMPATIBLE_IOCTL entries if the userland apps could work
around iw_point.pointer issue for these ioctls.

--
Masakazu MOKUNO

