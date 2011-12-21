Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34394 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab1LUSBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 13:01:46 -0500
Received: by ghbz12 with SMTP id z12so4987860ghb.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 10:01:45 -0800 (PST)
Message-ID: <4EF21F06.309@lwfinger.net> (sfid-20111221_190149_373442_69D5F44F)
Date: Wed, 21 Dec 2011 12:01:42 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: lina <lina.lastname@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Debian Lists <debian-user@lists.debian.org>,
	=?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>
Subject: Re: bcm4331 firmware installer package
References: <CAG9cJm=YkvHY56LoBoUf3fuh=xb7m+c0GgUzMZX+QyG1+CBCMg@mail.gmail.com>
In-Reply-To: <CAG9cJm=YkvHY56LoBoUf3fuh=xb7m+c0GgUzMZX+QyG1+CBCMg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/2011 04:59 AM, lina wrote:
> Hi,
>
> I don't know which one (else) can be fit for bcm4331 802.11a/b/g/n (rev 02)
>
>> From http://wiki.debian.org/bcm43xx#b43_and_b43legacy
>
> I tried:
>
> 1] aptitude install firmware-b43-lpphy-installer
>
> No chroot environment found. Starting normal installation
> No supported card found.
> Use proper b43 or b43legacy firmware.
> Aborting.
>
> 2] # aptitude install firmware-b43-installer
>
> No chroot environment found. Starting normal installation
> Unsupported device(s) found: PCI id 14e4:4331
> Aborting.
>
> both of the listed are not working,
>
> lspci showed:
>
> 03:00.0 Network controller: Broadcom Corporation BCM4331 802.11a/b/g/n (rev 02)
>
> Thanks for providing some suggestions or links.
>
> P.S extra info:
>
> $ uname -a
> Linux debian 3.2.0-rc6-3.2-mj-lina #1 SMP Sat Dec 17 13:14:26 SGT 2011
> x86_64 GNU/Linux
>
> # modprobe b43
> # lsmod | grep -e b43 -e bcma
> b43                   349208  0
> mac80211              228257  1 b43
> cfg80211              173366  2 b43,mac80211
> ssb                    52359  1 b43
> pcmcia                 40840  2 b43,ssb
> rng_core               12614  1 b43
> bcma                   23572  1 b43
> mmc_core               84258  4 b43,ssb,sdhci_pci,sdhci
>
> # dmesg
> [29546.428354] b43-phy0: Broadcom 4331 WLAN found (core revision 29)
> [29546.428389] bcma: Switched to core: 0x812
> [29546.428819] b43-phy0 ERROR: FOUND UNSUPPORTED PHY (Analog 9, Type
> 7, Revision 1)
> [29546.428837] b43: probe of bcma0:0 failed with error -95
> [29546.428878] Broadcom 43xx driver loaded [ Features: PMNLS ]
> [29683.101838] applesmc: F1Mn: write arg fail

Missing firmware is not yet the problem.

As the ERROR message above says, the PHY contained in the BCM4331 is not 
supported by your version of b43. It takes kernel 3.2-rc3+. You can also get 
that version of the driver by installing the latest version of bleeding-edge 
compat-wireless found at http://linuxwireless.org/download/compat-wireless-2.6/. 
You will need to build that code, unless Debian has such a package.

Once you get the correct version of b43, then the firmware and the firmware 
cutter are available at http://wireless.kernel.org/en/users/Drivers/b43.

Larry
