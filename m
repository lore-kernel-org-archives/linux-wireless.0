Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61318 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab1IMJot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 05:44:49 -0400
Date: Tue, 13 Sep 2011 15:14:49 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] ath6kl: Fix random reconnect failures
Message-ID: <20110913094448.GA8296@vasanth-laptop> (sfid-20110913_114506_208209_A25F7C68)
References: <1315648597-17999-1-git-send-email-vthiagar@qca.qualcomm.com>
 <1315648597-17999-4-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1315648597-17999-4-git-send-email-vthiagar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 10, 2011 at 03:26:37PM +0530, Vasanthakumar Thiagarajan wrote:
> Sometimes connect events are received after disconnect
> events from target, this puts host and target in different
> states. When receiving a connect event in a wrong state,
> make sure to send disconnect event to target to maintain
> state consistency.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> index 0ad458b..2e4bea3 100644
> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -460,6 +460,14 @@ void ath6kl_cfg80211_connect_event(struct ath6kl *ar, u16 channel,
>  				   "%s: ath6k not in station mode\n", __func__);
>  			return;
>  		}
> +
> +		if ((ar->sme_state != SME_CONNECTING) &&
> +		    (ar->sme_state != SME_CONNECTED)) {
> +			ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
> +				   "Connect event at inappropriate state, sending disconnect cmd\n");
> +			ath6kl_wmi_disconnect_cmd(ar->wmi);
> +			return;
> +		}

Please hold on this patch, it seems to introduce regression when
testing with different APs.

Vasanth
