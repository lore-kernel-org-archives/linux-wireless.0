Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45938 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752133AbdEVGR5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 02:17:57 -0400
Message-ID: <1495433875.2653.4.camel@sipsolutions.net> (sfid-20170522_081940_683323_97770089)
Subject: Re: [PATCH] nl80211: Add association id to station response
From: Johannes Berg <johannes@sipsolutions.net>
To: Kirill Obukhov <kirill.obukhov@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 22 May 2017 08:17:55 +0200
In-Reply-To: <CAP3TkT3VE6FWBXm0K4=-pWLrmsCk4a7wuqc24KdcgYNBRQRyoA@mail.gmail.com> (sfid-20170521_104507_802538_58DA290C)
References: <CAP3TkT3VE6FWBXm0K4=-pWLrmsCk4a7wuqc24KdcgYNBRQRyoA@mail.gmail.com>
         (sfid-20170521_104507_802538_58DA290C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kirill,

First of all, please read

https://www.kernel.org/doc/html/latest/process/submitting-patches.html

particularly

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin

is important

On Sun, 2017-05-21 at 11:45 +0300, Kirill Obukhov wrote:
> There are unique association id attribute must be passed in station
> add request.
> But we have no way to retrieve ids already in use. To solve issue
> association id attribute added to station response.

This sound fine.

However, it'd be good to mention that you're also adding it to
mac80211, or preferably even split the patch into two, one to add the
feature and one to make use of it in mac80211.

Once you do that, you'll quite likely also notice that with just the
first of the patches, the thing is broken and always reports a 0 AID.

>         if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
>             nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr) ||
> +           nla_put_u16(msg, NL80211_ATTR_STA_AID, sinfo->aid) ||

That's because you need to make this conditional on the right filled
flag.

johannes
