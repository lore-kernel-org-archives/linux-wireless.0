Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36884 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbaAUQBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 11:01:24 -0500
Message-ID: <1390320081.6199.62.camel@jlt4.sipsolutions.net> (sfid-20140121_170128_862781_22E42C7E)
Subject: Re: [RFC 2/5] mac80211: export minstrel best rate information in
 set_sta_info()
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Tue, 21 Jan 2014 17:01:21 +0100
In-Reply-To: <1390302591-3352-3-git-send-email-antonio@meshcoding.com>
References: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>
	 <1390302591-3352-3-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-21 at 12:09 +0100, Antonio Quartulli wrote:

>  struct rate_control_ops {
>  	struct module *module;
>  	const char *name;
> @@ -4478,6 +4489,10 @@ struct rate_control_ops {
>  	void (*add_sta_debugfs)(void *priv, void *priv_sta,
>  				struct dentry *dir);
>  	void (*remove_sta_debugfs)(void *priv, void *priv_sta);
> +
> +	void (*get_minstrel_best_rate)
> +		(void *priv, void *priv_sta,
> +		 struct ieee80211_minstrel_rate_info *info);
>  };

This, I think, is a terrible idea. Never mind the coding style (which
too looks terrible imho), but this also bloats the struct for a single
rate control algorithm's use only.

I'd be much happier if you actually declared this to be something like
"expected throughput" and did some calculations and made it generic.

johannes

