Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:53727 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbbHEMVW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 08:21:22 -0400
Subject: Re: [PATCH] ath10k: Add QCA99X0 to supported device list
To: ath10k@lists.infradead.org
References: <1437478567-11339-1-git-send-email-vthiagar@qti.qualcomm.com>
Cc: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, Kalle Valo <kvalo@qca.qualcomm.com>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <55C1FFBC.7070905@openwrt.org> (sfid-20150805_142139_789114_6AADC7C2)
Date: Wed, 5 Aug 2015 14:21:16 +0200
MIME-Version: 1.0
In-Reply-To: <1437478567-11339-1-git-send-email-vthiagar@qti.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-07-21 13:36, Vasanthakumar Thiagarajan wrote:
> Add vendor/device id of QCA99X0 V2.0 to pci id table and
> QCA99X0_HW_2_0_CHIP_ID_REV to ath10k_pci_supp_chips[] for
> QCA99X0 to get detected by the driver.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
I just tested a 99X0 card, and I'm getting this:

[    8.742514] ath10k_pci 0000:01:00.0: enabling device (0140 -> 0142)
[    8.747173] ath10k_pci 0000:01:00.0: pci irq msi interrupts 1 irq_mode 0 reset_mode 0
[   11.793314] ath10k_pci 0000:01:00.0: failed to receive initialized event from target: 00000000
[   11.793344] ath10k_pci 0000:01:00.0: failed to wait for target after cold reset: -110
[   11.800814] ath10k_pci 0000:01:00.0: failed to reset chip: -110
[   11.809228] ath10k_pci: probe of 0000:01:00.0 failed with error -110

This is on an AP148 board with Linux 3.18, backports generated from
latest wireless-testing (2015-08-03) + all patches from kvalo's ath
tree.

- Felix
