Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail81.extendcp.co.uk ([79.170.40.81]:51916 "EHLO
	mail81.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab1CNQsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 12:48:06 -0400
Received: from 93-97-72-247.zone5.bethere.co.uk ([93.97.72.247] helo=toddler)
	by mail81.extendcp.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.73)
	id 1PzAw8-0002DV-BY
	for linux-wireless@vger.kernel.org; Mon, 14 Mar 2011 16:48:04 +0000
Received: from localhost ([127.0.0.1] helo=toddler)
	by toddler with esmtp (Exim 4.74)
	(envelope-from <h@realh.co.uk>)
	id 1PzAwH-0000lX-7y
	for linux-wireless@vger.kernel.org; Mon, 14 Mar 2011 16:48:13 +0000
Date: Mon, 14 Mar 2011 16:48:12 +0000
From: Tony Houghton <h@realh.co.uk>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Could ath9k and rt2800pci bugs be related?
Message-ID: <20110314164812.4c0cfc29@toddler>
In-Reply-To: <20110224200203.GB17412@elie>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[I am no longer subscribed to the list so please Cc me]

I'm the person who reported that my system kept freezing when shutting
down my AR9285 wireless with kernel 2.6.35 or newer.

I've just bought an Acer Aspire Revo 3700 and this had very similar
symptoms with a different adapter. Luckily another customer had posted
about it on the vendor's website and his fix works for me. The fix is to
blacklist the rt2800pci module and the rt2860sta driver seems to work
quite happily without it.

It looks as if rt2800pci was introduced somewhere between 2.6.32 and
2.6.34 and I experienced the crashes with 2.6.35 (Mint 10/Ubuntu 10.10)
and 2.6.37 (Debian unstable), but not with 2.6.32 (Debian squeeze) which
doesn't have that module.

It's probably just coincidence, but I was struck by how similar the
symptoms are and wondered whether these different drivers have anything
in common? 

lspci output:

02:00.0 Network controller [0280]: RaLink RT3090 Wireless 802.11n 1T/1R PCIe [1814:3090]
	Subsystem: Lite-On Communications Inc Device [11ad:6622]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at febf0000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: <access denied>
	Kernel driver in use: rt2860
