Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33127 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbcHPHLs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2016 03:11:48 -0400
Message-ID: <1471331504.16783.24.camel@sipsolutions.net> (sfid-20160816_091151_417542_3B7788C2)
Subject: Re: [PATCH v2] nl80211: Allow GET_INTERFACE dumps to be filtered
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Tue, 16 Aug 2016 09:11:44 +0200
In-Reply-To: <1471018357-3047-1-git-send-email-denkenz@gmail.com> (sfid-20160812_181231_305175_FD58D5D3)
References: <1471018357-3047-1-git-send-email-denkenz@gmail.com>
	 (sfid-20160812_181231_305175_FD58D5D3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>  static int nl80211_dump_interface(struct sk_buff *skb, struct
> netlink_callback *cb)
>  {
> -	int wp_idx = 0;
> -	int if_idx = 0;
> -	int wp_start = cb->args[0];
> -	int if_start = cb->args[1];
>  	struct cfg80211_registered_device *rdev;
>  	struct wireless_dev *wdev;
> +	unsigned int wp_idx = 0;
> +	unsigned int if_idx;
> +	static struct dump_interface_context static_ctx;
> +	struct dump_interface_context *ctx = cb->args[0];
> +
> +	if (!ctx) {
> +		int ret;
> +
> +		static_ctx.wp_start = 0;
> +		static_ctx.if_start = 0;
> +		static_ctx.filter_wiphy = -1;
> +
> +		ret = nl80211_dump_interface_parse(skb, cb,
> +						   &static_ctx.filte
> r_wiphy);
> +		if (ret)
> +			return ret;
> +
> +		ctx = &static_ctx;
> +		cb->args[0] = ctx;

You can't do this, multiple applications are allowed to dump at the
same time. I think I'll take your previous patch and adjust it a bit.

johannes
