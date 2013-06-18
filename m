Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38192 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab3FRJjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 05:39:41 -0400
Message-ID: <1371548362.8318.5.camel@jlt4.sipsolutions.net> (sfid-20130618_114004_936412_33B1DF45)
Subject: Re: [PATCH] mac80211: allow key deletion for mesh interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Date: Tue, 18 Jun 2013 11:39:22 +0200
In-Reply-To: <1371528422-20710-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130618_060934_033197_015BA4A8)
References: <1371528422-20710-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20130618_060934_033197_015BA4A8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-18 at 12:07 +0800, Chun-Yeow Yeoh wrote:

> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -239,7 +239,10 @@ static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
>  	if (mac_addr) {
>  		ret = -ENOENT;
>  
> -		sta = sta_info_get_bss(sdata, mac_addr);
> +		if (ieee80211_vif_is_mesh(&sdata->vif))
> +			sta = sta_info_get(sdata, mac_addr);
> +		else
> +			sta = sta_info_get_bss(sdata, mac_addr);

I don't see that this actually changes anything. The mesh sdata will
have a NULL bss pointer, so the second condition in sta_info_get_bss()
can't be true.

Therefore, only the first condition can ever be considered, which is
exactly the same as sta_info_get(), no?

johannes

