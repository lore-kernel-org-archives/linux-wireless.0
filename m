Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:50037 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161218AbXDWSW2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 14:22:28 -0400
Date: Mon, 23 Apr 2007 20:22:31 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: PATCH [001/001] - Remove duplicate rtnl_unlock()
Message-ID: <20070423202231.372849f2@griffin.suse.cz>
In-Reply-To: <4628259E.7060105@canonical.com>
References: <4628259E.7060105@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 19 Apr 2007 20:29:50 -0600, Tim Gardner wrote:
> Remove a duplicate rtnl_unlock().
> 
> Signed-off-by: tim.gardner@ubuntu.com

Please use the "Name <mail>" form of the Signed-off-by line.

> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> index b5a62b7..cf3d020 100644
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -4816,7 +4816,6 @@ int ieee80211_register_hw(struct ieee80211_hw
> *hw) rtnl_lock();
>  	result = dev_alloc_name(local->mdev, local->mdev->name);
>  	if (result < 0) {
> -		rtnl_unlock();
>  		goto fail_dev;
>  	}

Please remove the enclosing braces too.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
