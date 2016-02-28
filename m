Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33433 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218AbcB1Lf5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2016 06:35:57 -0500
Received: by mail-io0-f195.google.com with SMTP id g203so11774150iof.0
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2016 03:35:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456520364-6275-1-git-send-email-arend@broadcom.com>
References: <1456520364-6275-1-git-send-email-arend@broadcom.com>
Date: Sun, 28 Feb 2016 13:35:56 +0200
Message-ID: <CAB3XZEfO2RvN-YDN8Sf18AK2EvV=rYdVndhUYwnkni3Gp0Ok2A@mail.gmail.com> (sfid-20160228_123608_516793_CA4961E3)
Subject: Re: [PATCH V9 1/2] nl80211: add feature for BSS selection support
From: Eliad Peller <eliad@wizery.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Arend,

On Fri, Feb 26, 2016 at 10:59 PM, Arend van Spriel <arend@broadcom.com> wrote:
> Introducing a new feature that the driver can use to
> indicate the driver/firmware supports configuration of BSS
> selection criteria upon CONNECT command. This can be useful
> when multiple BSS-es are found belonging to the same ESS,
> ie. Infra-BSS with same SSID. The criteria can then be used to
> offload selection of a preferred BSS.
>
[...]

>
> +/**
> + * struct nl80211_bss_select_rssi_adjust - RSSI adjustment parameters.
> + *
> + * @band: band of BSS that must match for RSSI value adjustment.
> + * @delta: value used to adjust the RSSI value of matching BSS.
> + */
> +struct nl80211_bss_select_rssi_adjust {
> +       enum nl80211_band band;
> +       __s8 delta;
> +} __attribute__((packed));
> +
i think enum can't be considered as fixed-size field, so better use u8 or so.

> @@ -626,6 +626,10 @@ int wiphy_register(struct wiphy *wiphy)
>                      !rdev->ops->set_mac_acl)))
>                 return -EINVAL;
>
> +       if (WARN_ON(wiphy->bss_select_support &&
> +                   (wiphy->bss_select_support & ~(BIT(__NL80211_BSS_SELECT_ATTR_AFTER_LAST) - 2))))
> +               return -EINVAL;
> +
worth noting that the "-2" counts for the invalid enum value (at least
it wasn't clear to me)

> @@ -7995,6 +8086,21 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
>                 return -EOPNOTSUPP;
>         }
>
> +       /* only do bss selection when no BSSID is specified. */
> +       if (!connect.bssid && wiphy->bss_select_support &&
> +           info->attrs[NL80211_ATTR_BSS_SELECT]) {

you don't have to check wiphy->bss_select_support here - we actually
want to fail if NL80211_ATTR_BSS_SELECT was given although the driver
doesn't support it.

> +               err = parse_bss_select(info->attrs[NL80211_ATTR_BSS_SELECT],
> +                                      wiphy, &connect.bss_select);
> +               if (err) {
> +                       kzfree(connkeys);
> +                       return err;
> +               }
> +               if (!(wiphy->bss_select_support & BIT(connect.bss_select.behaviour))) {

(it will fail here instead)

Eliad.
