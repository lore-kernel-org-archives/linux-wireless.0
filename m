Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3747 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760379AbXHMUGu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 16:06:50 -0400
Date: Mon, 13 Aug 2007 15:35:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Turn off meaningless TKIP message when  software WEP encryption is used
Message-ID: <20070813193552.GE19115@tuxdriver.com>
References: <46c0b062.yM23YNXGCQhX0Zd/%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46c0b062.yM23YNXGCQhX0Zd/%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 13, 2007 at 02:26:26PM -0500, Larry Finger wrote:

> --- wireless-legacy.orig/net/mac80211/wpa.c
> +++ wireless-legacy/net/mac80211/wpa.c
> @@ -516,9 +516,11 @@ ieee80211_rx_h_tkip_decrypt(struct ieee8
>  					  skb->len - hdrlen, rx->sta->addr,
>  					  hwaccel, rx->u.rx.queue);
>  	if (res != TKIP_DECRYPT_OK || wpa_test) {
> -		printk(KERN_DEBUG "%s: TKIP decrypt failed for RX frame from "
> -		       MAC_FMT " (res=%d)\n",
> -		       rx->dev->name, MAC_ARG(rx->sta->addr), res);
> +		if ((rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV)) {
> +			printk(KERN_DEBUG "%s: TKIP decrypt failed for RX frame from "
> +			       MAC_FMT " (res=%d)\n",
> +			       rx->dev->name, MAC_ARG(rx->sta->addr), res);
> +		}
>  		return TXRX_DROP;
>  	}

Since you are in there anyway, should this be rate limited?

John
-- 
John W. Linville
linville@tuxdriver.com
