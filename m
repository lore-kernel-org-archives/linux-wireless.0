Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52908 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751503AbcLAKfs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 05:35:48 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
        <mohammed@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "mohammed@codeaurora.org" <mohammed@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: Fix soft lockup during firmware
 crash/hw-restart
Date: Thu, 1 Dec 2016 10:35:38 +0000
Message-ID: <87inr4rl6t.fsf@kamboji.qca.qualcomm.com> (sfid-20161201_113551_534585_4C07F663)
References: <1480483769-17693-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1480483769-17693-1-git-send-email-mohammed@qca.qualcomm.com>
        (Mohammed Shafi Shajakhan's message of "Wed, 30 Nov 2016 10:59:29       +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> During firmware crash (or) user requested manual restart
> the system gets into a soft lock up state because of the
> below root cause.
>
> During user requested hardware restart / firmware crash
> the system goes into a soft lockup state as 'napi_synchronize'
> is called after 'napi_disable' (which sets 'NAPI_STATE_SCHED'
> bit) and it sleeps into infinite loop as it waits for
> 'NAPI_STATE_SCHED' to be cleared. This condition is hit because
> 'ath10k_hif_stop' is called twice as below (resulting in calling
> 'napi_synchronize' after 'napi_disable')
>
> 'ath10k_core_restart' -> 'ath10k_hif_stop' (ATH10K_STATE_ON) ->
> -> 'ieee80211_restart_hw' -> 'ath10k_start' -> 'ath10k_halt' ->
> 'ath10k_core_stop' -> 'ath10k_hif_stop' (ATH10K_STATE_RESTARTING)
>
> Fix this by calling 'ath10k_halt' in ath10k_core_restart itself
> as it makes more sense before informing mac80211 to restart h/w
> Also remove 'ath10k_halt' in ath10k_start for the state of 'restarting'
>
> Fixes: 3c97f5de1f28 ("ath10k: implement NAPI support")
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> ---
> [v2 Added Fixes ]

I'll also add:

Cc: <stable@vger.kernel.org> # v4.9

--=20
Kalle Valo=
