Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7413 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbZF2WRi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2009 18:17:38 -0400
Subject: Re: [PATCH CRDA] Introduce separate HOST and TARGET compilation
 steps.
From: Pavel Roskin <proski@gnu.org>
To: Jon Loeliger <jdl@bigfootnetworks.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1246310952.15012.22.camel@jdl-desktop>
References: <1246310952.15012.22.camel@jdl-desktop>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 18:17:39 -0400
Message-Id: <1246313859.15956.29.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-06-29 at 16:29 -0500, Jon Loeliger wrote:
> The regdbdump tool is really a host executable that is used
> during the build process.  It could also be installed and
> used on the target, but two separate compilations are needed
> to achieve that goal.
> 
> Currently, regdbdump is only built for the target, and thus
> cross-compilation of the tool is really feasible without
> this patch (or one like it).
> 
> Signed-off-by: Jon Loeliger <jdl@bigfootnetworks.com>
> ---
> 
> This patch for the CRDA repository was offered on 12-June-2009
> as an RFC, but received no comments at that time.

I think you'll get more attention if you make your changes simple and
separate.  Otherwise, it's hard to review.

> @@ -1,3 +1,5 @@
> +-include .config

This shouldn't be needed.  Variables can be set on the make command
line.
 
> +MKDIR ?= mkdir -p
> +INSTALL ?= install

That's unrelated to the purpose of your patch.

> +ifeq ($(V),1)
> +    Q=
> +    NQ=@true
> +else
> +    Q=@
> +    NQ=@echo
> +endif

And this is unrelated too.

> +# Determine what target and host libraries and executables
> +# need to be built as that will determine what libraries will
> +# need to be found on the host or in the target environment.

That's unclear.  Also, most user don't cross-compile.  It's better not
to attract too much attention to the aspect important to you unless
there is some trick here that everybody touching this Makefile needs to
know.

> -reglib.o: keys-ssl.c
> +HOST_BUILD	:= $(patsubst %,host/%,$(BUILD))
> +TARGET_BUILD	:= $(patsubst %,target/%,$(BUILD))

The word "target" is normally limited to the compilers and similar tools
to denote what kind of executables or object files will be supported by
the program.  It doesn't really apply here.  If you look at the Linux
build system, it has HOSTCC that produces tools for compiling and CC
that produces the actual kernel.

> -NL1FOUND := $(shell pkg-config --atleast-version=1 libnl-1 && echo Y)
> -NL2FOUND := $(shell pkg-config --atleast-version=2 libnl-2.0 && echo Y)
> +TARGET_NL1FOUND := $(shell PKG_CONFIG_PATH=$(TARGET_PKG_CONFIG_PATH) \
> +			pkg-config --atleast-version=1 libnl-1 && echo Y)
> +TARGET_NL2FOUND := $(shell PKG_CONFIG_PATH=$(TARGET_PKG_CONFIG_PATH) \
> +			pkg-config --atleast-version=2 libnl-2.0 && echo Y)

Again, you are adding "TARGET" for no reason.
 
> -$(error Cannot find development files for any supported version of libnl)
> +ifneq ($(findstring clean,$(MAKECMDGOALS)),clean)
> +ifeq ($(TARGET_NLLIBNAME),)
> +$(error Cannot find development files for any supported version of target libnl)

The same thing here.  Most users don't really care about this
distinction.  It's the "host" compilation that is unusual.  If a library
was missing to build an interim tool for compilation, that might be
worth noting.

> +# When not cross-compiling, treat target and host the same
> +# by transferring target-values to the HOST_* names and then
> +# only building the host targets.

Again, you are attracting too much attention to your work.  There are
other aspects most users will care about.  They will look to see which
libraries are needed, where the executables will be installed by
default, what the default compiler options are.

I've seen code where many developers commented about the changes they
did.  It was impossible to understand what the code does, but the
comments were telling why the code was changed.

Skipping lots of stuff.

> +	$(NQ) '    CLEAN'
>  	$(Q)rm -f crda regdbdump intersect *.o *~ *.pyc keys-*.c *.gz \
>  	udev/$(UDEV_LEVEL)regulatory.rules udev/regulatory.rules.parsed
> +	$(Q)rm -rf host/ target/

Again, this is an unrelated change.

-- 
Regards,
Pavel Roskin
