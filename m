Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47190 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751152AbcKSHTp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Nov 2016 02:19:45 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v4,
 01/11] mwifiex: check tx_hw_pending before downloading sleep confirm
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1479477634-27841-1-git-send-email-akarwar@marvell.com>
References: <1479477634-27841-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Shengzhen Li <szli@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20161119071944.C049C614C3@smtp.codeaurora.org> (sfid-20161119_081949_456949_C37A7322)
Date: Sat, 19 Nov 2016 07:19:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Shengzhen Li <szli@marvell.com>
> 
> We may get SLEEP event from firmware even if TXDone interrupt
> for last Tx packet is still pending. In this case, we may
> end up accessing PCIe memory for handling TXDone after power
> save handshake is completed. This causes kernel crash with
> external abort.
> 
> This patch will only allow downloading sleep confirm
> when no tx done interrupt is pending in the hardware.
> 
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Shengzhen Li <szli@marvell.com>
> Tested-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

11 patches applied to wireless-drivers-next.git, thanks.

eb2428fb1a21 mwifiex: check tx_hw_pending before downloading sleep confirm
6712076883ca mwifiex: complete blocked power save handshake in main process
4a79aa17d53e mwifiex: resolve races between async FW init (failure) and device removal
a1beec4b2c6f mwifiex: remove redundant pdev check in suspend/resume handlers
7ccdf72f9128 mwifiex: don't pretend to resume while remove()'ing
b42dbb27e326 mwifiex: resolve suspend() race with async FW init failure
bcf28a2f2846 mwifiex: reset card->adapter during device unregister
58b7033551cd mwifiex: usb: handle HS failures
6caf34cb3a92 mwifiex: sdio: don't check for NULL sdio_func
e98fb11ffa0a mwifiex: stop checking for NULL drvata/intfdata
97489c284d9f mwifiex: pcie: stop checking for NULL adapter->card

-- 
https://patchwork.kernel.org/patch/9436513/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
