Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36044 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932569AbeGFMbi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 08:31:38 -0400
Message-ID: <1530880295.3197.39.camel@sipsolutions.net> (sfid-20180706_143329_659166_FFE17039)
Subject: Re: [PATCH] cfg80211: inspect off channel operation only when off
 channel given
From: Johannes Berg <johannes@sipsolutions.net>
To: peter.oh@bowerswilkins.com, linux-wireless@vger.kernel.org
Date: Fri, 06 Jul 2018 14:31:35 +0200
In-Reply-To: <1530659052-5834-1-git-send-email-peter.oh@bowerswilkins.com>
References: <1530659052-5834-1-git-send-email-peter.oh@bowerswilkins.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-07-03 at 16:04 -0700, peter.oh@bowerswilkins.com wrote:
> From: Peter Oh <peter.oh@bowerswilkins.com>
> 
> NL80211_ATTR_OFFCHANNEL_TX_OK does not mean given channel is always
> off channel, but it means the channel given could be off channel.
> Hence it should not block the given channel to be used if given
> channel does not require off channel mgmt tx although regulatory
> domain is non-ETSI.
> 
> Signed-off-by: Peter Oh <peter.oh@bowerswilkins.com>
> ---
>  net/wireless/nl80211.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 4eece06..991042b 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -9915,7 +9915,9 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
>  		return -EINVAL;
>  
>  	wdev_lock(wdev);
> -	if (params.offchan && !cfg80211_off_channel_oper_allowed(wdev)) {
> +	if (params.offchan &&
> +	    !cfg80211_chandef_identical(&chandef, &wdev->chandef) &&
> +	    !cfg80211_off_channel_oper_allowed(wdev)) {
>  		wdev_unlock(wdev);

Hmm. That seems fine, but can we be sure that wdev->chandef is always
valid? ISTR that it isn't necessarily updated all the time, but I can't
really say right now.

johannes
