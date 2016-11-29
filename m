Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45232 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757116AbcK2P25 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 10:28:57 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: pcie: implement timeout loop for FW programming doorbell
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1479868785-16263-1-git-send-email-briannorris@chromium.org>
References: <1479868785-16263-1-git-send-email-briannorris@chromium.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Cathy Luo <cluo@marvell.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Brian Norris <briannorris@chromium.org>
Message-Id: <20161129152856.ECB9A612BA@smtp.codeaurora.org> (sfid-20161129_162901_056780_6CA374FD)
Date: Tue, 29 Nov 2016 15:28:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> wrote:
> Marvell Wifi PCIe modules don't always behave nicely for PCIe power
> management when their firmware hasn't been loaded, particularly after
> suspending the PCIe link one or more times. When this happens, we might
> end up spinning forever in this status-polling tight loop. Let's make
> this less tight by adding a timeout and by sleeping a bit in between
> reads, as we do with the other similar loops.
> 
> This prevents us from hogging a CPU even in such pathological cases, and
> allows the FW initialization to just fail gracefully instead.
> 
> I chose the same polling parameters as the earlier loop in this
> function, and empirically, I found that this loop never makes it more
> than about 12 cycles in a sane FW init sequence. I had no official
> information on the actual intended latency for this portion of the
> download.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

22dde1ed5a48 mwifiex: pcie: implement timeout loop for FW programming doorbell

-- 
https://patchwork.kernel.org/patch/9442499/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
