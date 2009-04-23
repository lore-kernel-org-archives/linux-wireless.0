Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:56829 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760038AbZDWHzF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 03:55:05 -0400
Received: by fxm2 with SMTP id 2so389383fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 00:55:03 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	"Guy\, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: calculate maximum sleep interval
References: <1240418677.30082.3.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 23 Apr 2009 10:55:01 +0300
In-Reply-To: <1240418677.30082.3.camel@johannes.local> (Johannes Berg's message of "Wed\, 22 Apr 2009 18\:44\:37 +0200")
Message-ID: <874owfdctm.fsf@litku.valot.fi> (sfid-20090423_095528_537860_23AD0141)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> The maximum sleep interval, for powersave purposes, is
> determined by the DTIM period (it may not be larger)
> and the required networking latency (it must be small
> enough to fulfil those constraints).
>
> This makes mac80211 calculate the maximum sleep interval
> based on those constraints, and pass it to the driver.
> Then the driver should instruct the device to sleep at
> most that long.

I like this, just one comment:

> + * @max_sleep_interval: the maximum number of beacon intervals to sleep for
> + *	before checking the beacon for a TIM bit (managed mode only); this
> + *	value will be only achievable between DTIM frames, the hardware
> + *	needs to check for the multicast traffic bit in DTIM beacons.
> + *	This variable is valid only when the CONF_PS flag is set.

I would prefer to call it max_sleep_period. Or maybe even wakeup period,
because it's about waking up here.

For me interval, for example beacon interval, means that the unit is TU.
But this might be just me.

-- 
Kalle Valo
