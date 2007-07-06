Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759526AbXGFDGb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2007 23:06:31 -0400
Subject: Re: [PATCH] libertas: remove adapter->radiomode
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <200707031722.29876.hs4233@mail.mn-solutions.de>
References: <200707031722.29876.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 23:11:15 -0400
Message-Id: <1183691475.24555.34.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-07-03 at 17:22 +0200, Holger Schurig wrote:
> radiomode was never initialized, so because of kzalloc() it was 0, which is
> WLAN_RADIOMODE_NONE. There was no code anywhere that would have changed this
> variable, so I killed it as well as any occurence/test for
> WLAN_RADIOMODE_RADIOTAP.

I'm going to hold off on this one too until the stuff Luis proposed gets
finalized.

Dan

> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> ---
>  drivers/net/wireless/libertas/dev.h  |    1 -
>  drivers/net/wireless/libertas/main.c |    8 +---
>  drivers/net/wireless/libertas/tx.c   |   78 +--------------------------------
>  drivers/net/wireless/libertas/wext.h |    3 -
>  4 files changed, 4 insertions(+), 86 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
> index ba31140..2ec2b9a 100644
> --- a/drivers/net/wireless/libertas/dev.h
> +++ b/drivers/net/wireless/libertas/dev.h
> @@ -379,7 +379,6 @@ struct _wlan_adapter {
>  	u32 pkttxctrl;
>  
>  	u16 txrate;
> -	u32 radiomode;
>  	u8 fw_ready;
>  
>  	u8 last_scanned_channel;
> diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
> index 1d439cd..f0c2df9 100644
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c
> @@ -512,13 +512,7 @@ static void libertas_tx_timeout(struct net_device *dev)
>  	dev->trans_start = jiffies;
>  
>  	if (priv->adapter->currenttxskb) {
> -		if (priv->adapter->radiomode == WLAN_RADIOMODE_RADIOTAP) {
> -			/* If we are here, we have not received feedback from
> -			   the previous packet.  Assume TX_FAIL and move on. */
> -			priv->adapter->eventcause = 0x01000000;
> -			libertas_send_tx_feedback(priv);
> -		} else
> -			wake_up_interruptible(&priv->waitq);
> +		wake_up_interruptible(&priv->waitq);
>  	} else if (priv->adapter->connect_status == LIBERTAS_CONNECTED) {
>  		netif_wake_queue(priv->dev);
>  		if (priv->mesh_dev)
> diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
> index a8787b0..f5f54ed 100644
> --- a/drivers/net/wireless/libertas/tx.c
> +++ b/drivers/net/wireless/libertas/tx.c
> @@ -11,44 +11,6 @@
>  #include "wext.h"
>  
>  /**
> - *  @brief This function converts Tx/Rx rates from IEEE80211_RADIOTAP_RATE
> - *  units (500 Kb/s) into Marvell WLAN format (see Table 8 in Section 3.2.1)
> - *
> - *  @param rate    Input rate
> - *  @return      Output Rate (0 if invalid)
> - */
> -static u32 convert_radiotap_rate_to_mv(u8 rate)
> -{
> -	switch (rate) {
> -	case 2:		/*   1 Mbps */
> -		return 0 | (1 << 4);
> -	case 4:		/*   2 Mbps */
> -		return 1 | (1 << 4);
> -	case 11:		/* 5.5 Mbps */
> -		return 2 | (1 << 4);
> -	case 22:		/*  11 Mbps */
> -		return 3 | (1 << 4);
> -	case 12:		/*   6 Mbps */
> -		return 4 | (1 << 4);
> -	case 18:		/*   9 Mbps */
> -		return 5 | (1 << 4);
> -	case 24:		/*  12 Mbps */
> -		return 6 | (1 << 4);
> -	case 36:		/*  18 Mbps */
> -		return 7 | (1 << 4);
> -	case 48:		/*  24 Mbps */
> -		return 8 | (1 << 4);
> -	case 72:		/*  36 Mbps */
> -		return 9 | (1 << 4);
> -	case 96:		/*  48 Mbps */
> -		return 10 | (1 << 4);
> -	case 108:		/*  54 Mbps */
> -		return 11 | (1 << 4);
> -	}
> -	return 0;
> -}
> -
> -/**
>   *  @brief This function processes a single packet and sends
>   *  to IF layer
>   *
> @@ -63,8 +25,6 @@ static int SendSinglePacket(wlan_private * priv, struct sk_buff *skb)
>  	struct txpd localtxpd;
>  	struct txpd *plocaltxpd = &localtxpd;
>  	u8 *p802x_hdr;
> -	struct tx_radiotap_hdr *pradiotap_hdr;
> -	u32 new_rate;
>  	u8 *ptr = priv->adapter->tmptxbuf;
>  
>  	lbs_deb_enter(LBS_DEB_TX);
> @@ -90,26 +50,7 @@ static int SendSinglePacket(wlan_private * priv, struct sk_buff *skb)
>  	plocaltxpd->tx_control = cpu_to_le32(adapter->pkttxctrl);
>  
>  	p802x_hdr = skb->data;
> -	if (priv->adapter->radiomode == WLAN_RADIOMODE_RADIOTAP) {
> -
> -		/* locate radiotap header */
> -		pradiotap_hdr = (struct tx_radiotap_hdr *)skb->data;
>  
> -		/* set txpd fields from the radiotap header */
> -		new_rate = convert_radiotap_rate_to_mv(pradiotap_hdr->rate);
> -		if (new_rate != 0) {
> -			/* use new tx_control[4:0] */
> -			new_rate |= (adapter->pkttxctrl & ~0x1f);
> -			plocaltxpd->tx_control = cpu_to_le32(new_rate);
> -		}
> -
> -		/* skip the radiotap header */
> -		p802x_hdr += sizeof(struct tx_radiotap_hdr);
> -		plocaltxpd->tx_packet_length =
> -			cpu_to_le16(le16_to_cpu(plocaltxpd->tx_packet_length)
> -				    - sizeof(struct tx_radiotap_hdr));
> -
> -	}
>  	/* copy destination address from 802.3 header */
>  	memcpy(plocaltxpd->tx_dest_addr_high, p802x_hdr, ETH_ALEN);
>  
> @@ -146,20 +87,8 @@ done:
>  		priv->stats.tx_errors++;
>  	}
>  
> -	if (!ret && priv->adapter->radiomode == WLAN_RADIOMODE_RADIOTAP) {
> -		/* Keep the skb to echo it back once Tx feedback is
> -		   received from FW */
> -		skb_orphan(skb);
> -		/* stop processing outgoing pkts */
> -		netif_stop_queue(priv->dev);
> -		if (priv->mesh_dev)
> -			netif_stop_queue(priv->mesh_dev);
> -		/* freeze any packets already in our queues */
> -		priv->adapter->TxLockFlag = 1;
> -	} else {
> -		dev_kfree_skb_any(skb);
> -		priv->adapter->currenttxskb = NULL;
> -	}
> +	dev_kfree_skb_any(skb);
> +	priv->adapter->currenttxskb = NULL;
>  
>  	lbs_deb_leave_args(LBS_DEB_TX, "ret %d", ret);
>  	return ret;
> @@ -254,8 +183,7 @@ void libertas_send_tx_feedback(wlan_private * priv)
>  	int txfail;
>  	int try_count;
>  
> -	if (adapter->radiomode != WLAN_RADIOMODE_RADIOTAP ||
> -	    adapter->currenttxskb == NULL)
> +	if (adapter->currenttxskb == NULL)
>  		return;
>  
>  	radiotap_hdr = (struct tx_radiotap_hdr *)adapter->currenttxskb->data;
> diff --git a/drivers/net/wireless/libertas/wext.h b/drivers/net/wireless/libertas/wext.h
> index 16ecc89..399b32b 100644
> --- a/drivers/net/wireless/libertas/wext.h
> +++ b/drivers/net/wireless/libertas/wext.h
> @@ -15,9 +15,6 @@ struct wlan_ioctl_regrdwr {
>  	u32 value;
>  };
>  
> -#define WLAN_RADIOMODE_NONE			0
> -#define WLAN_RADIOMODE_RADIOTAP			2
> -
>  extern struct iw_handler_def libertas_handler_def;
>  extern struct iw_handler_def mesh_handler_def;
>  

