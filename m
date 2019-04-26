Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0F7C43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 09:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5982B2077B
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 09:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfDZJ2X (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 05:28:23 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54144 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfDZJ2X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 05:28:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hJx9W-0007bP-T7; Fri, 26 Apr 2019 11:28:18 +0200
Message-ID: <b90f20a45af63a3261ee14eda38239521dce6486.camel@sipsolutions.net>
Subject: Re: [PATCHv5 1/9] nl80211: New netlink command for TID specific
 configuration
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Tamizh chelvam <tamizhr@codeaurora.org>, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 26 Apr 2019 11:28:17 +0200
In-Reply-To: <1553592550-15282-2-git-send-email-tamizhr@codeaurora.org>
References: <1553592550-15282-1-git-send-email-tamizhr@codeaurora.org>
         <1553592550-15282-2-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Sorry, I apologize for taking so long to review this (again).

> +enum ieee80211_tid_conf_mask {
> +	IEEE80211_TID_CONF_NOACK	= BIT(0),
> +};
> +
> +/**
> + * struct ieee80211_tid_cfg - TID specific configuration
> + * @tid: TID number
> + * @tid_conf_mask: bitmap indicating which parameter changed
> + *	see %enum ieee80211_tid_conf_mask
> + * @noack: noack configuration value for the TID
> + */
> +struct ieee80211_tid_cfg {
> +	u8 tid;
> +	enum ieee80211_tid_conf_mask tid_conf_mask;

This shouldn't use the enum type if it's a bitmap. Doing the enum type
above is only useful for documentation, which you should add there.

> + * @set_tid_config: TID specific configuration. Apply this configuration for
> + *	all the connected stations in the BSS if peer is NULL. Otherwise

%NULL renders better, IIRC

> + * @NL80211_ATTR_TID_CONFIG: TID specific configuration in a
> + *	nested attribute with %NL80211_ATTR_TID_* sub-attributes.

Please use NL80211_TID_ATTR_* to disambiguate the namespaces

> +enum nl80211_tid_config {
> +	NL80211_TID_CONFIG_DEFAULT,
> +	NL80211_TID_CONFIG_ENABLE,
> +	NL80211_TID_CONFIG_DISABLE,
> +};


That could do with some documentation

> +
> +/* enum nl80211_attr_tid_config - TID specific configuration.
> + * @NL80211_ATTR_TID_CONFIG_TID: a TID value (u8 attribute).

See above - TID_ATTR_* is better.

> + * @NL80211_ATTR_TID_CONFIG_NOACK: Configure ack policy for the TID.
> + *	specified in %NL80211_ATTR_TID_CONFIG_TID. see %enum nl80211_tid_config.
> + *	Its type is u8, if the peer MAC address is passed in %NL80211_ATTR_MAC,
> + *	then the noack configuration is applied to the data frame for the tid
> + *	to that connected station. This configuration is valid only for STA's
> + *      current connection. i.e. the configuration will be reset to default when
> + *      the station connects back after disconnection/roaming.
> + *      when user-space does not include %NL80211_ATTR_MAC, then this

please use tabs consistently

> + *	configuration should be treated as per-netdev configuration.
> + *	This configuration will be cleared when the interface goes down and on
> + *	the disconnection from a BSS. 

"goes down" is redundant then? Or do you mean that's for the AP case?

> +static const struct nla_policy
> +nl80211_attr_tid_config_policy[NL80211_ATTR_TID_CONFIG_MAX + 1] = {
> +	[NL80211_ATTR_TID_CONFIG_TID] = { .type = NLA_U8 },

Shouldn't this use NLA_POLICY_RANGE() or MAX()?

> +	[NL80211_ATTR_TID_CONFIG_NOACK] =
> +			NLA_POLICY_MAX(NLA_U8, NL80211_TID_CONFIG_DISABLE),
> +};
> +
>  const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
>  	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
>  	[NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
> @@ -541,6 +548,8 @@ static int validate_ie_attr(const struct nlattr *attr,
>  	[NL80211_ATTR_PEER_MEASUREMENTS] =
>  		NLA_POLICY_NESTED(nl80211_pmsr_attr_policy),
>  	[NL80211_ATTR_AIRTIME_WEIGHT] = NLA_POLICY_MIN(NLA_U16, 1),
> +	[NL80211_ATTR_TID_CONFIG] =
> +			NLA_POLICY_NESTED(nl80211_attr_tid_config_policy),
>  };

Great! :-)

>  /* policy for the key attributes */
> @@ -13259,6 +13268,93 @@ static int nl80211_get_ftm_responder_stats(struct sk_buff *skb,
>  	return -ENOBUFS;
>  }
>  
> +static int parse_tid_conf(struct cfg80211_registered_device *rdev,
> +			  struct nlattr *attrs[],
> +			  struct ieee80211_tid_cfg *tid_conf,
> +			  const u8 *peer)
> +{
> +	tid_conf->tid = nla_get_u8(attrs[NL80211_ATTR_TID_CONFIG_TID]);

You need to check that this is even present!

> +	size_of_conf = sizeof(struct ieee80211_tid_config) +
> +		num_conf * sizeof(struct ieee80211_tid_cfg);

use struct_size()

> +	tid_conf = kzalloc(size_of_conf, GFP_KERNEL);
> +	if (!tid_conf)
> +		return -ENOMEM;
> +
> +	tid_conf->n_tid_conf = num_conf;
> +
> +	if (info->attrs[NL80211_ATTR_MAC])
> +		tid_conf->peer = nla_data(info->attrs[NL80211_ATTR_MAC]);
> +	else
> +		tid_conf->peer = NULL;

No need to initialize to NULL after kzalloc()

> +	nla_for_each_nested(tid, info->attrs[NL80211_ATTR_TID_CONFIG],
> +			    rem_conf) {
> +		ret = nla_parse_nested(attrs, NL80211_ATTR_TID_CONFIG_MAX, tid,
> +				       NULL, NULL);
> +
> +		if (ret)
> +			goto bad_tid_conf;
> +
> +		if (!attrs[NL80211_ATTR_TID_CONFIG_TID]) {
> +			ret = -EINVAL;
> +			goto bad_tid_conf;
> +		}

Oh, you check here. Perhaps easier to do inside though?

> +	{
> +		.cmd = NL80211_CMD_SET_TID_CONFIG,
> +		.doit = nl80211_set_tid_config,
> +		.policy = nl80211_policy,

The .policy field no longer exists.

johannes

