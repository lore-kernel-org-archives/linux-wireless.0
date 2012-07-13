Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50328 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab2GMI5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 04:57:42 -0400
Message-ID: <1342169856.4983.1.camel@jlt3.sipsolutions.net> (sfid-20120713_105749_825982_9C95B4CB)
Subject: [PATCH] b43: use temporary rate_index for error checking
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 13 Jul 2012 10:57:36 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The mac80211 rate_index changed to be a u8, so
can't hold the negative error value properly.
Use a temporary variable for error checking.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/b43/xmit.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index b31ccc0..136510e 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -663,7 +663,7 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 	u32 uninitialized_var(macstat);
 	u16 chanid;
 	u16 phytype;
-	int padding;
+	int padding, rate_idx;
 
 	memset(&status, 0, sizeof(status));
 
@@ -766,16 +766,17 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 	}
 
 	if (phystat0 & B43_RX_PHYST0_OFDM)
-		status.rate_idx = b43_plcp_get_bitrate_idx_ofdm(plcp,
+		rate_idx = b43_plcp_get_bitrate_idx_ofdm(plcp,
 						phytype == B43_PHYTYPE_A);
 	else
-		status.rate_idx = b43_plcp_get_bitrate_idx_cck(plcp);
-	if (unlikely(status.rate_idx == -1)) {
+		rate_idx = b43_plcp_get_bitrate_idx_cck(plcp);
+	if (unlikely(rate_idx == -1)) {
 		/* PLCP seems to be corrupted.
 		 * Drop the frame, if we are not interested in corrupted frames. */
 		if (!(dev->wl->filter_flags & FIF_PLCPFAIL))
 			goto drop;
 	}
+	status.rate_idx = rate_idx;
 	status.antenna = !!(phystat0 & B43_RX_PHYST0_ANT);
 
 	/*
-- 
1.7.10.4



