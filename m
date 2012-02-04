Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57068 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab2BDNmq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Feb 2012 08:42:46 -0500
Date: Sat, 4 Feb 2012 11:44:15 -0200
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Richard Farina <sidhayn@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	wireless <linux-wireless@vger.kernel.org>,
	Jon Masters <jcm@jonmasters.org>, linux-modules@vger.kernel.org
Subject: Re: [compat-wireless] modprobe -l is legacy compatibility mode and
 is being removed from some distros
Message-ID: <20120204134415.GB528@vader> (sfid-20120204_144251_716892_5B7FF899)
References: <4F1F0810.2000306@gmail.com>
 <4F25BCAE.3040709@hauke-m.de>
 <4F27F4DC.6080101@gmail.com>
 <CAB=NE6WzrBy+yEzgtNbS7yAyuVkXDumMG-XEwQ96P6ztzV=iEg@mail.gmail.com>
 <874nv8k295.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <874nv8k295.fsf@rustcorp.com.au>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Rusty Russell <rusty@rustcorp.com.au> [2012-02-03 14:16:30 +1030]:

> On Tue, 31 Jan 2012 15:15:45 -0800, "Luis R. Rodriguez" <mcgrof@gmail.com> wrote:
> > On Tue, Jan 31, 2012 at 6:04 AM, Richard Farina <sidhayn@gmail.com> wrote:
> > > On 01/29/2012 04:39 PM, Hauke Mehrtens wrote:
> > >>
> > >> On 01/24/2012 08:35 PM, Richard Farina wrote:
> > >>>
> > >>> module-init-tools has been deprecated in favor of kmod in Arch Linux,
> > >>> and kmod doesn't have the legacy --list option for modprobe.
> > >>> This patch fixes the areas of the Makefile which actually needed the
> > >>> output of modprobe -l. The other 100's of uses are just to echo info to
> > >>> the screen which in this case will simply fail in an extremely noisy
> > >>> fashion yet non-fatal way.
> > >>>
> > >>> Please apply to all branches.
> > >>>
> > >>> Signed-of-By: Rick Farina<sidhayn@gmail.com>
> > >>>
> > >>> diff -Naur compat-wireless-3.3-rc1-2/Makefile
> > >>> compat-wireless-3.3-rc1-2-modinfo-migration/Makefile
> > >>> --- compat-wireless-3.3-rc1-2/Makefile    2012-01-21 02:00:21.000000000
> > >>> -0500
> > >>> +++ compat-wireless-3.3-rc1-2-modinfo-migration/Makefile    2012-01-24
> > >>> 14:27:20.000000000 -0500
> > >>> @@ -9,11 +9,6 @@
> > >>>  # Sometimes not available in the path
> > >>>  MODPROBE := /sbin/modprobe
> > >>>
> > >>> -ifneq ($(wildcard $(MODPROBE)),)
> > >>> -MADWIFI=$(shell $(MODPROBE) -l ath_pci)
> > >>> -OLD_IWL=$(shell $(MODPROBE) -l iwl4965)
> > >>> -endif
> > >>> -

Why do you need to know this? If you really need this, it can be well
accomplished by 'find'. That's the reason it was removed from modprobe
(and it was already deprecated in module-init-tools).

But what's the point in knowing where the file is?

> > >>
> > >> What happens if modinfo is not available? I do not know on what systems
> > >> this is the case, but I do not think that modinfo is available when
> > >> modprobe is not.
> > >
> > > AFAIK this is never the case.  modinfo is packaged with module-init-tools
> > > and on Arch module-init-tools has been replaced by KMOD which also includes
> > > modinfo.  It would seem to me that at this point modinfo is a required tool
> > > and is always packaged with modprobe.
> > 
> > Rusty, should all Linux distributions that carry modprobe also have modinfo ?
> 
> Yes, at least so far.  But you should make sure the kmod guys are in the
> loop, so they know exactly what you're trying to do.
> 

Yes, let us know what exactly you are trying to accomplish here.


Lucas De Marchi
