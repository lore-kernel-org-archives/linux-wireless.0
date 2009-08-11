Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:50061 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399AbZHKAlW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 20:41:22 -0400
Message-ID: <4A80BE25.2000800@redfish-solutions.com>
Date: Mon, 10 Aug 2009 17:41:09 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jon Loeliger <jdl@bigfootnetworks.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] CRDA and cross-compilation
References: <4A7A8F7E.6020503@redfish-solutions.com>	 <1249576886.14919.16.camel@mj>	 <43e72e890908060956j3548c23ak4cf98d11c32efec0@mail.gmail.com>	 <1249580707.14919.29.camel@mj>	 <43e72e890908061142w41d3c0e8x1dc81ffd3ac5b8ae@mail.gmail.com>	 <4A7BD15E.1030604@redfish-solutions.com>	 <43e72e890908070905s447a2fc0j2dc086048194db34@mail.gmail.com>	 <4A7CC24D.1000104@redfish-solutions.com> <1249698462.25983.7.camel@mj>	 <4A809B8D.5000309@redfish-solutions.com>	 <43e72e890908101530h3b024c83t7e73817ed6e28618@mail.gmail.com>	 <4A80B363.3090809@redfish-solutions.com> <1249950344.14653.51.camel@mj>
In-Reply-To: <1249950344.14653.51.camel@mj>
Content-Type: multipart/mixed;
 boundary="------------010804030703080904070504"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010804030703080904070504
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Pavel Roskin wrote:
> On Mon, 2009-08-10 at 16:55 -0700, Philip A. Prindeville wrote:
> 
>> You're right: that comment was much more helpful...  does it apply to the first file or the second or both?
>>
>> And what in particular is a mess?
> 
> Cross compilation is not easy.  That's why there are such
> "metadistros" (for the lack of a better word) as buildroot and
> openembedded.  They have special entries for every package that specify
> how to cross-compile it.  There are patches for many sources, although
> it's better to have such files applied to the upstream sources.  But
> it's inevitable that the build is influenced in some way to
> cross-compile, often by specifying variables on the make command line.

Yes, agreed.  We are a downstream user of buildroot.  Unfortunately, not everything we use finds its way upstream to the buildroot repo... so we make certain changes ourselves.

And it's exactly because getting the fixes upstream *is* useful (why fix it in multiple places when you can fix it once???) that I'm being persistent.

I have no problem using variables to make to influence cross-compilation.  Indeed, my patch uses "make ... CROSS_COMPILE=$(TARGET_CROSS)" to work.


> I believe the developers of buildroot and openembedded would be able to
> deal with CRDA as is.  If they find something that could be improved,
> they can send a patch, but I don't think they will bother to change so
> many things as your patch does.
> 
> Besides, it's one thing to follow sane rules that simplify
> cross-compilation, such as providing the fourth argument to
> AC_RUN_IFELSE in configure.ac or not using uname to determine the target
> architecture.  It's another thing to support cross-compilation in a way
> unique to the package.  The gain is miniscule, and the potential for
> breaking is substantial.

There are environments where using pkg-config is every bit as evil using uname.  You just haven't had the unfortunate experience of encountering any yet.

If you're volunteering to add autoconf support to crda, then I accept.  :-)

> Most importantly, you are wasting time of people who could be doing
> something they are better at, such as development of wireless drivers.

By getting wireless drivers to run in yet another environment, I'm augmenting the base of people who will test the code you write.  What I'm doing here isn't without value as well, and some collaboration might be justified.

> There is no point in pushing the same patch over and over again, just
> because you wrote it.  Please try to accept the fact that it's not
> useful for others.  Maybe it was useful for you as an exercise.  But now
> you are not helping.  Please move on and do something else.

You're contradicting yourself.  Above you agree that "specifying variables on the make command line" is a common and acceptable way to indicate cross-compilation.

That's exactly what I'm adding here.



--------------010804030703080904070504
Content-Type: text/plain;
 name="crda-cross-compile.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="crda-cross-compile.patch"

Changes:

1. Move invariant definitions to before any cross-compilation conditional sections for clarity (and to avoid having to duplicate them).

2. Bracket any host (native) compilation sections with conditional based on $(CROSS_COMPILE) being empty.

4. Add 'else' section for cross-compilation using openssl and libnl-1 (or libnl-2 if explicitly selected).


--- crda-1.1.0/Makefile	2009-08-10 13:37:36.000000000 -0700
+++ crda-1.1.0/Makefile.new	2009-08-10 17:29:22.000000000 -0700
@@ -22,12 +22,17 @@
 # with make PUBKEY_DIR=/usr/lib/crda/pubkeys
 PUBKEY_DIR?=pubkeys
 
+MKDIR ?= mkdir -p
+INSTALL ?= install
+
 CFLAGS += -Wall -g
 
 all: all_noverify verify
 
 all_noverify: crda intersect regdbdump
 
+ifeq ($(CROSS_COMPILE),)
+
 ifeq ($(USE_OPENSSL),1)
 CFLAGS += -DUSE_OPENSSL `pkg-config --cflags openssl`
 LDLIBS += `pkg-config --libs openssl`
@@ -41,8 +46,6 @@
 reglib.o: keys-gcrypt.c
 
 endif
-MKDIR ?= mkdir -p
-INSTALL ?= install
 
 NL1FOUND := $(shell pkg-config --atleast-version=1 libnl-1 && echo Y)
 NL2FOUND := $(shell pkg-config --atleast-version=2 libnl-2.0 && echo Y)
@@ -64,6 +67,31 @@
 NLLIBS += `pkg-config --libs $(NLLIBNAME)`
 CFLAGS += `pkg-config --cflags $(NLLIBNAME)`
 
+else
+
+ifeq ($(USE_OPENSSL),1)
+CFLAGS += -DUSE_OPENSSL
+LDLIBS += -lssl
+
+reglib.o: keys-ssl.c
+
+else
+CFLAGS += -DUSE_GCRYPT
+LDLIBS += -lgcrypt
+
+reglib.o: keys-gcrypt.c
+
+endif
+
+ifeq ($(USE_LIBNL20),1)
+CFLAGS += -DCONFIG_LIBNL20
+NLLIBS = -lnl-genl -lnl-2.0
+else
+NLLIBS = -lnl
+endif
+
+endif
+
 ifeq ($(V),1)
 Q=
 NQ=@true

--------------010804030703080904070504--
