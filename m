Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C355C43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 09:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 153C6206BA
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 09:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfDZJhi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 05:37:38 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54414 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfDZJhg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 05:37:36 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hJxIT-0007qn-8m; Fri, 26 Apr 2019 11:37:33 +0200
Message-ID: <d9135c6be42425424e4c3fd606c7e5aaf9dac1e9.camel@sipsolutions.net>
Subject: Re: [PATCHv5 5/9] nl80211: Add netlink attribute to configure TID
 specific tx rate
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Tamizh chelvam <tamizhr@codeaurora.org>, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 26 Apr 2019 11:37:32 +0200
In-Reply-To: <1553592550-15282-6-git-send-email-tamizhr@codeaurora.org>
References: <1553592550-15282-1-git-send-email-tamizhr@codeaurora.org>
         <1553592550-15282-6-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> @@ -13354,6 +13367,42 @@ static int parse_tid_conf(struct cfg80211_registered_device *rdev,
>  			nla_get_u8(attrs[NL80211_ATTR_TID_CONFIG_RTSCTS_CTRL]);
>  	}
>  
> +	if (attrs[NL80211_ATTR_TID_CONFIG_TX_RATES_TYPE]) {
> +		int idx;
> +		enum nl80211_attrs attr;
> +
> +		if (!wiphy_ext_feature_isset(&rdev->wiphy,
> +				NL80211_EXT_FEATURE_PER_TID_TX_BITRATE_MASK))
> +			return -EOPNOTSUPP;
> +
> +		if (peer &&
> +		    !wiphy_ext_feature_isset(&rdev->wiphy,
> +				NL80211_EXT_FEATURE_PER_STA_TX_BITRATE_MASK))
> +			return -EOPNOTSUPP;
> +
> +		idx = NL80211_ATTR_TID_CONFIG_TX_RATES_TYPE;
> +		tid_conf->txrate_type = nla_get_u8(attrs[idx]);
> +
> +		tid_conf->tid_conf_mask |= IEEE80211_TID_CONF_TX_BITRATE;
> +		if (tid_conf->txrate_type != NL80211_TX_RATE_AUTOMATIC) {
> +			tid_conf->mask =
> +				kzalloc(sizeof(struct cfg80211_bitrate_mask),
> +					GFP_KERNEL);

You leak this

> +			if (!tid_conf->mask)
> +				return -ENOMEM;
> +
> +			attr = NL80211_ATTR_TID_CONFIG_TX_RATES;
> +			ret = nl80211_parse_tx_bitrate_mask(attrs, rdev, attr,
> +							    tid_conf->mask);
> +			if (ret) {
> +				kfree(tid_conf->mask);
> +				return ret;
> +			}
> +		} else {
> +			tid_conf->mask = NULL;
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> @@ -13407,7 +13456,7 @@ static int nl80211_set_tid_config(struct sk_buff *skb,
>  		}
>  
>  		ret = parse_tid_conf(rdev, attrs, &tid_conf->tid_conf[conf_idx],
> -				     tid_conf->peer);
> +				     info, tid_conf->peer);
>  		if (ret)
>  			goto bad_tid_conf;

Practically everywhere, but particularly in the bad case in the next
loop iteration etc?

johannes

