Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3222 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911AbXERScw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 14:32:52 -0400
Date: Fri, 18 May 2007 14:09:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Florin Malita <fmalita@gmail.com>
Cc: marcelo@kvack.org, linville@redhat.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: skb dereferenced after netif_rx
Message-ID: <20070518180903.GC3492@tuxdriver.com>
References: <464B7127.5080502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <464B7127.5080502@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 16, 2007 at 05:01:27PM -0400, Florin Malita wrote:
> In libertas_process_rxed_packet() and process_rxed_802_11_packet() the 
> skb is dereferenced after being passed to netif_rx (called from 
> libertas_upload_rx_packet). Spotted by Coverity (1658, 1659).
 
Relocating the libertas_upload_rx_packet call is fine, but...

> Also, libertas_upload_rx_packet() unconditionally returns 0 so the error 
> check is dead code - might as well take it out.

Is this merely an implementation detail?  Or an absolute fact?
If the former is true, then we should preserve the error
checking.  If the latter, then we should change the signature of
libertas_upload_rx_packet to return void.

> Signed-off-by: Florin Malita <fmalita@gmail.com>

> 	lbs_pr_debug(1, "RX Data: size of actual packet = %d\n", skb->len);
> -	if (libertas_upload_rx_packet(priv, skb)) {
> -		lbs_pr_debug(1, "RX error: libertas_upload_rx_packet"
> -		       " returns failure\n");
> -		ret = -1;
> -		goto done;
> -	}
> 	priv->stats.rx_bytes += skb->len;
> 	priv->stats.rx_packets++;
> 
> +	libertas_upload_rx_packet(priv, skb);
> +
> 	ret = 0;
> done:
> 	LEAVE();

Another potential patch is to remove the "ret = 0" line before the
"done" label, since ret is initialized at the head of the function.
Come to think of it, you can probably remove the "= 0" part of ret's
declaration as well (in both functions).

Hth!

John

P.S.  Also, please make sure to send wireless patches to
linux-wireless@vger.kernel.org and CC me.
-- 
John W. Linville
linville@tuxdriver.com
