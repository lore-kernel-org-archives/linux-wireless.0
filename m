Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:63047 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3IHGUq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Sep 2013 02:20:46 -0400
Received: by mail-bk0-f54.google.com with SMTP id mz12so1866798bkb.13
        for <linux-wireless@vger.kernel.org>; Sat, 07 Sep 2013 23:20:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1378408479-1025-1-git-send-email-yeohchunyeow@cozybit.com>
References: <1378408479-1025-1-git-send-email-yeohchunyeow@cozybit.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Sat, 7 Sep 2013 23:20:25 -0700
Message-ID: <CAG6hwVNn4f2J8GMgPEJiE_gf+3n26CmwSJV7+P_GG2Hopamg_g@mail.gmail.com> (sfid-20130908_082049_943911_3CF97E27)
Subject: Re: [PATCH v2] mac80211: fix the setting of extended supported rate IE
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	open11s <devel@lists.open80211s.org>,
	"distro11s@cozybit.com" <distro11s@cozybit.com>,
	Colleen Twitty <colleen@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 5, 2013 at 12:14 PM, Chun-Yeow Yeoh
<yeohchunyeow@cozybit.com> wrote:
> The patch "mac80211: select and adjust bitrates according to
> channel mode" causes regression and breaks the extended supported rate
> IE setting. Since "i" is starting with 8, so this is not necessary
> to introduce "skip" here.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
> Signed-off-by: Colleen Twitty <colleen@cozybit.com>
> Reviewed-by: Jason Abele <jason@cozybit.com>
> ---
> v2: remove skip (Jason)
>
>  net/mac80211/util.c |    3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 3c8283b..4bb639f 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -2128,14 +2128,11 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
>                 pos = skb_put(skb, exrates + 2);
>                 *pos++ = WLAN_EID_EXT_SUPP_RATES;
>                 *pos++ = exrates;
> -               skip = 0;

You could also remove the declaration then?

-- 
Thomas
