Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37146 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935638AbeEYKI6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 06:08:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/10] wcn36xx: fix buffer commit logic on TX path
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180516140820.1636-2-daniel@zonque.org>
References: <20180516140820.1636-2-daniel@zonque.org>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, loic.poulain@linaro.org,
        Daniel Mack <daniel@zonque.org>
Message-Id: <20180525100858.6251560618@smtp.codeaurora.org> (sfid-20180525_120949_362618_892842BD)
Date: Fri, 25 May 2018 10:08:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Mack <daniel@zonque.org> wrote:

> When wcn36xx_dxe_tx_frame() is entered while the device is still processing
> the queue asyncronously, we are racing against the firmware code with
> updates to the buffer descriptors. Presumably, the firmware scans the ring
> buffer that holds the descriptors and scans for a valid control descriptor,
> and then assumes that the next descriptor contains the payload. If, however,
> the control descriptor is marked valid, but the payload descriptor isn't,
> the packet is not sent out.
> 
> Another issue with the current code is that is lacks memory barriers before
> descriptors are marked valid. This is important because the CPU may reorder
> writes to memory, even if it is allocated as coherent DMA area, and hence
> the device may see incompletely written data.
> 
> To fix this, the code in wcn36xx_dxe_tx_frame() was restructured a bit so
> that the payload descriptor is made valid before the control descriptor.
> Memory barriers are added to ensure coherency of shared memory areas.
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

10 patches applied to ath-next branch of ath.git, thanks.

9a81cc23dfef wcn36xx: fix buffer commit logic on TX path
57e06e0e2a86 wcn36xx: set DMA mask explicitly
ba437e72378c wcn36xx: don't disable RX IRQ from handler
edd23ab403cf wcn36xx: clear all masks in RX interrupt
ce1d4be82b10 wcn36xx: only handle packets when ED or DONE bit is set
18c7ed138824 wcn36xx: consider CTRL_EOP bit when looking for valid descriptors
2a46c829a926 wcn36xx: set PREASSOC and IDLE stated when BSS info changes
773f9a28bcda wcn36xx: drain pending indicator messages on shutdown
a50c6c8412f7 wcn36xx: simplify wcn36xx_smd_open()
ffbc9197b472 wcn36xx: improve debug and error messages for SMD

-- 
https://patchwork.kernel.org/patch/10404031/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
