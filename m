Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38211 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759678Ab0EDSO1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 14:14:27 -0400
Received: by pwi5 with SMTP id 5so380321pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 May 2010 11:14:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1272955622-6987-2-git-send-email-benoit.papillault@free.fr>
References: <1272955622-6987-1-git-send-email-benoit.papillault@free.fr>
	<1272955622-6987-2-git-send-email-benoit.papillault@free.fr>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 4 May 2010 11:14:07 -0700
Message-ID: <o2h43e72e891005041114sb04fbfcbl7e1f144826a02479@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: Check for channel HT capabilities in an IBSS
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 3, 2010 at 11:47 PM, Benoit Papillault
<benoit.papillault@free.fr> wrote:
> When configuring an HT IBSS, we need to check if the specified channel
> is capable of ht40+, ht40- or ht20.
>
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
> ---
>  net/wireless/nl80211.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 8da9823..0a82623 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -3858,11 +3858,11 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
>                ibss.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
>        }
>
> -       ibss.channel = ieee80211_get_channel(wiphy,
> -               nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
> +       ibss.channel = rdev_freq_to_chan(rdev,
> +               nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
> +               channel_type);
>        if (!ibss.channel ||
> -           ibss.channel->flags & IEEE80211_CHAN_NO_IBSS ||
> -           ibss.channel->flags & IEEE80211_CHAN_DISABLED) {
> +           ibss.channel->flags & IEEE80211_CHAN_NO_IBSS) {
>                err = -EINVAL;

Why is the disabled channel check being removed here?

  Luis
