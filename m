Return-Path: <SRS0=FFSH=OD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DATE_IN_PAST_03_06,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A361C43441
	for <linux-wireless@archiver.kernel.org>; Sat, 24 Nov 2018 22:02:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2714B2086B
	for <linux-wireless@archiver.kernel.org>; Sat, 24 Nov 2018 22:02:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2714B2086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbeKYIwM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 25 Nov 2018 03:52:12 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:42070 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbeKYIwM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Nov 2018 03:52:12 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gQg0k-0005hd-EX; Sat, 24 Nov 2018 23:02:46 +0100
Message-ID: <3ce0f8352354900cd89074bcafe6ac45c29abd78.camel@sipsolutions.net>
Subject: Re: [PATCH] {nl,mac}80211: allow 4addr AP operation on crypto
 controlled devices
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
In-Reply-To: <1542798228-3293-1-git-send-email-mpubbise@codeaurora.org>
References: <1542798228-3293-1-git-send-email-mpubbise@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date:   Sat, 24 Nov 2018 19:48:17 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This looks good to me, just a few nits below

On Wed, 2018-11-21 at 16:33 +0530, Manikanta Pubbisetty wrote:
> As per the current design, for sw crypto controlled devices, it is
> the device which has to advertise the support for AP/VLAN iftype
> based on it's capability to tranmsit packets encrypted in software
> (In VLAN functionality, group traffic generated for a specific
> VLAN group is always encrypted in software). Commit db3bdcb9c3ff
> ("mac80211: allow AP_VLAN operation on crypto controlled devices")
> has introduced this change.
> 
> Since 4addr AP operation also uses AP/VLAN iftype, this conditional
> way of advertising AP/VLAN support has broken 4addr AP mode operation on
> crypto controlled devices which do not support VLAN functionality.
> 
> For example:
> In the case of ath10k driver, not all firmwares have support for VLAN
> functionality but all can support 4addr AP operation. Because AP/VLAN
> support is not advertised for these devices, 4addr AP operations are
> also blocked.
> 
> Fix this by allowing 4addr opertion on devices which do not advertise

operation

> AP/VLAN iftype but which can support 4addr operation (the desicion is

decision

> taken based on the wiphy flag WIPHY_FLAG_4ADDR_AP).

> Fixes: Commit db3bdcb9c3ff ("mac80211: allow AP_VLAN operation on
> crypto controlled devices")

I think it'd be better not to wrap this

> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -1394,8 +1394,13 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
>  		}
>  		break;
>  	case NETDEV_PRE_UP:
> -		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)))
> -			return notifier_from_errno(-EOPNOTSUPP);
> +		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype))) {
> +			if (!(wdev->iftype == NL80211_IFTYPE_AP_VLAN &&
> +			      rdev->wiphy.flags & WIPHY_FLAG_4ADDR_AP &&
> +			      wdev->use_4addr))
> +				return notifier_from_errno(-EOPNOTSUPP);
> +		}

Maybe that could be combined into one condition? It's kinda hard to read
either way though. I was thinking of making it positive, but then the
ERFKILL

>  		if (rfkill_blocked(rdev->rfkill))
>  			return notifier_from_errno(-ERFKILL);

would have to be _before_ it, and I'm not sure we want to change that.

So maybe make it

if (!(interface_modes & BIT() ||
      (iftype == AP_VLAN && use_4addr && wiphy.flags & 4ADDR_AP)))
	return ...(-EOPNOTSUPP);

instead?

I feel that's still easier to read than the double conditional with both
things being negated.

> +++ b/net/wireless/nl80211.c
> @@ -3383,8 +3383,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
>  	if (info->attrs[NL80211_ATTR_IFTYPE])
>  		type = nla_get_u32(info->attrs[NL80211_ATTR_IFTYPE]);
>  
> -	if (!rdev->ops->add_virtual_intf ||
> -	    !(rdev->wiphy.interface_modes & (1 << type)))
> +	if (!rdev->ops->add_virtual_intf)
>  		return -EOPNOTSUPP;
>  
>  	if ((type == NL80211_IFTYPE_P2P_DEVICE || type == NL80211_IFTYPE_NAN ||
> @@ -3403,6 +3402,13 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
>  			return err;
>  	}
>  
> +	if (!(rdev->wiphy.interface_modes & (1 << type))) {
> +		if (!(type == NL80211_IFTYPE_AP_VLAN &&
> +		      rdev->wiphy.flags & WIPHY_FLAG_4ADDR_AP &&
> +		      params.use_4addr))
> +			return -EOPNOTSUPP;
> +	}

I'm not sure you should insert this further down, rather tahn at the
place where the check was before? Why not just insert this part directly
after the piece you modified above?

johannes

