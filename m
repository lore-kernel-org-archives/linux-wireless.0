Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:38101 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbaKSRvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 12:51:38 -0500
Received: by mail-ie0-f180.google.com with SMTP id rp18so1007953iec.11
        for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2014 09:51:38 -0800 (PST)
Date: Wed, 19 Nov 2014 12:49:25 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC] mac80211: allow drivers to provide any statistics
Message-ID: <20141119174925.GM11482@localhost> (sfid-20141119_185149_468170_7496D8BC)
References: <1416221286-23126-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416221286-23126-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 17, 2014 at 11:48:06AM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In many cases, drivers can filter things like beacons that will
> skew statistics reported by mac80211. To get correct statistics
> in these cases, call drivers to obtain statistics and let them
> override all values, filling values from mac80211 if the driver
> didn't provide them.

Neat.

For mesh, it's handy to have the (somewhat imperfectly specified)
sta->fail_avg too for drivers that implement all the rate control
in firmware and thus may not report tx status for all frames.

At cozybit we had implemented a drv_link_stats driver op (hack) that
just got last_tx_rate and fail_avg so that the airtime link metric
could work on such devices; this call could replace that, I hope.

-- 
Bob Copeland %% http://bobcopeland.com/
