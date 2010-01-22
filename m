Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:42141 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab0AVTtP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 14:49:15 -0500
Received: by pwi21 with SMTP id 21so1008698pwi.21
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2010 11:49:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B59FAAD.6060804@redfish-solutions.com>
References: <4B59FAAD.6060804@redfish-solutions.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 22 Jan 2010 11:48:55 -0800
Message-ID: <43e72e891001221148t23728d1el87b8194ee3373e97@mail.gmail.com>
Subject: Re: Building compat-wireless from 2.6.27
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 22, 2010 at 11:21 AM, Philip A. Prindeville
<philipp_subx@redfish-solutions.com> wrote:
> I'm trying to build compat-wireless's snapshot from git on compat-wireless-2.6-mcgrof last night, on linux 2.6.27.42 and getting:
>
> ...
> make -j5 -C /home/philipp/alix/build_i586/compat-wireless-2010-01-21 \
>                HOSTCC=gcc CC=/home/philipp/alix/build_i586/staging_dir/bin/i586-linux-uclibc-gcc ARCH=i386 \
>                KLIB_BUILD=/home/philipp/alix/build_i586/linux-2.6.27.42-astlinux \
>                MODPROBE='true' PWD=/home/philipp/alix/build_i586/compat-wireless-2010-01-21 \
>                CONFIG_IPW2100= CONFIG_IPW2200= CONFIG_LIBERTAS= CONFIG_B44= CONFIG_B43= CONFIG_B43LEGACY= \
>                modules
> make[1]: Entering directory `/home/philipp/alix/build_i586/compat-wireless-2010-01-21'
> ./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
> make[2]: warning: jobserver unavailable: using -j1.  Add `+' to parent make rule.
> make -C /home/philipp/alix/build_i586/linux-2.6.27.42-astlinux M=/home/philipp/alix/build_i586/compat-wireless-2010-01-21 modules
> make[2]: Entering directory `/home/philipp/alix/build_i586/linux-2.6.27.42-astlinux'
> scripts/Makefile.build:41: /home/philipp/alix/build_i586/compat-wireless-2010-01-21/compat/Makefile: No such file or directory
> make[4]: *** No rule to make target `/home/philipp/alix/build_i586/compat-wireless-2010-01-21/compat/Makefile'.  Stop.
> make[3]: *** [/home/philipp/alix/build_i586/compat-wireless-2010-01-21/compat] Error 2
> make[3]: *** Waiting for unfinished jobs....
> scripts/Makefile.build:41: /home/philipp/alix/build_i586/compat-wireless-2010-01-21/drivers/bluetooth/Makefile: No such file or directory
> make[4]: *** No rule to make target `/home/philipp/alix/build_i586/compat-wireless-2010-01-21/drivers/bluetooth/Makefile'.  Stop.
> make[3]: *** [/home/philipp/alix/build_i586/compat-wireless-2010-01-21/drivers/bluetooth] Error 2
> make[2]: *** [_module_/home/philipp/alix/build_i586/compat-wireless-2010-01-21] Error 2
> make[2]: Leaving directory `/home/philipp/alix/build_i586/linux-2.6.27.42-astlinux'
> make[1]: *** [modules] Error 2
> make[1]: Leaving directory `/home/philipp/alix/build_i586/compat-wireless-2010-01-21'
> make: *** [/home/philipp/alix/build_i586/compat-wireless-2010-01-21/net/wireless/lib80211.ko] Error 2
> %
>
> as a diagnostic, I've patched my makefile to $(info ...) out the following:
>
> CONFIG_PCI=y
> CONFIG_USB=y
> CONFIG_PCMCIA=
> CONFIG_SSB=
> CONFIG_LIBERTAS=
> CONFIG_ATH5K=m
> CONFIG_ATH9K=m
> CONFIG_IPW2100=
> CONFIG_IPW2200=
> CONFIG_IWLWIFI=m
> CONFIG_B43=
> CONFIG_B43LEGACY=
> CONFIG_B44=
>
>
> How should I be building compat-wireless?  This worked until about early December.

you need compat.git as  well and you need to export COMPAT_TREE to
point to where you have it. I'm sorry for not updating the
documentation on this, I will do so now.

  Luis
