Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46200 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbeCUHk0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 03:40:26 -0400
Date: Wed, 21 Mar 2018 10:40:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH 06/11] staging: wilc1000: refactor mgmt_tx to fix line
 over 80 chars
Message-ID: <20180321074013.ic7r7n5mwrl6apcc@mwanda> (sfid-20180321_084030_531521_64B2323F)
References: <1521564944-3565-1-git-send-email-ajay.kathat@microchip.com>
 <1521564944-3565-7-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521564944-3565-7-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This would have been easier for me if it were split up slightly
different again.

This patch is fine.  I have a couple comments for future patches which
you are free to ignore if you want because it's mostly just my personal
taste.

On Tue, Mar 20, 2018 at 10:25:39PM +0530, Ajay Singh wrote:
> +		if (subtype != P2P_INV_REQ && subtype != P2P_INV_RSP) {
> +			int vendor_spec_len = sizeof(p2p_vendor_spec);

I'm not a huge fan of making shorter names for sizeof()s just to get
around the 80 character rule.  The 80 character rule is ultimately
supposed to make the code more readable, and this is making less
readable so it's maybe better to just ignore the rule.

> +
> +			memcpy(&mgmt_tx->buff[len], p2p_vendor_spec,
> +			       vendor_spec_len);
> +			mgmt_tx->buff[len + vendor_spec_len] = p2p_local_random;
> +			mgmt_tx->size = buf_len;
> +		}
> +	}
> +}
> +
>  static int mgmt_tx(struct wiphy *wiphy,
>  		   struct wireless_dev *wdev,
>  		   struct cfg80211_mgmt_tx_params *params,
> @@ -1568,9 +1620,9 @@ static int mgmt_tx(struct wiphy *wiphy,
>  	struct p2p_mgmt_data *mgmt_tx;
>  	struct wilc_priv *priv;
>  	struct host_if_drv *wfi_drv;
> -	u32 i;
>  	struct wilc_vif *vif;
>  	u32 buf_len = len + sizeof(p2p_vendor_spec) + sizeof(p2p_local_random);
> +	int ret = 0;
>  
>  	vif = netdev_priv(wdev->netdev);
>  	priv = wiphy_priv(wiphy);
> @@ -1580,92 +1632,75 @@ static int mgmt_tx(struct wiphy *wiphy,
>  	priv->tx_cookie = *cookie;
>  	mgmt = (const struct ieee80211_mgmt *)buf;
>  
> -	if (ieee80211_is_mgmt(mgmt->frame_control)) {
> -		mgmt_tx = kmalloc(sizeof(struct p2p_mgmt_data), GFP_KERNEL);
> -		if (!mgmt_tx)
> -			return -EFAULT;
> +	if (!ieee80211_is_mgmt(mgmt->frame_control))
> +		goto out;


I hate this "goto out;".  My first question when I see it is "what does
goto out; do?"  It's a kind of vague label name.  So I have to scroll
down to the bottom of the function.  And then I'm like "Oh, it doesn't
do anything.  Well that was a waste of time."  And then it occurs to me,
"Huh, what is 'ret' set to?" So now I have to scroll all the way to the
very start of the function...  All this scrolling could be avoided if we
just did a direct "return 0;"

regards,
dan carpenter
