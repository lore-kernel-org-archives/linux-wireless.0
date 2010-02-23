Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:46025 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab0BWRch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 12:32:37 -0500
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate01.web.de (Postfix) with ESMTP id 11971148BC93F
	for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2010 18:32:36 +0100 (CET)
Received: from [84.56.180.53] (helo=pinguin.localnet)
	by smtp07.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #314)
	id 1Njycd-00054M-00
	for linux-wireless@vger.kernel.org; Tue, 23 Feb 2010 18:32:36 +0100
From: Jens Westemeier <Jens_Westemeier@web.de>
To: linux-wireless@vger.kernel.org
Subject: Re: problem with WG511v1
Date: Tue, 23 Feb 2010 18:32:30 +0100
References: <4B83B96A.6050605@sorengo.com> <20100223144502.GA2928@tuxdriver.com>
In-Reply-To: <20100223144502.GA2928@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201002231832.31015.Jens_Westemeier@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 23. Februar 2010 15:45:03 schrieb John W. Linville:
> On Tue, Feb 23, 2010 at 12:18:02PM +0100, Fabrice Lamareille wrote:
> > Hello
> > 
> > I have a NETGEAR WG511v1 wireless pcmcia card.
> > It was working perfectly on fedora 11 with the prism54 driver and the
> > attached isl3890 firmware.
> > 
> > Since fedora 12, the p54pci driver is enabled by default, but it does
> > not work with my card. I downloaded the right isl3886pci firmware on
> > your website, but the card does not start...
> > With the old isl3890 renamed as isl3886pci, the kernel crashes.
> > With the attachd isl3886pci firmware, which I extracted from the windows
> > driver with fwextract, it seems not to crash, but the card does not
> > appear in NetworkManager nor starts automaticaly...
> > 
> > Thanks in advance for your help.
> 
> I'm not sure what you mean by "firmware on your website", but the
> file you attached does not match what is linked here:
> 
> http://wireless.kernel.org/en/users/Drivers/p54#firmware
> 
> In the command-lines pasted below, 2.13.12.0.arm is the file downloaded
> through the link for "PCI / PCMCIA" for kernels 2.6.29 and above at
> the URL above and isl3886pci is the file you attached to your email
> by that same name.
> 
> /tmp
> [linville-t400.local]:> ls -l isl3886pci 2.13.12.0.arm
> -rw-rw-r-- 1 linville linville 29036 2010-02-23 09:39 2.13.12.0.arm
> -rw------- 1 linville linville 29040 2010-02-23 09:39 isl3886pci
> 
> /tmp
> [linville-t400.local]:> cmp 2.13.12.0.arm isl3886pci
> 2.13.12.0.arm isl3886pci differ: byte 5, line 1
> 
> If you use the specified firmware, does the device work for you?
> 
> John

I have the same problem with my PrismGT based SMC 2802 FullMAC card. I use 
kernel 2.6.31.8-0.1-desktop (OpenSuSE 11.2) and tried several versions of FW.

lspci gives:

Network controller: Intersil Corporation ISL3890 [Prism GT/Prism 
Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)

The card is working with prism54 driver and on my dual boot Windows XP.

modprobe p54pci gives (in /var/log/messages):

p54pci 0000:05:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
p54pci 0000:05:01.0: firmware: requesting isl3886pci
phy2: p54 detected a LM86 firmware
p54: rx_mtu reduced from 3240 to 2376
phy2: FW rev 2.17.2.0 - Softmac protocol 7.6
phy2: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
phy2: device does not respond!
p54pci 0000:05:01.0: PCI INT A disabled
p54pci: probe of 0000:05:01.0 failed with error -16

With every modprobe try phyx is incremented by 1.

The driver seems to be loaded properly, lsmod | grep p54 gives:

p54pci                 13128  0
p54common              33420  1 p54pci
mac80211              257024  3 p54pci,zd1211rw,p54common
cfg80211              123264  3 zd1211rw,p54common,mac80211

Any attempt to configure this card is failing.

Greetings, Jens.
