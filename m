Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34875 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3IHGcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Sep 2013 02:32:18 -0400
Received: by mail-wi0-f170.google.com with SMTP id cb5so2251238wib.3
        for <linux-wireless@vger.kernel.org>; Sat, 07 Sep 2013 23:32:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1377582278-3768-1-git-send-email-c_duttus@qti.qualcomm.com>
References: <1377582278-3768-1-git-send-email-c_duttus@qti.qualcomm.com>
Date: Sun, 8 Sep 2013 12:02:16 +0530
Message-ID: <CACA4iOrhMhksNV78VUafCyw=Jeu++LV4BO5StQD4oVgARPCbfQ@mail.gmail.com> (sfid-20130908_083221_923403_8EB0A55B)
Subject: Re: [PATCH] cfg80211: Pass station supported channel and oper class
 info to kernel
From: Sunil Dutt <usdutt@gmail.com>
To: Sunil Dutt <c_duttus@qti.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, j@w1.fi,
	"Deepak (QCA)" <djindal@qti.qualcomm.com>,
	Ashwani <adwivedi@qti.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,
Can you please help in reviewing the patch and upstream the same.
Regards,
Sunil

On Tue, Aug 27, 2013 at 11:14 AM, Sunil Dutt <c_duttus@qti.qualcomm.com> wrote:
> The information of the peer's supported channels and supported operating
> classes are required for the driver to perform TDLS off channel
> operations. This commit enhances the function nl80211_(new)set_station
> to pass this information of the peer to the driver.
>
> Signed-off-by: Sunil Dutt <c_duttus@qti.qualcomm.com>
> ---
>  include/net/cfg80211.h       |  8 ++++++++
>  include/uapi/linux/nl80211.h |  9 +++++++++
>  net/wireless/nl80211.c       | 30 ++++++++++++++++++++++++++++++
>  3 files changed, 47 insertions(+)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 9ab7a06..81889ca 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -735,6 +735,10 @@ enum station_parameters_apply_mask {
>   * @capability: station capability
>   * @ext_capab: extended capabilities of the station
>   * @ext_capab_len: number of extended capabilities
> + * @supported_channels: supported channels in IEEE 802.11 format
> + * @supported_channels_len: number of supported channels
> + * @supported_oper_classes: supported oper classes in IEEE 802.11 format
> + * @supported_oper_classes_len: number of supported operating classes
>   */
>  struct station_parameters {
>         const u8 *supported_rates;
> @@ -754,6 +758,10 @@ struct station_parameters {
>         u16 capability;
>         const u8 *ext_capab;
>         u8 ext_capab_len;
> +       const u8 *supported_channels;
> +       u8 supported_channels_len;
> +       const u8 *supported_oper_classes;
> +       u8 supported_oper_classes_len;
>  };
>
>  /**
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 1f42bc3..61a21a4 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -1493,6 +1493,11 @@ enum nl80211_commands {
>   * @NL80211_ATTR_CSA_C_OFF_PRESP: Offset of the channel switch counter
>   *     field in the probe response (%NL80211_ATTR_PROBE_RESP).
>   *
> + * @NL80211_ATTR_STA_SUPPORTED_CHANNELS: array of supported channels.
> + *
> + * @NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES: array of supported
> + *      supported operating classes.
> + *
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
>   */
> @@ -1801,6 +1806,10 @@ enum nl80211_attrs {
>         NL80211_ATTR_CSA_C_OFF_BEACON,
>         NL80211_ATTR_CSA_C_OFF_PRESP,
>
> +       NL80211_ATTR_STA_SUPPORTED_CHANNELS,
> +
> +       NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES,
> +
>         /* add attributes here, update the policy in nl80211.c */
>
>         __NL80211_ATTR_AFTER_LAST,
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 741368c..0765b9a 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -354,6 +354,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
>         [NL80211_ATTR_CSA_IES] = { .type = NLA_NESTED },
>         [NL80211_ATTR_CSA_C_OFF_BEACON] = { .type = NLA_U16 },
>         [NL80211_ATTR_CSA_C_OFF_PRESP] = { .type = NLA_U16 },
> +       [NL80211_ATTR_STA_SUPPORTED_CHANNELS] = { .type = NLA_BINARY },
> +       [NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES] = { .type = NLA_BINARY },
>  };
>
>  /* policy for the key attributes */
> @@ -3909,6 +3911,20 @@ static int nl80211_set_station_tdls(struct genl_info *info,
>                 params->vht_capa =
>                         nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY]);
>
> +       if (info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]) {
> +               params->supported_channels =
> +                    nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]);
> +               params->supported_channels_len =
> +                    nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]);
> +       }
> +
> +       if (info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]) {
> +               params->supported_oper_classes =
> +                nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]);
> +               params->supported_oper_classes_len =
> +                 nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]);
> +       }
> +
>         return nl80211_parse_sta_wme(info, params);
>  }
>
> @@ -4089,6 +4105,20 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
>                         return -EINVAL;
>         }
>
> +       if (info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]) {
> +               params->supported_channels =
> +                    nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]);
> +               params->supported_channels_len =
> +                    nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]);
> +       }
> +
> +       if (info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]) {
> +               params->supported_oper_classes =
> +                nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]);
> +               params->supported_oper_classes_len =
> +                 nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]);
> +       }
> +
>         err = nl80211_parse_sta_wme(info, &params);
>         if (err)
>                 return err;
> --
> 1.8.2.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
