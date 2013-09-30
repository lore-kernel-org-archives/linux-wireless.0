Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55766 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3I3Oal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 10:30:41 -0400
Message-ID: <1380551437.14467.15.camel@jlt4.sipsolutions.net> (sfid-20130930_163043_872765_0A1F1CF3)
Subject: Re: [RFC] mac80211: correctly close cancelled scans
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Sep 2013 16:30:37 +0200
In-Reply-To: <1379396919-11983-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130917_074903_860444_E605037C)
References: <1379396919-11983-1-git-send-email-emmanuel.grumbach@intel.com>
	 (sfid-20130917_074903_860444_E605037C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-17 at 08:48 +0300, Emmanuel Grumbach wrote:
> __ieee80211_scan_completed is called from a worker. This
> means that the following flow is possible.
> 
>  * driver calls ieee80211_scan_completed
>  * mac80211 cancels the scan (that is already complete)
>  * __ieee80211_scan_complete runs
> 
> When scan_work will finally run, it will see that the scan
> hasn't been aborted and might even trigger another scan on
> another band. This leads to a situation where cfg80211's
> scan is not done and no further scan can be issued.
> 
> Fix this by setting a new flag when a HW scan is being
> cancelled so that no other scan will be triggered.

I'll apply this


> +		if (local->ops->cancel_hw_scan) {
>  			drv_cancel_hw_scan(local,
>  				rcu_dereference_protected(local->scan_sdata,
>  						lockdep_is_held(&local->mtx)));
> +		}

WIthout the extra braces.

johannes

