Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.191]:63672 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938545AbXHIFn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2007 01:43:26 -0400
Received: by rv-out-0910.google.com with SMTP id k20so322212rvb
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2007 22:43:25 -0700 (PDT)
Message-ID: <a728f9f90708082243u2e66e84cjeed8856722c4bea5@mail.gmail.com>
Date: Thu, 9 Aug 2007 01:43:25 -0400
From: "Alex Deucher" <alexdeucher@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Marvell pci wifi chips
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <a728f9f90708072129m2c5dd9f8j70e5bba44e504ff0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <a728f9f90708070921x13c1a9fem8f7bbf3fe77756d@mail.gmail.com>
	 <20070807173431.GC3330@tuxdriver.com>
	 <a728f9f90708072129m2c5dd9f8j70e5bba44e504ff0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/8/07, Alex Deucher <alexdeucher@gmail.com> wrote:
> On 8/7/07, John W. Linville <linville@tuxdriver.com> wrote:
> > On Tue, Aug 07, 2007 at 12:21:02PM -0400, Alex Deucher wrote:
> > > Is anyone working on a driver for the marvell pci libertas chips
> > > (8335, 8300, 8310, etc.) or know of someone who is?  I've got several
> > > of these cards not doing anything at the moment if someone is
> > > interested in one.  It seems there are several drivers floating
> > > around:
> > >
> > > - mrv8k driver (http://www.saillard.org/linux/mrv8k/)
> > > - openbsd malo driver (http://www.openbsd.org/cgi-bin/man.cgi?query=malo)
> > > - marvell GPL driver (http://johannes.sipsolutions.net/files/marvell.tar.bz2)
> > >
> > > Reading through the linux-wireless archive, several people seemed to
> > > indicate there was work going on, but I have not been able to find any
> > > information on that other than Holger's CF libertas integration.  I
> > > and others have asked before, but there seems to be some confusion as
> > > to the whole libertas line and their relative compatibility.  Just
> > > curious.
> >
> > I think I saw discussion lately to the effect that the PCI devices are
> > not currently supported, and that they likely could be supported by
> > simply implementing a PCI front-end to the core of the libertas code.
> > I think Holger is the person most likely to know for sure.
> >
> > I've got cards like that too -- would love for you to get them
> > working... :-)
>
> Has anyone tested the marvell driver
> (http://johannes.sipsolutions.net/files/marvell.tar.bz2)?  Does it
> work?

I attempted to build the driver on 2.6.22, but I got the following
errors.  Unfortunately, I'm not too familiar with the net80211 stuff.
Anyone got any ideas?

  CC [M]  drivers/net/wireless/marvell_softap/driver/mwl_debug.o
In file included from drivers/net/wireless/marvell_softap/driver/mwl_main.h:42,
                 from drivers/net/wireless/marvell_softap/driver/mwl_debug.h:42,
                 from drivers/net/wireless/marvell_softap/driver/mwl_debug.c:26:
drivers/net/wireless/marvell_softap/driver/mwl_descriptors.h:72:
warning: 'packed' attribute ignored
drivers/net/wireless/marvell_softap/driver/mwl_descriptors.h:90:
warning: 'packed' attribute ignored
In file included from drivers/net/wireless/marvell_softap/driver/mwl_main.h:43,
                 from drivers/net/wireless/marvell_softap/driver/mwl_debug.h:42,
                 from drivers/net/wireless/marvell_softap/driver/mwl_debug.c:26:
drivers/net/wireless/marvell_softap/driver/mwl_wlanext.h:37:26: error:
if_ethersubr.h: No such file or directory
drivers/net/wireless/marvell_softap/driver/mwl_wlanext.h:38:22: error:
if_media.h: No such file or directory
drivers/net/wireless/marvell_softap/driver/mwl_wlanext.h:39:20: error:
if_llc.h: No such file or directory
drivers/net/wireless/marvell_softap/driver/mwl_wlanext.h:40:27: error:
ieee80211_var.h: No such file or directory
In file included from drivers/net/wireless/marvell_softap/driver/mwl_debug.h:42,
                 from drivers/net/wireless/marvell_softap/driver/mwl_debug.c:26:
drivers/net/wireless/marvell_softap/driver/mwl_main.h:44:29: error:
ieee80211_proto.h: No such file or directory
In file included from drivers/net/wireless/marvell_softap/driver/mwl_debug.h:42,
                 from drivers/net/wireless/marvell_softap/driver/mwl_debug.c:26:
drivers/net/wireless/marvell_softap/driver/mwl_main.h:125: error:
field 'beaconOffsets' has incomplete type
drivers/net/wireless/marvell_softap/driver/mwl_main.h:129: error:
field 'node' has incomplete type
drivers/net/wireless/marvell_softap/driver/mwl_main.h:200: warning:
'enum ieee80211_state' declared inside parameter list
drivers/net/wireless/marvell_softap/driver/mwl_main.h:200: warning:
its scope is only this definition or declaration, which is probably
not what you want
drivers/net/wireless/marvell_softap/driver/mwl_main.h:200: warning:
'struct ieee80211com' declared inside parameter list
drivers/net/wireless/marvell_softap/driver/mwl_main.h:201: warning:
'struct ieee80211com' declared inside parameter list
drivers/net/wireless/marvell_softap/driver/mwl_main.h:204: warning:
'struct ieee80211com' declared inside parameter list
drivers/net/wireless/marvell_softap/driver/mwl_main.h:208: warning:
'struct ieee80211com' declared inside parameter list
drivers/net/wireless/marvell_softap/driver/mwl_main.h:231: error:
field 'curr80211com' has incomplete type
drivers/net/wireless/marvell_softap/driver/mwl_main.h:232: error:
field 'initialOpmode' has incomplete type
drivers/net/wireless/marvell_softap/driver/mwl_main.h:233: error:
field 'currChannel' has incomplete type
make[4]: *** [drivers/net/wireless/marvell_softap/driver/mwl_debug.o] Error 1
make[3]: *** [drivers/net/wireless/marvell_softap] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2


Thanks,

Alex
