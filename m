Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50258 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752804AbeF2Ltg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 07:49:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Niklas Cassel <niklas.cassel@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        alagusankar@silex-india.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 1/3] ath10k: sdio: use same endpoint id for all packets in a bundle
References: <20180620084222.3521-1-niklas.cassel@linaro.org>
        <20180620084222.3521-2-niklas.cassel@linaro.org>
Date: Fri, 29 Jun 2018 14:49:29 +0300
In-Reply-To: <20180620084222.3521-2-niklas.cassel@linaro.org> (Niklas Cassel's
        message of "Wed, 20 Jun 2018 10:42:20 +0200")
Message-ID: <87zhzdersm.fsf@codeaurora.org> (sfid-20180629_134955_968313_5A1A8158)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Niklas Cassel <niklas.cassel@linaro.org> writes:

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
> Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>

You have Alagu's s-o-b first so that implies Alagu is the author. So
should I add From header for Alagu and add you (Niklas) as
Co-Developed-by? Or vice versa?

-- 
Kalle Valo
