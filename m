Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:56988 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab0ASTr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 14:47:28 -0500
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate02.web.de (Postfix) with ESMTP id 4558E14C334C0
	for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 20:47:26 +0100 (CET)
Received: from [84.56.172.240] (helo=pinguin.localnet)
	by smtp07.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #314)
	id 1NXK2w-0007aw-00
	for linux-wireless@vger.kernel.org; Tue, 19 Jan 2010 20:47:26 +0100
From: Jens Westemeier <Jens_Westemeier@web.de>
To: linux-wireless@vger.kernel.org
Subject: p54pci not working with SMC 2802W V-1 FullMAC
Date: Tue, 19 Jan 2010 20:47:24 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201001192047.24798.Jens_Westemeier@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have an old SMC 2802 FullMAC card, which runs since years with the prism54 
driver. To be able to use WPA, I want to use the new p54pci driver.
I updated to kernel 2.6.31.8-0.1-desktop (OpenSuSE 11.2) to get latest drivers 
and copied 2.13.12.0.arm to /usr/firmware/isl3886pci.
But the card seems to be dead for any configuration approaches - Yast 
recommends to load the correct FW. The card was running since years and is 
still working in the dual boot Windows XP part of my computer.

lsmod | grep p54 gives:

p54pci                 13128  0
p54common              33420  1 p54pci
mac80211              257024  3 p54pci,zd1211rw,p54common
cfg80211              123264  3 zd1211rw,p54common,mac80211

rmmod p54pci;modprobe p54pci adds to /var/log/messages:

Jan 19 19:42:03 Pinguin kernel: [  605.707167] p54pci 0000:05:01.0: PCI INT A 
-> GSI 19 (level, low) -> IRQ 19
Jan 19 19:42:03 Pinguin kernel: [  605.707252] p54pci 0000:05:01.0: firmware: 
requesting isl3886pci
Jan 19 19:42:03 Pinguin kernel: [  605.724210] phy5: p54 detected a LM86 
firmware
Jan 19 19:42:03 Pinguin kernel: [  605.724220] p54: rx_mtu reduced from 3240 
to 2376
Jan 19 19:42:03 Pinguin kernel: [  605.724226] phy5: FW rev 2.13.12.0 - 
Softmac protocol 5.9
Jan 19 19:42:03 Pinguin kernel: [  605.724232] phy5: cryptographic accelerator 
WEP:YES, TKIP:YES, CCMP:YES
Jan 19 19:42:04 Pinguin kernel: [  606.833012] phy5: device does not respond!
Jan 19 19:42:04 Pinguin kernel: [  606.833082] p54pci 0000:05:01.0: PCI INT A 
disabled
Jan 19 19:42:04 Pinguin kernel: [  606.833109] p54pci: probe of 0000:05:01.0 
failed with error -16

The log also shows the existence of the zd1211driver. I use this USB stick for 
being able to write this mail, the p54pci problem also shows up without this 
stick being connected.
Playing around with other FW revisions does not help.
I've also seen the same issue described in this mailing list, but without any 
solution.
Now any idea?

Greetings, Jens.
