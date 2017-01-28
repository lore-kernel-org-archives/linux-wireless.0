Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54522 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbdA1HKa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Jan 2017 02:10:30 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] mwifiex: mwifiex_unmap_pci_memory() handling for sleep
 confirm
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1485264945-1248-1-git-send-email-akarwar@marvell.com>
References: <1485264945-1248-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20170128071029.EC89D60A5F@smtp.codeaurora.org> (sfid-20170128_081203_275200_94E50590)
Date: Sat, 28 Jan 2017 07:10:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> Sleep confirm is a special command for which "adapter->cur_cmd" pointer
> is not set. When it's response is received, host writes SLEEP confirm done
> to a register. Firmware will perform DMA for writing sleep cookie signature
> on same buffer after this.
> 
> Let's not immediately call mwifiex_unmap_pci_memory() for this special
> command. Unmapping will be done when firmware completes writing sleep
> cookie signature.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

2 patches applied to wireless-drivers-next.git, thanks.

3e66849865ed mwifiex: mwifiex_unmap_pci_memory() handling for sleep confirm
cc37d8efd2ba mwifiex: use pci_dma_sync_single* APIs

-- 
https://patchwork.kernel.org/patch/9535189/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
