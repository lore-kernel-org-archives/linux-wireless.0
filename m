Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39934 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbcK3GKr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Nov 2016 01:10:47 -0500
Date: Wed, 30 Nov 2016 11:40:36 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: ath10k: Fix soft lockup during firmware crash/hw-restart
Message-ID: <20161130053610.GA3044@atheros-ThinkPad-T61> (sfid-20161130_071051_129212_DA1E2D15)
References: <1480430762-15995-1-git-send-email-mohammed@qca.qualcomm.com>
 <ecb7e9d7-34c5-4ea8-62a9-b5b96409bb0b@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ecb7e9d7-34c5-4ea8-62a9-b5b96409bb0b@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 29, 2016 at 04:43:48PM -0800, Ben Greear wrote:
> I have not seen this hang since adding this patch, so
> hopefully it has resolved the problem.

thanks Ben ! I had updated the commit log with Fixes tag
https://patchwork.kernel.org/patch/9453609/

> 
> On 11/29/2016 06:46 AM, Mohammed Shafi Shajakhan wrote:
> >From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> >
> >During firmware crash (or) user requested manual restart
> >the system gets into a soft lock up state because of the
> >below root cause.
> >
> >During user requested hardware restart / firmware crash
> >the system goes into a soft lockup state as 'napi_synchronize'
> >is called after 'napi_disable' (which sets 'NAPI_STATE_SCHED'
> >bit) and it sleeps into infinite loop as it waits for
> >'NAPI_STATE_SCHED' to be cleared. This condition is hit because
> >'ath10k_hif_stop' is called twice as below (resulting in calling
> >'napi_synchronize' after 'napi_disable')
> >
> >'ath10k_core_restart' -> 'ath10k_hif_stop' (ATH10K_STATE_ON) ->
> >-> 'ieee80211_restart_hw' -> 'ath10k_start' -> 'ath10k_halt' ->
> >'ath10k_core_stop' -> 'ath10k_hif_stop' (ATH10K_STATE_RESTARTING)
> >
> >Fix this by calling 'ath10k_halt' in ath10k_core_restart itself
> >as it makes more sense before informing mac80211 to restart h/w
> >Also remove 'ath10k_halt' in ath10k_start for the state of 'restarting'
> >
> >Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> >---
> >[thanks to Kalle and Michal for their inputs]
> >
> > drivers/net/wireless/ath/ath10k/core.c | 2 +-
> > drivers/net/wireless/ath/ath10k/mac.c  | 1 -
> > 2 files changed, 1 insertion(+), 2 deletions(-)
> >
> >diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> >index 7005e2a..5bc6847 100644
> >--- a/drivers/net/wireless/ath/ath10k/core.c
> >+++ b/drivers/net/wireless/ath/ath10k/core.c
> >@@ -1536,7 +1536,7 @@ static void ath10k_core_restart(struct work_struct *work)
> > 	switch (ar->state) {
> > 	case ATH10K_STATE_ON:
> > 		ar->state = ATH10K_STATE_RESTARTING;
> >-		ath10k_hif_stop(ar);
> >+		ath10k_halt(ar);
> > 		ath10k_scan_finish(ar);
> > 		ieee80211_restart_hw(ar->hw);
> > 		break;
> >diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> >index 717b2fa..481842b 100644
> >--- a/drivers/net/wireless/ath/ath10k/mac.c
> >+++ b/drivers/net/wireless/ath/ath10k/mac.c
> >@@ -4449,7 +4449,6 @@ static int ath10k_start(struct ieee80211_hw *hw)
> > 		ar->state = ATH10K_STATE_ON;
> > 		break;
> > 	case ATH10K_STATE_RESTARTING:
> >-		ath10k_halt(ar);
> > 		ar->state = ATH10K_STATE_RESTARTED;
> > 		break;
> > 	case ATH10K_STATE_ON:
> >
> 
> 
> -- 
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
> 
