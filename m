Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37194 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750844AbeCNJwv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 05:52:51 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: dma unmap mgmt tx buffer if wmi cmd send fails
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1518169330-4934-1-git-send-email-pillair@codeaurora.org>
References: <1518169330-4934-1-git-send-email-pillair@codeaurora.org>
To: Rakesh Pillai <pillair@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Message-Id: <20180314095251.004B460300@smtp.codeaurora.org> (sfid-20180314_105255_222563_3C3B7C68)
Date: Wed, 14 Mar 2018 09:52:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rakesh Pillai <pillair@codeaurora.org> wrote:

> WCN3990 sends mgmt frames by reference via WMI.
> The host dma maps the mgmt frame and sends the physical
> address to the firmware in the wmi command. Since the
> dma mapping is done in the gen_mgmt_tx and if the wmi
> command send fails, the corresponding mgmt frame is
> not being dma unmapped.
> 
> Fix the missing dma unmapping of mgmt tx frame when
> wmi command sending fails for mgmt tx by reference
> via WMI. The already exisiting mgmt tx using copy by
> value does not need such dma unmapping.
> Add a separate wmi-tlv op for mgmt tx via ref, which
> takes care of unmapping the dma address, in case of
> wmi command sending failure.
> 
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

38a1390e02b7 ath10k: dma unmap mgmt tx buffer if wmi cmd send fails

-- 
https://patchwork.kernel.org/patch/10208681/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
