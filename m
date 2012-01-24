Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24411 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab2AXLgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 06:36:13 -0500
Message-ID: <4F1E97A5.1030403@qca.qualcomm.com> (sfid-20120124_123626_722687_86BDE598)
Date: Tue, 24 Jan 2012 13:36:05 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v2 2/8] ath6kl: Add a new func to configure default WOW
 patterns for AP mode
References: <1327066544-23779-1-git-send-email-rmani@qca.qualcomm.com> <1327066544-23779-3-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1327066544-23779-3-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2012 03:35 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> ath6kl_ap_add_default_wow_patterns() is added to configure
> the below default patterns when the system enters into WOW
> suspend in AP mode.
> 
>   * Unicast IP, EAPOL-like and ARP packet pattern
>   * ARP packet pattern
>   * mDNS/SSDP/LLMNR pattern
>   * DHCP broadcast pattern
> 
> This will be called from ath6kl_wow_suspend() func.
> 
> In addition, two argument variable's ('filter' and 'mask)
> data type in ath6kl_wmi_add_wow_pattern_cmd() are changed
> from 'u8 *' to 'const u8 *'. This is needed to make all
> pattern and mask arrays to be 'static const u8' in
> the caller function.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

You could fold patches 2-5 into one patch as they seem to be the same
logical change. At least patches 4 and 5 need to be folded, otherwise
wow will be broken between the patches.

> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -1723,6 +1723,85 @@ static int ath6kl_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
>  	return 0;
>  }
>  
> +static int ath6kl_ap_add_default_wow_patterns(struct ath6kl *ar,
> +		struct ath6kl_vif *vif)
> +{

ath6kl_wow_ap() or similar would be a lot shorter name.

Kalle
