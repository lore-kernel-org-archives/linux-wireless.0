Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55354 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbeH1ReH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 13:34:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] ath10k: schedule hardware restart if WMI command times out
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180822073952.30922-1-martin@strongswan.org>
References: <20180822073952.30922-1-martin@strongswan.org>
To: Martin Willi <martin@strongswan.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20180828134224.849BB60452@smtp.codeaurora.org> (sfid-20180828_154227_423098_5395A15E)
Date: Tue, 28 Aug 2018 13:42:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin Willi <martin@strongswan.org> wrote:

> When running in AP mode, ath10k sometimes suffers from TX credit
> starvation. The issue is hard to reproduce and shows up once in a
> few days, but has been repeatedly seen with QCA9882 and a large
> range of firmwares, including 10.2.4.70.67.
> 
> Once the module is in this state, TX credits are never replenished,
> which results in "SWBA overrun" errors, as no beacons can be sent.
> Even worse, WMI commands run in a timeout while holding the conf
> mutex for three seconds each, making any further operations slow
> and the whole system unresponsive.
> 
> The firmware/driver never recovers from that state automatically,
> and triggering TX flush or warm restarts won't work over WMI. So
> issue a hardware restart if a WMI command times out due to missing
> TX credits. This implies a connectivity outage of about 1.4s in AP
> mode, but brings back the interface and the whole system to a usable
> state. WMI command timeouts have not been seen in absent of this
> specific issue, so taking such drastic actions seems legitimate.
> 
> Signed-off-by: Martin Willi <martin@strongswan.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

a9911937e7d3 ath10k: schedule hardware restart if WMI command times out

-- 
https://patchwork.kernel.org/patch/10572645/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
