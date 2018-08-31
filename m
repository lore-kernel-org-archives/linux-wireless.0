Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53442 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbeHaQhJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 12:37:09 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Anilkumar Kolli <akolli@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgen?= =?utf-8?Q?sen?=
        <toke@toke.dk>
Subject: Re: [RFC v2] ath10k: report tx rate using ieee80211_tx_status()
References: <1524291786-30850-1-git-send-email-akolli@codeaurora.org>
Date: Fri, 31 Aug 2018 15:29:47 +0300
In-Reply-To: <1524291786-30850-1-git-send-email-akolli@codeaurora.org>
        (Anilkumar Kolli's message of "Sat, 21 Apr 2018 11:53:06 +0530")
Message-ID: <87k1o6d8hw.fsf@kamboji.qca.qualcomm.com> (sfid-20180831_142955_425344_46F7955C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anilkumar Kolli <akolli@codeaurora.org> writes:

> Mesh path metric needs txrate information from ieee80211_tx_status()
> call but in ath10k there is no mechanism to report tx rate information
> via ieee80211_tx_status(), the rate is only accessible via
> sta_statiscs() op.
>
> Per peer stats has tx rate info available, this patch stores per peer
> last tx rate and updates the tx rate info structures in tx completition.
> The rate updated in ieee80211_tx_status() is not exactly for the last
> transmitted frame instead the rate is from one of the previous frames.
>
> Per peer txrate information is updated through per peer statistics
> and is available for QCA9888/QCA9984/QCA4019/QCA998X only
>
> Tested on QCA9984 with firmware-5.bin_10.4-3.5.3-00053
> Tested on QCA998X with firmware-5.bin_10.2.4-1.0-00036
>
> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>

This is a patch from last March, full patch here:

https://patchwork.kernel.org/patch/10267693/

> @@ -119,6 +122,18 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
>  			info->flags &= ~IEEE80211_TX_STAT_ACK;
>  	}
>  
> +	if (sta) {
> +		spin_lock_bh(&ar->data_lock);
> +		arsta = (struct ath10k_sta *)sta->drv_priv;
> +		info->status.rates[0].idx =
> +			arsta->tx_info.status.rates[0].idx;
> +		info->status.rates[0].count =
> +			arsta->tx_info.status.rates[0].count;
> +		info->status.rates[0].flags =
<> +			arsta->tx_info.status.rates[0].flags;
> +		spin_unlock_bh(&ar->data_lock);
> +	}
> +
>  	ieee80211_tx_status(htt->ar->hw, msdu);
>  	/* we do not own the msdu anymore */

"is not exactly" is IMHO an understatement. What it means that with this
patch ath10k reports the rate information from another frame instead of
the current skb, because the firmware provides the rate information "out
of band". A simple example to clarify:

   Let's say ath10k transmits frames A, B and C. Then ath10k calls
   ieee80211_tx_status() for frame C the rate information could be for
   frame A, or it could be the other around for frame A status the rate
   information is from frame C.

In other words, there's no guarantee from what frame the rate
information is from.

Too me this feels like a bad idea but I'm not familiar enough with
mac80211 to really comment on this. What kind of implications does this
have for Mesh or ATF, for example? Adding Johannes and Toke to hear
about their opinion about this.

-- 
Kalle Valo
