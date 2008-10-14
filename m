Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:54343 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbYJNCGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 22:06:20 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [RFC/RFT] p54: Fix for big-endian architecture
Date: Tue, 14 Oct 2008 04:10:27 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <48EE20FB.4060700@lwfinger.net> <200810140215.47242.chunkeey@web.de> <20081013212039.dy5fki5pck4g0cg4-cebfxv@webmail.spamcop.net>
In-Reply-To: <20081013212039.dy5fki5pck4g0cg4-cebfxv@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810140410.27397.chunkeey@web.de> (sfid-20081014_040625_734551_BF74F523)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 14 October 2008 03:20:39 Pavel Roskin wrote:
> Quoting Christian Lamparter <chunkeey@web.de>:
> 
> > I ask again:
> > What Card/MAC & RF-Chip do you have? Indigo/Duette/Firsbee or XBow?
> 
> Sorry if I missed your question.
np
> 
> This is a MiniPCI card that has a label with "XG-600" printed on it.   
> The driver shows following in the kernel log:
> 
> firmware: requesting isl3886
> p54: LM86 firmware
> p54: FW rev 2.7.0.0 - Softmac protocol 4.1
> p54: unknown eeprom code : 0x1
> p54: unknown eeprom code : 0x3
> p54: unknown eeprom code : 0x1007
> p54: unknown eeprom code : 0x1008
> p54: unknown eeprom code : 0x1100
> p54: unknown eeprom code : 0x1905
> phy10: hwaddr 00:60:b3:c9:04:f2, MAC:isl3890 RF:Indigo?
> phy10: Selected rate control algorithm 'pid'
> udev: renamed network interface wlan1 to wlan2
> firmware: requesting isl3886
> 
> I understand the driver detects it as Indigo.
> 
> # lspci -v -s 01:04.0
> 01:04.0 Network controller: Intersil Corporation ISL3890 [Prism  
> GT/Prism Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)
>          Subsystem: Z-Com, Inc. XG-600 and clones Wireless Adapter
>          Flags: bus master, medium devsel, latency 16, IRQ 25
>          Memory at 80882000 (32-bit, non-prefetchable) [size=8K]
>          Capabilities: [dc] Power Management version 1
>          Kernel driver in use: p54pci
>          Kernel modules: prism54, p54pci
> 
Alright, your eeprom says that your card is technically 802.11a capable.
It has the right MAC (ISL3890 Duette) and a 5GHz Phy/Synth/RF (whatever it's called).
 
but unfortunatly, it doesn't provide any calibration data...
And that's the problem here. Since without it, p54_set_freq can't put the card into 802.11a
and the card stays at the last selected channel (somewhere in the 2.4GHz spectrum!).
However after p54_config returns with -EINVAL, mac80211 doesn't revert dev->conf.channel
back to the original 2.4GHz setting...

with your card still listening on 802.11bg channels, it could capture a beacon, or something else
that is transmitted with 1MBit (hdr->rate = 0) and crash.
note: hdr->rate is a u8. so: 0 - 4 = 0xfc and (0xfc & 0xf) = 0xc => 12

so, I guess we have to do two things...
1. check if calibration data includes 5GHz channels AND if it has the Phy/Synth/RF.
2. cache dev->conf.channel locally in the driver.

Regards,
	Chr
