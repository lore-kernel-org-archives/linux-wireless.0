Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57067 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab1CEOFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 09:05:24 -0500
Subject: Re: [PATCH 1/4 v2] mac80211: Enable mesh security from userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Javier Cardona <javier@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <1299288252-28314-2-git-send-email-thomas@cozybit.com>
References: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
	 <1299288252-28314-2-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Mar 2011 15:05:20 +0100
Message-ID: <1299333920.3826.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-03-04 at 17:24 -0800, Thomas Pedersen wrote:


> +#define NL80211_MESH_SETUP_VENDOR_IE NL80211_MESH_SETUP_IE

> -	NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE,
> +	NL80211_MESH_SETUP_IE,
> +	NL80211_MESH_SETUP_ENABLE_SECURITY,

Clearly the intent was to be API compatible (ABI is guaranteed anyway),
but that seems to not work this way since the names don't match.

> +	if (tb[NL80211_MESH_SETUP_IE]) {
>  		struct nlattr *ieattr =
> -			tb[NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE];
> +			tb[NL80211_MESH_SETUP_IE];
>  		if (!is_valid_ie_attr(ieattr))
>  			return -EINVAL;
> -		setup->vendor_ie = nla_data(ieattr);
> -		setup->vendor_ie_len = nla_len(ieattr);
> +		setup->ie = nla_data(ieattr);
> +		setup->ie_len = nla_len(ieattr);
> +		if (eid_in_ie_attr(ieattr, WLAN_EID_RSN))
> +			setup->is_secure =
> +			nla_get_flag(tb[NL80211_MESH_SETUP_ENABLE_SECURITY]);

That last check seems a bit pointless -- I'd trust userspace (aka allow
it to shoot itself in the foot) and not check that there's RSN
information when it says it wants security -- maybe WAPI will come up
with mesh security at some point ;-)

johannes

