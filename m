Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59145 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab2LFJqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 04:46:25 -0500
Received: by mail-wg0-f46.google.com with SMTP id dr13so3609312wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 01:46:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354570539-5323-1-git-send-email-helmut.schaa@googlemail.com>
References: <1354570539-5323-1-git-send-email-helmut.schaa@googlemail.com>
Date: Thu, 6 Dec 2012 10:46:23 +0100
Message-ID: <CAGXE3d_DBCoGkiOTex0U5XjptC=4j=rbWNn8BB3XUD3884=UQw@mail.gmail.com> (sfid-20121206_104719_602561_AD3EBFF6)
Subject: Re: [PATCH] rt2x00: Only specify interface combinations if more then
 one interface is possible
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Cc: IvDoorn@gmail.com, gwingerde@gmail.com, s.l-h@gmx.de,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Forgot to CC linux-wireless.

On Mon, Dec 3, 2012 at 10:35 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Otherwise rt2500* triggers a warning in cfg80211, from net/wireless/core.c:
>
>         /* Combinations with just one interface aren't real */
>         if (WARN_ON(c->max_interfaces < 2))
>
> This was introduced in commit 55d2e9da744ba11eae900b4bfc2da72eace3c1e1:
> rt2x00: Replace open coded interface checking with interface combinations.
>
> Reported-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
> Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: stable@vger.kernel.org [3.7+]
> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 69097d1..dafb448 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1123,6 +1123,9 @@ static inline void rt2x00lib_set_if_combinations(struct rt2x00_dev *rt2x00dev)
>         struct ieee80211_iface_limit *if_limit;
>         struct ieee80211_iface_combination *if_combination;
>
> +       if (rt2x00dev->ops->max_ap_intf < 2)
> +               return;
> +
>         /*
>          * Build up AP interface limits structure.
>          */
> --
> 1.8.0
>
