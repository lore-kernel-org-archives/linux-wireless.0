Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:53136 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab0JRNvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 09:51:44 -0400
Subject: Re: [PATCH v3 0/4] wl1271: TX optimizations & fixes
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ido Yariv <ido@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286887752-19321-1-git-send-email-ido@wizery.com>
References: <1286887752-19321-1-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 16:51:42 +0300
Message-ID: <1287409902.20107.58.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-12 at 14:49 +0200, ext Ido Yariv wrote:
> The following patches fix some issues in the TX path, as well as optimize it.
> 
> The first patch fixes an issue in wl1271_tx_work. In case the aggregation
> buffer is completely filled, the content of the buffer is transferred and no
> more packets are sent. Fixed by flushing the buffer and continue aggregating
> packets.
> 
> The second patch solves a TX starvation issue in wl1271_irq_work. Since TX is
> handled by wl1271_tx_work, packets are transmitted after all interrupts are
> handled in wl1271_irq_work. Since these include TX completion interrupts the
> FW status might be read multiple times needlessly, which could hurt performance.
> 
> The third patch is more of a cosmetic change. Instead of traversing the array
> of TX descriptors in order to find a free entry, use a bitmap for that
> purpose.
> 
> The last patch fixes an issue with the TX queue low watermark. The number of
> items in the TX queue is checked against the low watermark in
> wl1271_tx_complete. However, the fact that a TX completion interrupt was fired
> does not necessarily mean that there are any less skbs in the TX queue. Fixed
> by moving the handling logic to the TX work, after skbs are actually dequeued.
> 
> These patches were tested on a Zoom2 platform (SDIO only). While throughput in
> RX scenarios was hardly affected, throughput in TX scenarios was significantly
> improved.
> 
> Changes from v2:
> - Remove the restriction on the maximum number of TX descriptors being 32
> Changes from v1:
> - Fix a theoretical potential deadlock in irq_work and tx_work. Instead of
>   cancelling redundant work, avoid scheduling it in the first place.
> - Check if the low watermark was reached only if skbs were really dequeued
> 
> Ido Yariv (4):
>   wl1271: TX aggregation optimization
>   wl1271: Fix TX starvation
>   wl1271: Allocate TX descriptors more efficiently
>   wl1271: Fix TX queue low watermark handling

Applied the series.  Thank you!


-- 
Cheers,
Luca.

