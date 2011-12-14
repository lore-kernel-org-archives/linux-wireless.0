Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58907 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536Ab1LNQYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 11:24:07 -0500
Received: by faar15 with SMTP id r15so1340463faa.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 08:24:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323876521-21224-1-git-send-email-helmut.schaa@googlemail.com>
References: <1323876521-21224-1-git-send-email-helmut.schaa@googlemail.com>
Date: Wed, 14 Dec 2011 17:24:05 +0100
Message-ID: <CAL1gcdNW3Qypf+wNq-heUOz8jpjcrh5j7QWY6HyvHFgs==MoPw@mail.gmail.com> (sfid-20111214_172410_602848_403BA516)
Subject: Re: [PATCH] rt2x00: Make use of ieee80211_free_txskb in tx path
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ivdoorn@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 14, 2011 at 4:28 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> ieee80211_free_txskb should be used when dropping a frame in the device
> rx path such that mac80211 knows about this frame being dropped.
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00mac.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
> index 7996cd0..5889558 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
> @@ -159,7 +159,7 @@ void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>  exit_fail:
>        rt2x00queue_pause_queue(queue);
>  exit_free_skb:
> -       dev_kfree_skb_any(skb);
> +       ieee80211_free_txskb(hw, skb);
>  }
>  EXPORT_SYMBOL_GPL(rt2x00mac_tx);
>
> --
> 1.7.7
>



-- 
---
Gertjan
