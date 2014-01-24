Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:13555 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaAXIUk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 03:20:40 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: implement channel switching
References: <1390473506-15677-1-git-send-email-michal.kazior@tieto.com>
	<1390473506-15677-2-git-send-email-michal.kazior@tieto.com>
Date: Fri, 24 Jan 2014 10:20:34 +0200
In-Reply-To: <1390473506-15677-2-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 23 Jan 2014 11:38:25 +0100")
Message-ID: <87ob314wq5.fsf@kamboji.qca.qualcomm.com> (sfid-20140124_092043_839802_F584BD88)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Until now channel change wasn't propagating to FW
> directly because operational channel is abstracted
> by VDEVs and it wasn't really necessary since
> ath10k implements hwscan and hwroc.
>
> This effectively fixes STA CSA and allows for
> future AP-like CSA as well.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> @@ -2559,15 +2676,18 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
>  				 * this is never erased as we it for crypto key
>  				 * clearing; this is FW requirement
>  				 */
> -				memcpy(arvif->u.sta.bssid, info->bssid,
> -				       ETH_ALEN);
> +				memcpy(arvif->bssid, info->bssid, ETH_ALEN);
>  
>  				ath10k_dbg(ATH10K_DBG_MAC,
>  					   "mac vdev %d start %pM\n",
>  					   arvif->vdev_id, info->bssid);
>  
> -				/* FIXME: check return value */
>  				ret = ath10k_vdev_start(arvif);
> +				if (ret)
> +					ath10k_warn("failed to start vdev: %d\n",
> +						    ret);
> +				else
> +					arvif->is_started = true;
>  			}

I really don't like that if-else construct and I think it's just better
to bail out if an error happens, so I changed this to:

				ret = ath10k_vdev_start(arvif);
				if (ret) {
					ath10k_warn("failed to start vdev: %d\n",
						    ret);
					return;
				}

				arvif->is_started = true;

-- 
Kalle Valo
