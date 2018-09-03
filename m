Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57102 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbeICVSg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 17:18:36 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] ath10k: Add waiting htt tx complete before wow enable
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1535442443-22152-1-git-send-email-wgong@codeaurora.org>
References: <1535442443-22152-1-git-send-email-wgong@codeaurora.org>
To: Wen Gong <wgong@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20180903165738.A79FD607B9@smtp.codeaurora.org> (sfid-20180903_185752_797887_8DB712C0)
Date: Mon,  3 Sep 2018 16:57:34 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wen Gong <wgong@codeaurora.org> wrote:

> If there are some tx packets pending in firmware, and then system
> enters suspend, firmware will fail for wow enable. This will trigger
> mac80211 to stop ath10k and download firmware again, then it is
> non-wow suspend.
> 
> After add the waiting htt tx complete, then firmware will have some
> time window to send or flush the pending tx packets.
> 
> Tested with QCA6174 PCI with firmware
> WLAN.RM.4.4.1-00109-QCARMSWPZ-1, but this will also affect QCA9377 PCI.
> It's not a regression with new firmware releases.
> 
> Signed-off-by: Wen Gong <wgong@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

828853ac5826 ath10k: add waiting htt tx complete before wow enable

-- 
https://patchwork.kernel.org/patch/10578009/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
