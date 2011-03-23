Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59902 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811Ab1CWNAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 09:00:39 -0400
Subject: Re: [PATCH] cfg80211: Add nl80211 event for deletion of a station
 entry
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110323125513.GB26467@jm.kir.nu>
References: <20110323125513.GB26467@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 14:00:29 +0100
Message-ID: <1300885229.3790.39.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +void nl80211_send_sta_del_event(struct cfg80211_registered_device *rdev,
> +				struct net_device *dev, const u8 *mac_addr,
> +				gfp_t gfp)
> +{
> +	struct sk_buff *msg;
> +	void *hdr;
> +
> +	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
> +	if (!msg)
> +		return;
> +
> +	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_DEL_STATION);
> +	if (!hdr) {
> +		nlmsg_free(msg);
> +		return;
> +	}
> +
> +	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
> +	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
> +
> +	if (genlmsg_end(msg, hdr) < 0) {
> +		nlmsg_free(msg);
> +		return;
> +	}
> +
> +	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
> +				nl80211_mlme_mcgrp.id, gfp);
> +	return;
> +
> + nla_put_failure:
> +	genlmsg_cancel(msg, hdr);
> +}

I bet you just copied that, but isn't that leaking the message?

johannes

