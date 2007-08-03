Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.riseup.net ([204.13.164.18]:58723 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762325AbXHCOld (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 10:41:33 -0400
Date: Fri, 3 Aug 2007 16:38:36 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/10] Port of bcm43xx from softmac to mac80211
Message-ID: <20070803163836.7ef9622b@morte>
In-Reply-To: <46b1fded.0g4ZHvU7XwSzeJVs%Larry.Finger@lwfinger.net>
References: <46b1fded.0g4ZHvU7XwSzeJVs%Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 02 Aug 2007 10:53:17 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> +static char big_buffer[1024*256];

static char big_buffer[1024 * 256];

> +		bcmerr(dev->wl, "debugfs: Board not initialized.\n");
>  		res = -EFAULT;
>  		goto out_unlock;
>  	}
> -	if (sscanf(buf, "%lli", &tsf) != 1) {
> -		printk(KERN_INFO PFX "debugfs: invalid values for
> \"tsf\"\n");
> +	if (sscanf(buf, "%llu", (unsigned long long *)(&tsf)) != 1) {
> +		bcmerr(dev->wl, "debugfs: invalid values for \"tsf\"\n");

"debugfs: Invalid values for TSF.\n"

> +	int i;
> +	int idx;

int i, idx;

> +void bcm43xx_debugfs_add_device(struct bcm43xx_wldev *dev)
>  {
>  	struct bcm43xx_dfsentry *e;
> -	char devdir[IFNAMSIZ];
> +	struct bcm43xx_txstatus_log *log;
> +	char devdir[16];
>  
> -	assert(bcm);
> +	BCM43xx_BUG_ON(!dev);
>  	e = kzalloc(sizeof(*e), GFP_KERNEL);
>  	if (!e) {
> -		printk(KERN_ERR PFX "out of memory\n");
> +		bcmerr(dev->wl, "debugfs: add device OOM\n");

"debugfs: OOM while adding device.\n"

> +		bcmerr(dev->wl, "debugfs: add device txstatus OOM\n");

"debugfs: OOM while adding device txstatus.\n"

And the same for all the debugfs messages, please be consistent.


-- 
Ciao
Stefano
