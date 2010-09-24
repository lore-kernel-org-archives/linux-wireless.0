Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48161 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab0IXRGk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 13:06:40 -0400
Received: by qyk36 with SMTP id 36so1578882qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Sep 2010 10:06:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100924185551.e3c3b41c.cyrille@cbiot.fr>
References: <20100924185551.e3c3b41c.cyrille@cbiot.fr>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 24 Sep 2010 19:06:17 +0200
Message-ID: <AANLkTik5QPw6K_CFQW-5qH3PhyDAguqe51AcNaDMOUqt@mail.gmail.com>
Subject: Re: problem with b43
To: Cyrille <cyrille@cbiot.fr>
Cc: b43-dev@lists.infradead.org,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 24, 2010 at 6:55 PM, Cyrille <cyrille@cbiot.fr> wrote:
> Hi
> I've got a problem with a broadcom 4312 [12e4:4315].
> The environment :
> ===========================
> uname -a
> 2.6.35.5-libre.29.fc14.x86_64
>
> lspci -vnn
> 0b:00.0 Network controller [0280]: Broadcom Corporation BCM4312 802.11b/g [14e4:4315] (rev 01)
>        Subsystem: Dell Wireless 1395 WLAN Mini-Card [1028:000b]
>        Flags: bus master, fast devsel, latency 0, IRQ 17
>        Memory at fe7fc000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: [40] Power Management version 3
>        Capabilities: [58] Vendor Specific Information: Len=78 <?>
>        Capabilities: [e8] MSI: Enable- Count=1/1 Maskable- 64bit+
>        Capabilities: [d0] Express Endpoint, MSI 00
>        Capabilities: [100] Advanced Error Reporting
>        Capabilities: [13c] Virtual Channel
>        Capabilities: [160] Device Serial Number 7f-78-4e-ff-ff-6d-00-23
>        Capabilities: [16c] Power Budgeting <?>
>        Kernel driver in use: b43-pci-bridge
>        Kernel modules: ssb
> ===============================
>
> Installation method ( http://wireless.kernel.org/en/users/Drivers/b43#fw-b43-lp ) :
> You are using the b43 driver from linux-2.6.25 or newer
> export FIRMWARE_INSTALL_DIR="/lib/firmware"
> wget http://mirror2.openwrt.org/sources/broadcom-wl-4.150.10.5.tar.bz2
> tar xjf broadcom-wl-4.150.10.5.tar.bz2
> cd broadcom-wl-4.150.10.5/driver
> sudo ../../b43-fwcutter-013/b43-fwcutter -w "$FIRMWARE_INSTALL_DIR" wl_apsta_mimo.o

You are using the firmware for G-PHYs. Yo should use v4.174 (also
known as v4.178) for LP-PHY.

>
>
> Seems work : ls /lib/firmware/b43-open/
> a0g0bsinitvals5.fw   a0g1bsinitvals9.fw   b0g0bsinitvals9.fw  lp0bsinitvals15.fw  n0initvals11.fw  ucode5.fw
> a0g0bsinitvals9.fw   a0g1initvals13.fw    b0g0initvals13.fw   lp0initvals13.fw    pcm5.fw          ucode9.fw
> a0g0initvals5.fw     a0g1initvals5.fw     b0g0initvals5.fw    lp0initvals14.fw    ucode11.fw
> a0g0initvals9.fw     a0g1initvals9.fw     b0g0initvals9.fw    lp0initvals15.fw    ucode13.fw
> a0g1bsinitvals13.fw  b0g0bsinitvals13.fw  lp0bsinitvals13.fw  n0absinitvals11.fw  ucode14.fw
> a0g1bsinitvals5.fw   b0g0bsinitvals5.fw   lp0bsinitvals14.fw  n0bsinitvals11.fw   ucode15.fw

Extract to /lib/firmware/b43. /lib/firmware/b43-open is only for OpenFWWF.

>
>
> But :
> dmesg
> b43-phy3 ERROR: You must go to http://wireless.kernel.org/en/users/Drivers/b43#devicefirmware and download the correct firmware for this driver version. Please carefully read all instructions on this website.
> b43-phy4: Broadcom 4312 WLAN found (core revision 15)
> b43-phy4 debug: Found PHY: Analog 6, Type 5, Revision 1
> b43-phy4 debug: Found Radio: Manuf 0x17F, Version 0x2062, Revision 2
> phy4: Selected rate control algorithm 'minstrel'
> Registered led device: b43-phy4::tx
> Registered led device: b43-phy4::rx
> Registered led device: b43-phy4::radio
> Broadcom 43xx driver loaded [ Features: PMLS, Firmware-ID: FW13 ]
> ssb0:0: Missing Free firmware
> b43-phy4 ERROR: Rejected non-Free firmware
> ssb0:0: Missing Free firmware
> b43-phy4 ERROR: Rejected non-Free firmware

Compile compat-wireless to bypass the "free-only" patch in Fedora.

(John, are you still maintaining the Fedora kernel's wireless part? If
so, please kill this "freedom enforcement"!)

>
>
> So don't work.
> Grrrrrrrrrrrrrrrrrrrr
> I thought nevertheless that with this kernel that was going to work.
> No idea, I thing is due of the model [12e4:4315]. Is there anyone who can say to me if it possible to install and configure this card with a free-kernel.
>
> Thanx !
>
> Cyrille
>
>
>
> ----
> [ cyrille@cbiot.fr | http://cbiot.fr ]
>
> "Et le combat cessa faute de combattants."
> --- Le Cid (1636), IV, 3, Rodrigue - - - -
>
> BLAG : http://blagblagblag.org
> Blag'em up! http://zenblagger.org
>
>
>
> _______________________________________________
> b43-dev mailing list
> b43-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/b43-dev
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
