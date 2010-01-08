Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58359 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab0AHR2f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 12:28:35 -0500
Date: Fri, 8 Jan 2010 18:28:34 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 03/11] mwl8k: bump the transmit wait timeout to 5 seconds
Message-ID: <20100108172830.GW1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While it is reasonable to expect that at least one transmit ring entry
will be processed per second while we are waiting for the transmit
rings to drain, the firmware can end up doing batching of transmit ring
status writeback, which means that the transmit rings can appear stuck
for more than a second at a time.

Bump the TX drain wait timeout up from 1 to 5 seconds to account for
this.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 3f5fdb6..8f5f7c9 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1173,7 +1173,7 @@ static void mwl8k_dump_tx_rings(struct ieee80211_hw *hw)
 /*
  * Must be called with priv->fw_mutex held and tx queues stopped.
  */
-#define MWL8K_TX_WAIT_TIMEOUT_MS	1000
+#define MWL8K_TX_WAIT_TIMEOUT_MS	5000
 
 static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 {
-- 
1.5.6.4
