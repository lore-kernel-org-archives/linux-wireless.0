Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP01.calltower.com ([69.4.184.248]:59611 "EHLO
	L01SLCSMTP01.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754352AbZF3VKJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 17:10:09 -0400
Subject: Re: [PATCH CRDA] Introduce separate HOST and TARGET compilation
 steps.
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: Pavel Roskin <proski@gnu.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1246313859.15956.29.camel@mj>
References: <1246310952.15012.22.camel@jdl-desktop>
	 <1246313859.15956.29.camel@mj>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 16:10:11 -0500
Message-Id: <1246396211.13176.221.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-06-29 at 18:17 -0400, Pavel Roskin wrote:

> 
> > @@ -1,3 +1,5 @@
> > +-include .config
> 
> This shouldn't be needed.  Variables can be set on the make command
> line.

Allowing the use of .config here is in the same style as iw's Makefile
and .config.  And, yes, the make command line does allow variables to
be set.  But here's what I'd have to supply:

        CC      := $(CROSS_COMPILE)gcc
        HOST_CC := gcc
        
        DESTDIR         := $(STAGING_DIR)
        
        HOST_PKG_CONFIG_PATH    ?= /usr/lib/pkgconfig
        TARGET_PKG_CONFIG_PATH  ?= $(PKG_CONFIG_PATH)
        
        STAGING_INC_DIR := $(STAGING_DIR)/usr/local/include
        STAGING_LIB_DIR := $(STAGING_DIR)/usr/local/lib
        
        KERNEL_DIR      ?= ../../kernel
        KERNEL_INC_DIR  := $(KERNEL_DIR)/include
        
        TARGET_CFLAGS   += -I$(KERNEL_INC_DIR) \
                           -I$(STAGING_INC_DIR)
        
        TARGET_LDLIBS   += -L$(STAGING_LIB_DIR)
        
        REG_BIN         := ../wireless-regdb/regulatory.bin

        HOST_USE_OPENSSL        := 1
        TARGET_USE_OPENSSL      := 1
        NO_INSTALL_UDEV         := 1

> > +MKDIR ?= mkdir -p
> > +INSTALL ?= install
> 
> That's unrelated to the purpose of your patch.
> 
> > +ifeq ($(V),1)
> > +    Q=
> > +    NQ=@true
> > +else
> > +    Q=@
> > +    NQ=@echo
> > +endif
> 
> And this is unrelated too.

Unrelated, perhaps.  I'll submit a separate patch to regroup
similar items.

> > +# Determine what target and host libraries and executables
> > +# need to be built as that will determine what libraries will
> > +# need to be found on the host or in the target environment.
> 
> That's unclear.

I'm not sure what is unclear here. Choosing the set of executables
determines what libraries are needed.

>   Also, most user don't cross-compile.

Some do.  I'm one of them.

>   It's better not
> to attract too much attention to the aspect important to you unless
> there is some trick here that everybody touching this Makefile needs to
> know.

OK.

> > -reglib.o: keys-ssl.c
> > +HOST_BUILD	:= $(patsubst %,host/%,$(BUILD))
> > +TARGET_BUILD	:= $(patsubst %,target/%,$(BUILD))
> 
> The word "target" is normally limited to the compilers and similar tools
> to denote what kind of executables or object files will be supported by
> the program.  It doesn't really apply here.

Right.  It does apply here.  I'm building on an X86 host for 
a PowerPC target.

>   If you look at the Linux
> build system, it has HOSTCC that produces tools for compiling and CC
> that produces the actual kernel.

Right. Like this:

	CC      := $(CROSS_COMPILE)gcc
        HOST_CC := gcc
        
> > -NL1FOUND := $(shell pkg-config --atleast-version=1 libnl-1 && echo Y)
> > -NL2FOUND := $(shell pkg-config --atleast-version=2 libnl-2.0 && echo Y)
> > +TARGET_NL1FOUND := $(shell PKG_CONFIG_PATH=$(TARGET_PKG_CONFIG_PATH) \
> > +			pkg-config --atleast-version=1 libnl-1 && echo Y)
> > +TARGET_NL2FOUND := $(shell PKG_CONFIG_PATH=$(TARGET_PKG_CONFIG_PATH) \
> > +			pkg-config --atleast-version=2 libnl-2.0 && echo Y)
> 
> Again, you are adding "TARGET" for no reason.

No reason except explicit clarity.

> > +	$(NQ) '    CLEAN'
> >  	$(Q)rm -f crda regdbdump intersect *.o *~ *.pyc keys-*.c *.gz \
> >  	udev/$(UDEV_LEVEL)regulatory.rules udev/regulatory.rules.parsed
> > +	$(Q)rm -rf host/ target/
> 
> Again, this is an unrelated change.

I'll submit a separate patch for the first, added line.

Thanks,
jdl



