Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:57151 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbZK3RM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:12:29 -0500
Date: Mon, 30 Nov 2009 18:12:35 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 05/12] mwl8k: properly report rate on received 40MHz packets
Message-ID: <20091130171235.GH20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8366, bit 6 in the rx descriptor rate field indicates whether the
packet was received on a 20MHz or 40MHz channel, and is not part of
the MCS index.  Handle this properly, which then prevents hitting the
WARN_ON and being dropped in ieee80211_rx().

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 0c90d85..b87908b 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -782,6 +782,10 @@ struct mwl8k_rxd_8366 {
 	__u8 rx_ctrl;
 } __attribute__((packed));
 
+#define MWL8K_8366_RATE_INFO_MCS_FORMAT		0x80
+#define MWL8K_8366_RATE_INFO_40MHZ		0x40
+#define MWL8K_8366_RATE_INFO_RATEID(x)		((x) & 0x3f)
+
 #define MWL8K_8366_RX_CTRL_OWNED_BY_HOST	0x80
 
 static void mwl8k_rxd_8366_init(void *_rxd, dma_addr_t next_dma_addr)
@@ -817,9 +821,11 @@ mwl8k_rxd_8366_process(void *_rxd, struct ieee80211_rx_status *status,
 	status->signal = -rxd->rssi;
 	status->noise = -rxd->noise_floor;
 
-	if (rxd->rate & 0x80) {
+	if (rxd->rate & MWL8K_8366_RATE_INFO_MCS_FORMAT) {
 		status->flag |= RX_FLAG_HT;
-		status->rate_idx = rxd->rate & 0x7f;
+		if (rxd->rate & MWL8K_8366_RATE_INFO_40MHZ)
+			status->flag |= RX_FLAG_40MHZ;
+		status->rate_idx = MWL8K_8366_RATE_INFO_RATEID(rxd->rate);
 	} else {
 		int i;
 
-- 
1.5.6.4
