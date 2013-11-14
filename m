Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44229 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab3KNKZ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 05:25:27 -0500
Message-ID: <5284A50E.4080702@openwrt.org> (sfid-20131114_112530_336904_A92AC477)
Date: Thu, 14 Nov 2013 11:25:18 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>, linux-wireless@vger.kernel.org
CC: Sujith Manoharan <sujith@msujith.org>,
	Ingo Randolf <ingo.randolf@qupik.com>, mcgrof@do-not-panic.com
Subject: Re: ath9k AR9382 high latency ping
References: <52492FB0.3010201@einfach.org>	<5249443E.3080700@rempel-privat.de>	<524954BE.8060603@einfach.org>	<52497C2E.1060406@rempel-privat.de>	<5249A2F7.5090908@einfach.org>	<524DA3DC.6060806@einfach.org> <21087.18050.72635.617321@gargle.gargle.HOWL> <52849677.3090609@einfach.org>
In-Reply-To: <52849677.3090609@einfach.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-11-14 10:23, Bruno Randolf wrote:
> Hello All!
> 
> Here is another ath9k PCIe card I have problems with in a Intel Atom
> N2600 embedded board (Advantech MIO-2261N). This is the same board I was
> reporting problems with the AR9287 before. I exchanged the card for an
> AR9382 and at least I can associate now.
> 
> It's a AR9382 (Unex DNXA-116) and the PCI ID 168c:0030 subsystem
> 168c:3116, reported as "AR9300 Rev:3"...
> 
> The symptom are ping times of around 1000ms, when connected to an AP
> (very close, I expect around 2ms), eg.
> 
> 64 bytes from 192.168.5.1: icmp_seq=1 ttl=64 time=1237 ms
> 64 bytes from 192.168.5.1: icmp_seq=2 ttl=64 time=1403 ms
> 64 bytes from 192.168.5.1: icmp_seq=3 ttl=64 time=1567 ms
> 64 bytes from 192.168.5.1: icmp_seq=4 ttl=64 time=1728 ms
> 
> The same card works fine in another Laptop, BTW, so it must be a problem
> specific to this board.
> 
> I run wireless-testing from yesterday and I tried with different
> combinations of enabling/disabling ASPM in the BIOS and booting with
> pcie_aspm=off pcie_aspm=force all of which has the same result...
Have you checked for IRQ issues? That seems likely given that packets
are sent, but the tx path is still considered hung.

- Felix

