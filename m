Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60227 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbcFNO3U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 10:29:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: remove misleading GFP_DMA flag in buffer allocations
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1463838211-31888-1-git-send-email-minipli@googlemail.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	linux-wireless@vger.kernel.org,
	Dennis Wassenberg <dennis.wassenberg@secunet.com>,
	Mathias Krause <minipli@googlemail.com>,
	Xinming Hu <huxm@marvell.com>,
	Brad Spengler <spender@grsecurity.net>,
	PaX Team <pageexec@freemail.hu>
Message-Id: <20160614142914.E8C7961360@smtp.codeaurora.org> (sfid-20160614_162923_949467_132F0CBF)
Date: Tue, 14 Jun 2016 14:29:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mathias Krause <minipli@googlemail.com> wrote:
> The GFP_DMA flag is obviously misunderstood in the mwifiex driver. It's
> meant for legacy ISA DMA memory mappings only -- the lower 16MB on x86.
> That doesn't apply to PCIe or SDIO devices, I guess.
> 
> Remove the GFP_DMA flag to reduce the need to place the socket buffer
> allocation into the low mem DMA area, which might already be in use by
> other drivers.
> 
> This misuse was flagged by the PaX USERCOPY feature by chance, as it
> detected the user copy operation from a DMA buffer in the recvfrom()
> syscall path.
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> Tested-by: Dennis Wassenberg <dennis.wassenberg@secunet.com>
> Cc: Amitkumar Karwar <akarwar@marvell.com>
> Cc: Nishant Sarmukadam <nishants@marvell.com>
> Cc: Xinming Hu <huxm@marvell.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Brad Spengler <spender@grsecurity.net>
> Cc: PaX Team <pageexec@freemail.hu>
> Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

5c87a55adbd5 mwifiex: remove misleading GFP_DMA flag in buffer allocations

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9130575/

