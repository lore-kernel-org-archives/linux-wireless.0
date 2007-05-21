Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3907 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459AbXEUOC5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2007 10:02:57 -0400
Date: Mon, 21 May 2007 09:31:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Eugene Teo <eteo@redhat.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	jeff@garzik.org, Florin Malita <fmalita@gmail.com>
Subject: Re: [2.6 patch] drivers/net/wireless/libertas/rx.c: fix use-after-free
Message-ID: <20070521133124.GB9621@tuxdriver.com>
References: <464DD957.9040803@redhat.com> <20070518174623.GA3492@tuxdriver.com> <464E6B82.40607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <464E6B82.40607@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 19, 2007 at 11:14:10AM +0800, Eugene Teo wrote:
> John W. Linville wrote:

> >>  done:
> >>         LEAVE();
> >>
> >> -       skb->protocol = __constant_htons(0x0019);       /* ETH_P_80211_RAW */
> >> -
> > 
> > Except for this part...is this intentional?
> 
> skb could have been freed by then. And, in libertas_upload_rx_packet(), skb->protocol
> is initialized by eth_type_trans(skb, priv->wlan_dev.netdev).

OK, I see that.  Looks like Florin has reposted his patch, still
without this hunk.  Would you like to submit a patch for this hunk?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
