Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1551 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325Ab2GCGvl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 02:51:41 -0400
Message-ID: <4FF29671.1020406@broadcom.com> (sfid-20120703_085144_175957_95AE7A1E)
Date: Tue, 3 Jul 2012 08:51:29 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: REGRESSION: [PATCH v2 0/9] bcma misc updates
References: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2012 01:44 AM, Hauke Mehrtens wrote:
> These are some updates for bcma. Some are extending or completing some 
> workarounds for PCIe based wireless cards. A patch adds 
> bcma_pmu_spuravoid_pllupdate, used by brcmsmac and an other patch adds 
> constants for the chip ids. This code is mostly based on code from 
> brcmsmac and the Broadcom SDK for BCM47XX SoCs.
> 
> This was tested on a BCM4718 SoC with a BCM43224 PCIe and a BCM5357.
> The Wifi part of the BCM4718 and BCM43224 is more or less working with 
> brcmsmac, which need some more patches for that, but it has low speed 
> and some times or with some access points I still get errors. The wifi 
> of the BCM5357 does not work.
> 

Hi Hauke,

This patch series caused a regression in one of our smoketest machines
last night. I have not looked at the exact patch causing it (suspect
2/9). The failure happens on a BCM43224 chip with external SPROM. Here
is the log info:

[317752.101665] bcma: Found chip with id 0xA8D8, rev 0x01 and package 0x08
[317752.101809] bcma: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800,
rev 0x22, class 0x0)
[317752.101827] bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812,
rev 0x17, class 0x0)
[317752.101870] bcma: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev
0x0F, class 0x0)
[317752.171926] bcma: Failed to get SPROM: -71 <== -EPROTO (crc failed).
[317752.171982] bcma: Bus registered
[317753.184455] brcmsmac bcma0:0: mfg 4bf core 812 rev 23 class 0 irq 16
[317753.191868] brcmsmac: Applying 43224B0+ WARs
[317753.193918] ieee80211 phy0: wl0: brcms_b_attach: bad macaddr
[317753.193924] ieee80211 phy0: wl0: brcms_b_attach: failed with err 22
[317753.193928] ieee80211 phy0: wl0: brcms_c_attach: failed with err 22
[317753.193959] ieee80211 phy0: brcmsmac: attach() failed with code 22
[317753.193966] brcmsmac: brcms_bcma_probe: brcms_attach failed!

I suspect it tries reading OTP instead of the external SPROM.

Gr. AvS

