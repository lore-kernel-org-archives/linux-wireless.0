Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33788 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab2E3Ok4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 10:40:56 -0400
Received: by dady13 with SMTP id y13so7013179dad.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2012 07:40:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338198791-21643-1-git-send-email-sgruszka@redhat.com>
References: <1338198791-21643-1-git-send-email-sgruszka@redhat.com>
Date: Wed, 30 May 2012 16:40:55 +0200
Message-ID: <CAGXE3d9s_fj-ofmKc1e44ooJavyhtyB4zszu7MMu2dvRxsxp6Q@mail.gmail.com> (sfid-20120530_164111_915320_8F4A58B7)
Subject: Re: [PATCH] rt2x00: claim RSN IBSS support
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 28, 2012 at 11:53 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Similar like other drivers, do not configure group keys to the hardware
> (on Ad-Hoc mode) to make IBSS RSN work.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Cool, looks good to me! Thanks Stanislaw

Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    2 ++
>  drivers/net/wireless/rt2x00/rt2x00mac.c |   14 ++++++++++++--
>  2 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index e5404e5..a6b88bd 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1161,6 +1161,8 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
>                    BIT(NL80211_IFTYPE_MESH_POINT) |
>                    BIT(NL80211_IFTYPE_WDS);
>
> +       rt2x00dev->hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
> +
>        /*
>         * Initialize work.
>         */
> diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
> index b49773e..ef8b984 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
> @@ -507,9 +507,19 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>
>        if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
>                return 0;
> -       else if (!test_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags))
> +
> +       if (!test_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags))
> +               return -EOPNOTSUPP;
> +
> +       /*
> +        * To support IBSS RSN, don't program group keys in IBSS, the
> +        * hardware will then not attempt to decrypt the frames.
> +        */
> +       if (vif->type == NL80211_IFTYPE_ADHOC &&
> +           !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
>                return -EOPNOTSUPP;
> -       else if (key->keylen > 32)
> +
> +       if (key->keylen > 32)
>                return -ENOSPC;
>
>        memset(&crypto, 0, sizeof(crypto));
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
