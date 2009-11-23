Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:58574 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757275AbZKWVpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 16:45:18 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v2 8/8] rt2x00: Properly request tx headroom for alignment operations.
Date: Mon, 23 Nov 2009 22:44:54 +0100
Message-Id: <1259012694-14869-9-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1259012694-14869-8-git-send-email-gwingerde@gmail.com>
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-2-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-3-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-4-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-5-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-6-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-7-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-8-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current rt2x00 drivers may result in a "ieee80211_tx_status: headroom too
small" error message when a frame needs to be properly aligned before
transmitting it.
This is because the space needed to ensure proper alignment isn't
requested from mac80211.
Fix this by adding sufficient amount of alignment space to the amount
of headroom requested for TX frames.

Reported-by: David Ellingsworth <david@identd.dyndns.org>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    6 ++++++
 drivers/net/wireless/rt2x00/rt2x00dev.c |   12 +++++++++++-
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 4d841c0..dcfc8c2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -113,6 +113,12 @@
 	(  ((unsigned long)((__skb)->data + (__header))) & 3 )
 
 /*
+ * Constants for extra TX headroom for alignment purposes.
+ */
+#define RT2X00_ALIGN_SIZE	4 /* Only whole frame needs alignment */
+#define RT2X00_L2PAD_SIZE	8 /* Both header & payload need alignment */
+
+/*
  * Standard timing and size defines.
  * These values should follow the ieee80211 specifications.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 06c43ca..265e66d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -686,7 +686,17 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize extra TX headroom required.
 	 */
-	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom;
+	rt2x00dev->hw->extra_tx_headroom =
+		max_t(unsigned int, IEEE80211_TX_STATUS_HEADROOM,
+		      rt2x00dev->ops->extra_tx_headroom);
+
+	/*
+	 * Take TX headroom required for alignment into account.
+	 */
+	if (test_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags))
+		rt2x00dev->hw->extra_tx_headroom += RT2X00_L2PAD_SIZE;
+	else if (test_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags))
+		rt2x00dev->hw->extra_tx_headroom += RT2X00_ALIGN_SIZE;
 
 	/*
 	 * Register HW.
-- 
1.6.5.3

