Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34023 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbcGSSOi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 14:14:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/4] brcmfmac: Fix glob_skb leak in brcmf_sdiod_recv_chain
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1468884277-18606-2-git-send-email-f.fainelli@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: brcm80211-dev-list.pdl@broadcom.com,
	linux-wireless@vger.kernel.org, pieterpg@broadcom.com,
	arend.vanspriel@broadcom.com, hante.meuleman@broadcom.com,
	Florian Fainelli <f.fainelli@gmail.com>
Message-Id: <20160719181437.D7C456037B@smtp.codeaurora.org> (sfid-20160719_201441_882930_7892B0E5)
Date: Tue, 19 Jul 2016 18:14:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Florian Fainelli <f.fainelli@gmail.com> wrote:
> In case brcmf_sdiod_recv_chain() cannot complete a succeful call to
> brcmf_sdiod_buffrw, we would be leaking glom_skb and not free it as we
> should, fix this.
> 
> Reported-by: coverity (CID 1164856)
> Fixes: a413e39a38573 ("brcmfmac: fix brcmf_sdcard_recv_chain() for host without sg support")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Thanks, 3 patches applied to wireless-drivers-next.git:

3bdae810721b brcmfmac: Fix glob_skb leak in brcmf_sdiod_recv_chain
5c5fa1f464ac brcmsmac: Free packet if dma_mapping_error() fails in dma_rxfill
f823a2aa8f46 brcmsmac: Initialize power in brcms_c_stf_ss_algo_channel_get()

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9235673/

