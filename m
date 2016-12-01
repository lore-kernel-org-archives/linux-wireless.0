Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56078 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757054AbcLAGGm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 01:06:42 -0500
Date: Thu, 1 Dec 2016 11:36:31 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: ath10k: Fix soft lockup during firmware crash/hw-restart
Message-ID: <20161201060612.GA8611@atheros-ThinkPad-T61> (sfid-20161201_070645_597372_0C8B75E1)
References: <1480430762-15995-1-git-send-email-mohammed@qca.qualcomm.com>
 <1a44a3e9-3d67-30a5-0325-a65003ebe1fc@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1a44a3e9-3d67-30a5-0325-a65003ebe1fc@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 29, 2016 at 10:16:50AM -0800, Ben Greear wrote:
> Is this something for stable?  And if so, how far back should it be applied?

@Kalle,

[shafi] kindly suggest. If i am not wrong this is only needed for 4.9

> 
> I'll add this patch to my 4.9 tree and test it...
>

[shafi] thanks a lot Ben.

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
