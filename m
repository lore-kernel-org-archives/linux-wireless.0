Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:23245 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727675AbeISQmK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 12:42:10 -0400
Date: Wed, 19 Sep 2018 16:34:40 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <venkateswara.kaja@microchip.com>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <adham.abozaeid@microchip.com>,
        <aditya.shankar@microchip.com>
Subject: Re: [PATCH 29/29] staging: wilc1000: return exact error of
 register_netdev() from wilc_netdev_init()
Message-ID: <20180919163440.2dfd185b@ajaysk-VirtualBox> (sfid-20180919_130450_423472_D74F0C67)
In-Reply-To: <20180919094132.3lfouwwzc7z3thf4@mwanda>
References: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
        <1537337119-14952-30-git-send-email-ajay.kathat@microchip.com>
        <20180919094132.3lfouwwzc7z3thf4@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thanks your reviewing the patch.

On Wed, 19 Sep 2018 12:41:32 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> I was waiting for you to send this like a spider waits for flies.  You
> fell directly into my trap.  Mwuahahahahaha.

Oops!!! I missed seeing it coming :)

> 
> drivers/staging/wilc1000/linux_wlan.c
>   1056  int wilc_netdev_init(struct wilc **wilc, struct device *dev,
> int io_type, 1057                       const struct wilc_hif_func
> *ops) 1058  {
>   1059          int i, ret = -ENOMEM;
>   1060          struct wilc_vif *vif;
>   1061          struct net_device *ndev;
>   1062          struct wilc *wl;
>   1063  
>   1064          wl = kzalloc(sizeof(*wl), GFP_KERNEL);
>   1065          if (!wl)
>   1066                  return ret;
>                                ^^^
> It's cleaner to return -ENOMEM so that we don't have to glance up to
> the declaration block.  This is especially true when "ret" is zero,
> btw, because that can indicate a reversed test.

I will change it to directly return -ENOMEM value.

> 
> 		if (!ret)
> 			return ret;
> 
> In this theoretically example it was supposed to be:
> 
> 		if (ret)
> 			return ret;
> 
> Normally, reversed conditions are caught in testing, but for the
> kernel, no one has the hardware to test everything so we do get
> reversed conditions from time to time.
> 
>   1067  
>   1068          if (wilc_wlan_cfg_init(wl))

I will set 'ret' value to -ENOMEM here also.

>   1069                  goto free_wl;
>   1070  
>   1071          *wilc = wl;
>   1072          wl->io_type = io_type;
>   1073          wl->hif_func = ops;
>   1074          wl->enable_ps = true;
>   1075          wl->chip_ps_state = CHIP_WAKEDUP;
>   1076          INIT_LIST_HEAD(&wl->txq_head.list);
>   1077          INIT_LIST_HEAD(&wl->rxq_head.list);
>   1078  
>   1079          wl->hif_workqueue =
> create_singlethread_workqueue("WILC_wq"); 1080          if
> (!wl->hif_workqueue) 1081                  goto free_cfg;
>   1082  
>   1083          register_inetaddr_notifier(&g_dev_notifier);
>   1084  
>   1085          for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
>   1086                  struct wireless_dev *wdev;
>   1087  
>   1088                  ndev = alloc_etherdev(sizeof(struct
> wilc_vif)); 1089                  if (!ndev)
>   1090                          goto free_ndev;
>                                 ^^^^^^^^^^^^^^^
> ret is zero on the second iteration through the loop.

I will set 'ret' to -ENOMEM before 'goto', which should handle this
scenario.

> 
>   1091  
>   1092                  vif = netdev_priv(ndev);
>   1093                  memset(vif, 0, sizeof(struct wilc_vif));
>   1094  
>   1095                  if (i == 0) {
>   1096                          strcpy(ndev->name, "wlan%d");
>   1097                          vif->ifc_id = 1;
>   1098                  } else {
>   1099                          strcpy(ndev->name, "p2p%d");
>   1100                          vif->ifc_id = 0;
>   1101                  }
>   1102                  vif->wilc = *wilc;
>   1103                  vif->ndev = ndev;
>   1104                  wl->vif[i] = vif;
>   1105                  wl->vif_num = i;
>   1106                  vif->idx = wl->vif_num;
>   1107  
>   1108                  ndev->netdev_ops = &wilc_netdev_ops;
>   1109  
>   1110                  wdev = wilc_create_wiphy(ndev, dev);
>   1111                  if (!wdev) {
>   1112                          netdev_err(ndev, "Can't register WILC
> Wiphy\n"); 1113                          goto free_ndev;
>                                 ^^^^^^^^^^^^^^^
> Here too.

Same here, i.e setting ret = -ENOMEM should handle the condition.

Also I will remove the default setting of 'ret' value to -ENOMEM because
after modification the error scenarios will set 'ret' explicitly.

Regards,
Ajay
