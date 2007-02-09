Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:33533 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992447AbXBIRPW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 12:15:22 -0500
Date: Fri, 9 Feb 2007 18:15:13 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: remove hosttime from ieee80211_rx_status
Message-ID: <20070209181513.66fdec56@griffin.suse.cz>
In-Reply-To: <200702091056.46679.flamingice@sourmilk.net>
References: <200702082359.47085.flamingice@sourmilk.net>
	<200702090650.11910.mb@bu3sch.de>
	<200702091056.46679.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 9 Feb 2007 10:56:42 -0500, Michael Wu wrote:
> @@ -4096,13 +4084,12 @@ static void ieee80211_tasklet_handler(un
>  	       (skb = skb_dequeue(&local->skb_queue_unreliable))) {
>                  switch (skb->pkt_type) {
>  		case ieee80211_rx_msg:
> -			/* get pointer to saved status out of skb->cb */
> -			memcpy(&rx_status, skb->cb, sizeof(rx_status));
> +			/* status is in skb->cb */
> +			rx_status = (struct ieee80211_rx_status *) skb->cb;
>  			/* Clear skb->type in order to not confuse kernel
>  			 * netstack. */
>  			skb->pkt_type = 0;
>  			__ieee80211_rx(local_to_hw(local), skb, rx_status);

Uh, sorry, I haven't noticed it before: you should copy cb to a local
rx_status structure as __ieee80211_rx is allowed to destroy the skb,
yet it still needs the rx_status.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
