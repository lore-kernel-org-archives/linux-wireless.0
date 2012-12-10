Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40194 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab2LJK6k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 05:58:40 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: allow testing paged RX
Date: Mon, 10 Dec 2012 11:59:02 +0100
Message-Id: <1355137142-21292-1-git-send-email-johannes@sipsolutions.net> (sfid-20121210_115844_109015_C979B5D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Paged RX, i.e. SKBs with (some of) the data in pages instead
of the SKB header data (skb->data) can behave differently in
the stack and cause other bugs. To make debugging easier add
an option to hwsim to test with such SKBs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ff90855..145498f 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -48,6 +48,10 @@ static int channels = 1;
 module_param(channels, int, 0444);
 MODULE_PARM_DESC(channels, "Number of concurrent channels");
 
+static bool paged_rx = false;
+module_param(paged_rx, bool, 0644);
+MODULE_PARM_DESC(paged_rx, "Use paged SKBs for RX instead of linear ones");
+
 /**
  * enum hwsim_regtest - the type of regulatory tests we offer
  *
@@ -755,9 +759,25 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 		 * reserve some space for our vendor and the normal
 		 * radiotap header, since we're copying anyway
 		 */
-		nskb = skb_copy_expand(skb, 64, 0, GFP_ATOMIC);
-		if (nskb == NULL)
-			continue;
+		if (skb->len < PAGE_SIZE && paged_rx) {
+			struct page *page = alloc_page(GFP_ATOMIC);
+
+			if (!page)
+				continue;
+
+			nskb = dev_alloc_skb(128);
+			if (!nskb) {
+				__free_page(page);
+				continue;
+			}
+
+			memcpy(page_address(page), skb->data, skb->len);
+			skb_add_rx_frag(nskb, 0, page, 0, skb->len, skb->len);
+		} else {
+			nskb = skb_copy(skb, GFP_ATOMIC);
+			if (!nskb)
+				continue;
+		}
 
 		if (mac80211_hwsim_addr_match(data2, hdr->addr1))
 			ack = true;
-- 
1.8.0

