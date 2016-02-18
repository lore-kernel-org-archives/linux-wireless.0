Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:35303 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946543AbcBRTCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 14:02:31 -0500
Received: by mail-ob0-f171.google.com with SMTP id xk3so82797123obc.2
        for <linux-wireless@vger.kernel.org>; Thu, 18 Feb 2016 11:02:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1455821358-37534-1-git-send-email-nbd@openwrt.org>
References: <1455821358-37534-1-git-send-email-nbd@openwrt.org>
From: Avery Pennarun <apenwarr@gmail.com>
Date: Thu, 18 Feb 2016 14:02:11 -0500
Message-ID: <CAHqTa-1-zXNfBeAb33xFzEZEnYeSVZ8whNXOWFByenJfa7QOXg@mail.gmail.com> (sfid-20160218_200238_867795_7AF5B1C8)
Subject: Re: [PATCH] mac80211: minstrel_ht: set default tx aggregation timeout
 to 0
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Acked-by: Avery Pennarun <apenwarr@gmail.com>

This fixes serious problems on our platform, especially with iPhone 4
generation devices.


On Thu, Feb 18, 2016 at 1:49 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> The value 5000 was put here with the addition of the timeout field to
> ieee80211_start_tx_ba_session. It was originally added in mac80211 to
> save resources for drivers like iwlwifi, which only supports a limited
> number of concurrent aggregation sessions.
>
> Since iwlwifi does not use minstrel_ht and other drivers don't need
> this, 0 is a better default - especially since there have been
> recent reports of aggregation setup related issues reproduced with
> ath9k. This should improve stability without causing any adverse
> effects.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  net/mac80211/rc80211_minstrel_ht.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index 3928dbd..a7d9227 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -691,7 +691,7 @@ minstrel_aggr_check(struct ieee80211_sta *pubsta, struct sk_buff *skb)
>         if (likely(sta->ampdu_mlme.tid_tx[tid]))
>                 return;
>
> -       ieee80211_start_tx_ba_session(pubsta, tid, 5000);
> +       ieee80211_start_tx_ba_session(pubsta, tid, 0);
>  }
>
>  static void
> --
> 2.2.2
>
