Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3649 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab2FSQur (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 12:50:47 -0400
Message-ID: <4FE0ADB6.5080105@broadcom.com> (sfid-20120619_185050_536251_B818D786)
Date: Tue, 19 Jun 2012 18:49:58 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes.berg@intel.com>
Subject: Re: [RFC 13/17] nl80211: move scan API to wdev
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
 <1340117456-10154-14-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1340117456-10154-14-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/19/2012 04:50 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The new P2P Device will have to be able to scan for
> P2P search, so move scanning to use struct wireless_dev
> instead of struct net_device.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> index 404e87c..a507b6e 100644
> --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> @@ -908,11 +908,11 @@ static int ath6kl_set_probed_ssids(struct ath6kl *ar,
>  	return 0;
>  }
>  
> -static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
> +static int ath6kl_cfg80211_scan(struct wiphy *wiphy,
>  				struct cfg80211_scan_request *request)

Lot of indent issues in this variety of drivers. Do you care to fix that
as well or leave it to .... whom it may concern.

Gr. AvS

