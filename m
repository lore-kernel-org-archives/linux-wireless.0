Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:53591 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbZG1Qzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 12:55:50 -0400
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Ken Lewis <kennylewis@gmail.com>
Subject: Re: [RT2X00] Linux-next tree next-20090725 and 20090727 FTBFS
Date: Tue, 28 Jul 2009 18:55:47 +0200
Cc: linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
	linux-net@vger.kernel.org
References: <5a44caba0907280935h59a22367la38382a0c9d388bf@mail.gmail.com>
In-Reply-To: <5a44caba0907280935h59a22367la38382a0c9d388bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200907281855.47790.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Kernel: arch/x86/boot/bzImage is ready  (#1)
>   Building modules, stage 2.
>   MODPOST 12 modules
> ERROR: "rt2x00mac_set_tim" [drivers/net/wireless/rt2x00/rt2500pci.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> rt2x00mac_set_tim is used in rt2500pci.c and declared in rt2x00mac.c
> within a section #IFDEF'd for CONFIG_RT2X00_LIB_CRYPTO.  I can get the
> kernel modules to build -- the error reports a missing symbol due to
> the definition of rt2x00mac_set_tim being IFDEFfed out, and excluding
> rt2x00mac_set_tim builds the module successfully -- but can't confirm
> whether it works due to a quirk of KDE, NetworkManager and my Linksys
> router not cooperating.
> 
> In terms of the right fix: should rt2500pci depend (in KConfig) on
> CONFIG_RT2X00_LIB_CRYPTO, or should rt2x00mac_set_tim be outside the
> IFDEF?

well rt2x00mac_set_tim has nothing to do with CRYPTO so the function
should simply be moved. I'll send a patch to fix this in a few minutes.

Ivo
