Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37704 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751349AbdDLOUk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 10:20:40 -0400
Message-ID: <1492006834.2855.7.camel@sipsolutions.net> (sfid-20170412_162043_400877_2B836476)
Subject: Re: [PATCH 6/6] mac80211: use common code for monitor options in
 add/change
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: aviya.erenfeld@intel.com
Date: Wed, 12 Apr 2017 16:20:34 +0200
In-Reply-To: <20170412110621.8981-6-johannes@sipsolutions.net> (sfid-20170412_130634_643028_12035135)
References: <20170412110621.8981-1-johannes@sipsolutions.net>
         <20170412110621.8981-6-johannes@sipsolutions.net>
         (sfid-20170412_130634_643028_12035135)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This crashes, need

> +	if (!monitor_sdata &&
> +	    (params->vht_mumimo_groups || params-
> >vht_mumimo_follow_addr))
> +		return -EOPNOTSUPP;
> +
> +	/* apply all changes now - no failures allowed */
> +

if (monitor_sdata)

> +	ieee80211_set_mu_mimo_follow(monitor_sdata, params);
> 
[...]

johannes
