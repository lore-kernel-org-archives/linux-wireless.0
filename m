Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46202 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754967AbeFNPKJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 11:10:09 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix spectral scan for QCA9984 and QCA9888 chipsets
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1527593473-15976-1-git-send-email-periyasa@codeaurora.org>
References: <1527593473-15976-1-git-send-email-periyasa@codeaurora.org>
To: Karthikeyan Periyasamy <periyasa@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Karthikeyan Periyasamy <periyasa@codeaurora.org>
Message-Id: <20180614151008.8DD14602D7@smtp.codeaurora.org> (sfid-20180614_171012_599247_564612A5)
Date: Thu, 14 Jun 2018 15:10:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Karthikeyan Periyasamy <periyasa@codeaurora.org> wrote:

> The spectral scan has been always broken on QCA9984 and QCA9888.
> 
> Introduce a hardware parameter 'spectral_bin_offset' to resolve this issue for
> QCA9984 and QCA9888 chipsets. For other chipsets, the hardware parameter
> 'spectral_bin_offset' is zero so that existing behaviour is retained as it is.
> 
> In QCA9984 and QCA9888 chipsets, hardware param value 'spectral_bin_discard'
> is 12 bytes. This 12 bytes is derived as the sum of segment index (4 bytes),
> extra bins before the actual data (4 bytes) and extra bins after the actual
> data (4 bytes). Always discarding (12 bytes) happens at end of the samples and
> incorrect samples got dumped, so that user can find incorrect arrangement
> samples in spectral scan dump.
> 
> To fix this issue, we have to discard first 8 bytes and last 4 bytes in every
> samples, so totally 12 bytes are discarded. In every sample we need to consider
> the offset while taking the actual spectral data. For QCA9984, QCA9888 the
> offset is 8 bytes (segment index + extra bins before actual data).
> 
> Hardware tested: QCA9984 and QCA9888
> Firmware tested: 10.4-3.5.3-00053
> 
> Signed-off-by: Karthikeyan Periyasamy <periyasa@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

2e9bcd0d7324 ath10k: fix spectral scan for QCA9984 and QCA9888 chipsets

-- 
https://patchwork.kernel.org/patch/10435029/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
