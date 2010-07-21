Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38351 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab0GUS7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 14:59:01 -0400
Received: by ewy23 with SMTP id 23so2550021ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jul 2010 11:58:59 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 21 Jul 2010 14:58:59 -0400
Message-ID: <AANLkTil3u8uFbH7WyPuvqu0wee4KsojqPUsAH2kupZhJ@mail.gmail.com>
Subject: ath9k - D-link DWA-552
From: Andy Pyles <andy.pyles@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have recently purchased two of these cards. ( the markings on the
outside indicate they have are same hardware revision). I am noticing
some strange behavior on one of them:

Card One ( this one works)
$lspci -v output"


05:02.0 Network controller: Atheros Communications Inc. AR5008
Wireless Network Adapter (rev 01)
	Subsystem: D-Link System Inc Device 3a6d
	Flags: bus master, 66MHz, medium devsel, latency 168, IRQ 18
	Memory at fbde0000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [40] #80 [0000]
	Kernel driver in use: ath9k
	Kernel modules: ath9k

$lspci -n output:
05:02.0 0280: 168c:0023 (rev 01)


Card Two ( this one doesn't work )
$lspci -v output:

05:05.0 Ethernet controller: Atheros Communications Inc. AR5008
Wireless Network Adapter (rev 01)
	Subsystem: Atheros Communications Inc. Device ee1c
	Flags: 66MHz, medium devsel, IRQ 17
	Memory at fbdf0000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [40] #80 [0000]
	Kernel modules: ath9k

$lspci -n output:
05:05.0 0200: 168c:ff1d (rev 01)
---

Has anyone else seen this behavior with Card Two? I tried swapping to
a different PCI slot, even to a different PC.
Same symptom. I also tried modifying pci.c in ath9k driver to no effect.
