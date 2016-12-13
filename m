Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50254 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933385AbcLMPdq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 10:33:46 -0500
Message-ID: <1481643200.20412.9.camel@sipsolutions.net> (sfid-20161213_163352_624423_62A8C3DA)
Subject: Re: [PATCH v3] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 13 Dec 2016 16:33:20 +0100
In-Reply-To: <20161212164500.691-1-andrew.zaborowski@intel.com> (sfid-20161212_174513_083117_405C8DC6)
References: <20161212164500.691-1-andrew.zaborowski@intel.com>
         (sfid-20161212_174513_083117_405C8DC6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[snip]

Please fix coding style, particularly indentation.

> +static void cfg80211_disconnect_wk(struct work_struct *work)
> +{
> +       struct cfg80211_registered_device *rdev;
> +       struct wireless_dev *wdev;
> +
> +       wdev = container_of(work, struct wireless_dev, disconnect_wk);
> +       rdev = wiphy_to_rdev(wdev->wiphy);


Those should also be possible as initializers on the same line, I
guess?

It might also be worthwhile moving this function into a better file,
even if then it needs a prototype in core.h (it can't be inlined anyway
since it's called through a function pointer in the work struct)

> +       if (!wdev->netdev)
> +               return;

This obviously cannot happen.

All the code you added to nl80211.c is racy.

johannes
