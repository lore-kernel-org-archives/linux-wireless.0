Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42420 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750873AbdBXGju (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 01:39:50 -0500
Message-ID: <1487918388.2540.6.camel@sipsolutions.net> (sfid-20170224_074026_065357_4E71DBC0)
Subject: Re: [PATCH 160/306] mac80211-hwsim: add rate-limited debugging for
 rx-netlink
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Fri, 24 Feb 2017 07:39:48 +0100
In-Reply-To: <1487896109-23851-5-git-send-email-greearb@candelatech.com> (sfid-20170224_012925_413696_4E3C0418)
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
         <1487896109-23851-5-git-send-email-greearb@candelatech.com>
         (sfid-20170224_012925_413696_4E3C0418)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	    !info->attrs[HWSIM_ATTR_SIGNAL]) {
> +		if (net_ratelimit())
> +			printk(KERN_DEBUG " hwsim rx-nl: Missing
> required attribute\n");

I'm not convinced net_ratelimit() is a good idea, that's a global rate
limiter.

johannes
