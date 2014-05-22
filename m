Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44430 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbaEVNnT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 09:43:19 -0400
Message-ID: <1400766195.4174.13.camel@jlt4.sipsolutions.net> (sfid-20140522_154322_565641_11B9A7DB)
Subject: Re: [PATCH 1/3] mac80211: move csa counters from sdata to
 beacon/presp
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 22 May 2014 15:43:15 +0200
In-Reply-To: <1400765294-14732-2-git-send-email-michal.kazior@tieto.com> (sfid-20140522_153529_435766_85FBB99B)
References: <1400765294-14732-1-git-send-email-michal.kazior@tieto.com>
	 <1400765294-14732-2-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140522_153529_435766_85FBB99B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-22 at 15:28 +0200, Michal Kazior wrote:
> Having csa counters part of beacon and probe_resp
> structures makes it easier to get rid of possible
> reaces between setting a beacon and updating
> counters on SMP systems by guaranteeing counters
> are always consistent against given beacon struct.

This makes a lot of sense.

>  static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
> -				   struct cfg80211_beacon_data *params)
> +				   struct cfg80211_beacon_data *params,
> +				   const u16 *csa_counter_offset_beacon,
> +				   int n_csa_counter_offset_beacon,
> +				   const u16 *csa_counter_offset_presp,
> +				   int n_csa_counter_offset_presp,
> +				   u8 csa_count)

But that seems overkill. Maybe those CSA-related arguments could be in
some new struct so you don't have to pass "..., NULL, 0, NULL, 0, 0"?

johannes

