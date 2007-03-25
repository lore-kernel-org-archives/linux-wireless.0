Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:21528 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753360AbXCYXSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2007 19:18:12 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: Fix for monitor mode bug
Message-Id: <20070325231817.9C5887B409F@zog.reactivated.net>
Date: Mon, 26 Mar 2007 00:18:17 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ulrich Kunitz <kune@deine-taler.de>

The ZD1211 supports the delivery of packets with a wrong CRC value
to the host. We switched that feature on in monitor mode, so that
incomplete packets were delivered.

This problem has been reported to bugzilla.kernel.org as bug 8152.
This patch fixes it for the mac80211 stack.

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/mac80211/zd1211rw/zd_mac.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
index 097f614..65eabfa 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
@@ -91,17 +91,9 @@ void zd_mac_clear(struct zd_mac *mac)
 
 static int reset_mode(struct zd_mac *mac)
 {
-	struct zd_ioreq32 ioreqs[] = {
-		{ CR_RX_FILTER, STA_RX_FILTER },
-		{ CR_SNIFFER_ON, 0U },
-	};
-
-	if (mac->mode == IEEE80211_IF_TYPE_MNTR) {
-		ioreqs[0].value = 0xffffffff;
-		ioreqs[1].value = 0x1;
-	}
+	u32 filter = mac->mode == IEEE80211_IF_TYPE_MNTR ? ~0 : STA_RX_FILTER;
 
-	return zd_iowrite32a(&mac->chip, ioreqs, ARRAY_SIZE(ioreqs));
+	return zd_iowrite32(&mac->chip, CR_RX_FILTER, filter);
 }
 
 static int zd_mac_open(struct ieee80211_hw *dev)
-- 
1.5.0.5

