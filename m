Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37703 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab1DZTzh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 15:55:37 -0400
Subject: Re: [PATCH 2/2] compat-wireless: use function for setting
 queue_mapping
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: mcgrof@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1303845431-972-2-git-send-email-hauke@hauke-m.de> (sfid-20110426_211805_054094_A89A532C)
References: <1303845431-972-1-git-send-email-hauke@hauke-m.de>
	 <1303845431-972-2-git-send-email-hauke@hauke-m.de>
	 (sfid-20110426_211805_054094_A89A532C)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 21:55:34 +0200
Message-ID: <1303847734.18002.0.camel@jlt3.sipsolutions.net> (sfid-20110426_215540_560448_B07759A9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-26 at 21:17 +0200, Hauke Mehrtens wrote:
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  patches/22-multiqueue.patch |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/patches/22-multiqueue.patch b/patches/22-multiqueue.patch
> index 0aa0ec6..2090320 100644
> --- a/patches/22-multiqueue.patch
> +++ b/patches/22-multiqueue.patch
> @@ -44,6 +44,17 @@ are used for injecting frames so they have their own respective queue
>  handling, but mac80211 just always sends management frames on VO
>  queue by using skb_set_queue_mapping(skb, 0) through ieee80211_tx_skb()
>  
> +--- a/drivers/net/wireless/wl12xx/main.c
> ++++ b/drivers/net/wireless/wl12xx/main.c
> +@@ -1272,7 +1272,7 @@ static struct sk_buff *wl12xx_alloc_dumm
> + 	skb->priority = WL1271_TID_MGMT;
> + 
> + 	/* Initialize all fields that might be used */
> +-	skb->queue_mapping = 0;
> ++	skb_set_queue_mapping(skb, 0);

You should submit that to the driver, it's preferred that way.

johannes

