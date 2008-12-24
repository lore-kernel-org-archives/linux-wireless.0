Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway06.websitewelcome.com ([67.18.125.13]:38505 "HELO
	gateway06.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751042AbYLXUZQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 15:25:16 -0500
Received: from 75-92-136-219.sea.clearwire-dns.net ([75.92.136.219]:58259 helo=[192.168.111.2])
	by solstice.websitewelcome.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <Info@delphi-real-estate.com>)
	id 1LFZsJ-0004rr-Bn
	for linux-wireless@vger.kernel.org; Wed, 24 Dec 2008 13:58:35 -0600
From: Delphi Real Estate <Info@delphi-real-estate.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: 4965AGN Not Associating
Date: Wed, 24 Dec 2008 11:58:29 -0800
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812241158.29493.Info@delphi-real-estate.com> (sfid-20081224_212522_750445_E8AD7456)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I was running the iwl4965 git driver successfully from 6 June up until two days ago, when I decided to be a smart-aleck and try to get 802.11n working.  After two 12 hour days of struggle, I now have no wifi.

Running Kubuntu Hardy and typically compile a custom kernel.  First I downloaded and compiled compat-wireless-old.tar.bz2 and compiled it to my kernel 2.6.24.  Driver loaded fine and the wlan0 interface came up, but would no longer associate as the old driver did.  Rebooted, but a second or so after the blue wireless light came on, the kernel crashed with an Aieeee!  No way to see exactly where or why, as it'd scrolled off the screen and there's nothing in the logs.

So I tried just compiling kernels 2.6.27 and .28 to test their iwlagn functionality, but unfortunately no version of .27 or .28 will compile on my laptop.  .27 does compile on my HTPC, but not where it counts:
  OFFSETS arch/x86/boot/offsets.h
  OBJCOPY arch/x86/boot/vmlinux.bin
  AS      arch/x86/boot/header.o
  LD      arch/x86/boot/setup.elf
  OBJCOPY arch/x86/boot/setup.bin
  BUILD   arch/x86/boot/bzImage
Root device is (8, 1)
Setup is 11916 bytes (padded to 12288 bytes).
System is 2904 kB
CRC 30db084d
Kernel: arch/x86/boot/bzImage is ready  (#1)
ERROR: "snd_hwdep_new" [ubuntu/misc/media/snd-bt-sco.ko] undefined!
WARNING: modpost: Found 4 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
#

So I gave up on a new kernel and compiled 2.6.22, booted, and compiled compat-wireless-old.tar.bz2 to it, which went fine.  I even get a blue light for the radio switch now.  But it will not associate.  I am using the exact same interfaces file as before.  I tried network manager, but it doesn't even recognize this as a wireless device.

 # iwconfig
wlan0     IEEE 802.11abgn  ESSID:"Hex"
          Mode:Managed  Frequency:2.462 GHz  Access Point: Not-Associated
          Tx-Power=14 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

# iwpriv
wlan0     no private ioctls.

# iwpriv wlan0 network_type g
wlan0     no private ioctls.

# iwlist wlan0 auth
wlan0     Authentication capabilities :
                WPA
                WPA2
                CIPHER-TKIP
                CIPHER-CCMP
          Current Authentication algorithm :
                open

So for some reason it is not recognizing my WPA commands in /etc/network/interfaces (which worked before).  Or maybe it's in 'n' or 'a' mode, rather than g.  I've searched everywhere and can not find how to set it to g mode now that it has no private ioctls.

/etc/network/interfaces:
iface wlan0 inet static
pre-up /sbin/iwpriv wlan0 network_type g
pre-up ip link set wlan0 up
address 192.168.1.1
netmask 255.255.255.0
gateway 192.168.1.5
wireless-essid Hex
wpa-scan-ssid 0
wpa-ap-scan 1
wpa-ssid Hex
wpa-psk Freeasinfreedom
