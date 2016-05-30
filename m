Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33720 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbcE3FWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2016 01:22:24 -0400
MIME-Version: 1.0
In-Reply-To: <aef84fd2cf9f2e8fc81b366c83cb38402513f5b1.1464576022.git.kirtika.ruchandani@gmail.com>
References: <cover.1464576022.git.kirtika.ruchandani@gmail.com> <aef84fd2cf9f2e8fc81b366c83cb38402513f5b1.1464576022.git.kirtika.ruchandani@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 30 May 2016 15:22:03 +1000
Message-ID: <CAGRGNgUh3Xc6iPKjOrfxKQdGUbFMKPRGSuMEg2M7U9nf7QaszA@mail.gmail.com> (sfid-20160530_072234_884064_5AF59F85)
Subject: Re: [PATCH v2 04/10] nl80211: Fix checkpatch.pl warning about braces
To: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Mon, May 30, 2016 at 12:52 PM, Kirtika Ruchandani
<kirtika.ruchandani@gmail.com> wrote:
> This patch fixes the following checkpatch,pl warning -
> - braces {} should be used on all arms of this statement.
>
> Signed-off-by: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>

Looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

Julian Calaby


> ---
>  net/wireless/nl80211.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
>
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 34b8fbe..945405d 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -870,8 +870,9 @@ nl80211_parse_connkeys(struct cfg80211_registered_device *rdev,
>                         result->def = parse.idx;
>                         if (!parse.def_uni || !parse.def_multi)
>                                 goto error;
> -               } else if (parse.defmgmt)
> +               } else if (parse.defmgmt) {
>                         goto error;
> +               }
>                 err = cfg80211_validate_key_settings(rdev, &parse.p,
>                                                      parse.idx, false, NULL);
>                 if (err)
> @@ -1401,8 +1402,9 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
>                         break;
>         case 2:
>                 if (nl80211_put_iftypes(msg, NL80211_ATTR_SUPPORTED_IFTYPES,
> -                                       rdev->wiphy.interface_modes))
> -                               goto nla_put_failure;
> +                                       rdev->wiphy.interface_modes)) {
> +                       goto nla_put_failure;
> +               }
>                 state->split_start++;
>                 if (state->split)
>                         break;
> @@ -2155,8 +2157,9 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
>                 wdev = NULL;
>                 netdev = NULL;
>                 result = 0;
> -       } else
> +       } else {
>                 wdev = netdev->ieee80211_ptr;
> +       }
>
>         /* end workaround code, by now the rdev is available
>          * and locked, and wdev may or may not be NULL.
> @@ -3403,8 +3406,9 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
>                 if (!nl80211_valid_auth_type(rdev, params.auth_type,
>                                              NL80211_CMD_START_AP))
>                         return -EINVAL;
> -       } else
> +       } else {
>                 params.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
> +       }
>
>         err = nl80211_crypto_settings(rdev, info, &params.crypto,
>                                       NL80211_MAX_NR_CIPHER_SUITES);
> @@ -3450,8 +3454,9 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
>                         return err;
>         } else if (wdev->preset_chandef.chan) {
>                 params.chandef = wdev->preset_chandef;
> -       } else if (!nl80211_get_ap_channel(rdev, &params))
> +       } else if (!nl80211_get_ap_channel(rdev, &params)) {
>                 return -EINVAL;
> +       }
>
>         if (!cfg80211_reg_can_beacon_relax(&rdev->wiphy, &params.chandef,
>                                            wdev->iftype))
> @@ -7262,8 +7267,9 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
>                         return -EINVAL;
>                 if (info->attrs[NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT])
>                         settings->control_port_no_encrypt = true;
> -       } else
> +       } else {
>                 settings->control_port_ethertype = cpu_to_be16(ETH_P_PAE);
> +       }
>
>         if (info->attrs[NL80211_ATTR_CIPHER_SUITES_PAIRWISE]) {
>                 void *data;
> @@ -7997,8 +8003,9 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
>                 if (!nl80211_valid_auth_type(rdev, connect.auth_type,
>                                              NL80211_CMD_CONNECT))
>                         return -EINVAL;
> -       } else
> +       } else {
>                 connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
> +       }
>
>         connect.privacy = info->attrs[NL80211_ATTR_PRIVACY];
>
> --
> 2.8.0.rc3.226.g39d4020
>



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
