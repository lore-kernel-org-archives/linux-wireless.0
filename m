Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28928 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751501AbcLALNo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 06:13:44 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: Fix soft lockup during firmware crash/hw-restart
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1480483769-17693-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1480483769-17693-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <f957e5d085a347b59d9eae0d2c794d1e@euamsexm01a.eu.qualcomm.com> (sfid-20161201_121347_440727_DC841C25)
Date: Thu, 1 Dec 2016 12:13:36 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
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

Patch applied to ath-next branch of ath.git, thanks.

c2cac2f74ab4 ath10k: fix soft lockup during firmware crash/hw-restart

-- 
https://patchwork.kernel.org/patch/9453609/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
