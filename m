Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40568 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759551AbZJPOQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 10:16:51 -0400
Date: Fri, 16 Oct 2009 10:03:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gabriele Gristina <matrix.use.linux@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fixed injection in monitor mode
Message-ID: <20091016140347.GC4849@tuxdriver.com>
References: <1255658961.23827.2.camel@el8pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1255658961.23827.2.camel@el8pc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 16, 2009 at 04:09:21AM +0200, Gabriele Gristina wrote:
> I have a problem with mac80211 injection:
> if i setup interface in monitor mode with iwconfig and i try to send a
> custum 802.11 frame i see twice the packet in monitor interface.
> The first packet is right, the second is different only in the radiotap
> header: rtap len is fixed to 13 bytes...
> If i setup interface with airmon-ng the packet is sended once but the
> radiotap header is fixed to 13 bytes.
> 
> Patch for 2.6.31.4
> 
> --- net/mac80211/main.c.orig    2009-10-16 00:50:00.000000000 +0200
> +++ net/mac80211/main.c    2009-10-15 23:06:03.000000000 +0200
> @@ -607,6 +607,9 @@
>      skb->protocol = htons(ETH_P_802_2);
>      memset(skb->cb, 0, sizeof(skb->cb));
>  
> +    if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS))
> +        goto out_no_echo;
> +
>      rcu_read_lock();
>      list_for_each_entry_rcu(sdata, &local->interfaces, list) {
>          if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
> @@ -630,7 +633,8 @@
>          skb = NULL;
>      }
>      rcu_read_unlock();
> -    dev_kfree_skb(skb);
> +out_no_echo:
> +    if (skb) dev_kfree_skb(skb);
>  }
>  EXPORT_SYMBOL(ieee80211_tx_status);
> 

Thanks for the patch!  But I need a Signed-off-by line...

	http://linux.yyz.us/patch-format.html

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
