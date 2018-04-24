Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43268 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755919AbeDXGHF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 02:07:05 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,
 1/5] wcn36xx: abort scan request when 'dequeued' indicator is sent
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180417132337.31720-2-daniel@zonque.org>
References: <20180417132337.31720-2-daniel@zonque.org>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        loic.poulain@linaro.org, rfried@codeaurora.org,
        bjorn.andersson@linaro.org, Daniel Mack <daniel@zonque.org>
Message-Id: <20180424060704.A92DC6071A@smtp.codeaurora.org> (sfid-20180424_080708_733657_18D31859)
Date: Tue, 24 Apr 2018 06:07:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Mack <daniel@zonque.org> wrote:

> When the firmware sends a WCN36XX_HAL_SCAN_IND_DEQUEUED indication,
> the request is apparently no longer valid. Attempts to stop the hardware
> scan request subsequently will lead to the following error message, and
> the hardware is no longer able to communicate with any AP:
> 
> [   57.917186] wcn36xx: ERROR hal_stop_scan_offload response failed err=5
> 
> Interpreting this indicator message as scan abortion fixes this.
> 
> While at it, add a newline to a debug print.
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

5 patches applied to ath-next branch of ath.git, thanks.

14ca3c98aa12 wcn36xx: abort scan request when 'dequeued' indicator is sent
80c764d32122 wcn36xx: cancel pending scan request when interface goes down
89722f5767ac wcn36xx: handle scan cancellation when firmware support is missing
5a425c8b78e5 wcn36xx: send bss_type in scan requests
4836ec42b074 wcn36xx: pass information elements in scan requests

-- 
https://patchwork.kernel.org/patch/10345025/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
