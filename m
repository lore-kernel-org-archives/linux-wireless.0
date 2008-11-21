Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:63913 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbYKUU2f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 15:28:35 -0500
Received: by ug-out-1314.google.com with SMTP id 39so218458ugf.37
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2008 12:28:34 -0800 (PST)
Message-ID: <492719ED.5000006@gmail.com> (sfid-20081121_212848_164167_5EFCD18C)
Date: Fri, 21 Nov 2008 22:28:29 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: ipw3945-devel@lists.sourceforge.net, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	wally@theblackmoor.net
Subject: Unusually low speeds with ath5k and iwl3945
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

sorry for cross-posting, but this issue really spans both iwl3945 and ath5k.

I have two laptops (acer 5720, and aspire one) and I see some strange speed issues.

I initially blamed iwl3945, then thought it got fixed, but now I have ath5k, and speeds are low
and I suspect that both drivers has bugs regarding to speed.

Walter Francis, once reported similar issue, so I cc'ed him too.
He says that 2.6.25 works fine for iwl3945.
I'll test this, and bisect if necessary. 

So here it goes:

System setup:

a wired desktop connected to a router, I call it just router
as wired connection there is 100 Mbits/s and this can't
be the bottleneck.

two laptops, both are close to the router, signal strength is -50 dBm on laptop
and -55 dBm on aspire one (they are really close, they are on same desktop).
Also I did try to bring both laptops to router, and this really didn't help much.

Only one of laptops was on when I did speed tests between a laptop and router.

I did those tests several times, and interleaved them in different order.

For data transfers, contents of /dev/zero were send to /dev/null via TCP connection,
using netcat.


So here are the speeds:

router->iwl3945 = 2.3 Mbytes/s, solid speed, never dropped much, was consistent across tests.

iwl3945->router	= 1.0 Mbytes/s max, on first test, it dropped often to 300 Kbytes/s

Then in another test for whole session it stayed at 200 Kbytes/s, it was same upload speed
to ath5k too, the speed varied a lot too.


router->ath5k   = 1.4 Mbytes/s max, was pretty solid, also noticed that
iwconfig shows maximum 18M, although my router supports all B/G speeds.
attempts to set higher speed resulted in full connection loss.
also association was dropping often, and that resulted in few minutes of no transfer
at all.

ath5k->router	= 1.4 Mbytes/s max, also the same 18 Mbytes/s issue , 
and same association issue.


And now for the worst part:


ath5k->iwl3945  = 800 Kbytes/s, but speed very often dropped to 600 Kbytes/s, and once it did drop to around 80~100 Kbytes/s
I did see same association drops, but they were rare. 

iwl3945->ath5k  = 500 Kbytes/s  and often drops to 300 Mbytes/s.



Best regards,
	Maxim Levitsky
