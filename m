Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44708 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752656AbdFMHA3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 03:00:29 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V3] brcmfmac: Fix glom_skb leak in brcmf_sdiod_recv_chain
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1497264382-2290-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1497264382-2290-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, "Peter S. Housel" <housel@acm.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20170613070028.5F9CB606DC@smtp.codeaurora.org> (sfid-20170613_090332_972319_8A16C1A1)
Date: Tue, 13 Jun 2017 07:00:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> From: "Peter S. Housel" <housel@acm.org>
> 
> An earlier change to this function (3bdae810721b) fixed a leak in the
> case of an unsuccessful call to brcmf_sdiod_buffrw(). However, the
> glom_skb buffer, used for emulating a scattering read, is never used
> or referenced after its contents are copied into the destination
> buffers, and therefore always needs to be freed by the end of the
> function.
> 
> Fixes: 3bdae810721b ("brcmfmac: Fix glob_skb leak in brcmf_sdiod_recv_chain")
> Fixes: a413e39a38573 ("brcmfmac: fix brcmf_sdcard_recv_chain() for host without sg support")
> Cc: stable@vger.kernel.org # 4.9.x-
> Signed-off-by: Peter S. Housel <housel@acm.org>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

5ea59db8a375 brcmfmac: Fix glom_skb leak in brcmf_sdiod_recv_chain

-- 
https://patchwork.kernel.org/patch/9780735/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
