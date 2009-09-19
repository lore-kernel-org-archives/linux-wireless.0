Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:41263 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbZISWIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2009 18:08:14 -0400
Received: from cpc2-whit1-0-0-cust96.cdif.cable.ntl.com ([82.13.80.97] helo=plato.andrewprice.me.uk)
	by silver.sucs.swan.ac.uk with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.69)
	(envelope-from <andy@andrewprice.me.uk>)
	id 1Mp86L-0003ko-3F
	for linux-wireless@vger.kernel.org; Sat, 19 Sep 2009 23:08:17 +0100
Date: Sat, 19 Sep 2009 23:08:05 +0100
From: Andrew Price <andy@andrewprice.me.uk>
To: linux-wireless@vger.kernel.org
Subject: Problem with "cfg80211: fix SME connect" (bisected)
Message-ID: <20090919220805.GA2728@plato.andrewprice.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

After building today's mainline kernel (as of 78f28b7c) my wireless
networking stopped working - the interface seems to come up but nothing
can connect.  The output of dmesg was clean, no backtraces or anything
unusual.

I've bisected the problem down to commit bbac31f4 "cfg80211: fix SME
connect".  Reverting that commit fixes the problem. I'm using
wpa_supplicant v0.6.9. The bug occurs for my b43 card and my rt2500pci
card, and reverting the commit fixes the problem for both cards.

Please let me know if there's any more info I can provide or patches I
can test.

Andrew
