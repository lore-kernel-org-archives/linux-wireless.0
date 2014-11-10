Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51381 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbaKJJcx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:32:53 -0500
Message-ID: <1415611968.1847.7.camel@sipsolutions.net> (sfid-20141110_103256_219716_55446610)
Subject: Re: [PATCH 1/2] mac80211-hwsim: Factor out netlink attribute
 appending
From: Johannes Berg <johannes@sipsolutions.net>
To: Patrik Flykt <patrik.flykt@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 10 Nov 2014 10:32:48 +0100
In-Reply-To: <1415348520-28558-2-git-send-email-patrik.flykt@linux.intel.com> (sfid-20141107_092208_883031_E35223C8)
References: <1415348520-28558-1-git-send-email-patrik.flykt@linux.intel.com>
	 <1415348520-28558-2-git-send-email-patrik.flykt@linux.intel.com>
	 (sfid-20141107_092208_883031_E35223C8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-11-07 at 10:21 +0200, Patrik Flykt wrote:

> -error:
> -	nlmsg_free(skb);
> -	return NULL;
> +	return 0;
>  }
>  
> -static void hswim_mcast_new_radio(int id, struct genl_info *info,
> +static void hwsim_mcast_new_radio(int id, struct genl_info *info,
>  				  struct hwsim_new_radio_params *param)
>  {
>  	struct sk_buff *mcast_skb;
> +	void *data;
>  
> -	mcast_skb = build_radio_msg(HWSIM_CMD_NEW_RADIO, id, param);
> +	mcast_skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
>  	if (!mcast_skb)
>  		return;
>  
> +	data = genlmsg_put(mcast_skb, 0, 0, &hwsim_genl_family, 0,
> +			   HWSIM_CMD_NEW_RADIO);
> +	if (!data)
> +		goto out_err;
> +
> +	if (append_radio_msg(mcast_skb, id, param) < 0)
> +		goto out_err;
> +
> +	if (genlmsg_end(mcast_skb, data))
> +		goto out_err;
> +
>  	hwsim_mcast_config_msg(mcast_skb, info);
> +	return;
> +
> +out_err:
> +	genlmsg_cancel(mcast_skb, data);
>  }

You seem to have lost the nlmsg_free() in error cases.

johannes

