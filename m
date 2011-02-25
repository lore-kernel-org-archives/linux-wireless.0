Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38219 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620Ab1BYUrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 15:47:16 -0500
Subject: Re: [PATCH] at76c50x-usb: fix warning caused by at76_mac80211_tx
 now returning void
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1298666447-30028-1-git-send-email-linville@tuxdriver.com>
References: <1298666447-30028-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 21:47:14 +0100
Message-ID: <1298666834.4329.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-25 at 15:40 -0500, John W. Linville wrote:
> CC [M]  drivers/net/wireless/at76c50x-usb.o
> drivers/net/wireless/at76c50x-usb.c: In function ‘at76_mac80211_tx’:
> drivers/net/wireless/at76c50x-usb.c:1759:4: warning: ‘return’ with a value, in function returning void
> 
> This is fallout from commit 7bb4568372856688bc070917265bce0b88bb7d4d
> ("mac80211: make tx() operation return void").
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/at76c50x-usb.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
> index 10b4393..a37c93b 100644
> --- a/drivers/net/wireless/at76c50x-usb.c
> +++ b/drivers/net/wireless/at76c50x-usb.c
> @@ -1756,7 +1756,6 @@ static void at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>  		if (compare_ether_addr(priv->bssid, mgmt->bssid)) {
>  			memcpy(priv->bssid, mgmt->bssid, ETH_ALEN);
>  			ieee80211_queue_work(hw, &priv->work_join_bssid);
> -			return NETDEV_TX_BUSY;

I guess I missed this one -- bit it needs to free the SKB otherwise it
probably leaks.

johannes

