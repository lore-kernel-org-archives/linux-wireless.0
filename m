Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47594 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751599AbcJZFgc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 01:36:32 -0400
Message-ID: <1477460187.4059.4.camel@sipsolutions.net> (sfid-20161026_073635_908431_D63162EE)
Subject: Re: [PATCH 5/8] cfg80211: Add KEK/nonces for FILS association frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 26 Oct 2016 07:36:27 +0200
In-Reply-To: <1477435489-8555-1-git-send-email-jouni@qca.qualcomm.com>
References: <1477435489-8555-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +++ b/net/wireless/nl80211.c
> @@ -414,6 +414,10 @@ enum nl80211_multicast_groups {
>  	[NL80211_ATTR_NAN_MASTER_PREF] = { .type = NLA_U8 },
>  	[NL80211_ATTR_NAN_DUAL] = { .type = NLA_U8 },
>  	[NL80211_ATTR_NAN_FUNC] = { .type = NLA_NESTED },
> +	[NL80211_ATTR_FILS_KEK] = { .type = NLA_BINARY,
> +				    .len = FILS_MAX_KEK_LEN },
> +	[NL80211_ATTR_FILS_NONCES] = { .type = NLA_BINARY,
> +				       .len = 2 * FILS_NONCE_LEN },
>  };

If you remove the type = NLA_BINARY and just leave the type zero, then
you'll get *minimum* length validation, rather than limiting the
maximum length. That seems more appropriate for the nonces?

> +	if (info->attrs[NL80211_ATTR_FILS_NONCES]) {
> +		if (nla_len(info->attrs[NL80211_ATTR_FILS_NONCES])
> !=
> +		    2 * FILS_NONCE_LEN)
> +			return -EINVAL;

You're validating the *exact* length here, which unfortunately nlattr
doesn't support right now, but perhaps we can live with checking that
it's at least that many bytes, and using only 2*nonces? We do that for
most other attributes (like MAC addresses).

Or do we expect to extend this to more than 2 nonces in the future, at
which point we'll need the length?

johannes
