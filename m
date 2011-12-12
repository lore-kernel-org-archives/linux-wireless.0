Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:59039 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1LLOt5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 09:49:57 -0500
Received: from moweb002.kundenserver.de (moweb002.kundenserver.de [172.19.20.108])
	by fmmailgate02.web.de (Postfix) with ESMTP id 4E3301BB38EE6
	for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 15:49:56 +0100 (CET)
From: Julian Wollrath <jwollrath@web.de>
To: linux-wireless@vger.kernel.org
Subject: brcmsmac fails to bring up BCM43224
Date: Mon, 12 Dec 2011 15:49:55 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201112121549.55949.jwollrath@web.de> (sfid-20111212_155000_914204_B3B7CB37)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

im running an up to date kernel and since after applying the "brcm80211: 
fullmac 4430 support and softmac switch to bcma" patch series, my BCM43224 
fails to bring up the device.

[ 9519.193496] bcma-pci-bridge 0000:12:00.0: PCI INT A disabled
[ 9574.033024] cfg80211: Calling CRDA to update world regulatory domain
[ 9574.033581] bcma-pci-bridge 0000:12:00.0: PCI INT A -> GSI 17 (level, low) 
-> IRQ 17
[ 9574.033596] bcma-pci-bridge 0000:12:00.0: setting latency timer to 64
[ 9574.033703] bcma: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 
0x22, class 0x0)
[ 9574.033728] bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 
0x17, class 0x0)
[ 9574.033784] bcma: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, 
class 0x0)
[ 9574.033912] bcma: Found rev 6 PMU (capabilities 0x108C2606)
[ 9574.044050] bcma: Bus registered
[ 9574.047141] brcmsmac bcma0:0: mfg 4bf core 812 rev 23 class 0 irq 17
[ 9574.051858] ieee80211 phy0: wl0: brcms_b_attach: si_attach failed
[ 9574.051864] ieee80211 phy0: wl0: brcms_b_attach: failed with err 11
[ 9574.051867] ieee80211 phy0: wl0: brcms_c_attach: failed with err 11
[ 9574.051880] ieee80211 phy0: brcmsmac: attach() failed with code 11
[ 9574.051887] brcmsmac: brcms_bcma_probe: brcms_attach failed!
[ 9574.051913] brcms_module_init: register returned 0

If I interpret this information right, it seems, like something went wrong in 
the function ai_doattach in aiutils.c.

If you need further information, feel free to ask.


With best regards,
Julian Wollrath
