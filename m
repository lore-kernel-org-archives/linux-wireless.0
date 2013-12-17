Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:40890 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab3LQQCz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 11:02:55 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Karl Beldan <karl.beldan@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH v4] mac80211_hwsim: claim CSA support for AP
References: <1385224698-12294-1-git-send-email-karl.beldan@gmail.com>
Date: Tue, 17 Dec 2013 18:01:00 +0200
In-Reply-To: <1385224698-12294-1-git-send-email-karl.beldan@gmail.com> (Karl
	Beldan's message of "Sat, 23 Nov 2013 17:38:18 +0100")
Message-ID: <874n67eabn.fsf@kamboji.qca.qualcomm.com> (sfid-20131217_170258_771984_C6A9D4E9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Karl Beldan <karl.beldan@gmail.com> writes:

> From: Karl Beldan <karl.beldan@rivierawaves.com>
>
> This assigns the channel_switch_beacon op.
> For hwsim, it comes down to calling ieee80211_csa_finish once
> ieee80211_csa_is_complete is true.
> Since channel_switch_beacon is not called if CSA count starts @ 0 or 1,
> the check for ieee80211_csa_is_complete can be done after getting the
> beacon (and this way it might trigger helpful warnings).
>
> This adds a per vif bool csa_finished that is set after a call to
> ieee80211_csa_finish() and used to skip beaconing while csa_active is
> set in case a beacon is scheduled prior to csa_finalize_work completion.
> This bool and the number of beacons transmitted during the CSA up to the
> call to ieee80211_csa_finish() are reset in channel_switch_beacon op.
>
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>

What are we going to do with this patch? It would be convenient to get
hwsim support CSA as it would help working with DFS issues.

Was the issue blocking this patch the race when transmitting beacons?
IMHO we can live with that and fix it properly later. It's not the only
bug in DFS code right now ;)

> @@ -1058,6 +1067,17 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
>  
>  	mac80211_hwsim_tx_frame(hw, skb,
>  				rcu_dereference(vif->chanctx_conf)->def.chan);
> +
> +	if (vif->csa_active) {
> +		vp->csa_bcn_cnt++;
> +		if (ieee80211_csa_is_complete(vif)) {
> +			wiphy_debug(hw->wiphy,
> +				    "%s CSA complete after %d beacons\n",
> +				    __func__, vp->csa_bcn_cnt);
> +			ieee80211_csa_finish(vif);
> +			vp->csa_finished = 1;
> +		}
> +	}

csa_finished is a bool so 'true' should be used here.

-- 
Kalle Valo
