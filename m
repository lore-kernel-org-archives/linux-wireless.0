Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15613 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaAJJqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 04:46:25 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: disable STA KICKOUT in FW
References: <1388390871-3932-1-git-send-email-marek.puzyniak@tieto.com>
Date: Fri, 10 Jan 2014 11:45:54 +0200
In-Reply-To: <1388390871-3932-1-git-send-email-marek.puzyniak@tieto.com>
	(Marek Puzyniak's message of "Mon, 30 Dec 2013 09:07:51 +0100")
Message-ID: <87wqi89nl9.fsf@kamboji.qca.qualcomm.com> (sfid-20140110_104631_089057_BCD8B547)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Puzyniak <marek.puzyniak@tieto.com> writes:

> Currently ath10k is not using STA KICKOUT firmware functionality.
> In order to avoid unwanted FW events this functionality should be
> disabled when not used.
>
> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>

Thanks, applied. I did minor changes to the commit log based on
the feedback:

    ath10k: disable STA kickout in FW
    
    Currently ath10k is not using STA KICKOUT firmware functionality.
    In order to avoid unwanted WMI_PEER_STA_KICKOUT_EVENT event this functionality
    should be disabled when not used.
    
    Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -2292,11 +2292,20 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
>  	}
>  
>  	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
> +		u32 param_id;
> +

Also I moved this to the beginning of the function.

-- 
Kalle Valo
