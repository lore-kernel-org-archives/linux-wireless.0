Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:59690 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbYIKVgg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 17:36:36 -0400
Received: by rv-out-0506.google.com with SMTP id k40so507647rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2008 14:36:35 -0700 (PDT)
Message-ID: <2da21fe50809111436v5bf231aeo13ac0eedcb59ce75@mail.gmail.com> (sfid-20080911_233641_186940_809D27AB)
Date: Thu, 11 Sep 2008 23:36:35 +0200
From: "Davide Pesavento" <davidepesa@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix build failure
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221168191.3742.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1221168191.3742.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/9/11 Johannes Berg <johannes@sipsolutions.net>:
> The two patches
>        mac80211: share sta->supp_rates
> and
>        mac80211: share STA information with driver
>
> caused a build failure in some debugging code, this fixes it.
> Thanks to Davide Pesavento for bringing the issue to my attention.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: Davide Pesavento <davidepesa@gmail.com>
> ---
>  net/mac80211/mlme.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> --- everything.orig/net/mac80211/mlme.c 2008-09-11 23:20:53.000000000 +0200
> +++ everything/net/mac80211/mlme.c      2008-09-11 23:21:11.000000000 +0200
> @@ -1534,14 +1534,15 @@ static void ieee80211_rx_bss_info(struct
>                                ieee80211_mandatory_rates(local, band);
>
>  #ifdef CONFIG_MAC80211_IBSS_DEBUG
> -                       if (sta->supp_rates[band] != prev_rates)
> +                       if (sta->sta.supp_rates[band] != prev_rates)
>                                printk(KERN_DEBUG "%s: updated supp_rates set "
>                                    "for %s based on beacon info (0x%llx | "
>                                    "0x%llx -> 0x%llx)\n",
> -                                   sdata->dev->name, print_mac(mac, sta->addr),
> +                                   sdata->dev->name,
> +                                   print_mac(mac, sta->sta.addr),
>                                    (unsigned long long) prev_rates,
>                                    (unsigned long long) supp_rates,
> -                                   (unsigned long long) sta->supp_rates[band]);
> +                                   (unsigned long long) sta->sta.supp_rates[band]);
>  #endif
>                } else {
>                        ieee80211_ibss_add_sta(sdata, NULL, mgmt->bssid,
>
>
>

Thank you, this patch fixes the build failure I reported, but there's
another one... :P

  CC [M]  net/mac80211/tx.o
net/mac80211/tx.c: In function 'ieee80211_beacon_get':
net/mac80211/tx.c:1906: error: 'union <anonymous>' has no member named 'mesh'
make[2]: *** [net/mac80211/tx.o] Error 1
make[1]: *** [net/mac80211] Error 2
make: *** [net] Error 2
