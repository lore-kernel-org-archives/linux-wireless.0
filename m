Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49897 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab2KVUo2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 15:44:28 -0500
Message-ID: <1353585496.9806.38.camel@jlt4.sipsolutions.net> (sfid-20121122_214459_638051_642CF951)
Subject: [PATCH] iwlegacy: initialize rx_status
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 22 Nov 2012 12:58:16 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The vendor radiotap patch added a few fields to
struct ieee80211_rx_status that need to be zero,
initialize the struct instead of using whatever
was left on the stack.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
I have a patch for iwlwifi queued as well, all other drivers seem fine.

 drivers/net/wireless/iwlegacy/3945.c     | 2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 87e5398..e0b9d7f 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -516,7 +516,7 @@ static void
 il3945_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 {
 	struct ieee80211_hdr *header;
-	struct ieee80211_rx_status rx_status;
+	struct ieee80211_rx_status rx_status = {};
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il3945_rx_frame_stats *rx_stats = IL_RX_STATS(pkt);
 	struct il3945_rx_frame_hdr *rx_hdr = IL_RX_HDR(pkt);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index ef68b72..07ffa57 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -613,7 +613,7 @@ void
 il4965_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 {
 	struct ieee80211_hdr *header;
-	struct ieee80211_rx_status rx_status;
+	struct ieee80211_rx_status rx_status = {};
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_rx_phy_res *phy_res;
 	__le32 rx_pkt_status;
-- 
1.8.0



