Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60864 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab1BWLfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 06:35:15 -0500
Subject: IBSS merge
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alina Friedrichsen <x-alina@gmx.net>,
	Bruno Randolf <br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 12:35:13 +0100
Message-ID: <1298460913.4122.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm confused about our IBSS merge code.

ieee80211_rx_bss_info:

...
        /* same BSSID */
        if (memcmp(cbss->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0)
                goto put_bss;
...
        /* give slow hardware some time to do the TSF sync */
        if (rx_timestamp < IEEE80211_IBSS_MERGE_DELAY)
                goto put_bss;
...


Both of this was added by Alina, but why did the patch adding the first
part not remove the second part again? If we suddenly need to adopt a
new BSSID due to higher TSF why wait for the HW to sync first?

It seems the latter was a workaround for syncing over and over again
when the HW hadn't caught up yet, but that doesn't seem worthwhile any
more since we no longer re-sync with the same BSSID?

johannes

