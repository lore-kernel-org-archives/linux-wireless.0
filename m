Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E03B8C65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF252204EC
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:41:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF252204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbeJHVxb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 17:53:31 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56626 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbeJHVxa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 17:53:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9Wir-0008L3-Kv; Mon, 08 Oct 2018 16:41:25 +0200
Message-ID: <1539009674.3687.75.camel@sipsolutions.net>
Subject: Re: [PATCH 13/19] wilc: add linux_wlan.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, aditya.shankar@microchip.com,
        venkateswara.kaja@microchip.com, claudiu.beznea@microchip.com,
        adham.abozaeid@microchip.com
Date:   Mon, 08 Oct 2018 16:41:14 +0200
In-Reply-To: <1537957525-11467-14-git-send-email-ajay.kathat@microchip.com> (sfid-20180926_122625_621450_BBA3DD9B)
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-14-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122625_621450_BBA3DD9B)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-09-26 at 15:55 +0530, Ajay Singh wrote:
> Moved '/driver/staging/wilc1000/linux_wlan.c' to
> 'drivers/net/wireless/microchip/wilc/'.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/net/wireless/microchip/wilc/linux_wlan.c | 1161 ++++++++++++++++++++++
>  1 file changed, 1161 insertions(+)
>  create mode 100644 drivers/net/wireless/microchip/wilc/linux_wlan.c

Hmm. It's pretty obviously a linux driver, what's the point?

> diff --git a/drivers/net/wireless/microchip/wilc/linux_wlan.c b/drivers/net/wireless/microchip/wilc/linux_wlan.c
> new file mode 100644
> index 0000000..76c9012
> --- /dev/null
> +++ b/drivers/net/wireless/microchip/wilc/linux_wlan.c
> @@ -0,0 +1,1161 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
> + * All rights reserved.
> + */
> +
> +#include <linux/irq.h>
> +#include <linux/kthread.h>
> +#include <linux/firmware.h>
> +#include <linux/netdevice.h>
> +#include <linux/inetdevice.h>
> +
> +#include "wilc_wfi_cfgoperations.h"
> +
> +static int dev_state_ev_handler(struct notifier_block *this,
> +				unsigned long event, void *ptr)
> +{
> +	struct in_ifaddr *dev_iface = ptr;
> +	struct wilc_priv *priv;
> +	struct host_if_drv *hif_drv;
> +	struct net_device *dev;
> +	u8 *ip_addr_buf;
> +	struct wilc_vif *vif;
> +	u8 null_ip[4] = {0};
> +	char wlan_dev_name[5] = "wlan0";

Regardless of what you're trying to do, thta seems like a bad idea.

> +	if (!dev_iface || !dev_iface->ifa_dev || !dev_iface->ifa_dev->dev)
> +		return NOTIFY_DONE;
> +
> +	if (memcmp(dev_iface->ifa_label, "wlan0", 5) &&
> +	    memcmp(dev_iface->ifa_label, "p2p0", 4))
> +		return NOTIFY_DONE;

That too. What???

> +	dev  = (struct net_device *)dev_iface->ifa_dev->dev;
> +	if (!dev->ieee80211_ptr || !dev->ieee80211_ptr->wiphy)
> +		return NOTIFY_DONE;
> +
> +	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
> +	if (!priv)
> +		return NOTIFY_DONE;
> +
> +	hif_drv = (struct host_if_drv *)priv->hif_drv;
> +	vif = netdev_priv(dev);
> +	if (!vif || !hif_drv)
> +		return NOTIFY_DONE;
> +
> +	switch (event) {
> +	case NETDEV_UP:
> +		if (vif->iftype == STATION_MODE || vif->iftype == CLIENT_MODE) {
> +			hif_drv->ifc_up = 1;
> +			vif->obtaining_ip = false;
> +			del_timer(&vif->during_ip_timer);
> +		}
> +
> +		if (vif->wilc->enable_ps)
> +			wilc_set_power_mgmt(vif, 1, 0);
> +
> +		netdev_dbg(dev, "[%s] Up IP\n", dev_iface->ifa_label);
> +
> +		ip_addr_buf = (char *)&dev_iface->ifa_address;
> +		netdev_dbg(dev, "IP add=%d:%d:%d:%d\n",
> +			   ip_addr_buf[0], ip_addr_buf[1],
> +			   ip_addr_buf[2], ip_addr_buf[3]);

%pI4, I believe, but I think you should just remove it, it likely won't
have an IP address anyway, and you might have multiple, and so this is
just broken.

> +	eth_h = (struct ethhdr *)(skb->data);
> +	if (eth_h->h_proto == cpu_to_be16(0x8e88))
> +		netdev_dbg(ndev, "EAPOL transmitted\n");

Err, no, just remove that.

> +	ih = (struct iphdr *)(skb->data + sizeof(struct ethhdr));

Sure, everything is IP. You just checked that it wasn't EAPOL?

> +	udp_buf = (char *)ih + sizeof(struct iphdr);
> +	if ((udp_buf[1] == 68 && udp_buf[3] == 67) ||
> +	    (udp_buf[1] == 67 && udp_buf[3] == 68))
> +		netdev_dbg(ndev, "DHCP Message transmitted, type:%x %x %x\n",
> +			   udp_buf[248], udp_buf[249], udp_buf[250]);

Umm... no. Just remove that too.

> +	vif->netstats.tx_packets++;
> +	vif->netstats.tx_bytes += tx_data->size;
> +	tx_data->bssid = wilc->vif[vif->idx]->bssid;
> +	queue_count = wilc_wlan_txq_add_net_pkt(ndev, (void *)tx_data,
> +						tx_data->buff, tx_data->size,
> +						linux_wlan_tx_complete);
> +
> +	if (queue_count > FLOW_CONTROL_UPPER_THRESHOLD) {
> +		netif_stop_queue(wilc->vif[0]->ndev);
> +		netif_stop_queue(wilc->vif[1]->ndev);
> +	}

It seems like a pretty bad idea to hard-code two interfaces, we do
dynamic addition/removal these days, in *particular* for P2P.

> +static int wilc_mac_close(struct net_device *ndev)
> +{
> +	struct wilc_priv *priv;
> +	struct wilc_vif *vif = netdev_priv(ndev);
> +	struct host_if_drv *hif_drv;
> +	struct wilc *wl;
> +
> +	if (!vif || !vif->ndev || !vif->ndev->ieee80211_ptr ||
> +	    !vif->ndev->ieee80211_ptr->wiphy)
> +		return 0;

I'm not really sure why you're so paranoid, none of that can possibly
happen.

> +	priv = wiphy_priv(vif->ndev->ieee80211_ptr->wiphy);
> +	wl = vif->wilc;
> +
> +	if (!priv)
> +		return 0;

Nor can this.

> +	hif_drv = (struct host_if_drv *)priv->hif_drv;
> +
> +	netdev_dbg(ndev, "Mac close\n");
> +
> +	if (!wl)
> +		return 0;
> +
> +	if (!hif_drv)
> +		return 0;

Nor these.

johannes
