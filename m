Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.189]:64077 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbYDIPu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 11:50:27 -0400
Received: by mu-out-0910.google.com with SMTP id i10so3605515mue.5
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2008 08:50:25 -0700 (PDT)
To: Daniel Wagner <wagi@monom.org>
Subject: Re: [PATCH] rt61pci: rt61pci_beacon_update do not free skb twice
Date: Wed, 9 Apr 2008 17:47:49 +0200
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <> <1207751341-27611-1-git-send-email-wagi@monom.org>
In-Reply-To: <1207751341-27611-1-git-send-email-wagi@monom.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804091747.50724.IvDoorn@gmail.com> (sfid-20080409_165031_692887_8AF77C37)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 April 2008, Daniel Wagner wrote:
> The layer above will free the skb in an error case.
> 
> Signed-off-by: Daniel Wagner <wagi@monom.org>

Daniel: Please CC me for rt2x00 related patches.
John: Please queue this for 2.6.25 as well.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt61pci.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index 1cb056b..468a31c 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -2379,10 +2379,8 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
>  	 */
>  	if (skb_headroom(skb) < intf->beacon->queue->desc_size) {
>  		if (pskb_expand_head(skb, intf->beacon->queue->desc_size,
> -				     0, GFP_ATOMIC)) {
> -			dev_kfree_skb(skb);
> +				     0, GFP_ATOMIC))
>  			return -ENOMEM;
> -		}
>  	}
>  
>  	/*


