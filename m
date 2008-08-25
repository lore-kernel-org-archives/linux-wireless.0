Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34381 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037AbYHYT4j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 15:56:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH RFC/RFT] b43: Improve TX power recalculation under load
Date: Mon, 25 Aug 2008 21:54:18 +0200
Cc: bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200808252154.18571.mb@bu3sch.de> (sfid-20080825_215644_293346_53583345)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch improves the recalculation of the TX attenuations
for improved scaling of the TX power under load.
This should improve (reduce) the time it takes the RC algorithm
to find the best transmission rate.
It should also improve the scaling of the attenuations to changed
environment (moving laptop, roaming, etc...)

This patch is experimental, but please test it a lot.
Please test performance and throughput of the wireless link (iperf, wget, ...)


The patch is available here:
http://bu3sch.de/patches/wireless-testing/20080825-2146/patches/004-b43-NEW-rewrite-txpower-adjusting.patch

It _requires_ this patch to be applied _first_:
http://bu3sch.de/patches/wireless-testing/20080825-2146/patches/003-b43-phy-ops.patch

The patches apply to wireless-testing.git:
git clone git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git

Thanks for supporting development of b43.

-- 
Greetings Michael.
