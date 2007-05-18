Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3672 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944AbXERSCv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 14:02:51 -0400
Date: Fri, 18 May 2007 13:46:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Eugene Teo <eteo@redhat.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
	linux-wireless@vger.kernel.org, Florin Malita <fmalita@gmail.com>
Subject: Re: [2.6 patch] drivers/net/wireless/libertas/rx.c: fix use-after-free
Message-ID: <20070518174623.GA3492@tuxdriver.com>
References: <464DD957.9040803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <464DD957.9040803@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First, please send all wireless patches to
linux-wireless@vger.kernel.org, and be sure to CC me as well...thanks!

On Sat, May 19, 2007 at 12:50:31AM +0800, Eugene Teo wrote:
> libertas_upload_rx_packet() calls netif_rx() before returning, and it always return 0.
> Also within libertas_upload_rx_packet(), it will initialize skb->protocol anyways.
> 
> Spotted by the Coverity checker.

A nearly identical patch was posted by Florin Malita <fmalita@gmail.com>
to netdev (also the wrong list) on Wednesday evening.

>  done:
>         LEAVE();
> 
> -       skb->protocol = __constant_htons(0x0019);       /* ETH_P_80211_RAW */
> -

Except for this part...is this intentional?

John
-- 
John W. Linville
linville@tuxdriver.com
