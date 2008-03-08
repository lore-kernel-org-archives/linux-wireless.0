Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.229]:40218 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbYCHC7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 21:59:01 -0500
Received: by qb-out-0506.google.com with SMTP id e11so779233qbe.15
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2008 18:59:00 -0800 (PST)
Message-ID: <43e72e890803071859r2788075cp12272cad0920d2b0@mail.gmail.com> (sfid-20080308_025924_648264_37AD02B7)
Date: Fri, 7 Mar 2008 21:59:00 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Franz Apeltauer" <franz.apeltauer@gmx.at>
Subject: Re: 2 compile errors: rt2x00firmware.c and mesh.c
Cc: linux-wireless@vger.kernel.org, "Ivo van Doorn" <ivdoorn@gmail.com>
In-Reply-To: <47CF28F2.6050509@gmx.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <47CB3B5E.4020701@gmx.at> <1204504331.3917.31.camel@johannes.berg>
	 <20080303035222.GP28995@ruslug.rutgers.edu> <47CF28F2.6050509@gmx.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 5, 2008 at 6:12 PM, Franz Apeltauer <franz.apeltauer@gmx.at> wrote:
> Luis R. Rodriguez schrieb:
>
> > Forced a new tarball out with new changes applied, would appreciate
>  > some testing on 2.6.21, 2.6.22. You can get the tarball from the
>  > usual place:
>  > http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2
>
>  Thank you very much!
>  Now everything compiles fine on 2.6.22.
>
>  I cannot send you test results yet. It looks like I have to read some
>  more documentation first. For now I can only tell you this:
>
>  a) Test on a PC with a Broadcom 4306 rev 03:
>  - Downloaded and installed the firmware.
>  - The module b43legacy loads without errors, but nothing else happens.
>    ifconfig doesn't show any new interface, like eth0 or wlan0.
>  # modprobe b43legacy
>  => messages: Mar  5 23:14:02 af-nb-3 kernel: [10519.728000] Broadcom
>  43xx driver loaded [ Features: PID, Firmware-ID: FW10 ]
>  => dmesg: [10519.728000] Broadcom 43xx driver loaded [ Features: PID,
>  Firmware-ID: FW10 ]
>
>  Maybe this is important: dmesg says "Firmware-ID: FW10", but there is no
>  ucode10.fw in /lib/firmware/b43legacy, only 2, 4, 5, 11 (downloaded
>  today, as described in the wiki).
>
>  # lsmod | grep 43
>  b43legacy             102040  0
>  ssb                    36484  1 b43legacy
>  mac80211              220020  1 b43legacy
>
>  # lspci
>  00:00.0 Host bridge: VIA Technologies, Inc. VT8378 [KM400/A] Chipset
>  Host Bridge
>  00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge
>  00:09.0 Network controller: Broadcom Corporation BCM4306 802.11b/g
>  Wireless LAN Controller (rev 03)
>  ...
>
>
>  b) Test on a PC with MSI PC54G2 ... RaLink rt2500
>  You wrote "For now I'll disable rt2x00 in compat-wireless."
>  So, the result of this test seems to be unimportant (it tried to load
>  the old driver).

You can test this now, I've enabled rt2x00 drivers by fixing
dependencies on config.mk. Forced re-generation of new tarball based
on latest updates too.

  Luis
