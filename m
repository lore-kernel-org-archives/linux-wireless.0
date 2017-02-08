Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42624 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932096AbdBHJ65 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 04:58:57 -0500
Message-ID: <1486547933.24745.2.camel@sipsolutions.net> (sfid-20170208_110004_175667_76D33593)
Subject: Re: [PATCH v4 3/5] cfg80211: Accept multiple RSSI thresholds for CQM
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 08 Feb 2017 10:58:53 +0100
In-Reply-To: <20170125114344.8179-3-andrew.zaborowski@intel.com> (sfid-20170125_124407_436433_080482FC)
References: <20170125114344.8179-1-andrew.zaborowski@intel.com>
         <20170125114344.8179-3-andrew.zaborowski@intel.com>
         (sfid-20170125_124407_436433_080482FC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This method doesn't have a hysteresis parameter because there's no
> benefit to the cfg80211 code from having the hysteresis be handled by
> hardware/driver in terms of the number of wakeups.  At the same time
> it would likely be less consistent between drivers if offloaded or
> done in the drivers.

I'm not really sure I buy this.

What if I configure a few ranges, and let's say one of the boundaries
is -50dBm. Now if I sit just on that value of -50dBm and thus my signal
fluctuates say -48..-52, I'd have to continuously wake up the host.

You try to avoid that here, I think:

+	if (low > (s32) (last - hyst))
+		low = last - hyst;
+	if (high < (s32) (last + hyst))
+		high = last + hyst;

but it's not clear to me that this is effective?

Let's see. last is -52, so low will be -60 and high will be -50.

Let's say hyst is 3 since I chose the ranges so closely. I'm guessing a
higher hysteresis and larger ranges would actually be better, but let's
stick to this for the sake of the example.

last-hyst = -55, so low isn't > that, low = -60
last+hyst = -49, so high = -49

but now it still fluctuates around -50, so if I next hit -48 you do the
same dance again with -50/-40, getting -51/-40 and never really
applying a full hysteresis, no?

I'll probably see an intermediate value of -50 at some point, but I'll
never actually *report* it, so "last" can switch between -48 and -52
constantly in this scenario, no?


I think it would make sense to unconditionally apply the hysteresis to
low/high, i.e. always set
 low = low - hyst
 high = high + hyst

so that you get "sticky" ranges once you're in them?



> +	if (!wiphy_ext_feature_isset(&rdev->wiphy,
> +			
> 	     NL80211_EXT_FEATURE_CQM_RSSI_LIST))
> +		return
> -EOPNOTSUPP;


That check should be earlier in the function
cfg80211_cqm_rssi_update(), no?



johannes
