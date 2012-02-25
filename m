Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45377 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150Ab2BYLGD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 06:06:03 -0500
Message-ID: <4F48C08A.5070501@hauke-m.de> (sfid-20120225_120636_620248_F8F2CCA9)
Date: Sat, 25 Feb 2012 12:05:46 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, nbd@nbd.name,
	linville@tuxdriver.com, "Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: Re: [PATCH 0/5] compat / compat-wireless: merge autoconf generation
References: <1330134726-1634-1-git-send-email-rodrigue@qca.qualcomm.com>
In-Reply-To: <1330134726-1634-1-git-send-email-rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2012 02:52 AM, Luis R. Rodriguez wrote:
> From: Luis R. Rodriguez <mcgrof@frijolero.org>
> 
> While testing ckmake cross compiling compat through different kernels I
> realized that compat was failing to build on some kernels but compat-wireless
> was not. The reason for this turned out to be that compat did not have an
> autoconf for the CONFIG_COMPAT_KERNEL_* variables. In order to make use
> of a variable properly in code on kernel we need two things: a makefile
> equivalent and a header file that defines it. The compat project had
> only makefile variable generation while compat-wireless had makefile
> variable generation with a *few* variables propagated to actual code.
> 
> To avoid issues with this any further I've decided to try merging the
> autoconf effort for both projects and taking leads on what compat does
> first.
> 
> compat then does the CONFIG_COMPAT_KERNEL_* trickery and generates a
> clean .config for us. This in turn generates our compat's compat_autoconf.h.
> The compat-wireless project leverages this work by dropping its own
> Makefile hackery in favor of the same work and later also uses the same
> .config to expand its own compat_autoconf.h.
> 
> John, I could use some extra help on reviewing the RHEL stuff. I'm going
> to push this stuff out now to help with testing.
> 
> compat:
> 
> Luis R. Rodriguez (2):
>   compat: fix few compilations by adding compat_autoconf.h support
>   compat: add some initial RHEL support
> 
>  .gitignore                      |   10 ++++
>  Makefile                        |   59 ++++++++++------------
>  include/linux/compat_autoconf.h |   37 --------------
>  scripts/gen-compat-autoconf.sh  |  105 +++++++++++++++++++++++++++++++++++++++
>  scripts/gen-compat-config.sh    |   60 ++++++++++++++++++++++
>  5 files changed, 201 insertions(+), 70 deletions(-)
>  delete mode 100644 include/linux/compat_autoconf.h
>  create mode 100755 scripts/gen-compat-autoconf.sh
>  create mode 100755 scripts/gen-compat-config.sh
> 
> compat-wireless:
> 
> Luis R. Rodriguez (3):
>   compat-wireless: fix old checks on KERNEL_SUBLEVEL
>   compat-wireless: start using CONFIG_COMPAT_KERNEL_ in code
>   compat-wireless: use compat's CONFIG_COMPAT_KERNEL_* variables
>  Makefile                       |   22 ++++++++++++++++------
>  config.mk                      |   24 ++++--------------------
>  scripts/check_config.sh        |    9 +++++----
>  scripts/gen-compat-autoconf.sh |   13 +++++++------
>  4 files changed, 32 insertions(+), 36 deletions(-)
> 

This patch series breaks parallel build.
Before these patches where applied parallel build was no problem I just
saw two error at the beginning, but after this patch series it does not
work any more.

These are the current error messages at the beginning and then it
compiles sequential.

Hauke

hauke@hauke:~/compat-wireless/compat-wireless$ make -j5
make[1]: warning: jobserver unavailable: using -j1.  Add `+' to parent
make rule.
make[1]: warning: jobserver unavailable: using -j1.  Add `+' to parent
make rule.
./scripts/gen-compat-autoconf.sh .config config.mk >
include/linux/compat_autoconf.h
make[1]: warning: jobserver unavailable: using -j1.  Add `+' to parent
make rule.
make[1]: warning: jobserver unavailable: using -j1.  Add `+' to parent
make rule.
make -C /home/hauke/compat-wireless/compat-wireless modules
make[1]: Entering directory `/home/hauke/compat-wireless/compat-wireless'
make[1]: warning: jobserver unavailable: using -j1.  Add `+' to parent
make rule.
make -C /lib/modules/3.0.0-16-generic/build
M=/home/hauke/compat-wireless/compat-wireless modules
make[2]: Entering directory `/usr/src/linux-headers-3.0.0-16-generic'
  LD      /home/hauke/compat-wireless/compat-wireless/compat/built-in.o

