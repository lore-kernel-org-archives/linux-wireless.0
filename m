Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56841 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbbDNPD7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 11:03:59 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA256:128)
	(Exim 4.84)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Yi2NZ-0008I5-O9
	for linux-wireless@vger.kernel.org; Tue, 14 Apr 2015 17:03:57 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC/RFT 00/11] mac80211: enable fast-xmit and some offloads
Date: Tue, 14 Apr 2015 17:03:38 +0200
Message-Id: <1429023829-3991-1-git-send-email-johannes@sipsolutions.net> (sfid-20150414_170402_357343_42C8C498)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First, add the TX fastpath ("fast-xmit") that I've been kicking around for
a while. I'm pretty happy with the abstraction since it allows me to not
have to worry about a lot of details in the regular TX path...

Secondly, I want to enable more offloads. So the first thing to do is to
actually fix checksum offload - the TI driver has a bug in that if it fails
to upload keys or so, checksums will be completely bogus.

So the first step to fix that bug is to enable checksum offload only on
the fast-xmit path, while having a software fallback on the regular TX path
to make software crypto etc. do the right thing. To not cause regressions
for the TI/ath10k drivers, this requires extending fast-xmit to cover more
cases, but that's easy.

Secondly then, we can add code to do in software what the driver might do,
which is actually what the network stack does for us anyway today, but now
we can do it only on the non-fast-xmit path so that the fast-xmit path can
pass packets with required checksumming or segmentation to the device.

So far I've only tested the software fallbacks, not the actual hardware
offloads.

johannes

