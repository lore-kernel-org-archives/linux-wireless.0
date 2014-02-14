Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43067 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaBNPeZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 10:34:25 -0500
Message-ID: <52FE3766.1080509@candelatech.com> (sfid-20140214_163428_289020_F05A614B)
Date: Fri, 14 Feb 2014 07:33:58 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath10k:  add vdev-id, return code to error codes
References: <1392318562-32440-1-git-send-email-greearb@candelatech.com> <87bnya6xey.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87bnya6xey.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2014 10:06 PM, Kalle Valo wrote:

> @@ -1542,20 +1542,20 @@ static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
>
>   	ret = ath10k_setup_peer_smps(ar, arvif, sta->addr, &sta->ht_cap);
>   	if (ret) {
> -		ath10k_warn("failed to setup peer SMPS: %d\n", ret);
> +		ath10k_warn("failed to setup peer SMPS for vdev: %d\n", ret);
>   		return ret;
>   	}

Looks like that could use the vdev id in it...I must have missed it on my first attempt.

> @@ -3252,7 +3252,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
>   			   arvif->vdev_id, sta->addr);
>   		ret = ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
>   		if (ret)
> -			ath10k_warn("Failed to delete peer: %pM for VDEV: %d ret %i\n",
> +			ath10k_warn("Failed to delete peer %pM for vdev %d: %i\n",
>   				    sta->addr, arvif->vdev_id, ret);


While you are harmonizing the messages...maybe change all instances of "failed to "Failed ?

I wasn't sure what was preferred so I left that alone when doing my patch.


The rest of the changes look fine to me.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

