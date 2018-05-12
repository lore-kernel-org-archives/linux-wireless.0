Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40222 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750722AbeELIuy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 04:50:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] b43: fix transmit failure when VT is switched
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <5AF41F55.4060606@sra-tohoku.co.jp>
References: <5AF41F55.4060606@sra-tohoku.co.jp>
To: kabe@sra-tohoku.co.jp
Cc: b43-dev@lists.infradead.org, kabe@sra-tohoku.co.jp,
        linux-wireless@vger.kernel.org
Message-Id: <20180512085053.D5B4160850@smtp.codeaurora.org> (sfid-20180512_105058_273589_D0DCA9E9)
Date: Sat, 12 May 2018 08:50:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kabe@sra-tohoku.co.jp wrote:

> From: Taketo Kabe <kabe@sra-tohoku.co.jp>
> 
> Fix for b43 wireless card stopping transmission when switching VTs.
> 
> Setup:
> Using BCM4306 rev.03 chip based CardBus wireless card.
> IRQ is shared with yenta (cardbus bridge) and i915 (display) driver.
> For firmware, installed latest but dated openfwwf 5.2
> (http://netweb.ing.unibs.it/~openfwwf/)
> 
> How-to-reproduce:
> Do "ssh <NetBSD-remotehost>", then "ls -lR /" to generate traffic, then
> repeatedly switch VTs by Alt-F1<>Alt-F2.
> Eventually (within a minute) the card stops working.
> You can receive traffic but no transmission.
> For unknown reason it doesn't occur when just generating traffic by
> "ssh <remotehost> ls -lR /".
> 
> With CONFIG_B43_DEBUG=y kernel config, when it stops,
> the debug message shows
>      kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 148, but got 180
> The slot offset I observed so far was always 32.
> 
> When err_out2 is not set to make error messages successive,
> the debug output will be like this:
> kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 116, but got 148
> kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 116, but got 150
> kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 116, but got 120
> kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 116, but got 152
> kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 116, but got 122
> kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 116, but got 154
> kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 116, but got 124
> kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 116, but got 156
> kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 116, but got 126
> The TX ring alternates between 2 sequences; the ring seems
> to be completely confused. Controller restart is needed.
> 
> Workaround(1):
> This problem doesn't occur when using propriatory firmware
> you will extract by b43-fwcutter, so it may be a bug in
> openfwwf firmware, as the comment in the b43_dma_handle_txstatus() suggests.
> I wasn't able to find a bug in the terse openfwwf code though.
> 
> Workaround(2):
> Using "pio=1" option to not use DMA makes this problem to
> not occur.
> 
> Description of the patch:
> This patch will forcibly reset the controller to make it
> work again. Very kludgy and doesn't look right, but
> the traffic will continue to flow.
> 
> Signed-off-by: Taketo Kabe <kabe@sra-tohoku.co.jp>
> Reviewed-by: Michael Buesch <m@bues.ch>
> [kvalo@codeaurora.org: clean up commit log]

Failed to apply to wireless-drivers-next:

fatal: sha1 information is lacking or useless (drivers/net/wireless/broadcom/b43/dma.c).
error: could not build fake ancestor
Applying: b43: fix transmit failure when VT is switched
Patch failed at 0001 b43: fix transmit failure when VT is switched
The copy of the patch that failed is found in: .git/rebase-apply/patch

Please read:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#format_of_patches

Also the change log should be after --- line:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10391617/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
