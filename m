Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP02.calltower.com ([69.4.184.249]:51195 "EHLO
	L01SLCSMTP02.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754076AbZFLVhr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 17:37:47 -0400
Subject: Re: RFC: cross-building crda
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1244760685.6544.6.camel@mj>
References: <1244733695.14768.22.camel@jdl-desktop>
	 <1244760685.6544.6.camel@mj>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 16:37:09 -0500
Message-Id: <1244842629.18211.429.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-06-11 at 18:51 -0400, Pavel Roskin wrote:
> This sounds too complicated.

Hi Pavel,

Thanks for your feedback.

>   No other popular software does it,

That's just flat not true.  Even Linux itself separates the
components that need to be built for the host from those that
need to be built for the target machine.  The Kconfig, dtc and
other tools in the scripts directory, for example, are host
tools are built and used during the rest of the target build.

>  yet
> somehow it can be cross-compiled.  I'm not talking about such software
> as kernels, compilers and other tools that need to know specific
> characteristics of the target.

Thanks, I get that.

> Please check the sources of buildroot (http://buildroot.uclibc.org/) to

And that.  Really, I get the whole cross compile thing.
And its environment.  Mine happens to be LTIB for PowerPC
and I'm using a powerpc-e300-linux-gnu- toolchain to do so.

> see how it manages to cross-compile a lot of programs that don't do
> anything specific to support cross-compilation.

The bulk of the CRDA correctly cross compiles by simply using
and setting CC to allow for CROSS_COMPILE like this:

    CC := $(CROSS_COMPILE)gcc

That's not the problem.

>   Sometimes minimal
> patches are needed, but nothing nearly as intrusive as your proposal.

The build of regdbdump needs to be split out as a *host* tool.
It is used on the *host* to verify the regulatory.bin database.
It shouldn't need, nor does it use, for example, the libnl that
is currently supplied on the link line for that executable.
That libnl is the *target*'s library for target linking.

Furthermore, this same distinction applies to the grcypt/openssl
library that is selected.  In fact, if regdump is built once
for the host and once for the target, you may need different
crypto mechanism selections for each.

You can see the same distinction in kconfig's Makefile where it
says this around line 95:

    96  # Use recursively expanded variables so we do not call gcc unless
    97  # we really need to do so. (Do not call gcc as part of make mrproper)
    98  HOST_EXTRACFLAGS = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ccflags)
    99  HOST_LOADLIBES   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
   100  
   101  HOST_EXTRACFLAGS += -DLOCALE

All I'm doing is the same HOST tool separation for CRDA.

RFC patch for comments to follow.

Thanks,
jdl


