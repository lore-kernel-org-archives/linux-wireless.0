Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756949Ab2IXQls (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 12:41:48 -0400
Message-ID: <1348505103.8464.16.camel@dcbw.foobar.com> (sfid-20120924_184152_790226_5566D40F)
Subject: Re: compile error iw on centos 5
From: Dan Williams <dcbw@redhat.com>
To: info <info@tonyspcrepairs.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 24 Sep 2012 11:45:03 -0500
In-Reply-To: <07A9A66798FE4AEEBDD199D961D87597@asusPC>
References: <CAPU73_t5_XjvPURXedOJGmfpRKZi9UG=_6rm7DXUBcRMDaqU8w@mail.gmail.com>
	 <20120924154646.GC32351@tuxdriver.com>
	 <07A9A66798FE4AEEBDD199D961D87597@asusPC>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-09-24 at 17:06 +0100, info wrote:
> sadly no, I've tried later versions and even iw-latest.tar.bz2 but each one 
> fails to compile with each version giving a different reason for the fail.

Well, the point here was that trying to run anything nl80211-based (like
'iw') on Centos 5 is simply not expected to work, because Centos 5 is
too old to support most of what 'iw' needs, both compile-time stuff and
likely runtime stuff.  The 2.6.18 kernel that Centos 5 has was
originally released in 2006, and that was *long* before any
nl80211-based wifi stuff was usable.  Which means iw is quite unlikely
to ever work there.

RHEL 6 (or Centos 6) have good nl80211 support and thus would be  much
more likely to work with 'iw'.

Dan

> 
> -----Original Message----- 
> From: John W. Linville
> Sent: Monday, September 24, 2012 4:46 PM
> To: Anthony Griffiths
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: compile error iw on centos 5
> 
> The wireless stack in RHEL 5 (and therefore CentOS 5) is rather old.
> I'm not sure that trying to run an updated iw on it will be a fruitful
> exercise...?
> 
> On Mon, Sep 24, 2012 at 09:59:52AM +0100, Anthony Griffiths wrote:
> > I'm trying to compile iw in centos5.8 server (command line only). I
> > have libnl and libnl-devel installed:
> > ]# rpm -q libnl
> > libnl-1.0-0.10.pre5.5
> > I've tried 4 different versions of iw*.tar.bz2 but all give compile
> > errors that i can't resolve. The last one I tried was iw-0.9.1 but
> > make gives:
> > ]# make
> >  CC   interface.o
> > In file included from /usr/include/net/if.h:26,
> >                  from interface.c:2:
> > /usr/include/sys/types.h:62: error: conflicting types for ‘dev_t’
> > /lib/modules/2.6.18-308.13.1.el5/source//include/linux/types.h:22:
> > error: previous declaration of ‘d                 ev_t’ was here
> > /usr/include/sys/types.h:67: error: conflicting types for ‘gid_t’
> > /lib/modules/2.6.18-308.13.1.el5/source//include/linux/types.h:54:
> > error: previous declaration of ‘g                 id_t’ was here
> > /usr/include/sys/types.h:72: error: conflicting types for ‘mode_t’
> > /lib/modules/2.6.18-308.13.1.el5/source//include/linux/types.h:24:
> > error: previous declaration of ‘m                 ode_t’ was here
> > /usr/include/sys/types.h:77: error: conflicting types for ‘nlink_t’
> > /lib/modules/2.6.18-308.13.1.el5/source//include/linux/types.h:25:
> > error: previous declaration of ‘n                 link_t’ was here
> > /usr/include/sys/types.h:82: error: conflicting types for ‘uid_t’
> > /lib/modules/2.6.18-308.13.1.el5/source//include/linux/types.h:53:
> > error: previous declaration of ‘u                 id_t’ was here
> > In file included from /usr/include/sys/types.h:133,
> >                  from /usr/include/net/if.h:26,
> >                  from interface.c:2:
> > /usr/include/time.h:105: error: conflicting types for ‘timer_t’
> > /lib/modules/2.6.18-308.13.1.el5/source//include/linux/types.h:31:
> > error: previous declaration of ‘t                 imer_t’ was here
> > In file included from /usr/include/sys/types.h:220,
> >                  from /usr/include/net/if.h:26,
> >                  from interface.c:2:
> > /usr/include/sys/select.h:78: error: conflicting types for ‘fd_set’
> > /lib/modules/2.6.18-308.13.1.el5/source//include/linux/types.h:21:
> > error: previous declaration of ‘f                 d_set’ was here
> > In file included from /usr/include/net/if.h:26,
> >                  from interface.c:2:
> > /usr/include/sys/types.h:235: error: conflicting types for ‘blkcnt_t’
> > /lib/modules/2.6.18-308.13.1.el5/source//include/linux/types.h:142:
> > error: previous declaration of ‘                 blkcnt_t’ was here
> > make: *** [interface.o] Error 1
> >
> > There is no iw yum package for centos5 that I can find.
> > I've been searching google but cannot find a solution to the above
> > error, thanks for any help.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" 
> > in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 


