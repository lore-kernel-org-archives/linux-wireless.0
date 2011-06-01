Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58579 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970Ab1FATbR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 15:31:17 -0400
Date: Wed, 1 Jun 2011 15:18:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>
Subject: Re: [PATCH 2/2] mwifiex: correct the error check used for
 dev_alloc_name()
Message-ID: <20110601191837.GG2509@tuxdriver.com> (sfid-20110601_213129_702847_78F99A08)
References: <1306198818-7423-1-git-send-email-bzhao@marvell.com>
 <1306198818-7423-2-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1306198818-7423-2-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 1c5cae815d19ffe02bdfda1260949ef2b1806171
Author: Jiri Pirko <jpirko@redhat.com>
Date:   Sat Apr 30 01:21:32 2011 +0000

    net: call dev_alloc_name from register_netdevice
    
    Force dev_alloc_name() to be called from register_netdevice() by
    dev_get_valid_name(). That allows to remove multiple explicit
    dev_alloc_name() calls.
    
    The possibility to call dev_alloc_name in advance remains.
    
    This also fixes veth creation regresion caused by
    84c49d8c3e4abefb0a41a77b25aa37ebe8d6b743
    
    Signed-off-by: Jiri Pirko <jpirko@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

This patch is now obsolete...

On Mon, May 23, 2011 at 06:00:18PM -0700, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> In failure case dev_alloc_name() returns negative errno code.
> This patch corrects the check used for handling error path.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/main.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
> index f6db51c..77c104b 100644
> --- a/drivers/net/wireless/mwifiex/main.c
> +++ b/drivers/net/wireless/mwifiex/main.c
> @@ -684,6 +684,7 @@ static struct mwifiex_private *mwifiex_add_interface(
>  	struct net_device *dev;
>  	struct mwifiex_private *priv;
>  	void *mdev_priv;
> +	int ret;
>  
>  	dev = alloc_netdev_mq(sizeof(struct mwifiex_private *), "mlan%d",
>  			      ether_setup, 1);
> @@ -691,8 +692,11 @@ static struct mwifiex_private *mwifiex_add_interface(
>  		dev_err(adapter->dev, "no memory available for netdevice\n");
>  		goto error;
>  	}
> -	if (dev_alloc_name(dev, dev->name)) {
> -		dev_err(adapter->dev, "unable to alloc name for netdevice\n");
> +
> +	ret = dev_alloc_name(dev, dev->name);
> +	if (ret < 0) {
> +		dev_err(adapter->dev, "unable to alloc dev name '%s': %d\n",
> +					dev->name, ret);
>  		goto error;
>  	}
>  
> -- 
> 1.7.0.2
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
