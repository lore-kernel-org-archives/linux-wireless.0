Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:60365 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab0INWMN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 18:12:13 -0400
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>
Subject: Re: [PATCH 08/10] mac80211: send last 3/5 probe requests as unicast
References: <1284474071-8404-1-git-send-email-lrodriguez@atheros.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 15 Sep 2010 01:12:11 +0300
In-Reply-To: <1284474071-8404-1-git-send-email-lrodriguez@atheros.com> (Luis R. Rodriguez's message of "Tue\, 14 Sep 2010 10\:21\:11 -0400")
Message-ID: <87mxrk5610.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <lrodriguez@atheros.com> writes:

> We need to do this since the beacon monitor does not
> push back the connection monitor by design so even if we
> are getting beacons from these type of APs our connection
> monitor currently relies heavily on the way the probe
> requests are received on the AP. An example of an AP
> affected by this is the Nexus One, but this has also been
> observed with random APs.
>
> We can probably optimize this later by using null funcs
> instead of probe requests.

Beginning of this year I sent patches to use null funcs. Unfortunately
I had to drop them due to time constraints.

Also a major power consumption imporovement from using null func
frames is that we don't have to trigger dynamic power save timer
during the poll. Just send the frame with PSM bit set, wait for ack
and go immeaditely back to sleep. So instead of having radios enabled
for example 100 ms per frame, we can do it in just 1 ms.

-- 
Kalle Valo
