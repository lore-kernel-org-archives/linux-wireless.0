Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:44342 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754296Ab2DFOy1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 10:54:27 -0400
Message-ID: <1333724066.8565.6.camel@joe2Laptop> (sfid-20120406_165429_959669_72EF29C8)
Subject: Re: [PATCH 2/2] ath6kl: Configure htcap in fw based on the channel
 type in AP mode
From: Joe Perches <joe@perches.com>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath6kl-devel@qualcomm.com
Date: Fri, 06 Apr 2012 07:54:26 -0700
In-Reply-To: <1333721235-16025-2-git-send-email-vthiagar@qca.qualcomm.com>
References: <1333721235-16025-1-git-send-email-vthiagar@qca.qualcomm.com>
	 <1333721235-16025-2-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-04-06 at 19:37 +0530, Vasanthakumar Thiagarajan wrote:
> This patch disables HT in start_ap if the type of the channel on
> which the AP mode is going to be operating is non-HT. HT is enabled
> with default ht cap setting if the operating channel is going to be
> 11n.
[]
> diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
[]
> @@ -477,6 +477,12 @@ struct ath6kl_mc_filter {
>  	char hw_addr[ATH6KL_MCAST_FILTER_MAC_ADDR_SIZE];
>  };
>  
> +struct ath6kl_htcap {
> +	bool ht_enable;
> +	unsigned short cap_info;
> +	u8 ampdu_factor;
> +};

Probably better to rearrange this as:

struct ath6kl_htcap {
	unsigned short cap_info;
	u8 ampdu_factor;
	bool ht_enable;
};


