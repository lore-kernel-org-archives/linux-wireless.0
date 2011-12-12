Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2106 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686Ab1LLR3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 12:29:35 -0500
Message-ID: <4EE639EF.5000201@broadcom.com> (sfid-20111212_182940_050612_DE561A1F)
Date: Mon, 12 Dec 2011 18:29:19 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Julian Wollrath" <jwollrath@web.de>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: brcmsmac fails to bring up BCM43224
References: <201112121549.55949.jwollrath@web.de>
In-Reply-To: <201112121549.55949.jwollrath@web.de>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/12/2011 03:49 PM, Julian Wollrath wrote:
> Hi,
> 
> im running an up to date kernel and since after applying the "brcm80211: 
> fullmac 4430 support and softmac switch to bcma" patch series, my BCM43224 
> fails to bring up the device.
> 
> [ 9519.193496] bcma-pci-bridge 0000:12:00.0: PCI INT A disabled
> [ 9574.033024] cfg80211: Calling CRDA to update world regulatory domain
> [ 9574.033581] bcma-pci-bridge 0000:12:00.0: PCI INT A -> GSI 17 (level, low) 
> -> IRQ 17
> [ 9574.033596] bcma-pci-bridge 0000:12:00.0: setting latency timer to 64
> [ 9574.033703] bcma: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 
> 0x22, class 0x0)
> [ 9574.033728] bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 
> 0x17, class 0x0)
> [ 9574.033784] bcma: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, 
> class 0x0)
> [ 9574.033912] bcma: Found rev 6 PMU (capabilities 0x108C2606)
> [ 9574.044050] bcma: Bus registered
> [ 9574.047141] brcmsmac bcma0:0: mfg 4bf core 812 rev 23 class 0 irq 17
> [ 9574.051858] ieee80211 phy0: wl0: brcms_b_attach: si_attach failed
> [ 9574.051864] ieee80211 phy0: wl0: brcms_b_attach: failed with err 11
> [ 9574.051867] ieee80211 phy0: wl0: brcms_c_attach: failed with err 11
> [ 9574.051880] ieee80211 phy0: brcmsmac: attach() failed with code 11
> [ 9574.051887] brcmsmac: brcms_bcma_probe: brcms_attach failed!
> [ 9574.051913] brcms_module_init: register returned 0
> 
> If I interpret this information right, it seems, like something went wrong in 
> the function ai_doattach in aiutils.c.
> 
> If you need further information, feel free to ask.

Thanks, Julian

This issue has been flagged by Larry Finger some days ago. Together with
Rafał (BCMA maintainer) we found what was wrong. The BCMA patches for
brcmsmac were not the complete set so likely our coming patch series
will correct the issue.

Gr. AvS

