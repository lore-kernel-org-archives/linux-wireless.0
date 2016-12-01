Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36440 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755909AbcLAKaF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 05:30:05 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: feed only active spectral / dfs-detector
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1479812709-18875-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1479812709-18875-1-git-send-email-zefir.kurtisi@neratec.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
CC: <linux-wireless@vger.kernel.org>, <michal.kazior@tieto.com>,
        <benjamin@sipsolutions.net>
Message-ID: <b1143d3a8f804030a30e0470e7e02dff@euamsexm01a.eu.qualcomm.com> (sfid-20161201_113016_321429_9133D512)
Date: Thu, 1 Dec 2016 11:29:54 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> Radar pulse and spectral scan reports are provided by the HW
> with the ATH9K_RXERR_PHY flag set. Those are forwarded to
> the dfs-detector and spectral module for further processing.
> 
> For some older chips, the pre-conditions checked in those
> modules are ambiguous, since ATH9K_PHYERR_RADAR is used to
> tag both types. As a result, spectral frames are fed into
> the dfs-detector and vice versa.
> 
> This could lead to a false radar detection on a non-DFS
> channel (which is uncritical), but more relevant it causes
> useless CPU load for processing invalid frames.
> 
> This commit ensures that the dfs-detector and spectral
> collector are only fed when they are active.
> 
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>

Patch applied to ath-next branch of ath.git, thanks.

87fedb974e0c ath9k: feed only active spectral / dfs-detector

-- 
https://patchwork.kernel.org/patch/9440817/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
