Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54892 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755863AbcKVNii (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 08:38:38 -0500
Message-ID: <1479821915.9021.4.camel@sipsolutions.net> (sfid-20161122_143841_363711_9E41DABB)
Subject: Re: [PATCH] nl80211: provide minimum scheduled scan (plan) interval
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 22 Nov 2016 14:38:35 +0100
In-Reply-To: <1479821515-13261-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1479821515-13261-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +		if (wiphy->min_sched_scan_plan_interval &&
> +		    request->scan_plans[i].interval <
> +		    wiphy->min_sched_scan_plan_interval)
> +			return -EINVAL;
> 
I'm not sure we should break the API that way - just move it up if it's
smaller?

johannes
