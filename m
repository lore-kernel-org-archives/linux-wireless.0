Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54007 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab2DSRiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 13:38:20 -0400
Received: by yenl12 with SMTP id l12so4649366yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 10:38:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1334802254-4704-1-git-send-email-thomas@cozybit.com>
References: <1334802254-4704-1-git-send-email-thomas@cozybit.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Thu, 19 Apr 2012 10:37:57 -0700
Message-ID: <CAG6hwVNpmzhbN6QbUz9Kc+hxPMqzqv9s=JP6NXUNodhaxJR3eQ@mail.gmail.com> (sfid-20120419_193825_064526_6E37396D)
Subject: Re: [PATCH 1/2] mac80211: don't set mesh peer ht caps if ht disabled
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 18, 2012 at 7:24 PM, Thomas Pedersen <thomas@cozybit.com> wrote:
> Blindly setting ht caps on a mesh peer's station entry would result in
> MCS rates being used by the rate control algorithm even if no ht had
> been configured. Fix this by checking the channel type before assigning
> ht capabilites.
>
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
>  net/mac80211/mesh_plink.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
> index c2af7b3..1ff2a5c 100644
> --- a/net/mac80211/mesh_plink.c
> +++ b/net/mac80211/mesh_plink.c
> @@ -295,7 +295,8 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
>        spin_lock_bh(&sta->lock);
>        sta->last_rx = jiffies;
>        sta->sta.supp_rates[band] = rates;
> -       if (elems->ht_cap_elem)
> +       if (elems->ht_cap_elem &&
> +           sdata->local->_oper_channel_type != NL80211_CHAN_NO_HT)
>                ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
>                                                  elems->ht_cap_elem,
>                                                  &sta->sta.ht_cap);
> --
> 1.7.5.4
>

Yikes, this obviously needs the mesh refactor series to apply.
