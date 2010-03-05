Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:34993 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab0CEARR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 19:17:17 -0500
From: Kel Modderman <kel@otaku42.de>
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Subject: Re: [PATCH] crda: allow build with gcrypt support
Date: Fri, 5 Mar 2010 10:17:04 +1000
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
References: <201003050011.44807.kel@otaku42.de> <20100304190059.GK8069@bombadil.infradead.org>
In-Reply-To: <20100304190059.GK8069@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003051017.04394.kel@otaku42.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 05 March 2010 05:00:59 Luis R. Rodriguez wrote:
> On Fri, Mar 05, 2010 at 12:11:44AM +1000, Kel Modderman wrote:
> > USE_GCRYPT=0 disables using gcrypt for signature verification.
> > 
> > Signed-off-by: Kel Modderman <kel@otaku42.de>
> > ---
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -28,6 +28,7 @@ CFLAGS += -DUSE_OPENSSL -DPUBKEY_DIR=\"$
> >  LDLIBS += `pkg-config --libs openssl`
> >  
> >  else
> > +ifneq ($(USE_GCRYPT),0)
> >  PUBKEY_DIR?=pubkeys
> >  CFLAGS += -DUSE_GCRYPT
> >  LDLIBS += -lgcrypt
> > @@ -40,6 +41,7 @@ keys-gcrypt: utils/key2pub.py $(wildcard
> >  	$(Q)./utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem) $@
> >  
> >  endif
> > +endif
> >  MKDIR ?= mkdir -p
> >  INSTALL ?= install
> 
> Thanks for the patch but it did not apply, is this against a

It depends on the previous patch because PUBKEY_DIR was moved.

> release or is this against git master? How about something like
> this instead, granted the debian example stuff is now completely
> outdated but nevertheless it covers it based on what is on
> the debian-example/ stuff:
> 
> From: Luis R. Rodriguez <lrodriguez@atheros.com>
> Subject: [PATCH] Use openssl by default
> 
> Now that openssl supports the /etc/wireless-regdb/pubkeys/
> directory to read trusted public keys dynamically just
> enable openssl by default. Propagate this to the debian
> and rpm package build files.

1. wireless-regdb does not install custom keys to /etc/wireless-regdb/pubkeys/

2. crypto data would be needlessly embedded into the binaries

3. $(PREFIX)/lib/crda/pukeys/linville.pub.pem would be a waste of space

4. why have all this code supporting embedding of crypto data into binary
   when its no longer needed

> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  Makefile                 |   14 ++++++------
>  crda.spec                |    6 ++--
>  debian-example/changelog |    7 ++++++
>  debian-example/control   |   29 ++++++++++++++++++++-------
>  debian-example/copyright |   48 ++++++++++++++++++++++++++++++---------------
>  5 files changed, 70 insertions(+), 34 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index b8bc7d3..0ab1e2b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -29,18 +29,18 @@ all: all_noverify verify
>  
>  all_noverify: crda intersect regdbdump
>  
> -ifeq ($(USE_OPENSSL),1)
> -CFLAGS += -DUSE_OPENSSL -DPUBKEY_DIR=\"$(RUNTIME_PUBKEY_DIR)\" `pkg-config --cflags openssl`
> -LDLIBS += `pkg-config --libs openssl`
> -
> -reglib.o: keys-ssl.c
> -
> -else
> +ifeq ($(USE_GCRYPT),1)
>  CFLAGS += -DUSE_GCRYPT
>  LDLIBS += -lgcrypt
>  
>  reglib.o: keys-gcrypt.c
>  
> +else
> +CFLAGS += -DUSE_OPENSSL -DPUBKEY_DIR=\"$(RUNTIME_PUBKEY_DIR)\" `pkg-config --cflags openssl`
> +LDLIBS += `pkg-config --libs openssl`
> +
> +reglib.o: keys-ssl.c
> +
>  endif
>  MKDIR ?= mkdir -p
>  INSTALL ?= install
> diff --git a/crda.spec b/crda.spec
> index f44a3e5..9876d90 100644
> --- a/crda.spec
> +++ b/crda.spec
> @@ -1,6 +1,6 @@
>  Summary: Linux central regulatory domain agent
>  Name: crda
> -Version: 1.0.1
> +Version: 1.1.1
>  Release: 1
>  License: ISC
>  Group: System Enviroment/Base
> @@ -8,8 +8,8 @@ Source: http://wireless.kernel.org/download/crda/crda-%version.tar.bz2
>  URL: http://wireless.kernel.org/en/developers/Regulatory/
>  Packager: Luis R. Rodriguez <mcgrof@gmail.com>
>  BuildRoot : /var/tmp/%{name}-buildroot
> -Requires: libnl, libgcrypt
> -BuildRequires: libnl-devel, gcc, wireless-regdb, libgcrypt-devel, m2crypto
> +Requires: libnl, openssl
> +BuildRequires: libnl-devel, gcc, wireless-regdb, openssl-devel, m2crypto
>  
>  %description
>  This package provides CRDA to be used by the new Linux kernel
> diff --git a/debian-example/changelog b/debian-example/changelog
> index b083b42..4d273d2 100644
> --- a/debian-example/changelog
> +++ b/debian-example/changelog
> @@ -1,3 +1,10 @@
> +crda (1.1.1-1) unstable; urgency=low
> +
> +  * New package slightly based on Kel Modderman <kel@otaku42.de>'s work
> +  * Use openssl instead of gcrypt to enable dynamic reading of keys
> +
> + -- Luis R. Rodriguez <mcgrof@gmail.com>  Sat, 24 Jan 2009 16:00:00 +0100
> +
>  crda (1.0.1-1) unstable; urgency=low
>  
>    * Compiles nicely on # CPUs > 1
> diff --git a/debian-example/control b/debian-example/control
> index eba7c0c..7e3334f 100644
> --- a/debian-example/control
> +++ b/debian-example/control
> @@ -1,17 +1,30 @@
>  Source: crda
>  Section: admin
>  Priority: optional
> -Maintainer: Luis R. Rodriguez <mcgrof@gmail.com>
> -Build-Depends: cdbs, debhelper (>= 5), gcc, wireless-regdb, libgcrypt11-dev, python-m2crypto, libnl1
> -Standards-Version: 3.7.3
> +Maintainer: Debian/Ubuntu wpasupplicant Maintainers <pkg-wpa-devel@lists.alioth.debian.org>
> +Uploaders: Luis R. Rodriguez <mcgrof@gmail.com>
> +Build-Depends: cdbs, debhelper (>= 7.0.50),
> + gcc,
> + wireless-regdb,
> + libssl-dev,
> + python-m2crypto,
> + libnl1,
> + libnl-dev
> +Standards-Version: 3.8.1
>  
>  Package: crda
> -Architecture: all
> -Depends: udev, libgcrypt11, libnl1
> -Suggests: iw
> +Architecture: any
> +Depends: ${shlibs:Depends}, ${misc:Depends}, wireless-regdb
> +Recommends: iw (>= 0.9.18-1)
>  Description: Linux wireless central regulatory domain agent
> - This package provides CRDA to be used by the new Linux kernel wireless
> - subsystem to query from userspace regulatory domains. For more information
> + This package provides CRDA to be used by the new Linux kernel
> + cfg80211 wireless subsystem to query from userspace regulatory
> + domain settings wireless devices may operate within for a given location.
> + .
> + CRDA queries operational frequency regulations stored within the regulatory
> + database provided by the wireless-regdb package.
> + .
> + For more information
>   see:
>   .
>   http://wireless.kernel.org/en/developers/Regulatory/
> diff --git a/debian-example/copyright b/debian-example/copyright
> index 85d6068..3325045 100644
> --- a/debian-example/copyright
> +++ b/debian-example/copyright
> @@ -1,21 +1,37 @@
> -This package was debianized by Luis Rodriguez <mcgrof@gmail.com> on
> -Thu, 22 Jan 2009 16:00:00 +0100.
> +Upstream-Name: crda
> +Upstream-Maintainer: Luis R. Rodriguez <mcgrof@gmail.com>
> +Upstream-Source: git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/crda.git
>  
> -The crda packages was downloaded from <http://wireless.kernel.org/download/crda/>
> +Files: *
> +Copyright: Copyright (c) 2008, Luis R. Rodriguez <mcgrof@gmail.com>
> +Copyright: Copyright (c) 2008, Johannes Berg <johannes@sipsolutions.net>
> +Copyright: Copyright (c) 2008, Michael Green <Michael.Green@Atheros.com>
> +License: ISC
>  
> -Copyright (c) 2008, Luis R. Rodriguez <mcgrof@gmail.com>
> -Copyright (c) 2008, Johannes Berg <johannes@sipsolutions.net>
> -Copyright (c) 2008, Michael Green <Michael.Green@Atheros.com>
> +Files: nl80211.h
> +Copyright: Copyright 2006, 2007, 2008 Johannes Berg <johannes@sipsolutions.net>
> +Copyright: Copyright 2008 Michael Wu <flamingice@sourmilk.net>
> +Copyright: Copyright 2008 Luis Carlos Cobo <luisca@cozybit.com>
> +Copyright: Copyright 2008 Michael Buesch <mb@bu3sch.de>
> +Copyright: Copyright 2008 Luis R. Rodriguez <lrodriguez@atheros.com>
> +Copyright: Copyright 2008 Jouni Malinen <jouni.malinen@atheros.com>
> +Copyright: Copyright 2008 Colin McCabe <colin@cozybit.com>
> +License: ISC
>  
> -Permission to use, copy, modify, and/or distribute this software for any
> -purpose with or without fee is hereby granted, provided that the above
> -copyright notice and this permission notice appear in all copies.
> +Files: debian/*
> +Copyright: Copyright (c) 2009, Kel Modderman <kel@otaku42.de>
> +Copyright: Copyright (c) 2010, Luis R. Rodriguez <mcgrof@gmail.com>
> +License: ISC
>  
> -THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> -WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> -MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> -ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> -WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> -ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> -OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> +License: ISC
> + Permission to use, copy, modify, and/or distribute this software for any
> + purpose with or without fee is hereby granted, provided that the above
> + copyright notice and this permission notice appear in all copies.
>  
> + THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> + ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> + ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> + OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> 
