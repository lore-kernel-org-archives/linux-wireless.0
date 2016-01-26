Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38964 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135AbcAZLWa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 06:22:30 -0500
Message-ID: <1453807346.2759.29.camel@sipsolutions.net> (sfid-20160126_122233_471552_77BFDC51)
Subject: Re: [PATCH] cfg80211: basic support for PBSS network type
From: Johannes Berg <johannes@sipsolutions.net>
To: Lior David <liord@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Dedy Lansky <dlansky@codeaurora.org>,
	Maya Erez <merez@codeaurora.org>,
	Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Date: Tue, 26 Jan 2016 12:22:26 +0100
In-Reply-To: <56961335.4040801@codeaurora.org>
References: <56961335.4040801@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-01-13 at 11:04 +0200, Lior David wrote:
> 
> + * @NL80211_ATTR_PBSS: flag attribute. If set it means operate
> + *	in a PBSS. Specified in %NL80211_CMD_CONNECT to request
> + *	connecting to a PCP, and in %NL80211_CMD_START_AP to start
> + *	a PCP instead of AP. Relevant for DMG networks only.

I'm continually confused by this; is it possible for DMG devices to be
a "real" AP rather than a PCP?

> @@ -3461,6 +3462,8 @@  static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
>  			return PTR_ERR(params.acl);
>  	}
>  
> +	params.pbss = nla_get_flag(info->attrs[NL80211_ATTR_PBSS]);
> +
>  	wdev_lock(wdev);
>  	err = rdev_start_ap(rdev, dev, &params);
>  	if (!err) {

This, and the corresponding code in nl80211_connect, really ought to
check that the device is a DMG device and able to do this.

Perhaps this even needs a capability check, or do we assume that all
devices/drivers will be able to do this (or should reject it?)

If you want to rely on drivers though you need to have (in this patch!)
a small change to the existing driver to reject the operations if
pbss==true since obviously it cannot be doing the right thing right now
without further changes. That reject would then of course be removed
again with the driver update.

johannes
