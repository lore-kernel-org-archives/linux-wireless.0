Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37340 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341AbcDFNJx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 09:09:53 -0400
Message-ID: <1459948184.17504.75.camel@sipsolutions.net> (sfid-20160406_150956_775333_4860CAE6)
Subject: Re: [PATCH 2/2] cfg80211: Allow reassociation to be requested with
 internal SME
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Apr 2016 15:09:44 +0200
In-Reply-To: <1459248808-16412-2-git-send-email-jouni@qca.qualcomm.com>
References: <1459248808-16412-1-git-send-email-jouni@qca.qualcomm.com>
	 <1459248808-16412-2-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-03-29 at 13:53 +0300, Jouni Malinen wrote:
> If the user space issues a NL80211_CMD_CONNECT with
> NL80211_ATTR_PREV_BSSID when there is already a connection, allow
> this
> to proceed as a reassociation instead of rejecting the new connect
> command with EALREADY.
> 
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
> ---
>  net/wireless/nl80211.c |  3 ++-
>  net/wireless/sme.c     | 11 +++++++++--
>  2 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index a98665a..773b20f 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -8117,7 +8117,8 @@ static int nl80211_connect(struct sk_buff *skb,
> struct genl_info *info)
>  	}
>  
>  	wdev_lock(dev->ieee80211_ptr);
> -	err = cfg80211_connect(rdev, dev, &connect, connkeys, NULL);
> +	err = cfg80211_connect(rdev, dev, &connect, connkeys,
> +			       connect.prev_bssid);
>  	wdev_unlock(dev->ieee80211_ptr);
>  	if (err)
>  		kzfree(connkeys);
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index 65882d2..ce32492 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -492,8 +492,15 @@ static int cfg80211_sme_connect(struct
> wireless_dev *wdev,
>  	if (!rdev->ops->auth || !rdev->ops->assoc)
>  		return -EOPNOTSUPP;
>  
> -	if (wdev->current_bss)
> -		return -EALREADY;
> +	if (wdev->current_bss) {
> +		if (!prev_bssid)
> +			return -EALREADY;
> +		cfg80211_unhold_bss(wdev->current_bss);
> +		cfg80211_put_bss(wdev->wiphy, &wdev->current_bss-
> >pub);
> +		wdev->current_bss = NULL;
> +
> +		cfg80211_sme_free(wdev);
> +	}
> 
Since we know the previous BSSID, I've added a check here for it.

johannes
