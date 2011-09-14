Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757104Ab1INRTd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 13:19:33 -0400
Subject: Re: [PATCH] ipw2x00: fix rtnl mutex deadlock
From: Dan Williams <dcbw@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Michael Witten <mfwitten@gmail.com>,
	Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Date: Wed, 14 Sep 2011 12:22:40 -0500
In-Reply-To: <1316011670-6787-1-git-send-email-sgruszka@redhat.com>
References: <1316011670-6787-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1316020961.3506.4.camel@dcbw.foobar.com> (sfid-20110914_191936_532019_90F8D5BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-14 at 16:47 +0200, Stanislaw Gruszka wrote:
> This fix regression introduced by:
> 
> commit: ecb4433550f0620f3d1471ae7099037ede30a91e
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> Date:   Fri Aug 12 14:00:59 2011 +0200
> 
>     mac80211: fix suspend/resume races with unregister hw
> 
> Above commit add rtnl_lock() into wiphy_register(), what cause deadlock
> when initializing ipw2x00 driver, which itself call wiphy_register()
> from register_netdev() internal callback with rtnl mutex taken.
> 
> To fix move wiphy_register() outside register_netdev(). This solution
> have side effect of not creating /sys/class/net/wlanX/phy80211 link,
> but that's a minor issue we can live with.

Unfortunately that path is one of the ways that programs distinguish
wifi devices from plain ethernet devices.  The other way is to poke it
with WEXT.  Should poking it with nl80211 be added to the mix instead?
I guess for ipw2x00 it's not an issue since the driver depends on WEXT
and thus the WEXT method will always work.  But this special usage of
the phy80211 link is something to remember.

Dan

> Bisected-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
> Bisected-by: Michael Witten <mfwitten@gmail.com>
> Tested-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
> Tested-by: Michael Witten <mfwitten@gmail.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> ecb4433550f0620f3d1471ae7099037ede30a91e was CCed to stable but we
> drop it there, when bug was reported. So this patch is only intended
> to 3.1
> 
>  drivers/net/wireless/ipw2x00/ipw2100.c |   21 +++++++++++-----
>  drivers/net/wireless/ipw2x00/ipw2200.c |   39 +++++++++++++++++++++----------
>  2 files changed, 40 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
> index 3774dd0..ef9ad79 100644
> --- a/drivers/net/wireless/ipw2x00/ipw2100.c
> +++ b/drivers/net/wireless/ipw2x00/ipw2100.c
> @@ -1903,15 +1903,17 @@ static void ipw2100_down(struct ipw2100_priv *priv)
>  static int ipw2100_net_init(struct net_device *dev)
>  {
>  	struct ipw2100_priv *priv = libipw_priv(dev);
> +
> +	return ipw2100_up(priv, 1);
> +}
> +
> +static int ipw2100_wdev_init(struct net_device *dev)
> +{
> +	struct ipw2100_priv *priv = libipw_priv(dev);
>  	const struct libipw_geo *geo = libipw_get_geo(priv->ieee);
>  	struct wireless_dev *wdev = &priv->ieee->wdev;
> -	int ret;
>  	int i;
>  
> -	ret = ipw2100_up(priv, 1);
> -	if (ret)
> -		return ret;
> -
>  	memcpy(wdev->wiphy->perm_addr, priv->mac_addr, ETH_ALEN);
>  
>  	/* fill-out priv->ieee->bg_band */
> @@ -6350,9 +6352,13 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
>  		       "Error calling register_netdev.\n");
>  		goto fail;
>  	}
> +	registered = 1;
> +
> +	err = ipw2100_wdev_init(dev);
> +	if (err)
> +		goto fail;
>  
>  	mutex_lock(&priv->action_mutex);
> -	registered = 1;
>  
>  	IPW_DEBUG_INFO("%s: Bound to %s\n", dev->name, pci_name(pci_dev));
>  
> @@ -6389,7 +6395,8 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
>  
>        fail_unlock:
>  	mutex_unlock(&priv->action_mutex);
> -
> +	wiphy_unregister(priv->ieee->wdev.wiphy);
> +	kfree(priv->ieee->bg_band.channels);
>        fail:
>  	if (dev) {
>  		if (registered)
> diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
> index 87813c3..4ffebed 100644
> --- a/drivers/net/wireless/ipw2x00/ipw2200.c
> +++ b/drivers/net/wireless/ipw2x00/ipw2200.c
> @@ -11425,16 +11425,23 @@ static void ipw_bg_down(struct work_struct *work)
>  /* Called by register_netdev() */
>  static int ipw_net_init(struct net_device *dev)
>  {
> +	int rc = 0;
> +	struct ipw_priv *priv = libipw_priv(dev);
> +
> +	mutex_lock(&priv->mutex);
> +	if (ipw_up(priv))
> +		rc = -EIO;
> +	mutex_unlock(&priv->mutex);
> +
> +	return rc;
> +}
> +
> +static int ipw_wdev_init(struct net_device *dev)
> +{
>  	int i, rc = 0;
>  	struct ipw_priv *priv = libipw_priv(dev);
>  	const struct libipw_geo *geo = libipw_get_geo(priv->ieee);
>  	struct wireless_dev *wdev = &priv->ieee->wdev;
> -	mutex_lock(&priv->mutex);
> -
> -	if (ipw_up(priv)) {
> -		rc = -EIO;
> -		goto out;
> -	}
>  
>  	memcpy(wdev->wiphy->perm_addr, priv->mac_addr, ETH_ALEN);
>  
> @@ -11519,13 +11526,9 @@ static int ipw_net_init(struct net_device *dev)
>  	set_wiphy_dev(wdev->wiphy, &priv->pci_dev->dev);
>  
>  	/* With that information in place, we can now register the wiphy... */
> -	if (wiphy_register(wdev->wiphy)) {
> +	if (wiphy_register(wdev->wiphy))
>  		rc = -EIO;
> -		goto out;
> -	}
> -
>  out:
> -	mutex_unlock(&priv->mutex);
>  	return rc;
>  }
>  
> @@ -11832,14 +11835,22 @@ static int __devinit ipw_pci_probe(struct pci_dev *pdev,
>  		goto out_remove_sysfs;
>  	}
>  
> +	err = ipw_wdev_init(net_dev);
> +	if (err) {
> +		IPW_ERROR("failed to register wireless device\n");
> +		goto out_unregister_netdev;
> +	}
> +
>  #ifdef CONFIG_IPW2200_PROMISCUOUS
>  	if (rtap_iface) {
>  	        err = ipw_prom_alloc(priv);
>  		if (err) {
>  			IPW_ERROR("Failed to register promiscuous network "
>  				  "device (error %d).\n", err);
> -			unregister_netdev(priv->net_dev);
> -			goto out_remove_sysfs;
> +			wiphy_unregister(priv->ieee->wdev.wiphy);
> +			kfree(priv->ieee->a_band.channels);
> +			kfree(priv->ieee->bg_band.channels);
> +			goto out_unregister_netdev;
>  		}
>  	}
>  #endif
> @@ -11851,6 +11862,8 @@ static int __devinit ipw_pci_probe(struct pci_dev *pdev,
>  
>  	return 0;
>  
> +      out_unregister_netdev:
> +	unregister_netdev(priv->net_dev);
>        out_remove_sysfs:
>  	sysfs_remove_group(&pdev->dev.kobj, &ipw_attribute_group);
>        out_release_irq:


