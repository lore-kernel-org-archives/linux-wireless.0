Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:52724 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932661AbbI3L1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 07:27:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: netdev@vger.kernel.org
Cc: y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 05/12] mwifiex: avoid gettimeofday in ba_threshold setting
Date: Wed, 30 Sep 2015 13:26:35 +0200
Message-Id: <1443612402-3000775-6-git-send-email-arnd@arndb.de> (sfid-20150930_133016_101373_FA569AA6)
In-Reply-To: <1443612402-3000775-1-git-send-email-arnd@arndb.de>
References: <1443612402-3000775-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mwifiex_get_random_ba_threshold() uses a complex homegrown implementation
to generate a pseudo-random number from the current time as returned
from do_gettimeofday().

This currently requires two 32-bit divisions plus a couple of other
computations that are eventually discarded as only eight bits of
the microsecond portion are used at all.

We could replace this with a call to get_random_bytes(), but that
might drain the entropy pool too fast if this is called for each
packet.

Instead, this patch converts it to use ktime_get_ns(), which is a
bit faster than do_gettimeofday(), and then uses a similar algorithm
as before, but in a way that takes both the nanosecond and second
portion into account for slightly-more-but-still-not-very-random
pseudorandom number.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/mwifiex/wmm.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 173d3663c2e0..878d358063dc 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -117,22 +117,15 @@ mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, const u8 *ra)
  */
 static u8 mwifiex_get_random_ba_threshold(void)
 {
-	u32 sec, usec;
-	struct timeval ba_tstamp;
-	u8 ba_threshold;
-
+	u64 ns;
 	/* setup ba_packet_threshold here random number between
 	 * [BA_SETUP_PACKET_OFFSET,
 	 * BA_SETUP_PACKET_OFFSET+BA_SETUP_MAX_PACKET_THRESHOLD-1]
 	 */
+	ns = ktime_get_ns();
+	ns += (ns >> 32) + (ns >> 16);
 
-	do_gettimeofday(&ba_tstamp);
-	sec = (ba_tstamp.tv_sec & 0xFFFF) + (ba_tstamp.tv_sec >> 16);
-	usec = (ba_tstamp.tv_usec & 0xFFFF) + (ba_tstamp.tv_usec >> 16);
-	ba_threshold = (((sec << 16) + usec) % BA_SETUP_MAX_PACKET_THRESHOLD)
-						      + BA_SETUP_PACKET_OFFSET;
-
-	return ba_threshold;
+	return ((u8)ns % BA_SETUP_MAX_PACKET_THRESHOLD) + BA_SETUP_PACKET_OFFSET;
 }
 
 /*
-- 
2.1.0.rc2

