Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56926 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab0KHTks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 14:40:48 -0500
Received: by gwj21 with SMTP id 21so3647218gwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Nov 2010 11:40:47 -0800 (PST)
From: Mark Mentovai <mark@moxienet.com>
Content-Type: text/plain; charset=windows-1252
Subject: Regulatory/CRDA Race
Date: Mon, 8 Nov 2010 14:40:45 -0500
Message-Id: <185731CC-606D-407D-80F4-33FEF08ED35D@moxienet.com>
To: linux-wireless@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1081)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following up on the old-ish “[ath5k-devel] Race condition in CRDA calls?” thread…

I independently experienced this problem, debugged it, and came to the same conclusion. There is in fact a race between regulatory requests being made via regulatory_hint and CRDA actually updating regulatory data. I see this on a system with two cards that come up one after the other during boot.

1. cfg80211 calls CRDA to update the world regulatory domain and CRDA does so. The regulatory domain is now 00.

2. The first card’s driver (in my case, ath9k) calls regulatory_hint to provide US as a driver hint. ignore_request decides against intersection because the last request came from the core. There’s a CRDA call, but CRDA isn’t quick enough to respond. The regulatory domain is still 00, because CRDA hasn’t changed it yet.

3. The second card’s driver (also ath9k) calls regulatory_hint to provide US as a driver hint. ignore_request sees that the last request came from a driver (instead of the core) and since the regulatory domain is changing from 00 to US, decides that intersection must be performed.

4. When CRDA finally responds to the request from #2 or #3, cfg80211 sees that last_request->intersect is true, and intersects. The regulatory domain is set to the intersection of 00 and US.

The race here is between CRDA providing data and the second card’s request being made via regulatory_hint. regulatory_hint and ignore_request assume that last_request is in sync with the currently-set regulatory domain, but there is no such synchronization.

Here’s my openwrt-devel post describing the above in a slightly different level of detail:https://lists.openwrt.org/pipermail/openwrt-devel/2010-November/008570.html.