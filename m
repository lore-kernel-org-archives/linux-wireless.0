Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:48209 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbYHOTlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 15:41:16 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1577664wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 15 Aug 2008 12:41:15 -0700 (PDT)
Message-ID: <43e72e890808151241r75a1146y525dbf6a2c441ea@mail.gmail.com> (sfid-20080815_214119_645991_A8767A3A)
Date: Fri, 15 Aug 2008 12:41:15 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jouni Malinen" <j@w1.fi>
Subject: Re: [RFC] mac80211/cfg80211: Add vif configuration options
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080815193324.GH7998@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080815193324.GH7998@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 15, 2008 at 12:33 PM, Jouni Malinen <j@w1.fi> wrote:

> @@ -1588,6 +1591,44 @@ static int nl80211_set_bss(struct sk_buf
>        return err;
>  }
>
> +static int nl80211_set_vif(struct sk_buff *skb, struct genl_info *info)
> +{
> +       struct cfg80211_registered_device *drv;
> +       int err;
> +       struct net_device *dev;
> +       struct vif_parameters params;
> +
> +       memset(&params, 0, sizeof(params));
> +       /* default to not changing parameters */
> +       params.drop_unencrypted = -1;
> +       params.userspace_mlme = -1;
> +
> +       if (info->attrs[NL80211_ATTR_VIF_DROP_UNENCRYPTED])
> +               params.userspace_mlme =

This should be params.drop_unencrypted instead right.

> +                   nla_get_u8(info->attrs[NL80211_ATTR_VIF_DROP_UNENCRYPTED]);
> +       if (info->attrs[NL80211_ATTR_VIF_USERSPACE_MLME])
> +               params.userspace_mlme =
> +                   nla_get_u8(info->attrs[NL80211_ATTR_VIF_USERSPACE_MLME]);
