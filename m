Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18071 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1KTPGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 10:06:25 -0500
Message-ID: <4EC91769.6040105@qca.qualcomm.com> (sfid-20111120_160629_654162_B182F8AC)
Date: Sun, 20 Nov 2011 17:06:17 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] cfg80211: add flags for off-channel capabilities
References: <1321522773.3997.3.camel@jlt3.sipsolutions.net>	 (sfid-20111117_103942_138938_A7896DED)  <1321606323.10266.0.camel@jlt3.sipsolutions.net>	 (sfid-20111118_095222_965831_061B5D4F) <1321626828.10266.60.camel@jlt3.sipsolutions.net>
In-Reply-To: <1321626828.10266.60.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2011 04:33 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Currently mac80211 implements these for all devices,
> but given restrictions of some devices that isn't
> really true, so prepare for being able to remove the
> capability for some mac80211 devices.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

[...]

> --- a/drivers/net/wireless/ath/ath6kl/init.c	2011-11-18 09:47:37.000000000 +0100
> +++ b/drivers/net/wireless/ath/ath6kl/init.c	2011-11-18 09:47:38.000000000 +0100
> @@ -1603,7 +1603,8 @@ int ath6kl_core_init(struct ath6kl *ar)
>  		ar->conf_flags |= ATH6KL_CONF_SUSPEND_CUTPOWER;
>  
>  	ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM |
> -			    WIPHY_FLAG_HAVE_AP_SME;
> +			    WIPHY_FLAG_HAVE_AP_SME |
> +			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;

For the ath6kl part:

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

Kalle
