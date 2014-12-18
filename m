Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:62913 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbaLRNoi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 08:44:38 -0500
Received: by mail-ie0-f182.google.com with SMTP id x19so1089894ier.27
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 05:44:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1418907095-10224-1-git-send-email-arend@broadcom.com>
References: <1418907095-10224-1-git-send-email-arend@broadcom.com>
Date: Thu, 18 Dec 2014 15:44:37 +0200
Message-ID: <CAB3XZEcF0r2fMD1GSw+ojWrsO7bxdxBfvQwLkZpTu4RP-iQtTg@mail.gmail.com> (sfid-20141218_144441_644565_EFBC9453)
Subject: Re: [RFC] cfg80211: Add feature flag for 4-way handshake offload
From: Eliad Peller <eliad@wizery.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Gautam Kumar Shukla <gautams@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

On Thu, Dec 18, 2014 at 2:51 PM, Arend van Spriel <arend@broadcom.com> wrote:
> From: Gautam Kumar Shukla <gautams@broadcom.com>
>
> The new feature flag allows the driver to indicate that it can
> offload the 4-way handshake for WPA/RSN-PSK. With the
> wiphy::features flag being used up this patch adds a new
> field wiphy::ext_features. Considering extensibility this
> new field is declared as a byte array.
>
> Signed-off-by: Gautam (Gautam Kumar) Shukla <gautams@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Hi Johannes,
>
> Here the proposed way to deal with new feature flags. Let
> me know if this is suitable.
>
> Regards,
> Arend
> ---

> @@ -3122,6 +3124,7 @@ struct wiphy {
>         u16 max_acl_mac_addrs;
>
>         u32 flags, regulatory_flags, features;
> +       u8 ext_features[1];
>
i think it would be nicer to use unsigned long (instead of u8) along
with BITS_TO_LONGS

>
>  /**
> + * enum nl80211_ext_feature_index - bit index of extended features.
> + *
> + * @NL80211_EXT_FEATURE_4WAY_HANDSHAKE: the device supports 4way handshake
> + */
> +enum nl80211_ext_feature_index {
> +       NL80211_EXT_FEATURE_4WAY_HANDSHAKE,
> +};

just add the standard LAST/MAX defines here, and the bitmap size will
be allocated automatically.

>
> +void cfg80211_ext_feature_set(struct wiphy *wiphy,
> +                             enum nl80211_ext_feature_index ftidx)
> +{
> +       u8 *ft_byte;
> +
> +       ft_byte = &wiphy->ext_features[ftidx / 8];
> +       *ft_byte |= BIT(ftidx % 8);
> +}
> +EXPORT_SYMBOL(cfg80211_ext_feature_set);
> +
> +bool cfg80211_ext_feature_isset(struct wiphy *wiphy,
> +                               enum nl80211_ext_feature_index ftidx)
> +{
> +       u8 ft_byte;
> +
> +       ft_byte = wiphy->ext_features[ftidx / 8];
> +       return (ft_byte & BIT(ftidx % 8)) != 0;
> +}
> +EXPORT_SYMBOL(cfg80211_ext_feature_isset);

and these (or only the implementations) could be replaced by set_bit/test_bit.

Eliad.
