Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48180 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751128AbdJBNvt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Oct 2017 09:51:49 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V3,3/3] brcmfmac: Add check for short event packets
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170917040824.22237-3-cernekee@chromium.org>
References: <20170917040824.22237-3-cernekee@chromium.org>
To: Kevin Cernekee <cernekee@chromium.org>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
Message-Id: <20171002135149.08D0F607CE@smtp.codeaurora.org> (sfid-20171002_155152_987517_B9140368)
Date: Mon,  2 Oct 2017 13:51:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kevin Cernekee <cernekee@chromium.org> wrote:

> The length of the data in the received skb is currently passed into
> brcmf_fweh_process_event() as packet_len, but this value is not checked.
> event_packet should be followed by DATALEN bytes of additional event
> data.  Ensure that the received packet actually contains at least
> DATALEN bytes of additional data, to avoid copying uninitialized memory
> into event->data.
> 
> Cc: <stable@vger.kernel.org> # v3.8
> Suggested-by: Mattias Nissler <mnissler@chromium.org>
> Signed-off-by: Kevin Cernekee <cernekee@chromium.org>

Patch applied to wireless-drivers.git, thanks.

dd2349121bb1 brcmfmac: Add check for short event packets

-- 
https://patchwork.kernel.org/patch/9954607/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
