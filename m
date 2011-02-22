Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:58580 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736Ab1BVM1T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Feb 2011 07:27:19 -0500
Received: by mail-vx0-f170.google.com with SMTP id 39so1760257vxb.29
        for <linux-wireless@vger.kernel.org>; Tue, 22 Feb 2011 04:27:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297778837.8664.0.camel@jlt3.sipsolutions.net>
References: <1297778837.8664.0.camel@jlt3.sipsolutions.net>
Date: Tue, 22 Feb 2011 14:27:18 +0200
Message-ID: <AANLkTi=upFyQWB6oJ1mtAuaWGCtaK3FzJNP7YBTP8fPF@mail.gmail.com>
Subject: Re: [RFC/RFT] mac80211: make tx() operation return void
From: "Coelho, Luciano" <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 15, 2011 at 4:07 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> --- wireless-testing.orig/drivers/net/wireless/wl12xx/main.c    2011-02-15 13:53:38.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/wl12xx/main.c 2011-02-15 13:55:02.000000000 +0100
> @@ -975,7 +975,7 @@ int wl1271_plt_stop(struct wl1271 *wl)
>        return ret;
>  }
>
> -static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
> +static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>  {
>        struct wl1271 *wl = hw->priv;
>        unsigned long flags;
> @@ -1009,8 +1009,6 @@ static int wl1271_op_tx(struct ieee80211
>                set_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags);
>                spin_unlock_irqrestore(&wl->wl_lock, flags);
>        }
> -
> -       return NETDEV_TX_OK;
>  }

For the wl12xx part:

Acked-by: Luciano Coelho <coelho@ti.com>

-- 
Cheers,
Luca.
