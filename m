Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:52667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbXIBT60 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2007 15:58:26 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211#everything: PS mode fix
Date: Sun,  2 Sep 2007 22:58:21 +0300
Message-Id: <1188763101479-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tx.mode must be set also for buffered frames. It is used in the tx hanlders

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/tx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 902d5b4..5a7345f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1877,6 +1877,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw, int if_id,
 	}
 	sta = tx.sta;
 	tx.flags |= IEEE80211_TXRXD_TXPS_BUFFERED;
+	tx.u.tx.mode = local->hw.conf.mode;
 
 	for (handler = local->tx_handlers; *handler != NULL; handler++) {
 		res = (*handler)(&tx);
-- 
1.5.2.2
