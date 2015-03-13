Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:34199
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751778AbbCMJys (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 05:54:48 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, karl.beldan@gmail.com
Subject: [PATCH] mac80211: minstrel_ht: fix rounding issue in MCS duration calculation
Date: Fri, 13 Mar 2015 10:54:44 +0100
Message-Id: <1426240484-37307-1-git-send-email-nbd@openwrt.org> (sfid-20150313_105451_955820_5E4ACB7C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On very high MCS bitrates, the calculated duration of rates that are
next to each other can be very imprecise, due to the small packet size
used as reference (1200 bytes).
This is most visible in VHT80 nss=2 MCS8/9, for which minstrel shows the
same throughput when the probability is also the same. This leads to a
bad rate selection for such rates.

Fix this issue by introducing an average A-MPDU size factor into the
calculation.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel_ht.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 80452cf..60698fc 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -17,10 +17,11 @@
 #include "rc80211_minstrel.h"
 #include "rc80211_minstrel_ht.h"
 
+#define AVG_AMPDU_SIZE	16
 #define AVG_PKT_SIZE	1200
 
 /* Number of bits for an average sized packet */
-#define MCS_NBITS (AVG_PKT_SIZE << 3)
+#define MCS_NBITS ((AVG_PKT_SIZE * AVG_AMPDU_SIZE) << 3)
 
 /* Number of symbols for a packet with (bps) bits per symbol */
 #define MCS_NSYMS(bps) DIV_ROUND_UP(MCS_NBITS, (bps))
@@ -33,7 +34,8 @@
 	)
 
 /* Transmit duration for the raw data part of an average sized packet */
-#define MCS_DURATION(streams, sgi, bps) MCS_SYMBOL_TIME(sgi, MCS_NSYMS((streams) * (bps)))
+#define MCS_DURATION(streams, sgi, bps) \
+	(MCS_SYMBOL_TIME(sgi, MCS_NSYMS((streams) * (bps))) / AVG_AMPDU_SIZE)
 
 #define BW_20			0
 #define BW_40			1
-- 
2.2.2

