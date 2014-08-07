Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:19122 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbaHGJaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 05:30:19 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 5/5] ath10k: flush hif buffers before recovery
References: <1407402308-29899-1-git-send-email-michal.kazior@tieto.com>
	<1407402308-29899-6-git-send-email-michal.kazior@tieto.com>
Date: Thu, 7 Aug 2014 12:30:07 +0300
In-Reply-To: <1407402308-29899-6-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 7 Aug 2014 11:05:08 +0200")
Message-ID: <8738d84pgg.fsf@kamboji.qca.qualcomm.com> (sfid-20140807_113024_724264_E2B88694)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Transport buffers weren't flushed and processed
> before queueing hw recovery request to mac80211.
>
> This could in theory result in an unwanted htt/wmi
> rx events being processed while mac80211 recovers
> the device and possibly interfere or even crash
> the system.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

This one had a conflict in ath-next-test, I changed the patch to this:

--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -666,6 +666,7 @@ static void ath10k_core_restart(struct work_struct *work)
        case ATH10K_STATE_ON:
                ar->state = ATH10K_STATE_RESTARTING;
                ath10k_scan_finish(ar);
+               ath10k_hif_stop(ar);
                ieee80211_restart_hw(ar->hw);
                break;
        case ATH10K_STATE_OFF:

-- 
Kalle Valo
