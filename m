Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF56C04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 14:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B131206B7
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 14:51:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B131206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbeLEOvi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 09:51:38 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:41702 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbeLEOvi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 09:51:38 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gUYWV-0000ot-OH; Wed, 05 Dec 2018 15:51:35 +0100
Message-ID: <471c7131e4b81a06f8c514652038d69819ae66ea.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v2 1/2] nl80211/cfg80211: Add support for Extended
 Key ID
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 05 Dec 2018 15:51:34 +0100
In-Reply-To: <20181111110235.14213-2-alexander@wetzel-home.de>
References: <20181111110235.14213-1-alexander@wetzel-home.de>
         <20181111110235.14213-2-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2018-11-11 at 12:02 +0100, Alexander Wetzel wrote:
> Extend cfg80211 and nl80211 to allow pairwise keys to be installed for
> RX only, allowing to switching over TX independently, as required by
> IEEE-802.11-2016 to support "Extended Key ID for Individually Addressed
> Frames"
> 
> PTK and STK keys are now also allowed to use Key ID 1.
> 
> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
> ---
>  include/net/cfg80211.h       |  2 ++
>  include/uapi/linux/nl80211.h | 41 ++++++++++++++++++++++++++---
>  net/wireless/nl80211.c       | 51 ++++++++++++++++++++++++++++++++----
>  net/wireless/rdev-ops.h      |  3 ++-
>  net/wireless/trace.h         | 31 ++++++++++++++++++----
>  net/wireless/util.c          |  9 ++++---
>  6 files changed, 119 insertions(+), 18 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 1fa41b7a1be3..0d59340563e0 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -485,6 +485,7 @@ struct vif_params {
>   *	with the get_key() callback, must be in little endian,
>   *	length given by @seq_len.
>   * @seq_len: length of @seq.
> + * @flag: One flag from &enum key_params_flag

That should be nl80211_key_params_flag.

But if only one flag can be set, then maybe this should instead be

enum nl80211_key_install_mode install_mode;

or so?
> +/**
> + * enum key_params_flag - additional key flag for drivers
> + *
> + * Actions other than @NL80211_KEY_DEFAULT_RX_TX are only required from drivers
> + * supporting Extended Key ID for pairwise keys using keyid 0 or 1.
> + *
> + * @NL80211_KEY_DEFAULT_RX_TX: key can be immediately used for Rx and Tx
> + * @NL80211_KEY_RX_ONLY: key must be installed for Rx only
> + * @NL80211_KEY_SET_TX: switch Tx for sta to specified keyid
> + */
> +enum key_params_flag {
> +	NL80211_KEY_DEFAULT_RX_TX,
> +	NL80211_KEY_RX_ONLY,
> +	NL80211_KEY_SET_TX
> +};

Clearly those aren't flags anyway.

I guess RX_ONLY and SET_TX are mostly needed AP-side?


> + * @NL80211_ATTR_KEY_RXONLY: Flag attribute to request RX key install only for
> + *      a pairwise key. Only supported for keyid's 0 and 1 when driver is
> + *      supporting Extended Key ID.
> + *
> + * @NL80211_ATTR_KEY_SETTX: Flag attribute to switch TX to a specified keyid.
> + *      Only supported for keyid's 0 and 1 when driver is supporting Extended
> + *      Key ID.

Ok, so you have these as separate netlink flags, but then you really
shouldn't also have the "install mode" in nl80211.h, that's not related
to userspace API then.

We might discuss instead having an NL80211_ATTR_INSTALL_MODE attribute,
and that takes the values from the enum, and then you do need the enum -
but if you don't need the enum then don't define it in nl80211.h but
keep it kernel-internal in cfg80211.h (and name it appropriately).

> @@ -4312,6 +4343,8 @@ enum nl80211_key_attributes {
>  	NL80211_KEY_DEFAULT_MGMT,
>  	NL80211_KEY_TYPE,
>  	NL80211_KEY_DEFAULT_TYPES,
> +	NL80211_KEY_RXONLY,
> +	NL80211_KEY_SETTX,

Indeed if you have this, you don't need the corresponding top-level NL80211_ATTR_*?

We went through a few iterations with the API, so a lot of this is
backward compatibility stuff, you should update the latest version only.
I believe it's this one.

> - * @NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER: Driver supports enabling fine
> - *	timing measurement responder role.
> - *
>   * @NL80211_EXT_FEATURE_CAN_REPLACE_PTK0: Driver/device confirm that they are
>   *      able to rekey an in-use key correctly. Userspace must not rekey PTK keys
>   *      if this flag is not set. Ignoring this can leak clear text packets and/or
>   *      freeze the connection.
> + * @NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER: Driver supports enabling fine
> + *	timing measurement responder role.

What's going on here?

> @@ -945,6 +960,16 @@ static int nl80211_parse_key_old(struct genl_info *info, struct key_parse *k)
>  	if (k->defmgmt)

Yeah, just don't change parse_key_old, whoever wants to use this stuff
should upgrade to the new API. wpa_s has both IIRC, but of course the
old-side is ignored on newer kernels (and the new on older) so the older
stuff never needs new features.

>  		k->def_multi = true;
>  
> +	k->rx_only = !!info->attrs[NL80211_ATTR_KEY_RXONLY];
> +	k->set_tx = !!info->attrs[NL80211_ATTR_KEY_SETTX];

shouldn't this already be install_mode?

> +	/* only support setting default key and
> +	 * Extended Key ID action NL80211_KEY_SET_TX */
> +	if (!key.def && !key.defmgmt && !key.set_tx)
>  		return -EINVAL;

You need to check if extended key ID is supported

> -	}
> +	} else if (wiphy_ext_feature_isset(&rdev->wiphy,
> +					   NL80211_EXT_FEATURE_EXT_KEY_ID)) {
> +		if (info->attrs[NL80211_ATTR_MAC])
> +			mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
>  
> +		if (!mac_addr || key.idx < 0 || key.idx > 1) {
> +			err = -EOPNOTSUPP;
> +			goto out;
> +		}
> +
> +		err = rdev_add_key(rdev, dev, key.idx,
> +				   NL80211_KEYTYPE_PAIRWISE,
> +				   mac_addr, &key.p);

I think you should _parse_ all the new stuff, and then reject it, when
extended key ID support isn't there?

Though not sure I'm parsing this code correctly right now.

> +++ b/net/wireless/util.c
> @@ -236,13 +236,14 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
>  	case WLAN_CIPHER_SUITE_CCMP_256:
>  	case WLAN_CIPHER_SUITE_GCMP:
>  	case WLAN_CIPHER_SUITE_GCMP_256:
> -		/* Disallow pairwise keys with non-zero index unless it's WEP
> +		/* IEEE802.11-2016 allows only 0 and 1 for pairwise keys.
> +		 * Disallow pairwise keys with index above 1 unless it's WEP
>  		 * or a vendor specific cipher (because current deployments use
> -		 * pairwise WEP keys with non-zero indices and for vendor
> +		 * pairwise WEP keys with higher indices and for vendor
>  		 * specific ciphers this should be validated in the driver or
> -		 * hardware level - but 802.11i clearly specifies to use zero)
> +		 * hardware level.
>  		 */
> -		if (pairwise && key_idx)
> +		if (pairwise && key_idx > 1)
>  			return -EINVAL;
>  		break;

Again, only if driver support is advertised, and the comment should
probably reference the feature bit from the spec.

johannes


