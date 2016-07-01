Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38568 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070AbcGAXCW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2016 19:02:22 -0400
Message-ID: <1467414130.5010.0.camel@sipsolutions.net> (sfid-20160702_010225_582283_2064FF51)
Subject: Re: [PATCH 3/3] ath6kl: Unset IFF_LOWER_UP flag on AP mode leave.
From: Johannes Berg <johannes@sipsolutions.net>
To: Pierre Le Magourou <lemagoup@gmail.com>, kvalo@qca.qualcomm.com
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
	jmassot@aldebaran.com,
	Pierre Le Magourou <plemagourou@aldebaran.com>
Date: Sat, 02 Jul 2016 01:02:10 +0200
In-Reply-To: <20160701161005.30341-4-plemagourou@aldebaran.com> (sfid-20160701_181044_283833_5906342D)
References: <20160701161005.30341-1-plemagourou@aldebaran.com>
	 <20160701161005.30341-4-plemagourou@aldebaran.com>
	 (sfid-20160701_181044_283833_5906342D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -2971,7 +2971,11 @@ static int ath6kl_stop_ap(struct wiphy *wiphy,
> struct net_device *dev)
>  		return -ENOTCONN;
>  
>  	ath6kl_wmi_disconnect_cmd(ar->wmi, vif->fw_vif_idx);
> +
> +	spin_lock_bh(&vif->if_lock);
>  	clear_bit(CONNECTED, &vif->flags);
> +	netif_carrier_off(vif->ndev);
> +	spin_unlock_bh(&vif->if_lock);
> 
The addition of the locking seems rather odd.

johannes
