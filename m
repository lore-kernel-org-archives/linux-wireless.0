Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42720 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbdBOJCh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:02:37 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Doru <gucea.doru@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k_htc_fw@lists.infradead.org,
        andra.paraschiv7@gmail.com, costin.raiciu@cs.pub.ro,
        dragos.niculescu@cs.pub.ro
Subject: Re: [RFC-PATCH] ath9k_htc: Adjust beacon timers for Power Save
References: <1487100985-4194-1-git-send-email-gucea.doru@gmail.com>
Date: Wed, 15 Feb 2017 11:02:32 +0200
In-Reply-To: <1487100985-4194-1-git-send-email-gucea.doru@gmail.com> (Doru's
        message of "Tue, 14 Feb 2017 21:36:25 +0200")
Message-ID: <87r32z968n.fsf@purkki.adurom.net> (sfid-20170215_100538_699206_46F9F335)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Doru <gucea.doru@gmail.com> writes:

> From: Doru Gucea <gucea.doru@gmail.com>
>
> Each time we receive a beacon we need to adjust the hardware
> timers for next DTIM and next TBTT.
>
> Before this commit, the Power Save behaviour was incorrect.
> The scenario was:
> - STA receives a beacon from AP with TIM unset;
> - mac80211 layers puts the chip to sleep;
> - chip is woken up by mac80211's software timer reponsible for
> beacon miss after 7 * beacon_interval period.
>
> Normally the chip should sleep at most DTIM period. This commit
> configures hardware timers for waking up the chip correctly.
>
> More details on the wiki:
> https://github.com/doru91/linux-stable/wiki/Single-Interface-Power-Save
>
> Signed-off-by: Doru Gucea <gucea.doru@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c | 4 ++++
>  net/mac80211/mlme.c                           | 6 ++++++
>  2 files changed, 10 insertions(+)

[...]

> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -3536,6 +3536,12 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
>  			sdata->vif.bss_conf.sync_dtim_count = 0;
>  	}
>  
> +	/* trigger hardware timers adjustment
> +	 * this needs to be done before beacon filtering
> +	 */
> +	changed |= BSS_CHANGED_BEACON_INFO;
> +	ieee80211_bss_info_change_notify(sdata, changed);

You shouldn't mix driver and mac80211 changes in the same patch, I
suspect Johannes didn't even notice this change because of that. Create
a new patchset with two patches, one for ath9k and another for mac80211.

-- 
Kalle Valo
