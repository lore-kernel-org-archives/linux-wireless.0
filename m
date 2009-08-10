Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:49018 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbZHJWa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 18:30:27 -0400
Received: by pzk34 with SMTP id 34so3112343pzk.4
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 15:30:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A809B8D.5000309@redfish-solutions.com>
References: <4A7A8F7E.6020503@redfish-solutions.com> <1249576886.14919.16.camel@mj>
	<43e72e890908060956j3548c23ak4cf98d11c32efec0@mail.gmail.com>
	<1249580707.14919.29.camel@mj> <43e72e890908061142w41d3c0e8x1dc81ffd3ac5b8ae@mail.gmail.com>
	<4A7BD15E.1030604@redfish-solutions.com> <43e72e890908070905s447a2fc0j2dc086048194db34@mail.gmail.com>
	<4A7CC24D.1000104@redfish-solutions.com> <1249698462.25983.7.camel@mj>
	<4A809B8D.5000309@redfish-solutions.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 10 Aug 2009 15:30:08 -0700
Message-ID: <43e72e890908101530h3b024c83t7e73817ed6e28618@mail.gmail.com>
Subject: Re: [PATCH] CRDA and cross-compilation
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: Pavel Roskin <proski@gnu.org>,
	Jon Loeliger <jdl@bigfootnetworks.com>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 10, 2009 at 3:13 PM, Philip A.
Prindeville<philipp_subx@redfish-solutions.com> wrote:
> Pavel Roskin wrote:
>> On Fri, 2009-08-07 at 17:09 -0700, Philip A. Prindeville wrote:
>>> Luis R. Rodriguez wrote:
>>>> Please send white space changes first in one patch, ie, that do not
>>>> change anything other than that. Then send the other stuff.
>>>>
>>>>   Luis
>>> Here it is.
>> ...
>>> -else
>>> + else
>> ...
>>> +install-rb: wireless-regdb/regulatory.bin
>>
>> If you don't understand what you were asked to do, I'll appreciate if
>> you stop wasting everybody's time.
>>
>> Nobody is going to extract useful bits from the patches you send,
>> especially if you don't provide an adequate description of the changes.
>>
>> I was able to cross-compile CDRA for MIPS without any changes other than
>> those that have already been applied.
>
> Since we compile a variety of images that are both Linux and i586 based as are the target and host, detecting instances amongst the 180+ packages contained in our distribution where the build used host parameters instead of target parameters can be painful and tedious.
>
> Sometimes it's just best to isolate such code paths with a safe, obvious gating variable.  That's what I've tried to do here.
>
> We don't just build images, we also make the entire SVN tree available to others to build in their environments as well (Fedora, Centos, Gentoo, Debian, x86, PPC, x86_64, etc).  We can't possibly test for every scenario our users will encounter, so we make things as safe as we know how.
>
> Yes, I'm sure Pavel *was* able to build for his MIPS target in his environment.  That's a bet I can't make for all of our users, however, without these changes.
>
> I've split our changes into two functional groups:
>
> * allowing a cross-compilation without contamination by the host's own state via pkg-config bleeding into it.
>
> * allowing regulatory.bin to be installed via an external Makefile without having to extract internal values from crda/Makefile (i.e. REG_BIN and REG_GIT).
>
> These patches assume that Pavel's own "noverify" patch has already been applied.
>
> Changes:
>
> 1. Remove trailing slashes from directory variables: they're redundant and cause duplicates if they are appended to a path that's already absolute.
>
> 2. Move invariant definitions to before any cross-compilation conditional sections for clarity (and to avoid having to duplicate them).
>
> 3. Bracket any host (native) compilation sections with conditional based on $(CROSS_COMPILE) being empty.
>
> 4. Add 'else' section for cross-compilation using openssl and libnl-1 (or libnl-2 if explicitly selected).
>
>
> --- crda-1.1.0/Makefile 2009-08-10 13:37:36.000000000 -0700
> +++ crda-1.1.0/Makefile.new     2009-08-10 13:37:11.000000000 -0700
> @@ -3,10 +3,10 @@
>  REG_BIN?=/usr/lib/crda/regulatory.bin
>  REG_GIT?=git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.git
>
> -PREFIX ?= /usr/
> -MANDIR ?= $(PREFIX)/share/man/
> +PREFIX ?= /usr
> +MANDIR ?= $(PREFIX)/share/man
>
> -SBINDIR ?= /sbin/
> +SBINDIR ?= /sbin
>
>  # Use a custom CRDA_UDEV_LEVEL when callling make install to
>  # change your desired level for the udev regulatory.rules
> @@ -14,7 +14,7 @@
>  UDEV_LEVEL=$(CRDA_UDEV_LEVEL)-
>  # You can customize this if your distributions uses
>  # a different location.
> -UDEV_RULE_DIR?=/lib/udev/rules.d/
> +UDEV_RULE_DIR?=/lib/udev/rules.d
>
>  # If your distribution requires a custom pubkeys dir
>  # you must update this variable to reflect where the
> @@ -22,48 +22,76 @@
>  # with make PUBKEY_DIR=/usr/lib/crda/pubkeys
>  PUBKEY_DIR?=pubkeys
>
> +MKDIR ?= mkdir -p
> +INSTALL ?= install
> +
>  CFLAGS += -Wall -g
>
>  all: all_noverify verify
>
>  all_noverify: crda intersect regdbdump
>
> -ifeq ($(USE_OPENSSL),1)
> +ifeq ($(CROSS_COMPILE),)
> +
> + ifeq ($(USE_OPENSSL),1)
>  CFLAGS += -DUSE_OPENSSL `pkg-config --cflags openssl`
>  LDLIBS += `pkg-config --libs openssl`
>
>  reglib.o: keys-ssl.c
>
> -else
> + else
>  CFLAGS += -DUSE_GCRYPT
>  LDLIBS += -lgcrypt
>
>  reglib.o: keys-gcrypt.c
>
> -endif
> -MKDIR ?= mkdir -p
> -INSTALL ?= install
> + endif
>
>  NL1FOUND := $(shell pkg-config --atleast-version=1 libnl-1 && echo Y)
>  NL2FOUND := $(shell pkg-config --atleast-version=2 libnl-2.0 && echo Y)
>
> -ifeq ($(NL1FOUND),Y)
> + ifeq ($(NL1FOUND),Y)
>  NLLIBNAME = libnl-1
> -endif
> + endif
>
> -ifeq ($(NL2FOUND),Y)
> + ifeq ($(NL2FOUND),Y)
>  CFLAGS += -DCONFIG_LIBNL20
>  NLLIBS += -lnl-genl
>  NLLIBNAME = libnl-2.0
> -endif
> + endif
>
> -ifeq ($(NLLIBNAME),)
> + ifeq ($(NLLIBNAME),)
>  $(error Cannot find development files for any supported version of libnl)
> -endif
> + endif
>
>  NLLIBS += `pkg-config --libs $(NLLIBNAME)`
>  CFLAGS += `pkg-config --cflags $(NLLIBNAME)`
>
> +else
> +
> + ifeq ($(USE_OPENSSL),1)
> +CFLAGS += -DUSE_OPENSSL
> +LDLIBS += -lssl
> +
> +reglib.o: keys-ssl.c
> +
> + else
> +CFLAGS += -DUSE_GCRYPT
> +LDLIBS += -lgcrypt
> +
> +reglib.o: keys-gcrypt.c
> +
> + endif
> +
> + ifeq ($(USE_LIBNL20),1)
> +CFLAGS += -DCONFIG_LIBNL20
> +NLLIBS = -lnl-genl -lnl-2.0
> + else
> +NLLIBS = -lnl
> + endif
> +
> +endif
> +
>  ifeq ($(V),1)
>  Q=
>  NQ=@true
>
>
> Add a couple of rules to (1) download (via GIT) John's working copy of regulatory.bin and (2) install it in the appropriate target destination.  This avoids us having to parse the Makefile for REG_BIN and REG_GIT from an enclosing (nesting) makefile, as is common in distros and buildroot environments in particular.
>
> --- crda-1.1.0/Makefile 2009-08-10 13:37:36.000000000 -0700
> +++ crda-1.1.0/Makefile.new     2009-08-10 13:37:11.000000000 -0700
> @@ -136,6 +164,14 @@
>        $(NQ) '  INSTALL  regdbdump.8.gz'
>        $(Q)$(INSTALL) -m 644 -t $(DESTDIR)/$(MANDIR)/man8/ regdbdump.8.gz
>
> +install-rb: wireless-regdb/regulatory.bin
> +       $(NQ) '  INSTALL  regulatory.bin'
> +       $(Q)$(INSTALL) -m 444 -D wireless-regdb/regulatory.bin $(DESTDIR)/$(REG_BIN)
> +
> +wireless-regdb/regulatory.bin:
> +       @rm -rf wireless-regdb
> +       git clone -q $(REG_GIT) wireless-regdb
> +
>  clean:
>        $(Q)rm -f crda regdbdump intersect *.o *~ *.pyc keys-*.c *.gz \
>        udev/$(UDEV_LEVEL)regulatory.rules udev/regulatory.rules.parsed

This is a glory mess, please stop trying.

  Luis
