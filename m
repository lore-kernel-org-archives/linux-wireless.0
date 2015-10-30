Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57456 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759057AbbJ3Jfi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 05:35:38 -0400
Message-ID: <1446197736.3261.17.camel@sipsolutions.net> (sfid-20151030_103541_972053_84334AB2)
Subject: Re: [PATCH 2/2] mac80211: Add support for aborting an ongoing scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Sunil Dutt <usdutt@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	vkanchan@qti.qualcomm.com, amarnath@qca.qualcomm.com
Date: Fri, 30 Oct 2015 10:35:36 +0100
In-Reply-To: <1446104804-8312-2-git-send-email-usdutt@qti.qualcomm.com>
References: <1446104804-8312-1-git-send-email-usdutt@qti.qualcomm.com>
	 <1446104804-8312-2-git-send-email-usdutt@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-10-29 at 13:16 +0530, Sunil Dutt wrote:
> From: Vidyullatha Kanchanapally <vkanchan@qti.qualcomm.com>
> 
> This commit adds implementation for abort scan in mac80211.
> 
> Reviewed-by: Jouni Malinen <jouni@qca.qualcomm.com>
> Signed-off-by: Vidyullatha Kanchanapally <vkanchan@qti.qualcomm.com>
> Signed-off-by: Sunil Dutt <usdutt@qti.qualcomm.com>
> ---
>  net/mac80211/cfg.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 713cdbf..d4d78e1 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -3797,6 +3797,16 @@ static int ieee80211_del_tx_ts(struct wiphy 
> *wiphy, struct net_device *dev,
>  	return -ENOENT;
>  }
>  
> +static int ieee80211_abort_scan(struct wiphy *wiphy, struct 
> net_device *dev)
> +{
> +	struct ieee80211_sub_if_data *sdata = 
> IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct ieee80211_local *local = sdata->local;
> +
> +	/* Cancel the ongoing scan */
> +	ieee80211_scan_cancel(local);
> +	return 0;
> +}

You're not returning -ENOENT when there's no scan, which could be racy?
I'm not sure those races would be relevant, but you should think about
that and document it.

johannes
