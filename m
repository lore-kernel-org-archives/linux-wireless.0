Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:35222 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbYJNBUm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 21:20:42 -0400
Message-ID: <20081013212039.dy5fki5pck4g0cg4-cebfxv@webmail.spamcop.net> (sfid-20081014_032102_961937_80AF673F)
Date: Mon, 13 Oct 2008 21:20:39 -0400
From: Pavel Roskin <proski@gnu.org>
To: Christian Lamparter <chunkeey@web.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] p54: Fix for big-endian architecture
References: <48EE20FB.4060700@lwfinger.net> <1223941001.28019.3.camel@dv>
	<1223942439.28019.9.camel@dv> <200810140215.47242.chunkeey@web.de>
In-Reply-To: <200810140215.47242.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Christian Lamparter <chunkeey@web.de>:

> I ask again:
> What Card/MAC & RF-Chip do you have? Indigo/Duette/Firsbee or XBow?

Sorry if I missed your question.

This is a MiniPCI card that has a label with "XG-600" printed on it.   
The driver shows following in the kernel log:

firmware: requesting isl3886
p54: LM86 firmware
p54: FW rev 2.7.0.0 - Softmac protocol 4.1
p54: unknown eeprom code : 0x1
p54: unknown eeprom code : 0x3
p54: unknown eeprom code : 0x1007
p54: unknown eeprom code : 0x1008
p54: unknown eeprom code : 0x1100
p54: unknown eeprom code : 0x1905
phy10: hwaddr 00:60:b3:c9:04:f2, MAC:isl3890 RF:Indigo?
phy10: Selected rate control algorithm 'pid'
udev: renamed network interface wlan1 to wlan2
firmware: requesting isl3886

I understand the driver detects it as Indigo.

# lspci -v -s 01:04.0
01:04.0 Network controller: Intersil Corporation ISL3890 [Prism  
GT/Prism Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)
         Subsystem: Z-Com, Inc. XG-600 and clones Wireless Adapter
         Flags: bus master, medium devsel, latency 16, IRQ 25
         Memory at 80882000 (32-bit, non-prefetchable) [size=8K]
         Capabilities: [dc] Power Management version 1
         Kernel driver in use: p54pci
         Kernel modules: prism54, p54pci

-- 
Regards,
Pavel Roskin
