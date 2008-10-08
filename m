Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.171.30]:42656 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753064AbYJHJ5z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 05:57:55 -0400
Date: Wed, 8 Oct 2008 04:57:53 -0500
From: Robin Holt <holt@sgi.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>, Robin Holt <holt@sgi.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix debugfs netdev rename
Message-ID: <20081008095753.GO8534@sgi.com> (sfid-20081008_115759_205309_81F6CC9A)
References: <1223453916.3618.34.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223453916.3618.34.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That looks like it is probably it!

Thanks,
Robin


On Wed, Oct 08, 2008 at 10:18:36AM +0200, Johannes Berg wrote:
> If, for some reason, a netdev has no debugfs dir, we shouldn't
> try to rename that dir.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: Robin Holt <holt@sgi.com>
> ---
> Robin, ok, I was wrong, this might be causing it...
> 
>  net/mac80211/debugfs_netdev.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> --- everything.orig/net/mac80211/debugfs_netdev.c	2008-10-08 10:08:23.000000000 +0200
> +++ everything/net/mac80211/debugfs_netdev.c	2008-10-08 10:08:37.000000000 +0200
> @@ -481,8 +481,12 @@ static int netdev_notify(struct notifier
>  
>  	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>  
> -	sprintf(buf, "netdev:%s", dev->name);
>  	dir = sdata->debugfsdir;
> +
> +	if (!dir)
> +		return 0;
> +
> +	sprintf(buf, "netdev:%s", dev->name);
>  	if (!debugfs_rename(dir->d_parent, dir, dir->d_parent, buf))
>  		printk(KERN_ERR "mac80211: debugfs: failed to rename debugfs "
>  		       "dir to %s\n", buf);
> 
