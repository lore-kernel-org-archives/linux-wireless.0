Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:22903 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab1CGOBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 09:01:45 -0500
Date: Mon, 7 Mar 2011 09:01:40 -0500
From: Jason <linuxdriverproject@lakedaemon.net>
To: George Nychis <gnychis@gmail.com>
Cc: linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	hharte2@gmail.com, devel@linuxdriverproject.org
Subject: Re: looking for more details on BCM4329, access to 802.11 header
Message-ID: <20110307140140.GC10509@titan.lakedaemon.net>
References: <AANLkTikwBUjSXJf+EUeM+kPhMg3PG0Y22S4BYKVVm8S2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTikwBUjSXJf+EUeM+kPhMg3PG0Y22S4BYKVVm8S2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 06, 2011 at 11:11:48PM -0500, George Nychis wrote:
> Hi all,
> 
> I was really hoping to be able to access 802.11 headers of received
> packets on a BCM4329 chip embedded on my HTC Incredible.  However, the
> further and further I dug in to the source code for the kernel and
> BCM4329 driver, the more and more I became less hopeful.  But, I'm
> hoping someone with some more knowledge on this chipset might be able
> to help (especially you, Howard!).
> 

Most development work for Broadcom wifi is occurring in GregKH's staging
tree, I've included the linuxdriverproject ml in the CC.  It's in
drivers/staging/brcm80211, it's a mac80211 driver that includes support
for bcm4329.  You may have more luck with it.

If you're feeling really frisky, try cyanogenmod [1] as your base system,
it's running 2.6.37 on my Nexus One right now.  Here's how to build for
the Incredible [2].  It shouldn't be too far of a leap to get brcm80211
running on it.

As a side note, the same holds for the TI wl1271 (right model?) found in
the HTC G1 and Nokia N900.  The in-kernel driver has much better support
for mac80211.  Android, by default uses the out-of-tree version, the
N900 used the in-tree version.  The N900 could go into monitor mode
without modification once you had root access.  

> The HTC Incredible has the wireless driver loaded as a module, and
> builds it straight from the kernel tree:
> http://android.git.kernel.org/?p=kernel/msm.git;a=tree;f=drivers/net/wireless/bcm4329;h=01f09252ff9b80379e6db6dbb22af4fcba004982;hb=HEAD

AFAICT, this driver will never make it into Linus' tree.  All of Broadcom's
efforts are on merging staging/brcm80211 into mainline.

hth,

Jason.

[1] http://www.cyanogenmod.com
[2]
http://wiki.cyanogenmod.com/index.php?title=Compile_CyanogenMod_for_Incredible
