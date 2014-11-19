Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38218 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbaKSLWj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 06:22:39 -0500
Message-ID: <1416396152.9374.0.camel@sipsolutions.net> (sfid-20141119_122242_652206_8CA21B08)
Subject: Re: [PATCH 16/16] mac80211: synchronously reserve TID per station
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Liad Kaufman <liad.kaufman@intel.com>
Date: Wed, 19 Nov 2014 12:22:32 +0100
In-Reply-To: <1415551822-20121-16-git-send-email-arik@wizery.com> (sfid-20141109_175048_373463_23BE58FA)
References: <1415551822-20121-1-git-send-email-arik@wizery.com>
	 <1415551822-20121-16-git-send-email-arik@wizery.com>
	 (sfid-20141109_175048_373463_23BE58FA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-11-09 at 18:50 +0200, Arik Nemtsov wrote:

> +	if (WARN_ON(tid >= IEEE80211_NUM_TIDS))
> +		return -EINVAL;

That validates < 16

> +	queues = BIT(sdata->vif.hw_queue[ieee802_1d_to_ac[tid]]);

but that's only valid for < 8, causing a smatch warning.

johannes

