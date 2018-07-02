Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55642 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752326AbeGBOXU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jul 2018 10:23:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] ath10k: sdio: use same endpoint id for all packets in a
 bundle
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180620084222.3521-2-niklas.cassel@linaro.org>
References: <20180620084222.3521-2-niklas.cassel@linaro.org>
To: Niklas Cassel <niklas.cassel@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        alagusankar@silex-india.com,
        Niklas Cassel <niklas.cassel@linaro.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180702142319.E93FC6037C@smtp.codeaurora.org> (sfid-20180702_162337_317306_1B155F26)
Date: Mon,  2 Jul 2018 14:23:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Niklas Cassel <niklas.cassel@linaro.org> wrote:

> All packets in a bundle should use the same endpoint id as the
> first lookahead.
> 
> This matches how things are done is ath6kl, however,
> this patch can theoretically handle several bundles
> in ath10k_sdio_mbox_rx_process_packets().
> 
> Without this patch we get lots of errors about invalid endpoint id:
> 
> ath10k_sdio mmc2:0001:1: invalid endpoint in look-ahead: 224
> ath10k_sdio mmc2:0001:1: failed to get pending recv messages: -12
> ath10k_sdio mmc2:0001:1: failed to process pending SDIO interrupts: -12
> 
> Co-Developed-by: Niklas Cassel <niklas.cassel@linaro.org>
> Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

3 patches applied to ath-next branch of ath.git, thanks.

679e1f07c862 ath10k: sdio: use same endpoint id for all packets in a bundle
d1d061b1395a ath10k: sdio: allocate correct size for RECV_1MORE_BLOCK rx packets
8530b4e7b22b ath10k: sdio: set skb len for all rx packets

-- 
https://patchwork.kernel.org/patch/10476637/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
