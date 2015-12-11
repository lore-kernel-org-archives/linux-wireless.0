Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:10983 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbbLKJMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2015 04:12:52 -0500
Message-ID: <566A9392.6090103@broadcom.com> (sfid-20151211_101343_616029_A7FEDAB8)
Date: Fri, 11 Dec 2015 10:12:50 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>
Subject: Re: [PATCH V2 13/13] brcmfmac: add arp offload ip address table configuration
 support
References: <1449751392-32569-1-git-send-email-arend@broadcom.com> <1449751392-32569-14-git-send-email-arend@broadcom.com>
In-Reply-To: <1449751392-32569-14-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2015 01:43 PM, Arend van Spriel wrote:
> From: Franky Lin <frankyl@broadcom.com>
>
> Obtain ipv4 address through inetaddr notification for ARP offload host
> ip table configuration.

Turns out this patch has a sparse warning, ie. would not work on 
big-endian system. We have a fix for that. Should I mark this patch as 
dropped in patchwork?

Regards,
Arend

> Signed-off-by: Franky Lin <frankyl@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>   .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 108 +++++++++++++++++++++
>   .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   2 +
>   2 files changed, 110 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index 3a39192..2631f6f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -17,6 +17,7 @@
>   #include <linux/kernel.h>
>   #include <linux/etherdevice.h>
>   #include <linux/module.h>
> +#include <linux/inetdevice.h>
>   #include <net/cfg80211.h>
>   #include <net/rtnetlink.h>
>   #include <brcmu_utils.h>
> @@ -620,6 +621,8 @@ static int brcmf_netdev_stop(struct net_device *ndev)
>
>   	brcmf_cfg80211_down(ndev);
>
> +	brcmf_fil_iovar_data_set(ifp, "arp_hostip_clear", NULL, 0);
> +
>   	brcmf_net_setcarrier(ifp, false);
>
>   	return 0;
> @@ -940,6 +943,98 @@ int brcmf_get_next_free_bsscfgidx(struct brcmf_pub *drvr)
>   	return available ? bsscfgidx : -ENOMEM;
>   }
>
> +#ifdef CONFIG_INET
> +#define ARPOL_MAX_ENTRIES	8
> +static int brcmf_inetaddr_changed(struct notifier_block *nb,
> +				  unsigned long action, void *data)
> +{
> +	struct brcmf_pub *drvr = container_of(nb, struct brcmf_pub,
> +					      inetaddr_notifier);
> +	struct in_ifaddr *ifa = data;
> +	struct net_device *ndev = ifa->ifa_dev->dev;
> +	struct brcmf_if *ifp;
> +	int idx, i, ret;
> +	u32 val;
> +	u32 addr_table[ARPOL_MAX_ENTRIES] = {0};
> +
> +	/* Find out if the notification is meant for us */
> +	for (idx = 0; idx < BRCMF_MAX_IFS; idx++) {
> +		ifp = drvr->iflist[idx];
> +		if (ifp && ifp->ndev == ndev)
> +			break;
> +		if (idx == BRCMF_MAX_IFS - 1)
> +			return NOTIFY_DONE;
> +	}
> +
> +	/* check if arp offload is supported */
> +	ret = brcmf_fil_iovar_int_get(ifp, "arpoe", &val);
> +	if (ret)
> +		return NOTIFY_OK;
> +
> +	/* old version only support primary index */
> +	ret = brcmf_fil_iovar_int_get(ifp, "arp_version", &val);
> +	if (ret)
> +		val = 1;
> +	if (val == 1)
> +		ifp = drvr->iflist[0];
> +
> +	/* retrieve the table from firmware */
> +	ret = brcmf_fil_iovar_data_get(ifp, "arp_hostip", addr_table,
> +				       sizeof(addr_table));
> +	if (ret) {
> +		brcmf_err("fail to get arp ip table err:%d\n", ret);
> +		return NOTIFY_OK;
> +	}
> +
> +	for (i = 0; i < ARPOL_MAX_ENTRIES; i++)
> +		if (ifa->ifa_address == addr_table[i])
> +			break;
> +
> +	switch (action) {
> +	case NETDEV_UP:
> +		if (i == ARPOL_MAX_ENTRIES) {
> +			brcmf_dbg(TRACE, "add %pI4 to arp table\n",
> +				  &ifa->ifa_address);
> +			/* set it directly */
> +			ret = brcmf_fil_iovar_int_set(ifp, "arp_hostip",
> +						      ifa->ifa_address);
> +			if (ret)
> +				brcmf_err("add arp ip err %d\n", ret);
> +		}
> +		break;
> +	case NETDEV_DOWN:
> +		if (i < ARPOL_MAX_ENTRIES) {
> +			addr_table[i] = 0;
> +			brcmf_dbg(TRACE, "remove %pI4 from arp table\n",
> +				  &ifa->ifa_address);
> +			/* clear the table in firmware */
> +			ret = brcmf_fil_iovar_data_set(ifp, "arp_hostip_clear",
> +						       NULL, 0);
> +			if (ret) {
> +				brcmf_err("fail to clear arp ip table err:%d\n",
> +					  ret);
> +				return NOTIFY_OK;
> +			}
> +			for (i = 0; i < ARPOL_MAX_ENTRIES; i++) {
> +				if (addr_table[i] != 0) {
> +					brcmf_fil_iovar_int_set(ifp,
> +								"arp_hostip",
> +								addr_table[i]);
> +					if (ret)
> +						brcmf_err("add arp ip err %d\n",
> +							  ret);
> +				}
> +			}
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +#endif
> +
>   int brcmf_attach(struct device *dev)
>   {
>   	struct brcmf_pub *drvr = NULL;
> @@ -1068,6 +1163,15 @@ int brcmf_bus_start(struct device *dev)
>   		if (p2p_ifp)
>   			ret = brcmf_net_p2p_attach(p2p_ifp);
>   	}
> +
> +	if (ret)
> +		goto fail;
> +
> +#ifdef CONFIG_INET
> +	drvr->inetaddr_notifier.notifier_call = brcmf_inetaddr_changed;
> +	ret = register_inetaddr_notifier(&drvr->inetaddr_notifier);
> +#endif
> +
>   fail:
>   	if (ret < 0) {
>   		brcmf_err("failed: %d\n", ret);
> @@ -1133,6 +1237,10 @@ void brcmf_detach(struct device *dev)
>   	if (drvr == NULL)
>   		return;
>
> +#ifdef CONFIG_INET
> +	unregister_inetaddr_notifier(&drvr->inetaddr_notifier);
> +#endif
> +
>   	/* stop firmware event handling */
>   	brcmf_fweh_detach(drvr);
>   	if (drvr->config)
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
> index 77d8239..6018af7 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
> @@ -141,6 +141,8 @@ struct brcmf_pub {
>   #ifdef DEBUG
>   	struct dentry *dbgfs_dir;
>   #endif
> +
> +	struct notifier_block inetaddr_notifier;
>   };
>
>   /* forward declarations */
>

