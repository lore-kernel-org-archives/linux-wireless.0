Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59669 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab1CIF7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 00:59:34 -0500
Received: by bwz15 with SMTP id 15so410863bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2011 21:59:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110307140140.GC10509@titan.lakedaemon.net>
References: <AANLkTikwBUjSXJf+EUeM+kPhMg3PG0Y22S4BYKVVm8S2@mail.gmail.com>
	<20110307140140.GC10509@titan.lakedaemon.net>
Date: Wed, 9 Mar 2011 00:59:33 -0500
Message-ID: <AANLkTi=TaeNnJ3u+HXojkbHvjsH+Z7C_=3Tg98NMNg1A@mail.gmail.com>
Subject: Re: looking for more details on BCM4329, access to 802.11 header
From: George Nychis <gnychis@gmail.com>
To: Jason <linuxdriverproject@lakedaemon.net>
Cc: linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	hharte2@gmail.com, devel@linuxdriverproject.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jason,

This was a *huge* help to get this response from you, thanks a bunch for that.

I'd love to poke GregKG's staging tree and the mac80211 driver for the
bcm4329.  I did some searching for the staging tree, and the only
address I could find was:
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git

But whenever I try to clone it, it just hangs up on me.  "fatal: The
remote end hung up unexpectedly" ... is there another location that
I'm not finding?

I can definitely give cyanogenmod a shot, I had it running on my old
G1 at one point.  Let me toss it on my Incredible and see where we can
go.

I actually tried to go the wl1271 on my Droid1 first with this code:
http://android.git.kernel.org/?p=platform/hardware/ti/wlan.git;a=tree

I am able to read the 802.11 header in the kernel module before it
gets translated to an Ethernet frame.  That was a great step towards
what I wanted, I just needed to then kick it in to promiscuous mode.
The mode is disabled, but I figured I could reconfigure the RX filter.
 I changed the RX filter to disable BSSID filtering, but I was still
only getting packets destined to my MAC.

But, then I found this comment which appears to state that the
firmware sets the local MAC address filter (plus broadcast traffic):
http://android.git.kernel.org/?p=platform/hardware/ti/wlan.git;a=blob;f=wl1271/TWD/Ctrl/CmdBldCmd.c#l147

So it seems like the firmware is preventing the driver from removing
the BSSID filter on the wl1271.  But, as you mentioned the N900 was
able to kick it in to promiscuous mode which must be changing this
filter.  Is it using a different firmware?  But, I'm going to explore
the in-kernel driver for this as you mentioned.  I will start poking
around that.

Thanks again, I really appreciate it.

- George


On Mon, Mar 7, 2011 at 9:01 AM, Jason <linuxdriverproject@lakedaemon.net> wrote:
> On Sun, Mar 06, 2011 at 11:11:48PM -0500, George Nychis wrote:
>> Hi all,
>>
>> I was really hoping to be able to access 802.11 headers of received
>> packets on a BCM4329 chip embedded on my HTC Incredible.  However, the
>> further and further I dug in to the source code for the kernel and
>> BCM4329 driver, the more and more I became less hopeful.  But, I'm
>> hoping someone with some more knowledge on this chipset might be able
>> to help (especially you, Howard!).
>>
>
> Most development work for Broadcom wifi is occurring in GregKH's staging
> tree, I've included the linuxdriverproject ml in the CC.  It's in
> drivers/staging/brcm80211, it's a mac80211 driver that includes support
> for bcm4329.  You may have more luck with it.
>
> If you're feeling really frisky, try cyanogenmod [1] as your base system,
> it's running 2.6.37 on my Nexus One right now.  Here's how to build for
> the Incredible [2].  It shouldn't be too far of a leap to get brcm80211
> running on it.
>
> As a side note, the same holds for the TI wl1271 (right model?) found in
> the HTC G1 and Nokia N900.  The in-kernel driver has much better support
> for mac80211.  Android, by default uses the out-of-tree version, the
> N900 used the in-tree version.  The N900 could go into monitor mode
> without modification once you had root access.
>
>> The HTC Incredible has the wireless driver loaded as a module, and
>> builds it straight from the kernel tree:
>> http://android.git.kernel.org/?p=kernel/msm.git;a=tree;f=drivers/net/wireless/bcm4329;h=01f09252ff9b80379e6db6dbb22af4fcba004982;hb=HEAD
>
> AFAICT, this driver will never make it into Linus' tree.  All of Broadcom's
> efforts are on merging staging/brcm80211 into mainline.
>
> hth,
>
> Jason.
>
> [1] http://www.cyanogenmod.com
> [2]
> http://wiki.cyanogenmod.com/index.php?title=Compile_CyanogenMod_for_Incredible
>
