Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbXF3T7i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2007 15:59:38 -0400
Subject: Re: drivers/net/wireless/libertas/rx.c: use-after-free
From: Dan Williams <dcbw@redhat.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: linville@tuxdriver.com,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070629195116.GG6087@stusta.de>
References: <20070629195116.GG6087@stusta.de>
Content-Type: text/plain
Date: Sat, 30 Jun 2007 16:02:46 -0400
Message-Id: <1183233766.9150.2.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-06-29 at 21:51 +0200, Adrian Bunk wrote:
> The Coverity checker spotted the following use-after-free of "skb" in 
> drivers/net/wireless/libertas/rx.c introduced by
> commit 9012b28a407511fb355f6d2176a12d4653489672 (WTF did this commit
> with the title "libertas: make debug configurable" add the 
> "skb->protocol = __constant_htons(0x0019);" line?):

Holger, that's all you :)

dan

> <--  snip  -->
> 
> ...
> static int process_rxed_802_11_packet(wlan_private * priv, struct sk_buff *skb)
> {
> ...
>         libertas_upload_rx_packet(priv, skb);
> 
>         ret = 0;
> 
> done:
>         skb->protocol = __constant_htons(0x0019);       /* ETH_P_80211_RAW */
> ...
> 
> <--  snip  -->
> 
> 
> cu
> Adrian
> 

