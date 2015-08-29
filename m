Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:34649 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbbH2RLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Aug 2015 13:11:05 -0400
Received: by iofe124 with SMTP id e124so56725178iof.1
        for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2015 10:11:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1440673024-13696-4-git-send-email-me@bobcopeland.com>
References: <1440673024-13696-1-git-send-email-me@bobcopeland.com>
	<1440673024-13696-4-git-send-email-me@bobcopeland.com>
Date: Sat, 29 Aug 2015 13:11:03 -0400
Message-ID: <CAKf6xpsaygeFJyX_LKH2r82P2Xvih1GGBTAspKtCsZbBcVO9Ug@mail.gmail.com> (sfid-20150829_191109_298428_A5BC1B02)
Subject: Re: [PATCH 3/3] ath10k: implement mesh support
From: Jason Andryuk <jandryuk@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 27, 2015 at 6:57 AM, Bob Copeland <me@bobcopeland.com> wrote:
> @@ -1117,6 +1120,15 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
>         ar->htt.max_num_amsdu = ATH10K_HTT_MAX_NUM_AMSDU_DEFAULT;
>         ar->htt.max_num_ampdu = ATH10K_HTT_MAX_NUM_AMPDU_DEFAULT;
>
> +       if (rawmode) {
> +               if (!test_bit(ATH10K_FW_FEATURE_RAW_MODE_SUPPORT,
> +                             ar->fw_features)) {
> +                       ath10k_err(ar, "rawmode = 1 requires support from firmware");
> +                       return -EINVAL;
> +               }
> +               set_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags);
> +       }
> +

Is there a reason to hide rawmode behind a modparam, or should the
modparam just be removed?  Just let the driver set
ATH10K_FLAG_RAW_MODE when ATH10K_FW_FEATURE_RAW_MODE_SUPPORT is
detected?

> @@ -6708,7 +6729,8 @@ static const struct ieee80211_iface_limit ath10k_tlv_qcs_if_limit[] = {
>         {
>                 .max = 1,
>                 .types = BIT(NL80211_IFTYPE_AP) |
> -                        BIT(NL80211_IFTYPE_P2P_GO),
> +                        BIT(NL80211_IFTYPE_P2P_GO) |
> +                        BIT(NL80211_IFTYPE_MESH_POINT),
>         },
>         {
>                 .max = 1,

Does struct ieee80211_iface_limit need to be conditional on firmware
support as well or does interface_modes (below) gate use of
MESH_POINT?

> @@ -6998,7 +7020,8 @@ int ath10k_mac_register(struct ath10k *ar)
>
>         ar->hw->wiphy->interface_modes =
>                 BIT(NL80211_IFTYPE_STATION) |
> -               BIT(NL80211_IFTYPE_AP);
> +               BIT(NL80211_IFTYPE_AP) |
> +               BIT(NL80211_IFTYPE_MESH_POINT);

Set BIT(NL80211_IFTYPE_MESH_POINT) conditionally if ATH10K_FLAG_RAW_MODE is set?

Regards,
Jason
