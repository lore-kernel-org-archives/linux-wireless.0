Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44667 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1C3IPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 04:15:05 -0400
Subject: Re: [PATCH v5 10/10] nl80211: return mesh capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com
In-Reply-To: <1301450767-27045-11-git-send-email-thomas@cozybit.com>
References: <1301450767-27045-1-git-send-email-thomas@cozybit.com>
	 <1301450767-27045-11-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 10:15:03 +0200
Message-ID: <1301472903.3935.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-29 at 19:06 -0700, Thomas Pedersen wrote:

> +	/* report mesh capabilities */
> +	container = nla_nest_start(msg, NL80211_ATTR_MESH_CAPS);
> +	if (!container)
> +		goto nla_put_failure;
> +	for (capa = __NL80211_MESH_CAP_INVALID + 1;
> +	     capa <= NL80211_MESH_CAP_MAX; capa++)
> +		NLA_PUT_FLAG(msg, capa);
> +	nla_nest_end(msg, container);

Also, it looks like this should depend on some cfg80211 wiphy flag that
mac80211 sets, like WIPHY_FLAG_IBSS_RSN, instead of being hardcoded for
all drivers.

johannes

