Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48567 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2HKK3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2012 06:29:42 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [wireless-testing:master 68/100] drivers/net/wireless/p54/eeprom.c:291:15: warning: comparison of distinct pointer types lacks a cast
Date: Sat, 11 Aug 2012 12:29:34 +0200
Cc: kernel-janitors@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20120811084404.GA7755@localhost> <201208111149.47874.chunkeey@googlemail.com> <20120811095951.GA8534@localhost>
In-Reply-To: <20120811095951.GA8534@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201208111229.35167.chunkeey@googlemail.com> (sfid-20120811_123031_980170_32526638)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 11 August 2012 11:59:51 Fengguang Wu wrote:
> On Sat, Aug 11, 2012 at 11:49:47AM +0200, Christian Lamparter wrote:
> > On Saturday 11 August 2012 10:44:04 Fengguang Wu wrote:
> > > Hi Christian,
> > > 
> > > FYI, there are new compile warnings show up in
> > 
> > Thanks for telling me. Are these "normal" gcc's warnings
> > for PPC? Because the usual C=2 CF=-D__CHECK_ENDIAN__
> > doesn't show anything (on a x86 no cross-compile).
> 
> Yes, I don't use any special flags.
> 
> > > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git master
> > > head:   0eba6e668abe4e0760d9d5e20921cc6000a77a85
> > > commit: 9bc63816be9bf504414d350e605a4b30f857907d [68/100] p54: parse output power table
> > > config: powerpc-allmodconfig (attached as .config)
> > > 
> > > All error/warnings:
> > > 
> > > drivers/net/wireless/p54/eeprom.c: In function 'p54_get_maxpower':
> > > drivers/net/wireless/p54/eeprom.c:291:15: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> > > drivers/net/wireless/p54/eeprom.c:292:15: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> > > drivers/net/wireless/p54/eeprom.c:293:15: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> > > drivers/net/wireless/p54/eeprom.c:294:15: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> > 
> > interesting, rawpower is declared as u16.
> > whereas le16_to_cpu returns a __u16. 
> > (is that all, or is there something I don't see?)
> > 
> > Anyway, since you are currently the only person
> > I know, would you mind telling me if either (or
> > both?) of those patches has/have an effect?
> > 
> > patch 1: make rawpower __u16
> 
> Thanks for the quick fix! It works (build log follows).
> 
> wfg@bee ~/tip/obj-compiletest% make drivers/net/wireless/p54/
> /usr/bin/make -j40 -C source O=/home/wfg/tip/obj-compiletest ARCH=powerpc 
> CROSS_COMPILE=/usr/local/gcc-4.6.3-nolibc/powerpc64-linux/bin/powerpc64-linux- -j32 
> drivers/net/wireless/p54/
OT: why is there a "-j40" (after make) and "-j32" (after CROSS_COMPILE)
in the command line? Isn't one -jXY enough anymore?

>   CC [M]  drivers/net/wireless/p54/eeprom.o
[...]
>   LD [M]  drivers/net/wireless/p54/p54common.o
> make: Leaving directory `/c/wfg/tip'
> wfg@bee ~/tip/obj-compiletest% ..
> wfg@bee ~/tip% q pop
> Removing patch patches/mutt-wfg-t420-1000-8534-5234451332105763812
> Restoring drivers/net/wireless/p54/eeprom.c
> 
Is this patch 1, or patch 2... or both?

Regards,
	Chr
