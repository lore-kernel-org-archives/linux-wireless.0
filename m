Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:62006 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbYLTVGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 16:06:43 -0500
Received: by bwz14 with SMTP id 14so5773729bwz.13
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 13:06:40 -0800 (PST)
Message-ID: <1ba2fa240812201306j5429b86fv3053e1ae65004854@mail.gmail.com> (sfid-20081220_220648_068485_07672103)
Date: Sat, 20 Dec 2008 23:06:40 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 01/16] mac80211: add HT conf helpers
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	buytenh@wantstofly.org
In-Reply-To: <1229752522-1917-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1229752522-1917-1-git-send-email-lrodriguez@atheros.com>
	 <1229752522-1917-2-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 20, 2008 at 7:55 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> In HT capable drivers you often need to check if you
> are currently using HT20 or HT40. This adds a few small
> helpers to let drivers figure that out.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  include/net/mac80211.h |   40 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 40 insertions(+), 0 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index b3bd00a..33891f9 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1963,4 +1963,44 @@ rate_lowest_index(struct ieee80211_supported_band *sband,
>  int ieee80211_rate_control_register(struct rate_control_ops *ops);
>  void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
>
> +static inline bool
> +conf_is_ht20(struct ieee80211_conf *conf)
> +{
> +       if (conf->ht.channel_type == NL80211_CHAN_HT20)

why not just
          return (conf->ht.channel_type == NL80211_CHAN_HT20);

Tomas

>
