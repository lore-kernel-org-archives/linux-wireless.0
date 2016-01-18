Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ems.wolfvision.net ([91.118.163.38]:16720 "EHLO
	ems.wolfvision.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbcARJzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2016 04:55:42 -0500
From: Matthias Fend <Matthias.Fend@wolfvision.net>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Michal Kazior <michal.kazior@tieto.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: ath10k: host lock up after firmware crash
Date: Mon, 18 Jan 2016 09:46:13 +0000
Message-ID: <CC2A85E271C1FB479D9C17305347F69A06CF0A9D@WOLFSERVER19.wolfvision-at.intra> (sfid-20160118_105545_905813_F2205EB5)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a x86_64 system where I use a COMPEX WLE600VX miniPCIe module wihich is based on Qualcomm-Atheros QCA9882.
Occasionally the system completely freezes - even the serial console does not work anymore.
During some cumbersome time of trying to produce such a behavior I found out what has happened before the systems locked up.

These are the last words on the console:
[..]
[214618.559061] ath10k_pci 0000:03:00.0: firmware crashed! (uuid a11b4028-a801-454d-82e2-6400792883e2)
[214618.580137] ath10k_pci 0000:03:00.0: failed to read diag value at 0xf7900804: -16
[214618.587704] ath10k_pci 0000:03:00.0: failed to get memcpy hi address for firmware address 4: -16
[214618.596589] ath10k_pci 0000:03:00.0: failed to read firmware dump area: -16
[214618.900072] ath10k_pci 0000:03:00.0: failed to read diag value at 0xf7900800: -16
[214618.907641] ath10k_pci 0000:03:00.0: failed to poke copy engine: -16
[214619.001861] ath10k_pci 0000:03:00.0: failed to read diag value at 0xf7900800: -16
[214619.009438] ath10k_pci 0000:03:00.0: failed to poke copy engine: -16
[214619.110129] ath10k_pci 0000:03:00.0: failed to read diag value at 0xf7900800: -16
[214619.117696] ath10k_pci 0000:03:00.0: failed to poke copy engine: -16
[214619.967868] x

While reading through the related kernel driver I stumbled over this comment:
[..]
/* FIXME: Sometimes copy engine doesn't recover after warm
* reset. In most cases this needs cold reset. In some of these
* cases the device is in such a state that a cold reset may
* lock up the host.
[..]

Currently for me it looks like that this is exactly my problem. Due the closed source of the module firmware it's not really possible to fix the root cause (firmware crash). Therefore I'm looking for alternative workaround.
To do so I am looking for answers to following questions:
Does anybody know what's exactly happening in such a situation?
What are the possibilities for a PCIe module to complete stall the whole system?
Is there a known (fast) way to reproduce this behavior (forcing a cold reset after crash and use simulate_fw_crash as trigger does not work)?

Of course I would be also very happy for any other hints.

Thanks,
 ~Matthias

