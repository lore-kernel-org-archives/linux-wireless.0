Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54791 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046AbbCCJde (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 04:33:34 -0500
Message-ID: <1425375211.2450.26.camel@sipsolutions.net> (sfid-20150303_103338_138980_C6EA413C)
Subject: Re: [PATCH v2 1/2] cfg80211: Allow NL80211_ATTR_IFINDEX to be added
 to vendor events
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	Ahmad Kholaif <akholaif@qca.qualcomm.com>
Date: Tue, 03 Mar 2015 10:33:31 +0100
In-Reply-To: <1424957214-6363-1-git-send-email-jouni@qca.qualcomm.com>
References: <1424957214-6363-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both applied, thanks. I changed this code:

> +       if (wdev) {
> +               if (nla_put_u64(skb, NL80211_ATTR_WDEV,
> +                               wdev_id(wdev)))
> +                       goto nla_put_failure;
> +               if (wdev->netdev) {
> +                       if (nla_put_u32(skb, NL80211_ATTR_IFINDEX,
> +                                       wdev->netdev->ifindex))
> +                               goto nla_put_failure;
> +               }
> +       }

to just

+       if (wdev) {
+               if (nla_put_u64(skb, NL80211_ATTR_WDEV,
+                               wdev_id(wdev)))
+                       goto nla_put_failure;
+               if (wdev->netdev &&
+                   nla_put_u32(skb, NL80211_ATTR_IFINDEX,
+                               wdev->netdev->ifindex))
+                       goto nla_put_failure;
+       }

though.

johannes

