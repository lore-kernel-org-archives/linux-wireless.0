Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:52230 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab1FFVxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 17:53:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [RFC][PATCH 01/10] bcma: Use array to store cores.
Date: Mon, 6 Jun 2011 23:53:40 +0200
Cc: George Kashperko <george@znau.edu.ua>,
	=?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Greg KH <greg@kroah.com>, linux-wireless@vger.kernel.org,
	linux-mips@linux-mips.org, mb@bu3sch.de, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de> <201106061503.14852.arnd@arndb.de> <4DED48EA.7070001@hauke-m.de>
In-Reply-To: <4DED48EA.7070001@hauke-m.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201106062353.40470.arnd@arndb.de> (sfid-20110606_235358_265210_3D9D2960)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 June 2011 23:38:50 Hauke Mehrtens wrote:
> Accessing chip common should be possible without scanning the hole bus
> as it is at the first position and initializing most things just needs
> chip common. For initializing the interrupts scanning is needed as we do
> not know where the mips core is located.
> 
> As we can not use kalloc on early boot we could use a function which
> uses kalloc under normal conditions and when on early boot the
> architecture code which starts the bcma code should also provide a
> function which returns a pointer to some memory in its text segment to
> use. We need space for 16 cores in the architecture code.
>
> In addition bcma_bus_register(struct bcma_bus *bus) has to be divided
> into two parts. The first part will scan the bus and initialize chip
> common and mips core. The second part will initialize pci core and
> register the devices in the system. When using this under normal
> conditions they will be called directly after each other.

Just split out the minimal low-level function from the bcma_bus_scan
then, to locate a single device based on some identifier. The
bcma_bus_scan() function can then repeatedly allocate one device
and pass it to the low-level function when doing the proper scan,
while the arch code calls the low-level function directly with static
data.

	Arnd
