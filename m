Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55812 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdJBOH4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Oct 2017 10:07:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V3,1/3] brcmfmac: Avoid possible out-of-bounds read
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170917040824.22237-1-cernekee@chromium.org>
References: <20170917040824.22237-1-cernekee@chromium.org>
To: Kevin Cernekee <cernekee@chromium.org>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
Message-Id: <20171002140756.7086460B72@smtp.codeaurora.org> (sfid-20171002_160800_473903_0B6A2AE6)
Date: Mon,  2 Oct 2017 14:07:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kevin Cernekee <cernekee@chromium.org> wrote:

> In brcmf_p2p_notify_rx_mgmt_p2p_probereq(), chanspec is assigned before
> the length of rxframe is validated.  This could lead to uninitialized
> data being accessed (but not printed).  Since we already have a
> perfectly good endian-swapped copy of rxframe->chanspec in ch.chspec,
> and ch.chspec is not modified by decchspec(), avoid the extra
> assignment and use ch.chspec in the debug print.
> 
> Suggested-by: Mattias Nissler <mnissler@chromium.org>
> Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

2 patches applied to wireless-drivers-next.git, thanks.

73f2c8e933b1 brcmfmac: Avoid possible out-of-bounds read
a7c9acc452b2 brcmfmac: Delete redundant length check

-- 
https://patchwork.kernel.org/patch/9954603/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
