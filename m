Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48050 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab2GWRHX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 13:07:23 -0400
Received: by bkwj10 with SMTP id j10so5519222bkw.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2012 10:07:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343016370-31163-1-git-send-email-yeohchunyeow@gmail.com>
References: <1343016370-31163-1-git-send-email-yeohchunyeow@gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 23 Jul 2012 10:07:01 -0700
Message-ID: <CAG6hwVPjvSVWwR3LqRkL5_XvuQe=bK2QPL+niaYUK6hH3gbH4Q@mail.gmail.com> (sfid-20120723_190726_663155_2B546FF9)
Subject: Re: [PATCH v2] mac80211: add extra checking for RC init upon
 receiving mesh beacon
To: devel@lists.open80211s.org
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chun-Yeow,

> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
> index 4256859..a73741c 100644
> --- a/net/mac80211/mesh_plink.c
> +++ b/net/mac80211/mesh_plink.c
> @@ -359,6 +359,9 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
>                 insert = true;
>         }
>
> +       if (sta->plink_state == NL80211_PLINK_ESTAB)
> +               return sta;
> +

Please keep updating sta->last_rx.

>         spin_lock_bh(&sta->lock);
>         sta->last_rx = jiffies;
>         sta->sta.supp_rates[band] = rates;

Thomas
