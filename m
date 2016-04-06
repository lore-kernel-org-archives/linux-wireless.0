Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58609 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbcDFJjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 05:39:06 -0400
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Andrei Otcheretianski" <andrei.otcheretianski@intel.com>
Subject: Re: [PATCHv3 RESEND 05/11] cfg80211: provide a function to report a
 match for NAN
Date: Wed, 6 Apr 2016 09:38:54 +0000
Message-ID: <20160406093851.GB10595@jouni.qca.qualcomm.com> (sfid-20160406_113910_702332_AF7C8B8A)
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
 <1459244109-16038-5-git-send-email-emmanuel.grumbach@intel.com>
In-Reply-To: <1459244109-16038-5-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 29, 2016 at 12:35:03PM +0300, Emmanuel Grumbach wrote:
> Provide a function the driver can call to report a match.
> This will send the event to the user space.

> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h

> +/**
> + * struct cfg80211_nan_match_params - NAN match parameters
> + * @type: the type of the function that triggered a match. If it is
> + *	 %NL80211_NAN_FUNC_SUBSCRIBE it means that we replied to a subscriber.
> + *	 If it is %NL80211_NAN_FUNC_PUBLISH, it means that we got a discovery
> + *	 result.
> + *	 If it is %NL80211_NAN_FUNC_FOLLOW_UP, we received a follow up.

> +/**
> + * cfg80211_nan_match - report a match for a NAN function.
> + * @wdev: the wireless device reporting the match
> + * @match: match notification parameters
> + * @gfp: allocation flags
> + *
> + * This function reports that the a NAN function had a match. This
> + * can be a subscribe that had a match or a solicited publish that
> + * was sent. It can also be a follow up that was received.
> + */
> +void cfg80211_nan_match(struct wireless_dev *wdev,
> +			struct cfg80211_nan_match_params *match, gfp_t gfp);

Looks like this function is common for publish, subscribe and follow up.
If so, can we please have separate functions for publish, subscribe and
followup to match the spec primitives?

-- 
Jouni Malinen                                            PGP id EFC895FA