Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34922 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753261AbcKUNYr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 08:24:47 -0500
Message-ID: <1479734683.8662.27.camel@sipsolutions.net> (sfid-20161121_142453_637219_9DD5C64B)
Subject: Re: [PATCH v7 2/2] mac80211: multicast to unicast conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        projekt-wlan@fem.tu-ilmenau.de
Date: Mon, 21 Nov 2016 14:24:43 +0100
In-Reply-To: <1477921260-24556-2-git-send-email-michael-dev@fami-braun.de>
References: <1477921260-24556-1-git-send-email-michael-dev@fami-braun.de>
         <1477921260-24556-2-git-send-email-michael-dev@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-31 at 14:41 +0100, Michael Braun wrote:
 
> +static int ieee80211_set_multicast_to_unicast(struct wiphy *wiphy,
> +					      struct net_device
> *dev,
> +					      const bool enabled)
> +{
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +
> +	/* not supported with P2P_GO for now */
> +	if (sdata->vif.type != NL80211_IFTYPE_AP)
> +		return -EOPNOTSUPP;

This check is completely inefficient, since vif.type is == AP for GO.

Also, I see no reason to restrict it that way, why not remove the
check? There's no difference.

> +static inline int
> +ieee80211_multicast_to_unicast(struct sk_buff *skb, struct
> net_device *dev)

use bool return?

johannes
