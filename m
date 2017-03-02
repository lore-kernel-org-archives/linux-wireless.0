Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47648 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753587AbdCBIvk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 03:51:40 -0500
Message-ID: <1488444659.8390.8.camel@sipsolutions.net> (sfid-20170302_102241_224084_D4294080)
Subject: Re: [PATCHv2 3/4] cfg80211: Add Support set btcoex priority value
From: Johannes Berg <johannes@sipsolutions.net>
To: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org
Date: Thu, 02 Mar 2017 09:50:59 +0100
In-Reply-To: <1488029873-14600-4-git-send-email-c_traja@qti.qualcomm.com>
References: <1488029873-14600-1-git-send-email-c_traja@qti.qualcomm.com>
         <1488029873-14600-4-git-send-email-c_traja@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is there much point in having 4 rather than just 2 patches?


> +	int     (*set_btcoex)(struct wiphy *wiphy, bool enabled,
> +			      int btcoex_priority);

Shouldn't that be u32 as a bitmap?

> +	bool btcoex_priority_support;

Why not use an extended nl80211 feature flag directly?

> + * @NL80211_ATTR_BTCOEX_PRIORITY: This is for the driver which
> + *     support btcoex priority feature. It used with
> %NL80211_CMD_SET_BTCOEX.
> + *     This will have u32 BITMAP value which represents
> + *     frame(bk, be, vi, vo, mgmt, beacon) type and that will have
> more
> + *     priority than a BT traffic.

I think you need to define the bits somewhere in an enum - i.e. which
one is VO, VI, ...

> +	int btcoex_priority = -1;

That -1 is pretty useless, if the driver doesn't support it, hopefully
it won't look at the value at all?

johannes
