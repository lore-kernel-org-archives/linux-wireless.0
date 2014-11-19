Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46733 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870AbaKSRxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 12:53:23 -0500
Message-ID: <546CD912.1090809@candelatech.com> (sfid-20141119_185325_711985_12C867B7)
Date: Wed, 19 Nov 2014 09:53:22 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, luca@coelho.fi,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC] mac80211: allow drivers to provide any statistics
References: <1416221286-23126-1-git-send-email-johannes@sipsolutions.net> <20141119174925.GM11482@localhost>
In-Reply-To: <20141119174925.GM11482@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/2014 09:49 AM, Bob Copeland wrote:
> On Mon, Nov 17, 2014 at 11:48:06AM +0100, Johannes Berg wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> In many cases, drivers can filter things like beacons that will
>> skew statistics reported by mac80211. To get correct statistics
>> in these cases, call drivers to obtain statistics and let them
>> override all values, filling values from mac80211 if the driver
>> didn't provide them.
> 
> Neat.
> 
> For mesh, it's handy to have the (somewhat imperfectly specified)
> sta->fail_avg too for drivers that implement all the rate control
> in firmware and thus may not report tx status for all frames.
> 
> At cozybit we had implemented a drv_link_stats driver op (hack) that
> just got last_tx_rate and fail_avg so that the airtime link metric
> could work on such devices; this call could replace that, I hope.


The ethtool stats API could also handle at least some of this,
but it's a bit free-form to program against...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

