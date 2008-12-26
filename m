Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:44598 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbYLZBAk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Dec 2008 20:00:40 -0500
Subject: Re: 4965AGN Not Associating
From: Pavel Roskin <proski@gnu.org>
To: Delphi Real Estate <Info@delphi-real-estate.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200812241002.12787.Info@delphi-real-estate.com>
References: <200812241002.12787.Info@delphi-real-estate.com>
Content-Type: text/plain
Date: Thu, 25 Dec 2008 20:00:38 -0500
Message-Id: <1230253238.17014.18.camel@dv> (sfid-20081226_020044_417131_99CE09C1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-12-24 at 10:02 -0800, Delphi Real Estate wrote:
> I was running the iwl4965 git driver successfully from 6 June up until
> two days ago, when I decided to be a smart-aleck and try to get
> 802.11n working.  After two 12 hour days of struggle, I now have no
> wifi.
> 
> Running Kubuntu Hardy and typically compile a custom kernel.  First I
> downloaded and compiled compat-wireless-old.tar.bz2 and compiled it to
> my kernel 2.6.24.  Driver loaded fine and the wlan0 interface came up,
> but would no longer associate as the old driver did.  Rebooted, but a
> second or so after the blue wireless light came on, the kernel crashed
> with an Aieeee!  No way to see exactly where or why, as it'd scrolled
> off the screen and there's nothing in the logs.

Capturing kernel messages is described in Documentation/oops-tracing.txt
in the kernel sources.

> So I tried just compiling kernels 2.6.27 and .28 to test their iwlagn
> functionality, but unfortunately no version of .27 or .28 will compile
> on my laptop.  .27 does compile on my HTPC, but not where it counts:
>   OFFSETS arch/x86/boot/offsets.h
>   OBJCOPY arch/x86/boot/vmlinux.bin
>   AS      arch/x86/boot/header.o
>   LD      arch/x86/boot/setup.elf
>   OBJCOPY arch/x86/boot/setup.bin
>   BUILD   arch/x86/boot/bzImage
> Root device is (8, 1)
> Setup is 11916 bytes (padded to 12288 bytes).
> System is 2904 kB
> CRC 30db084d
> Kernel: arch/x86/boot/bzImage is ready  (#1)
> ERROR: "snd_hwdep_new" [ubuntu/misc/media/snd-bt-sco.ko] undefined!
> WARNING: modpost: Found 4 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

You must be compiling kernel sources patched by Ubuntu.  There is an
unresolved symbol in on of the sound driver provided by Ubuntu.  You can
disable that driver or enable sound option that would provide
"snd_hwdep_new".  I think you can even ignore this error.  It should not
prevent wireless drivers from working.

> So I gave up on a new kernel and compiled 2.6.22, booted, and compiled
> compat-wireless-old.tar.bz2 to it, which went fine.

IMHO it's a major overkill to downgrade the kernel so much because of
some external sound module, especially when the userspace is not exactly
conservative!

>   I even get a blue light for the radio switch now.  But it will not
> associate.  I am using the exact same interfaces file as before.  I
> tried network manager, but it doesn't even recognize this as a
> wireless device.
> 
>  # iwconfig
> wlan0     IEEE 802.11abgn  ESSID:"Hex"
>           Mode:Managed  Frequency:2.462 GHz  Access Point: Not-Associated
>           Tx-Power=14 dBm
>           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
>           Encryption key:off

It looks like WPA is not being used.

>           Power Management:off
>           Link Quality:0  Signal level:0  Noise level:0
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> # iwpriv
> wlan0     no private ioctls.
> 
> # iwpriv wlan0 network_type g
> wlan0     no private ioctls.

I don't think it's supposed to work.

> # iwlist wlan0 auth
> wlan0     Authentication capabilities :
>                 WPA
>                 WPA2
>                 CIPHER-TKIP
>                 CIPHER-CCMP
>           Current Authentication algorithm :
>                 open
> 
> So for some reason it is not recognizing my WPA commands
> in /etc/network/interfaces (which worked before).  Or maybe it's in
> 'n' or 'a' mode, rather than g.  I've searched everywhere and can not
> find how to set it to g mode now that it has no private ioctls.

I don't think you need to do anything like that.  Try scanning to see if
the card sees the AP.

I don't know much about Ubuntu (or Debian) specific network
configuration, but I suggest that you try running wpa_supplicant
manually.  Upgrading to a recent kernel may help too.  If you want to
try the bleeding edge 802.11n support, perhaps you should check out the
wireless-testing branch from git.

-- 
Regards,
Pavel Roskin
