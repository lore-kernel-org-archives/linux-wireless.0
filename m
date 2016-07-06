Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:34290 "EHLO
	mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbcGFJxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 05:53:07 -0400
Received: by mail-vk0-f66.google.com with SMTP id v6so31934169vkb.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2016 02:53:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460498140-18874-1-git-send-email-per.forlin@gmail.com>
References: <1460498140-18874-1-git-send-email-per.forlin@gmail.com>
From: =?UTF-8?Q?Per_F=C3=B6rlin?= <per.forlin@gmail.com>
Date: Wed, 6 Jul 2016 11:53:05 +0200
Message-ID: <CAC0pXTLDeiiVma7AGD1XirQG=SqSDht_BA3arQQnvn=ztTLDug@mail.gmail.com> (sfid-20160706_115313_390469_0119EEE9)
Subject: Re: [PATCH v4] brcmfmac: Decrease 8021x_cnt for dropped packets
To: linux-wireless@vger.kernel.org
Cc: arend@broadcom.com, Per Forlin <per.forlin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have now verified this patch on backports 4.4.

2016-04-12 23:55 GMT+02:00  <per.forlin@gmail.com>:
> From: Per Forlin <per.forlin@gmail.com>
>
> This patch resolves an issue where pend_8021x_cnt was not decreased
> on txfinalize. This caused brcmf_netdev_wait_pend8021x to timeout
> because the counter indicated pending packets.
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
> The solution is to pull back the header offset in case
> of an error in txdata(), which may happen in case of
> packet overload in brcmf_sdio_bus_txdata.
>
> Overloading an WLAN interface is not an unlikely scenario.
> In case of packet overload the error print "out of bus->txq"
> is very verbose. To reduce SPAM degrade it to a debug print.
>
> Signed-off-by: Per Forlin <per.forlin@gmail.com>
> ---
> Change log:
>  v2 - Add variable to know whether the counter is increased or not
>  v3 - txfinalize should decrease the counter. Adjust skb header offset
>  v4 - Fix build error
>
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c     | 4 ++++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c | 4 +++-
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c     | 2 +-
>  3 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index ed9998b..f342f7c 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -541,6 +541,9 @@ void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
>         struct ethhdr *eh;
>         u16 type;
>
> +       if (!ifp)
> +               goto free;
> +
>         eh = (struct ethhdr *)(txp->data);
>         type = ntohs(eh->h_proto);
>
> @@ -553,6 +556,7 @@ void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
>         if (!success)
>                 ifp->stats.tx_errors++;
>
> +free:
>         brcmu_pkt_buf_free_skb(txp);
>  }
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
> index f82c9ab..98cb83f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
> @@ -1899,8 +1899,10 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
>
>         if (fws->avoid_queueing) {
>                 rc = brcmf_proto_txdata(drvr, ifp->ifidx, 0, skb);
> -               if (rc < 0)
> +               if (rc < 0) {
> +                       (void)brcmf_proto_hdrpull(drvr, false, skb, &ifp);
>                         brcmf_txfinalize(ifp, skb, false);
> +               }
>                 return rc;
>         }
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index a14d9d9d..485e2ad 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -2721,7 +2721,7 @@ static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
>         *(u16 *)(pkt->cb) = 0;
>         if (!brcmf_sdio_prec_enq(&bus->txq, pkt, prec)) {
>                 skb_pull(pkt, bus->tx_hdrlen);
> -               brcmf_err("out of bus->txq !!!\n");
> +               brcmf_dbg(INFO, "out of bus->txq !!!\n");
>                 ret = -ENOSR;
>         } else {
>                 ret = 0;
> --
> 2.1.4
>
