Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57217 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab0LAGTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 01:19:49 -0500
Subject: Re: [PATCH] mac80211: Support beacon configuration via nl80211 for
 mesh interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1291168735-3423-1-git-send-email-javier@cozybit.com>
References: <1291168735-3423-1-git-send-email-javier@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 07:19:43 +0100
Message-ID: <1291184383.4199.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-30 at 17:58 -0800, Javier Cardona wrote:
> This patch adds the capability to the mesh stack to receive vendor
> specific information elements from userspace.  When a vendor specific
> IE is set via nl80211, the mesh stack will configure the mesh beacon to
> advertise that a vendor specific path selection and metric is in use.
> This is accordance with the Extensible Path Selection Framework
> specified in version 7.0 of the 802.11s draft.

> @@ -1709,6 +1709,7 @@ static int nl80211_addset_beacon(struct sk_buff *skb, struct genl_info *info)
>  		return -EINVAL;
>  
>  	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
> +	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
>  	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
>  		return -EOPNOTSUPP;

I'm not convinced that letting userspace set the *entire* beacon is the
right way to do it? Wouldn't it make more sense to allow it to specify
vendor-specific IEs (like IBSS), and the fact that vendor selection
protocol is used? It seems to me that somebody may want to have vendor
IEs while using the default protocols?

johannes

