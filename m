Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41178 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab1CGMHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 07:07:16 -0500
Subject: Re: WARN_ON in ieee80211_scan_completed_finish triggered
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Ben Greear <greearb@candelatech.com>
In-Reply-To: <1299498147.5665.3.camel@marge>
References: <1299443142.1292.6.camel@marge>
	 <1299491485.3790.2.camel@jlt3.sipsolutions.net>
	 (sfid-20110307_105130_457515_FFFFFFFF997C7B78)  <1299498147.5665.3.camel@marge>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 13:03:20 +0100
Message-ID: <1299499400.3790.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-07 at 12:42 +0100, Michael Buesch wrote:

> > > [ 1182.826599] WARNING: at net/mac80211/scan.c:310 ieee80211_rx_bss_free+0x20c/0x4b8 [mac80211]()

Actually ... It just looks like a race:

The pattern is this:

mutex_lock(&local->mtx);
finish = __ieee80211_scan_completed(&local->hw, true, false);
mutex_unlock(&local->mtx);
...
if (finish)
        __ieee80211_scan_completed_finish(&local->hw, false);


scan_completed() does

	local->scanning = 0;
	return true;

The warning is:
	WARN_ON(local->scanning & (SCAN_SW_SCANNING | SCAN_HW_SCANNING));

but I don't see anything that would prevent a new scan from beginning
during the time the mutex isn't locked, since everything is set to 0 or
NULL that would block a new scan, I think?

johannes

