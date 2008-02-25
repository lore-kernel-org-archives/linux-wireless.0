Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbYBYV2G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 16:28:06 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m1PLS4tM031249
	for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 16:28:04 -0500
Received: from mail.boston.redhat.com (mail.boston.redhat.com [172.16.76.12])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1PLS4ug029458
	for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 16:28:04 -0500
Received: from [172.16.83.84] (dhcp83-84.boston.redhat.com [172.16.83.84])
	by mail.boston.redhat.com (8.13.1/8.13.1) with ESMTP id m1PLS1DK018944
	for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 16:28:01 -0500
Subject: scanning behavior question
From: Dan Williams <dcbw@redhat.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Mon, 25 Feb 2008 16:25:57 -0500
Message-Id: <1203974757.22949.21.camel@localhost.localdomain> (sfid-20080225_212810_151716_A9A58A6D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[resend; I apparently forgot a subject the first time...]

While debugging why ipw2200 and wpa_supplicant would not connect to a
hidden access point today even with scan_ssid=1, I ran into an
interesting scan behavior question.

The root of the problem was that since the ipw2200 driver aggressively
rescans when it doesn't find the requested AP in it's list, and since it
only allows one scan at a time, wpa_supplicant's specific SSID scans
just happened to get rejected every time, which means the card never
sent out probe requests for the hidden SSID I wanted to associate with.

There are more general issues here than just ipw2200 though.  Most of
the fullmac drivers (counting ipw2x00 here) don't handle multiple scan
requests very well.  I'm not entirely sure what mac80211 does here but
it probably doesn't have extremely sophisticated scan result handling
either.  At startup

In the ideal case, the driver would add each separate scan request to a
queue, execute each request in turn (respecting each requests options
like active/passive, dwell time, SSID/BSSID, channel list, etc).  Each
request would trigger a corresponding scan completion event.  Perhaps
multiple identical scan requests (ie, a few 'iwlist <iface> scan') could
be batched together for efficiency.  With nl80211/cfg80211, perhaps each
individual scan request would have a UID to match it up with a specific
scan response (but the response would still be broadcast too).

Less invasive fixes could be made to ipw2200, like caching the last
SSID-specific request and instead of triggering a general scan the next
time, trigger a direct scan.  A workaround but not a real fix.

Thoughts?  How should a second, different scan request be handled while
another is already in flight?

Dan

