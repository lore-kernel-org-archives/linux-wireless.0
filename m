Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:49389 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751831Ab2CJSB7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 13:01:59 -0500
Message-ID: <1331402517.14442.10.camel@joe2Laptop> (sfid-20120310_190211_538909_80C2F26D)
Subject: Re: [PATCH] mac80211:  Add iface name when calling WARN-ON.
From: Joe Perches <joe@perches.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Sat, 10 Mar 2012 10:01:57 -0800
In-Reply-To: <4F5B8C66.4060808@candelatech.com>
References: <1331318216-27235-1-git-send-email-greearb@candelatech.com>
	 (sfid-20120310_015306_799372_9A7E4047) <1331366543.3348.1.camel@jlt3.sipsolutions.net>
	 <4F5B8C66.4060808@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-03-10 at 09:16 -0800, Ben Greear wrote:
[]
> >> diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
[]
> >> @@ -7,7 +7,11 @@
> >>
> >>   static inline void check_sdata_in_driver(struct ieee80211_sub_if_data *sdata)
> >>   {
> >> -	WARN_ON(!(sdata->flags&  IEEE80211_SDATA_IN_DRIVER));
> >> +	if (unlikely(!(sdata->flags&  IEEE80211_SDATA_IN_DRIVER))) {
> >> +		printk(KERN_ERR "%s:  Failed check-sdata-in-driver check, flags: 0x%x\n",
> >> +		       sdata->dev->name, sdata->flags);

Perhaps better as:
		netdev_err(sdata->dev, "%s(): Failed check, flags: 0x%x\n",
			   __func__, sdata->flags);


