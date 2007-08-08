Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:33939
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbXHHJL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 05:11:57 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] Fix handling of failure to create debugfs directory
Date: Wed, 8 Aug 2007 11:04:56 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>
References: <20070808051710.3902.43211.stgit@dv.roinet.com>
In-Reply-To: <20070808051710.3902.43211.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708081104.56295.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 08 August 2007 07:17:10 Pavel Roskin wrote:
> This can happen if CONFIG_BCM43XX_MAC80211_DEBUG is enabled, but
> CONFIG_DEBUG_FS is not.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---

Thanks, queued.
Larry, this might also apply to bcm4301.

>  .../wireless/bcm43xx-mac80211/bcm43xx_debugfs.c    |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_debugfs.c b/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_debugfs.c
> index 9ca4625..aded2b3 100644
> --- a/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_debugfs.c
> +++ b/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_debugfs.c
> @@ -408,7 +408,7 @@ static struct file_operations restart_fops = {
>  
>  int bcm43xx_debug(struct bcm43xx_wldev *dev, enum bcm43xx_dyndbg feature)
>  {
> -	return !!(dev->dfsentry->dyn_debug[feature]);
> +	return !!(dev->dfsentry && dev->dfsentry->dyn_debug[feature]);
>  }
>  
>  static void bcm43xx_remove_dynamic_debug(struct bcm43xx_wldev *dev)
> @@ -472,7 +472,9 @@ void bcm43xx_debugfs_add_device(struct bcm43xx_wldev *dev)
>  	snprintf(devdir, sizeof(devdir), "%s", wiphy_name(dev->wl->hw->wiphy));
>  	e->subdir = debugfs_create_dir(devdir, fs.root);
>  	if (!e->subdir || IS_ERR(e->subdir)) {
> -		e->subdir = NULL;
> +		bcmerr(dev->wl, "debugfs: cannot create %s directory\n",
> +		       devdir);
> +		dev->dfsentry = NULL;
>  		kfree(log->log);
>  		kfree(e);
>  		return;
> @@ -525,6 +527,8 @@ void bcm43xx_debugfs_log_txstat(struct bcm43xx_wldev *dev,
>  	struct bcm43xx_txstatus *cur;
>  	int i;
>  
> +	if (!e)
> +		return;
>  	log = &e->txstatlog;
>  	assert(irqs_disabled());
>  	spin_lock(&log->lock);

-- 
Greetings Michael.
