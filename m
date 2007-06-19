Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:19968 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbXFSH77 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2007 03:59:59 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org, marvell8385-devel@linuxtogo.org,
	libertas-dev@lists.infradead.org
Subject: Update about libertas CompactFlash 8585 driver
Date: Tue, 19 Jun 2007 09:59:53 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200706190959.53476.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My CF driver for the 8385 now can associate. But currently I also 
have a bunch of serious and not-so-serious bugs:


Associating
-----------
Sometimes, this command sequence is enought:

    ifconfig eth1 up
    iwconfig eth1 essid key BLAHBLAH
    iwconfig eth1 key s:BLAH1

But sometimes I have to do that to get a an association:

    ifconfig eth1 up
    iwconfig eth1 essid key BLAHBLAH
    iwconfig eth1 key s:BLAH1
    iwconfig eth1 essid key BLAHBLAH

This does not happen with the 8388 USB dongle, so I guess there 
is an issue between firmware v5.0 vica v5.1.



Not re-associating
------------------
When I am associated from to an Access Point, and actively 
de-associate the client on the AP, then I get the dissassociate 
event back ... but then the driver stays where it is. It does no 
re-scan and try to re-associate to the best AP it can find.

This happens also with the reference 8388 USB dongle, so it's a 
general bug in libertas.



Some softirq problem
--------------------
Sometimes I get the kernel error "NOHZ: local_softirq_pending 
08". This line comes out 5 or 10 times. That nonwithstanding, 
the driver works.

My system has lots of other devices on IRQ 11: yenta, yenta, 
ehci_hcd:usb1, uhci_hcd:usb2, uhci_hcd:usb3, uhci_hcd:usb4 and 
libertas_cs. There are no USB devices attached, Kernel is from 
the libertas2.6 tree, so it's similar to 2.6.22-rc4. Oh, and I 
don't have hyperthreading.



Power management is hosed
-------------------------
After "iwconfig eth1 power on" almost nothing works anymore. 
Sometimes one or two pings came throught, but with extremely 
long delays. And then I get "libertas: tx watch dog timeout"

The reference USB 8388 dongle doesn't have this problem.
