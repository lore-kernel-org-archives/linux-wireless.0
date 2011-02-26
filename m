Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:43656 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445Ab1BZSuQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Feb 2011 13:50:16 -0500
Subject: Re: ath9k stopped queue bug
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
In-Reply-To: <AANLkTin0ixVQJA6B6Et1AUqdkhu1b+hv6Gxu_SQWEMzD@mail.gmail.com>
References: <1298390485.2575.6.camel@gnutoo-laptop>
	 <AANLkTin0ixVQJA6B6Et1AUqdkhu1b+hv6Gxu_SQWEMzD@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Feb 2011 19:44:23 +0100
Message-ID: <1298745863.29858.3.camel@gnutoo-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-23 at 11:04 +0530, Mohammed Shafi wrote:
> please try with debug messages enabled sudo modprobe ath9k debug=0x2
> (or)
> sudo modprobe debug=0x82 (this produces lots of log) 
I unloaded, reloaded with debug= the ath9k module, then I connected to
the AP and I didn't see any supplementary message:

root@gnutoo-laptop:~# modinfo ath9k
filename:       /lib/modules/2.6.37-020637-generic/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
license:        Dual BSD/GPL
description:    Support for Atheros 802.11n wireless LAN cards.
author:         Atheros Communications
srcversion:     9F79F17BF7FC245D5B37879
alias:          pci:v0000168Cd00000030sv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Esv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Dsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Csv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Bsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Asv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000029sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000027sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000024sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000023sv*sd*bc*sc*i*
depends:        ath9k_hw,mac80211,cfg80211,ath9k_common,ath
vermagic:       2.6.37-020637-generic SMP mod_unload modversions 
parm:           debug:Debugging mask (uint)
parm:           nohwcrypt:Disable hardware encryption (int)
parm:           blink:Enable LED blink on activity (int)
root@gnutoo-laptop:~# lsmod | grep ath9k
ath9k_common            3151  0 
ath9k_hw              288200  1 ath9k_common
ath                    17109  1 ath9k_hw
root@gnutoo-laptop:~# modprobe ath9k debug=0x82
[...] #connect to the open AP with network manager
root@gnutoo-laptop:~# dmesg | tail -n 1
[22036.864772] wlan0: no IPv6 routers present

Denis.




