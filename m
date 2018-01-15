Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36980 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965771AbeAOM6h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 07:58:37 -0500
Message-ID: <1516021115.410.23.camel@sipsolutions.net> (sfid-20180115_135842_581886_98477B14)
Subject: Re: [RFC v2 1/5] nl80211: Add CONTROL_PORT_OVER_NL80211 attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Mon, 15 Jan 2018 13:58:35 +0100
In-Reply-To: <20180110170938.2341-2-denkenz@gmail.com> (sfid-20180110_180956_952258_12ECA7BD)
References: <20180110170938.2341-1-denkenz@gmail.com>
         <20180110170938.2341-2-denkenz@gmail.com>
         (sfid-20180110_180956_952258_12ECA7BD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-10 at 11:09 -0600, Denis Kenzior wrote:
> 
> +	WIPHY_FLAG_CONTROL_PORT_OVER_NL80211	= BIT(25),

I think it'd be easier for everyone to just use an nl80211 extended
feature flag for this, then you also don't need this code:

> +	if (info->attrs[NL80211_ATTR_CONTROL_PORT_OVER_NL80211]) {
> +		if (!info->attrs[NL80211_ATTR_SOCKET_OWNER])
> +			return -EINVAL;
> +
> +		if (!(rdev->wiphy.flags & WIPHY_FLAG_CONTROL_PORT_OVER_NL80211))
> +			return -EOPNOTSUPP;
> +
> +		settings->control_port_over_nl80211 = true;
> +	} else {
> +		settings->control_port_over_nl80211 = false;
> +	}

Nit: you don't really need the else branch.

johannes
