Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57920 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab1CDLcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 06:32:15 -0500
Subject: Re: [PATCH 2/7] mac80211: New constant definitions for SAE
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <1299208307-9428-3-git-send-email-thomas@cozybit.com>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
	 <1299208307-9428-3-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 12:32:12 +0100
Message-ID: <1299238332.4348.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-03-03 at 19:11 -0800, Thomas Pedersen wrote:

> +++ b/include/linux/nl80211.h
> @@ -1817,6 +1817,7 @@ enum nl80211_bss_status {
>   * @NL80211_AUTHTYPE_SHARED_KEY: Shared Key authentication (WEP only)
>   * @NL80211_AUTHTYPE_FT: Fast BSS Transition (IEEE 802.11r)
>   * @NL80211_AUTHTYPE_NETWORK_EAP: Network EAP (some Cisco APs and mainly LEAP)
> + * @NL80211_AUTHTYPE_SAE: Simultaneous Authentication of Equals
>   * @__NL80211_AUTHTYPE_NUM: internal
>   * @NL80211_AUTHTYPE_MAX: maximum valid auth algorithm
>   * @NL80211_AUTHTYPE_AUTOMATIC: determine automatically (if necessary by

I think some of the auth code in nl80211 or so needs to catch this.
Maybe nl80211_valid_auth_type() wouldn't be the right place, but for now
it doesn't look like we'd be able to support this in managed mode, yet
it wouldn't get errors and at least in the cfg80211 SME fall back to
using OPEN, which is no fun.

johannes

