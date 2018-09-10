Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:12139 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbeIKPaC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 11:30:02 -0400
Date: Mon, 10 Sep 2018 19:54:06 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Claudiu Beznea <Claudiu.Beznea@microchip.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <venkateswara.kaja@microchip.com>, <aditya.shankar@microchip.com>,
        <adham.abozaeid@microchip.com>
Subject: Re: [PATCH v2 25/26] staging: wilc1000: refactor wilc_netdev_init()
 to handle memory free in error path
Message-ID: <20180910195406.47e6c6a4@ajaysk-VirtualBox> (sfid-20180911_123123_195803_47CECA80)
In-Reply-To: <4146484d-e815-7d02-88dd-dc66493d0719@microchip.com>
References: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
        <1536043182-19735-26-git-send-email-ajay.kathat@microchip.com>
        <4146484d-e815-7d02-88dd-dc66493d0719@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Claudiu,

On Tue, 11 Sep 2018 12:21:13 +0300
Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:

> On 04.09.2018 09:39, Ajay Singh wrote:
> > Refactor the wilc_netdev_init() to cleanup the memory for error
> > scenario and remove unnecessary 'dev' pointer check.
> > 
> > Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> > ---
> >  drivers/staging/wilc1000/linux_wlan.c             | 36
> > ++++++++++++++++-------
> > drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  6 +++- 2 files
> > changed, 30 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/staging/wilc1000/linux_wlan.c
> > b/drivers/staging/wilc1000/linux_wlan.c index d7d43fd..91a45a7
> > 100644 --- a/drivers/staging/wilc1000/linux_wlan.c
> > +++ b/drivers/staging/wilc1000/linux_wlan.c
> > @@ -1073,10 +1073,8 @@ int wilc_netdev_init(struct wilc **wilc,
> > struct device *dev, int io_type, INIT_LIST_HEAD(&wl->rxq_head.list);
> >  
> >  	wl->hif_workqueue =
> > create_singlethread_workqueue("WILC_wq");
> > -	if (!wl->hif_workqueue) {
> > -		kfree(wl);
> > -		return -ENOMEM;
> > -	}
> > +	if (!wl->hif_workqueue)
> > +		goto free_wl;
> >  
> >  	register_inetaddr_notifier(&g_dev_notifier);
> >  
> > @@ -1085,7 +1083,7 @@ int wilc_netdev_init(struct wilc **wilc,
> > struct device *dev, int io_type, 
> >  		ndev = alloc_etherdev(sizeof(struct wilc_vif));
> >  		if (!ndev)
> > -			return -ENOMEM;
> > +			goto free_ndev;
> >  
> >  		vif = netdev_priv(ndev);
> >  		memset(vif, 0, sizeof(struct wilc_vif));
> > @@ -1106,15 +1104,13 @@ int wilc_netdev_init(struct wilc **wilc,
> > struct device *dev, int io_type, ndev->netdev_ops =
> > &wilc_netdev_ops; 
> >  		wdev = wilc_create_wiphy(ndev, dev);
> > -
> > -		if (dev)
> > -			SET_NETDEV_DEV(ndev, dev);
> > -
> >  		if (!wdev) {
> >  			netdev_err(ndev, "Can't register WILC
> > Wiphy\n");
> > -			return -1;
> > +			goto free_ndev;
> >  		}
> >  
> > +		SET_NETDEV_DEV(ndev, dev);
> > +
> >  		vif->ndev->ieee80211_ptr = wdev;
> >  		vif->ndev->ml_priv = vif;
> >  		wdev->netdev = vif->ndev;
> > @@ -1125,11 +1121,29 @@ int wilc_netdev_init(struct wilc **wilc,
> > struct device *dev, int io_type, 
> >  		ret = register_netdev(ndev);
> >  		if (ret)
> > -			return ret;
> > +			goto free_ndev;  
> 
> In case this happens you will loose the return code of
> register_netdev() and you will return instead -ENOMEM. Maybe, the
> best approach will be to initialize ret = -ENOMEM while declaring it

Thanks for your suggestion to handle the return code.
I will work on it and submit the changes in different series. 

Regards,
Ajay
