Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:48261 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZJPQSW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 12:18:22 -0400
Subject: Re: [PATCH 03/16] iwmc3200wifi: WPS support
From: Marcel Holtmann <marcel@holtmann.org>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1255670340-22565-4-git-send-email-yi.zhu@intel.com>
References: <1255670340-22565-1-git-send-email-yi.zhu@intel.com>
	 <1255670340-22565-2-git-send-email-yi.zhu@intel.com>
	 <1255670340-22565-3-git-send-email-yi.zhu@intel.com>
	 <1255670340-22565-4-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain
Date: Fri, 16 Oct 2009 18:18:07 +0200
Message-Id: <1255709887.31260.4.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yi,

> From: Samuel Ortiz <sameo@linux.intel.com>
> 
> By setting the WSC profile flag, we now support WPS as an enrollee.
> 
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  drivers/net/wireless/iwmc3200wifi/cfg80211.c |    7 +++++++
>  drivers/net/wireless/iwmc3200wifi/commands.h |    3 +++
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
> index 0d2e719..a6d2f20 100644
> --- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
> +++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
> @@ -628,6 +628,13 @@ static int iwm_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
>  		iwm->default_key = sme->key_idx;
>  	}
>  
> +	/* WPA and open AUTH type from wpa_s means WPS (a.k.a. WSC) */
> +	if ((iwm->umac_profile->sec.flags &
> +	     (UMAC_SEC_FLG_WPA_ON_MSK | UMAC_SEC_FLG_RSNA_ON_MSK)) &&
> +	    iwm->umac_profile->sec.auth_type == UMAC_AUTH_TYPE_OPEN) {
> +			iwm->umac_profile->sec.flags = UMAC_SEC_FLG_WSC_ON_MSK;
> +	}
> +

I don't wanna be picky, but what coding style are you following here?
The indentation makes no sense and doesn't improve readability.

Regards

Marcel


