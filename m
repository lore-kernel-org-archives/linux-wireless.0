Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:35134 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbcDFIWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 04:22:48 -0400
Received: by mail-pf0-f177.google.com with SMTP id n1so28900037pfn.2
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2016 01:22:48 -0700 (PDT)
Subject: Re: [PATCH v2] brcmfmac: Don't increase 8021x_cnt for dropped packets
To: per.forlin@gmail.com, linux-wireless@vger.kernel.org
References: <1459886507-26249-1-git-send-email-per.forlin@gmail.com>
Cc: arend@broadcom.com, brudley@broadcom.com, frankyl@broadcom.com,
	meuleman@broadcom.com,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5704C751.3060201@broadcom.com> (sfid-20160406_102317_171576_8A23DFBE)
Date: Wed, 6 Apr 2016 10:22:41 +0200
MIME-Version: 1.0
In-Reply-To: <1459886507-26249-1-git-send-email-per.forlin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5-4-2016 22:01, per.forlin@gmail.com wrote:
> From: Per Forlin <per.forlin@gmail.com>
> 
> The pend_8021x_cnt gets into a state where it's not being decreased.
> When the brcmf_netdev_wait_pend8021x is called it will timeout
> because there are no pending packets to be consumed. There is no
> easy way of getting out of this state once it has happened.
> Preventing the counter from being increased in case of dropped
> packets seem like a reasonable solution.
> 
> Log showing overflow txq and increased cnt:
> 
> // Extra debug prints
> brcmfmac: [brcmf_netdev_wait_pend8021x] pend_8021x_cnt == 0
> brcmfmac: [brcmf_netdev_start_xmit] pend_8021x_cnt == 1
> brcmfmac: [brcmf_netdev_start_xmit] pend_8021x_cnt == 2
> 
> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
> brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
> 
> // Extra debug prints
> brcmfmac: [brcmf_netdev_start_xmit] pend_8021x_cnt == 3
> brcmfmac: [brcmf_netdev_start_xmit] pend_8021x_cnt == 4
> brcmfmac: [brcmf_netdev_wait_pend8021x] pend_8021x_cnt == 4
> 
> WARNING: at .../brcmfmac/core.c:1289 brcmf_netdev_wait_pend8021x
>   (warn_slowpath_common)
>   (warn_slowpath_null)
>   (brcmf_netdev_wait_pend8021x [brcmfmac])
>   (send_key_to_dongle [brcmfmac])
>   (brcmf_cfg80211_del_key [brcmfmac])
>   (nl80211_del_key [cfg80211])
>   (genl_rcv_msg)
>   (netlink_rcv_skb)
>   (genl_rcv)
>   (netlink_unicast)
>   (netlink_sendmsg)
>   (sock_sendmsg)
>   (___sys_sendmsg)
>   (__sys_sendmsg)
>   (SyS_sendmsg)
> 
> Signed-off-by: Per Forlin <per.forlin@gmail.com>
> ---
> I came across this bug in an older kernel but it seems relevant
> for the latest kernel as well. I'm not familiar with the code
> but I can reproduce the issue and verify a fix for it.
> With this patch I no longer get stuck with a pend8021_cnt > 0.
> 
> Change log:
>  v2 - Add variable to know whether the counter is increased or not

Sorry for the late response. Can you elaborate where you are seeing this.

What kind of chipset are you using?
What kernel version are you running?

The function brcmf_fws_process_skb() should call brcmf_txfinalize() in
case of an error and it does in latest kernel. There the count is
decreased. We had an issue mapping to the right ifp as reported by
Rafał, but that has also been fixed recently. So main question here:

Do you see the issue in the latest kernel?

Regards,
Arend

>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index ed9998b..de80ad8 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -196,6 +196,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
>  	struct brcmf_if *ifp = netdev_priv(ndev);
>  	struct brcmf_pub *drvr = ifp->drvr;
>  	struct ethhdr *eh = (struct ethhdr *)(skb->data);
> +	bool pend_8021x_cnt_increased = false;
>  
>  	brcmf_dbg(DATA, "Enter, bsscfgidx=%d\n", ifp->bsscfgidx);
>  
> @@ -233,14 +234,18 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
>  		goto done;
>  	}
>  
> -	if (eh->h_proto == htons(ETH_P_PAE))
> +	if (eh->h_proto == htons(ETH_P_PAE)) {
>  		atomic_inc(&ifp->pend_8021x_cnt);
> +		pend_8021x_cnt_increased = true;
> +	}
>  
>  	ret = brcmf_fws_process_skb(ifp, skb);
>  
>  done:
>  	if (ret) {
>  		ifp->stats.tx_dropped++;
> +		if (pend_8021x_cnt_increased)
> +			atomic_dec(&ifp->pend_8021x_cnt);
>  	} else {
>  		ifp->stats.tx_packets++;
>  		ifp->stats.tx_bytes += skb->len;
> 
