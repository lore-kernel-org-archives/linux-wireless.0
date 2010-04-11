Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36689 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab0DKFd5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Apr 2010 01:33:57 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 10 Apr 2010 22:33:57 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19393.24337.10019.88274@gargle.gargle.HOWL>
Date: Sun, 11 Apr 2010 11:03:05 +0530
To: "tom.leiming@gmail.com" <tom.leiming@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: [PATCH 1/3] ath9k-htc: replace __dev_alloc_skb with alloc_skb in ath9k_hif_usb_alloc_rx_urbs
In-Reply-To: <1270911887-5717-1-git-send-email-tom.leiming@gmail.com>
References: <1270911887-5717-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tom.leiming@gmail.com wrote:
> In ath9k_hif_usb_alloc_rx_urbs, ath9k-htc will pass skb->data into
> usb hcd and usb hcd will do dma mapping and unmapping to the buffer
> pointed by skb->data, so we should pass a cache-line aligned address.
> 
> This patch replace __dev_alloc_skb with alloc_skb to make skb->data
> pointed to a cacheline aligned address simply since ath9k-htc does not
> skb_push on the skb.
> 

AFAIK, the only architecture that has a requirement to override NET_SKB_PAD
is powerpc, and it does it anyway - by setting it to a cacheline size.

So why do we need to do this ?

Sujith
