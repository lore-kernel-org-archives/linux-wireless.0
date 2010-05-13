Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:61680 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab0EMOlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 10:41:55 -0400
Received: by pzk42 with SMTP id 42so741997pzk.4
        for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 07:41:54 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 13 May 2010 09:41:54 -0500
Message-ID: <AANLkTim6GiiFR0zWVqlmIJr-sk1ThwO3GAA97aJwWg3U@mail.gmail.com>
Subject: Possible issue with mac80211 and certain access points
From: Chad Koehler <chad.koehler@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recently purchased a Palm Pre and immediately found some issues with
connecting to the Wifi Hotspot.  Connecting to other access points
would work flawlessly.

Using the Palm Pre hotspot, I can get connected, but the connection
will drop after a very short period of time.  There are messages in
the system log whenever the connection drops:

No probe response from AP <address> after 500ms, disconnecting.

An internet search turned up several results for people with the same
issue, different wireless drivers and different access point types.

I traced this message down to mac80211/mlme.c, to the
ieee80211_sta_work() function, and was able to determine that for some
reason this particular AP was not responding to probe requests.  This
let me further on to the function ieee80211_mgd_probe_ap_send(), which
sends a direct probe request to the AP -- this probe request was being
sent and never responded to.

If I change this function to send a probe request to the broadcast
address, in a similar manner to what is done in
ieee80211_direct_probe(), then the access point responds and works
without issue.

Due to the volume of issues on the internet that I see with the same
underlying symptoms, I wonder if there are some small amount of access
points that will not respond to a direct packet probe request even
when associated.

I admittedly know very little about wireless networking internals, so
I am hesitant to state that this fix is necessary or appropriate, but
it does solve the issue for me and I am able to remain connected to
the Palm Pre hotspot, as well as other access points that I have
tried.

Please let me know if I can provide further information in this space.


Thank You,
Chad
