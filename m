Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:49707 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517AbZL3Kgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2009 05:36:52 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Wireless list <linux-wireless@vger.kernel.org>,
	rt2x00 users list <users@rt2x00.serialmonkey.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 2/6] rt2x00: Properly request tx headroom for alignment operations.
Date: Wed, 30 Dec 2009 11:36:30 +0100
Message-Id: <1262169394-11647-3-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1262169394-11647-2-git-send-email-gwingerde@gmail.com>
References: <1262169394-11647-1-git-send-email-gwingerde@gmail.com>
 <1262169394-11647-2-git-send-email-gwingerde@gmail.com>
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
Acked-by: Ivo van Doorn <ivdoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    6 ++++++
 drivers/net/wireless/rt2x00/rt2x00dev.c |   12 +++++++++++-
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index b4c6e0a..096da85 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -119,6 +119,12 @@
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
index d7711e4..b93731b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -688,7 +688,17 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
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
1.6.6

