Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49526 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751466AbdF0OJm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 10:09:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        James Hughes <james.hughes@raspberrypi.org>
Subject: Re: [PATCH 3/4] brcmfmac: rework headroom check in .start_xmit()
References: <1498125664-25980-1-git-send-email-arend.vanspriel@broadcom.com>
        <1498125664-25980-4-git-send-email-arend.vanspriel@broadcom.com>
Date: Tue, 27 Jun 2017 17:09:38 +0300
In-Reply-To: <1498125664-25980-4-git-send-email-arend.vanspriel@broadcom.com>
        (Arend van Spriel's message of "Thu, 22 Jun 2017 11:01:03 +0100")
Message-ID: <874lv15xp9.fsf@purkki.adurom.net> (sfid-20170627_160945_854822_DD317FF3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> Since commit 9cc4b7cb86cb ("brcmfmac: Make skb header writable
> before use") the headroom usage has been fixed. However, the
> driver was keeping statistics that got lost. So reworking the
> code so we get those driver statistics back for debugging.
>
> Cc: James Hughes <james.hughes@raspberrypi.org>
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h | 15 ++++++++++++--
>  .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 23 +++++++++++++++-------
>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 13 +++++++-----
>  3 files changed, 37 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> index e1a4d9e..163ddc4 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> @@ -113,6 +113,17 @@ struct brcmf_bus_msgbuf {
>  
>  
>  /**
> + * struct brcmf_bus_stats - bus statistic counters.
> + *
> + * @pktcowed: packets cowed for extra headroom/unorphan.
> + * @pktcow_failed: packets dropped due to failed cow-ing.
> + */
> +struct brcmf_bus_stats {
> +	atomic_t pktcowed;
> +	atomic_t pktcow_failed;
> +};

Same question as in the previous patch. I only see updates for these
variables, but nobody reading them?

-- 
Kalle Valo
