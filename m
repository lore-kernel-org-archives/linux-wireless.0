Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbYFXLEL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 07:04:11 -0400
Subject: Re: [PATCH 2/4] mac80211: update the authentication method
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1214303881-31525-3-git-send-email-tomas.winkler@intel.com>
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-2-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-3-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 07:03:02 -0400
Message-Id: <1214305382.12270.0.camel@localhost.localdomain> (sfid-20080624_130414_034620_1CA45C8F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-06-24 at 13:37 +0300, Tomas Winkler wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> This patch updates the authentication method upon giwencode ioctl.
> 
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  net/mac80211/wext.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index 53f8767..308b953 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -952,6 +952,19 @@ static int ieee80211_ioctl_giwencode(struct net_device *dev,
>  	erq->length = sdata->keys[idx]->conf.keylen;
>  	erq->flags |= IW_ENCODE_ENABLED;
>  
> +	if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
> +		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
> +		switch (ifsta->auth_alg) {
> +		case WLAN_AUTH_OPEN:
> +		case WLAN_AUTH_LEAP:
> +			erq->flags |= IW_ENCODE_OPEN;
> +			break;
> +		case WLAN_AUTH_SHARED_KEY:
> +			erq->flags |= IW_ENCODE_RESTRICTED;
> +			break;
> +		}
> +	}
> +
>  	return 0;
>  }
>  

