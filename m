Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58730 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab2BJRsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Feb 2012 12:48:22 -0500
Received: by pbcun15 with SMTP id un15so2608235pbc.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Feb 2012 09:48:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F34BF3C.9030809@01019freenet.de>
References: <CAO=xpBHy9p4yzhxaWTfG+jjw7f_OzbACmxxPnDL8AmLBS-JdwQ@mail.gmail.com>
 <CAO=xpBGT7ovdSOV77AV6wpUcTDFYr0t8GEab474mVmZm0-BhVA@mail.gmail.com>
 <20120207171538.3336af0c@mj> <CAO=xpBGRs_kYtt_w6aG2dFjO4Pgd9MrjPwn7YfuLe7bw3mGiPg@mail.gmail.com>
 <4F34BF3C.9030809@01019freenet.de>
From: Alfonso Fiore <alfonso.fiore@gmail.com>
Date: Fri, 10 Feb 2012 18:47:52 +0100
Message-ID: <CAO=xpBFKOAdTEi1DMfJxWCCv9oEtJpuLjuN4uNPNRgN1iWG85Q@mail.gmail.com> (sfid-20120210_184827_533815_84D9B95E)
Subject: Re: Setting up an AP @ 5 GHz 802.11a - hostapd refuses [Could not
 select hw_mode and channel. (-1)]
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 10, 2012 at 7:54 AM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
>
> I always have to issue a "depmod -a" after make install. You can check
> if the new modules are used afterwards with
> "modinfo modname[without .ko]" and check the given path. It should
> contain "updates".
> Sometimes, it is necessary for me to insert a "depmod -a" even before
> make install, because of missing files, which are needed by the
> installation and which are created by depmod -a.

Hi Andreas,

I hope you can help me a bit further cause I don't know what's going on...

# lsmod | grep 80211
mac80211              157166  1 ath5k
cfg80211              111132  3 ath5k,ath,mac80211
rfkill                  6676  1 cfg80211

# lshw -C network
  *-network:0
       description: Ethernet interface
       product: VT6105M [Rhine-III]
       vendor: VIA Technologies, Inc.
       physical id: 9
       bus info: pci@0000:00:09.0
       logical name: eth0
       version: 96
       serial: 00:0d:b9:16:4b:0c
       size: 100MB/s
       capacity: 100MB/s
       width: 32 bits
       clock: 33MHz
       capabilities: pm bus_master cap_list ethernet physical tp mii
10bt 10bt-fd 100bt 100bt-fd autonegotiation
       configuration: autonegotiation=on broadcast=yes
driver=via-rhine driverversion=1.5.0 duplex=full latency=64 link=yes
maxlatency=8 mingnt=3 multicast=yes port=MII speed=100MB/s
       resources: irq:11 ioport:fc00(size=256) memory:effff000-effff0ff
  *-network:1
       description: Wireless interface
       product: AR5413 802.11abg NIC
       vendor: Atheros Communications Inc.
       physical id: c
       bus info: pci@0000:00:0c.0
       logical name: wlan0
       version: 01
       serial: 00:0b:6b:2e:25:d5
       width: 32 bits
       clock: 33MHz
       capabilities: pm bus_master cap_list ethernet physical wireless logical
       configuration: broadcast=yes driver=ath5k
driverversion=3.0.0-voyage firmware=N/A latency=168 link=yes
maxlatency=28 mingnt=10 multicast=yes wireless=IEEE 802.11abg
       resources: irq:10 memory:effd0000-effdffff

both commands confirm I'm using the ath5k driver (as I knew).

# modinfo ath5k
filename:
/lib/modules/3.0.0-voyage/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
license:        Dual BSD/GPL
description:    Support for 5xxx series of Atheros 802.11 wireless LAN cards.
author:         Nick Kossifidis
author:         Jiri Slaby
alias:          pci:v0000168Cd0000001Dsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000001Csv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000001Bsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000001Asv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000019sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000018sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000017sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000016sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000015sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000014sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00001014sv*sd*bc*sc*i*
alias:          pci:v000010B7d00000013sv*sd*bc*sc*i*
alias:          pci:v0000A727d00000013sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000013sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000012sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000011sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000007sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000207sv*sd*bc*sc*i*
depends:        mac80211,cfg80211,ath
intree:         Y
vermagic:       3.0.0-voyage SMP preempt mod_unload 486
parm:           debug:uint
parm:           nohwcrypt:Disable hardware encryption. (bool)
parm:           all_channels:Expose all channels the device can use. (bool)
parm:           fastchanswitch:Enable fast channel switching for
AR2413/AR5413 radios. (bool)

# find / | grep ath5k.ko
/lib/modules/3.0.0-voyage/kernel/drivers/net/wireless/ath/ath5k/ath5k.ko
/lib/modules/3.0.0/updates/drivers/net/wireless/ath/ath5k/ath5k.ko
/root/compat-wireless-3.3-rc1-2/drivers/net/wireless/ath/ath5k/ath5k.ko
/root/compat-wireless-3.3-rc1-2/drivers/net/wireless/ath/ath5k/.ath5k.ko.cmd

I tried depmod -a and also a simple reboot (which I always do after
make install) but the "updates" module is never loaded.

Any idea?

thanks,
alfonso

>
> Kind regards,
> Andreas
