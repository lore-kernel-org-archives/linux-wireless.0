Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34139 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab2GKIol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 04:44:41 -0400
Received: by yenl2 with SMTP id l2so953225yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jul 2012 01:44:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341984754-76477-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1341984754-76477-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Date: Wed, 11 Jul 2012 10:44:39 +0200
Message-ID: <CAAd0S9CMUVQNMsbg0Wv6DrNoyqw6H-OiGnvA8ByVgEgAd+02sw@mail.gmail.com> (sfid-20120711_104505_967290_422C3732)
Subject: Re: [PATCH v2] mwl8k: fix possible race condition in
 info->control.sta use
From: Christian Lamparter <chunkeey@googlemail.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	buytenh@wantstofly.org, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 11, 2012 at 7:32 AM, Thomas Huehn
<thomas@net.t-labs.tu-berlin.de> wrote:
> info->control.sta may only be dereferenced during the drv_tx call otherwise
> could lead to use-after-free bugs

Don"t forget many ieee80211_sta_* functions have to be called under RCU
lock and the resulting pointer is only valid under RCU lock as well.

>
> diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
> index df6c6f1..eec5cd1 100644
> --- a/drivers/net/wireless/mwl8k.c
> +++ b/drivers/net/wireless/mwl8k.c
> @@ -1667,7 +1667,8 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw,
>
>                 info = IEEE80211_SKB_CB(skb);
>                 if (ieee80211_is_data(wh->frame_control)) {

+                         rcu_read_lock();

> -                       sta = info->control.sta;
> +                       sta = ieee80211_find_sta_by_ifaddr(hw, wh->addr1,
> +                                                          wh->addr2);
>                         if (sta) {
>                                 sta_info = MWL8K_STA(sta);
>                                 BUG_ON(sta_info == NULL);
>                                 [...]
>                         }

+                         rcu_read_unlock();

Regards,
      Chr
