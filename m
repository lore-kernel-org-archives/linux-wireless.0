Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35997 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189AbcDFIvR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 04:51:17 -0400
Message-ID: <1459932671.17504.38.camel@sipsolutions.net> (sfid-20160406_105122_642807_08355C65)
Subject: Re: [PATCHv3 RESEND 05/11] cfg80211: provide a function to report a
 match for NAN
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Wed, 06 Apr 2016 10:51:11 +0200
In-Reply-To: <1459244109-16038-5-git-send-email-emmanuel.grumbach@intel.com>
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1459244109-16038-5-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-03-29 at 12:35 +0300, Emmanuel Grumbach wrote:
> 
> +/**
> + * enum nl80211_nan_match_attributes - NAN match attributes
> + * @__NL80211_NAN_MATCH_INVALID: invalid
> + * @NL80211_NAN_MATCH_FUNC_TYPE: &enum nl80211_nan_function_type
> (u8). This is
> + *	the type of the function which had a match.

> + * @NL80211_NAN_MATCH_INSTANCE_ID: The instance ID of the local
> function that
> + *	had a match. This is a u8.

It would make sense to report this using the proper
NL80211_ATTR_NAN_FUNC_INST_ID.

In a previous email I just said you can remove that, so then you'd have to do some nesting here, and then you can easily also use the FUNC_TYPE from the function attributes.

Having two sets of identical attributes is quite odd, IMHO.

> + * @NL80211_NAN_MATCH_MAC: The MAC address of the peer. This
> attribute is
> + *	binary.

This is debatable, I guess, you could also use the top-level attribute.

> +nla_put_failure:
> +	genlmsg_cancel(msg, hdr);
> +	nlmsg_free(msg);

No need to cancel before free :)

johannes
