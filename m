Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60359 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbcDPWL7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Apr 2016 18:11:59 -0400
Message-ID: <1460844715.2075.21.camel@sipsolutions.net> (sfid-20160417_001202_886137_87D3D9A3)
Subject: Re: [PATCH] cfg80211: Advertise extended capabilities per interface
 type to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: "Kanchanapally, Vidyullatha" <vkanchan@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	amarnath@qca.qualcomm.com, usdutt@qti.qualcomm.com
Date: Sun, 17 Apr 2016 00:11:55 +0200
In-Reply-To: <1460719669-3421-1-git-send-email-vkanchan@qti.qualcomm.com>
References: <1460719669-3421-1-git-send-email-vkanchan@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-04-15 at 16:57 +0530, Kanchanapally, Vidyullatha wrote:
> 
> +struct wiphy_iftype_ext_capab {
> +	enum nl80211_iftype iftype;
> +	const u8 *ext_capab;
> +	const u8 *ext_capab_mask;
> +	u8 ext_capab_len;

I think you should reuse the struct member names that we used before -
that will make grepping for them easier.

> +	struct wiphy_iftype_ext_capab *iftype_ext_capab;

const

> + * @NL80211_ATTR_IFTYPE_EXT_CAPA: Nested attribute of the following
> attributes:
> + *	%NL80211_ATTR_IFTYPE, %NL80211_ATTR_EXT_CAPA,
> + *	%NL80211_ATTR_EXT_CAPA_MASK, to specify the extended
> capabilities per
> + *	interface type.

That's a bit awkward to parse, since you have to parse the big
attribute list again, but I guess it still makes more sense than having
entirely different attributes.
 
> +		state->split_start++;
> +		break;
> +	case 13:
> +		if (rdev->wiphy.num_iftype_ext_capab &&
> +		    rdev->wiphy.iftype_ext_capab) {
> +			struct nlattr *nested_ext_capab, *nested;
> +
> +			nested = nla_nest_start(msg,
> +						NL80211_ATTR_IFTYPE_
> EXT_CAPA);
> +			if (!nested)
> +				goto nla_put_failure;
> +
> +			for (i = 0; i < rdev-
> >wiphy.num_iftype_ext_capab; i++) {
> +				struct wiphy_iftype_ext_capab
> *capab;
> +
> +				capab = &rdev-
> >wiphy.iftype_ext_capab[i];
> +				nested_ext_capab =
> nla_nest_start(msg, i);
> +				if (!nested_ext_capab ||
> +				    nla_put_u32(msg,
> NL80211_ATTR_IFTYPE,
> +						capab->iftype) ||
> +				    nla_put(msg,
> NL80211_ATTR_EXT_CAPA,
> +					    capab->ext_capab_len,
> +					    capab->ext_capab) ||
> +				    nla_put(msg,
> NL80211_ATTR_EXT_CAPA_MASK,
> +					    capab->ext_capab_len,
> +					    capab->ext_capab_mask))
> +					goto nla_put_failure;
> +
> +				nla_nest_end(msg, nested_ext_capab);
> +			}
> +			nla_nest_end(msg, nested);
> +		}

I think we should consider allowing this to be split multiple messages
(for different interface types), since this can potentially get rather
long (interface types x 2 x capa len). OTOH, we'd have to get a LOT of
interface types x capabilities to hit the limit of 4k, not sure. But it
should just require a few lines of code to do this.


Also, if it's possible, perhaps we should consider checking that nobody
globally advertises any capabilities they don't advertise on all
possible interface types?

I'm assuming that not listing an interface type would mean that the
global defaults apply, but old userspace will also not know about the
per-interface, so you shouldn't list anything there.

So I'm thinking something like

supported_on_all = iftype_ext_capab[0]
for i in 1..num_iftype_ext_capab-1:
    supported_on_all &= iftype_ext_capab[i]
WARN_ON(wiphy->ext_capa_mask & ~supported_on_all)

(which is obviously some kind of pseudo-code.)

johannes
