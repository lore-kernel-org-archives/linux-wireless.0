Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:56738 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbbDPLdH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2015 07:33:07 -0400
Message-ID: <552F9DE1.7070700@openwrt.org> (sfid-20150416_133312_608345_79120369)
Date: Thu, 16 Apr 2015 13:32:49 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: miaoqing@qti.qualcomm.com, linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com
Subject: Re: [PATCH] ath9k: fix soft lockup - CPU stuck
References: <1429151050-22488-1-git-send-email-miaoqing@qca.qualcomm.com>
In-Reply-To: <1429151050-22488-1-git-send-email-miaoqing@qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-04-16 04:24, miaoqing@qti.qualcomm.com wrote:
> From: Miaoqing Pan <miaoqing@qca.qualcomm.com>
> 
> BUG: soft lockup - CPU#0 stuck for 22s! [hostapd:965]
> CPU: 0 PID: 965 Comm: hostapd Not tainted 3.14.0 #1
> task: 82e29c40 ti: 82fb2000 task.ti: 82fb2000
> $ 0   : 00000000 00000000 83281f90 00004018
> $ 4   : 832a0010 b810403c 00004030 00000600
> $ 8   : 8036a980 ffd23940 00000000 00000000
> $12   : 00000060 00000007 00000000 0000000c
> $16   : 832a0010 00023f40 00000002 00000000
> $20   : 832a0010 832a0298 832ba994 832bb83c
> $24   : 00000002 800aa2d4
> $28   : 82fb2000 82fb3c08 832bbf0c 8339edc4
> Hi    : 00000006
> Lo    : 009b9500
> epc   : 8339ede0 ath9k_hw_enable_interrupts+0xf8/0x194 [ath9k_hw]
> Not tainted
> ra    : 8339edc4 ath9k_hw_enable_interrupts+0xdc/0x194 [ath9k_hw]
> Status: 1000fc03	KERNEL EXL IE
> Cause : 5080d400
> PrId  : 00019374 (MIPS 24Kc)
> 	Kernel panic - not syncing: softlockup: hung tasks
> 
> The original intention of commit e3f31175a3("ath9k: fix race condition
> in irq processing during hardware reset") is to avoid the IRQ storms,it
> disabled the IRQ entirely for the duration of the reset, but it introducted
> a new IRQ storms in handle_level_irq() when call ath9k_hw_enable_interrupts(),
> meanwhile the irq is disabled by disable_irq().
That sounds like it might be a bug in the platform IRQ handling code,
not ath9k. When I made this change, it uncovered multiple bugs in the
platform code. One was in the generic MIPS CPU IRQ code, fixed in
upstream commit a3e6c1eff54878506b2dddcc202df9cc8180facb.
The other bug was in the ar71xx platform handler code in OpenWrt, fixed
here: http://git.openwrt.org/?p=openwrt.git;a=blob;f=target/linux/ar71xx/patches-3.18/736-MIPS-ath79-fix-chained-irq-disable.patch;h=8cb38d3971678e3cf951d36e6ab2f4b170cd1f0c;hb=HEAD

> Remove disable_irq/enable_irq
> paire, instead of diabling tasklet to re-enable IRQ during the reset.
That is insufficient - it completely ignores the problem of shared
interrupts.

- Felix
