Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25628 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbZKBQCU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 11:02:20 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2009 08:02:26 -0800
Date: Mon, 2 Nov 2009 08:02:25 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Andrej Podzimek <andrej@podzimek.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	<linux-wireless@vger.kernel.org>
Subject: Discrepancy when using old version of wpa_supplicant and git
	version
Message-ID: <20091102160225.GC3647@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Renaming thread and moving this particular topic to linux-wireless.

Andrej, you reported some major frequent disconnect issues with ath9k. You
noticed TX hang issue from an upgrade from 2.6.29 to 2.6.30. You indicated
that when you ping flood you get your connection back.

Your card is an AR5416 MAC/BB Rev:2 AR2122 RF Rev:81.

You noted your disconnect issues appear even with the latest compat-wireless
drivers as:

wlan0: deauthenticating from 00:23:f8:22:aa:a6 by local choice (reason=3)
wlan0: direct probe to AP 00:23:f8:22:aa:a6 (try 1)
wlan0: deauthenticating from 00:23:f8:22:aa:a6 by local choice (reason=3)
wlan0: deauthenticating from 00:23:f8:22:aa:a6 by local choice (reason=3)
wlan0: direct probe to AP 00:23:f8:22:aa:a6 (try 1)
wlan0: direct probe responded
wlan0: authenticate with AP 00:23:f8:22:aa:a6 (try 1)
wlan0: authenticated
wlan0: associate with AP 00:23:f8:22:aa:a6 (try 1)
wlan0: RX AssocResp from 00:23:f8:22:aa:a6 (capab=0x431 status=0 aid=2)
wlan0: associated


You noted you tried connecting to 4 different APs but are only sure
of the model of one of them:

  * Zyxel NBG-420N. It's set to WPA2 with EAP-TLS authentication

The other three (or more) APs are enterprise-class devices that form a
big network with roaming inside a university building. Zyxel NBG-420N supports
802.11n, whereas all the other APs only support 802.11g.

I then suggested for kicks to just try the latest version of wpa_supplicant
from git -- you tried it and it seems to have resolved your random
disconnects.

Your current pending issue is what seems to be a TX hang after a period
of time. This issue is another issue which I do not want to get into
on this thread. I started this thread specifically on linux-wireless
so we can review the issue you had with an older version of wpa_supplicant.
I am curious to see what the issue was that an upgrade fixed for you.

Can you please try to re-use the old version of wpa_supplicant and while
you connect please leave a window open with:

iw event -t

If anyone has other suggestions for Andrej to test please let me know.

  Luis
