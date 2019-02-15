Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D5BC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CD0B21900
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405947AbfBOKwf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 05:52:35 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:38082 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405807AbfBOKwe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 05:52:34 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gub6e-0004Yg-BU; Fri, 15 Feb 2019 11:52:32 +0100
Message-ID: <790f69239a9635c62c9349323c069e4ac9ad51c9.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 02/12] nl80211/cfg80211: Extended Key ID support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 15 Feb 2019 11:52:30 +0100
In-Reply-To: <20190210210620.31181-3-alexander@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
         <20190210210620.31181-3-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2019-02-10 at 22:06 +0100, Alexander Wetzel wrote:
> +/**
> + * enum nl80211_key_install_mode - Key install mode
> + *
> + * @NL80211_KEY_RX_TX: Key must be installed for Rx and Tx
> + * @NL80211_KEY_RX_ONLY: Allowed in combination with @NL80211_CMD_NEW_KEY:
> + *	Unicast key has to be installed for Rx only.
> + * @NL80211_KEY_SWITCH_TX: Allowed in combination with @NL80211_CMD_SET_KEY:
> + *	Switch Tx to a Rx only, referenced by sta mac and idx.

Don't you mean the other way around? Or, well, what you say is true for
the *other* keys?

>   *	by the %NL80211_SCAN_FLAG_MIN_PREQ_CONTENT flag.
>   * @NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER: Driver supports enabling fine
>   *	timing measurement responder role.
> - *

no need to remove that :)

> -	/* only support setting default key */
> -	if (!key.def && !key.defmgmt)
> +	/* Only support setting default key and
> +	 * Extended Key ID action @NL80211_KEY_SWITCH_TX.
> +	 */

you can remove the @, it's not a kernel-doc formatted comment

> -	}
> +	} else if (key.p.install_mode == NL80211_KEY_SWITCH_TX &&
> +		   wiphy_ext_feature_isset(&rdev->wiphy,
> +					   NL80211_EXT_FEATURE_EXT_KEY_ID)) {
> +		u8 *mac_addr = NULL;
>  
> +		if (info->attrs[NL80211_ATTR_MAC])
> +			mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
> +
> +		if (!mac_addr || key.idx < 0 || key.idx > 1) {
> +			err = -EINVAL;
> +			goto out;
> +		}

Really only 0 and 1 are allowed? Not 0-3?

> +++ b/net/wireless/util.c
> @@ -236,14 +236,22 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
>  	case WLAN_CIPHER_SUITE_CCMP_256:
>  	case WLAN_CIPHER_SUITE_GCMP:
>  	case WLAN_CIPHER_SUITE_GCMP_256:
> -		/* Disallow pairwise keys with non-zero index unless it's WEP
> -		 * or a vendor specific cipher (because current deployments use
> -		 * pairwise WEP keys with non-zero indices and for vendor
> -		 * specific ciphers this should be validated in the driver or
> -		 * hardware level - but 802.11i clearly specifies to use zero)
> +		/* IEEE802.11-2016 allows only 0 and - when using Extended Key
> +		 * ID - 1 as index for pairwise keys.
> +		 * @NL80211_KEY_RX_ONLY is only allowed for pairwise keys when
> +		 * the driver supports Extended Key ID.
> +		 * @NL80211_KEY_SWITCH_TX must not be set when validating a key.
>  		 */
> -		if (pairwise && key_idx)
> +		if (params->install_mode == NL80211_KEY_RX_ONLY) {
> +			if (!wiphy_ext_feature_isset(&rdev->wiphy,
> +						     NL80211_EXT_FEATURE_EXT_KEY_ID))
> +				return -EINVAL;
> +			else if (!pairwise || key_idx < 0 || key_idx > 1)
> +				return -EINVAL;

same question here

johannes

