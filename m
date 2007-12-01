Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:63456 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbXLAK0I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Dec 2007 05:26:08 -0500
Date: Sat, 1 Dec 2007 11:26:05 +0100
From: Ulrich Kunitz <kune@deine-taler.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.org, dsd@gentoo.org, netdev@vger.kernel.org,
	shaddy_baddah@hotmail.com, davem@davemloft.net,
	herbert@gondor.apana.org.au, johannes@sipsolutions.net
Subject: [PATCH] zd1211rw: Fix alignment problems
Message-ID: <20071201102605.GA25387@deine-taler.de> (sfid-20071201_102627_153329_3F014082)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Shaddy Baddah found an alignment problem with zd1211rw driver at
2007-11-19. This patch fixes it, it is based on the patch proposed by
Herbert Xu. The alignment 4 has been the agreed value on the
linux-wireless mailing list.

Notify that the problem does only affect the old zd1211rw softmac
driver and not the zd1211rw-mac80211 driver. Daniel Drake has
already provided a patch for the replacement of the softmac
driver, which this patch will break.

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index a903645..5298a8b 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -1130,6 +1130,8 @@ static void zd_mac_rx(struct zd_mac *mac, struct sk_buff *skb)
 	__skb_trim(skb, skb->len -
 		        (IEEE80211_FCS_LEN + sizeof(struct rx_status)));
 
+	ZD_ASSERT(IS_ALIGNED((unsigned long)skb->data, 4));
+
 	update_qual_rssi(mac, skb->data, skb->len, stats.signal,
 		         status->signal_strength);
 
@@ -1166,15 +1168,19 @@ static void do_rx(unsigned long mac_ptr)
 int zd_mac_rx_irq(struct zd_mac *mac, const u8 *buffer, unsigned int length)
 {
 	struct sk_buff *skb;
+	unsigned int reserved =
+		ALIGN(max_t(unsigned int,
+		            sizeof(struct zd_rt_hdr), ZD_PLCP_HEADER_SIZE), 4) -
+		ZD_PLCP_HEADER_SIZE;
 
-	skb = dev_alloc_skb(sizeof(struct zd_rt_hdr) + length);
+	skb = dev_alloc_skb(reserved + length);
 	if (!skb) {
 		struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
 		dev_warn(zd_mac_dev(mac), "Could not allocate skb.\n");
 		ieee->stats.rx_dropped++;
 		return -ENOMEM;
 	}
-	skb_reserve(skb, sizeof(struct zd_rt_hdr));
+	skb_reserve(skb, reserved);
 	memcpy(__skb_put(skb, length), buffer, length);
 	skb_queue_tail(&mac->rx_queue, skb);
 	tasklet_schedule(&mac->rx_tasklet);
-- 
1.5.3.6
