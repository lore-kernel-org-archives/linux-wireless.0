Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hpsmtp-eml16.kpnxchange.com ([213.75.38.116]:20004 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756117AbYATX3G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 18:29:06 -0500
From: Frans Pop <elendil@planet.nl>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [ath5k] Help needed for Trust Speedshare Turbo Pro (PCMCIA)
Date: Mon, 21 Jan 2008 00:12:40 +0100
Cc: linux-wireless@vger.kernel.org
References: <200710211316.06772.elendil@planet.nl> <200710221848.27985.elendil@planet.nl> <43e72e890710221011p2b2f66d8w3f341bec068e49f1@mail.gmail.com>
In-Reply-To: <43e72e890710221011p2b2f66d8w3f341bec068e49f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801210012.41021.elendil@planet.nl> (sfid-20080120_232911_676484_3B76A95E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 October 2007, Luis R. Rodriguez wrote:
> This is the problem. ath5k currently assumes only AR5210s (which are
> 802.11a only capable) have an RF5110. This is also an 802.11bg card.
> Essentially support for this is on the TODO list. For now we'll have
> to just detect this and inform users the card is not supported yet.

I've just given the ath5k driver from current wireless-everything.git
repository a try, and it looks like it now supports my Trust Speedshare
Turbo Pro PCMCIA card. At least, I can scan for networks.
As I don't have a wireless router at home (and no neighbors with open ones),
I cannot try an actual connection.

$ git describe
v2.6.24-rc8-689-g40dfd0a

I do get some probably bad messages in dmesg though:
<on insertion of the card>
pccard: CardBus card inserted into slot 0
PCI: Enabling device 0000:02:00.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 18 (level, low) -> IRQ 16
ath5k_pci 0000:02:00.0: registered as 'phy0'
phy0: Selected rate control algorithm 'pid'
ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
ath5k phy0: RF2112A 2GHz radio found (0x46)
udev: renamed network interface wlan0 to ath0
<on 'ifconfig ath0 up'>
ADDRCONF(NETDEV_UP): ath0: link is not ready
<on 'iwlist ath0 scan'>
ath5k phy1: noise floor calibration timeout (2412MHz)
ath5k phy1: noise floor calibration timeout (2412MHz)
ath5k phy1: noise floor calibration timeout (2422MHz)
ath5k phy1: ath5k_chan_set: unable to reset channel 3 (2422 Mhz)
ath0: failed to set channel 3 (2422 MHz) for scan
ath5k phy1: noise floor calibration timeout (2412MHz)
ath5k phy1: ath5k_chan_set: unable to reset channel 1 (2412 Mhz)
ath0: failed to restore operational channel after scan

The host system is a Toshiba Satellite A40 laptop (i386, Mobile Pentium 4)
running Debian unstable.
>From lspci:
01:0b.0 CardBus bridge [0607]: Toshiba America Info Systems ToPIC100 PCI to Cardbus Bridge with ZV Support (rev 33)
01:0b.0 0607: 1179:0617 (rev 33)
02:00.0 Ethernet controller [0200]: Atheros Communications, Inc. AR5212 802.11abg NIC (rev 01)
02:00.0 0200: 168c:0013 (rev 01)

Still, definite progression over what we had in October :-) Thanks!
If you need any additional info, please ask.

Cheers,
FJP
