Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6664 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab2EPVGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 17:06:48 -0400
Date: Wed, 16 May 2012 14:06:42 -0700
From: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: issue wmi disconnect after notifying cfg80211
Message-ID: <20120516210642.GA4203@pista> (sfid-20120516_230652_674062_875EB66B)
References: <1337200873-3698-1-git-send-email-c_tpeder@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1337200873-3698-1-git-send-email-c_tpeder@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 16, 2012 at 01:41:13PM -0700, Thomas Pedersen wrote:
> ath6kl would issue a wmi disconnect command in response to a remote
> disconnect and return early without notifying cfg80211, only sending a
> cfg80211_disconnected (with reason code always 3) in response to the
> second disconnect firmware event.
> 
> Pass the right reason code to cfg80211 on the first disconnect instead.

This fixes at least one bug where a p2p client would stop trying to
connect after receiving a stale RSN deauth which was reported to
cfg80211 as GO leaving BSS.

> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/cfg80211.c |   27 ++++++++++++---------------
>  1 files changed, 12 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> index f3a6cfc..7845d33 100644
> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -860,20 +860,6 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
>  		}
>  	}
>  
> -	/*
> -	 * Send a disconnect command to target when a disconnect event is
> -	 * received with reason code other than 3 (DISCONNECT_CMD - disconnect
> -	 * request from host) to make the firmware stop trying to connect even
> -	 * after giving disconnect event. There will be one more disconnect
> -	 * event for this disconnect command with reason code DISCONNECT_CMD
> -	 * which will be notified to cfg80211.
> -	 */
> -
> -	if (reason != DISCONNECT_CMD) {
> -		ath6kl_wmi_disconnect_cmd(ar->wmi, vif->fw_vif_idx);
> -		return;
> -	}
> -
>  	clear_bit(CONNECT_PEND, &vif->flags);
>  
>  	if (vif->sme_state == SME_CONNECTING) {
> @@ -883,11 +869,22 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
>  					WLAN_STATUS_UNSPECIFIED_FAILURE,
>  					GFP_KERNEL);
>  	} else if (vif->sme_state == SME_CONNECTED) {
> -		cfg80211_disconnected(vif->ndev, reason,
> +		cfg80211_disconnected(vif->ndev, proto_reason,
>  				      NULL, 0, GFP_KERNEL);
>  	}
>  
>  	vif->sme_state = SME_DISCONNECTED;
> +
> +	/*
> +	 * Send a disconnect command to target when a disconnect event is
> +	 * received with reason code other than 3 (DISCONNECT_CMD - disconnect
> +	 * request from host) to make the firmware stop trying to connect even
> +	 * after giving disconnect event. There will be one more disconnect
> +	 * event for this disconnect command with reason code DISCONNECT_CMD
> +	 * which won't be notified to cfg80211.
> +	 */
> +	if (reason != DISCONNECT_CMD)
> +		ath6kl_wmi_disconnect_cmd(ar->wmi, vif->fw_vif_idx);
>  }
>  
>  static int ath6kl_set_probed_ssids(struct ath6kl *ar,
> -- 
> 1.7.4.1
> 
