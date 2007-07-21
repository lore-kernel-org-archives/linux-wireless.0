Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:54493 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757121AbXGUU7L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jul 2007 16:59:11 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: remove fill_rt_header
Message-Id: <20070721205915.341957B409F@zog.reactivated.net>
Date: Sat, 21 Jul 2007 21:59:15 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ulrich Kunitz <kune@deine-taler.de>

The mac80211 stack fills the radiotap header itself. So we can
remove the code, which did it in the driver. The patch removes
also warning about the unused fill_rt_header() function.

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/mac80211/zd1211rw/zd_mac.c |   38 ++---------------------
 1 files changed, 3 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
index 1de2630..b7fa301 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
@@ -570,33 +570,6 @@ struct zd_rt_hdr {
 	__le16 rt_chbitmask;
 } __attribute__((packed));
 
-static void fill_rt_header(void *buffer, struct zd_mac *mac,
-	                   const struct ieee80211_rx_status *stats,
-			   const struct rx_status *status)
-{
-	struct zd_rt_hdr *hdr = buffer;
-
-	hdr->rt_hdr.it_version = PKTHDR_RADIOTAP_VERSION;
-	hdr->rt_hdr.it_pad = 0;
-	hdr->rt_hdr.it_len = cpu_to_le16(sizeof(struct zd_rt_hdr));
-	hdr->rt_hdr.it_present = cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
-		                 (1 << IEEE80211_RADIOTAP_CHANNEL) |
-				 (1 << IEEE80211_RADIOTAP_RATE));
-
-	hdr->rt_flags = 0;
-	if (status->decryption_type & (ZD_RX_WEP64|ZD_RX_WEP128|ZD_RX_WEP256))
-		hdr->rt_flags |= IEEE80211_RADIOTAP_F_WEP;
-
-	hdr->rt_rate = stats->rate / 5;
-
-	/* FIXME: 802.11a */
-	hdr->rt_channel = cpu_to_le16(ieee80211chan2mhz(
-		                             _zd_chip_get_channel(&mac->chip)));
-	hdr->rt_chbitmask = cpu_to_le16(IEEE80211_CHAN_2GHZ |
-		((status->frame_status & ZD_RX_FRAME_MODULATION_MASK) ==
-		ZD_RX_OFDM ? IEEE80211_CHAN_OFDM : IEEE80211_CHAN_CCK));
-}
-
 static int fill_rx_stats(struct ieee80211_rx_status *stats,
 	                 const struct rx_status **pstatus,
 		         struct zd_mac *mac,
@@ -684,8 +657,7 @@ int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length)
 	if (r)
 		return r;
 
-	length -= ZD_PLCP_HEADER_SIZE+
-		  sizeof(struct rx_status);
+	length -= ZD_PLCP_HEADER_SIZE + sizeof(struct rx_status);
 	buffer += ZD_PLCP_HEADER_SIZE;
 
 	if (length == (10 /* IEEE80211_1ADDR_LEN */ + FCS_LEN) &&
@@ -693,13 +665,9 @@ int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length)
 	    mac->mode != IEEE80211_IF_TYPE_MNTR)
 		return 0;
 
-	skb = dev_alloc_skb(sizeof(struct zd_rt_hdr) + length);
-	if (!skb)
+	skb = dev_alloc_skb(length);
+	if (skb == NULL)
 		return -ENOMEM;
-	/* FIXME: reenable when mac80211 has support */
-	/*if (mac->mode == IEEE80211_IF_TYPE_MNTR)
-		fill_rt_header(skb_put(skb, sizeof(struct zd_rt_hdr)), mac,
-			       &stats, status);*/
 	memcpy(skb_put(skb, length), buffer, length);
 
 	ieee80211_rx_irqsafe(hw, skb, &stats);
-- 
1.5.2.2

