Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:1536 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbdLAU1j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 15:27:39 -0500
From: Aditya Shankar <aditya.shankar@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <ganesh.krishna@microchip.com>, <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: [PATCH] staging: wilc1000: Fix problems reported by checkpatch
Date: Sat, 2 Dec 2017 01:57:14 +0530
Message-ID: <1512160034-6400-1-git-send-email-aditya.shankar@microchip.com> (sfid-20171201_212745_076081_D7481041)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit fixes below style problems in multiple lines
Fix checkpatch WARNING: line over 80 characters
Fix CHECK: Lines should not end with a '('

Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
---
 drivers/staging/wilc1000/linux_mon.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 91d49c4..a793c42 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -69,7 +69,8 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 	if (pkt_offset & IS_MANAGMEMENT_CALLBACK) {
 		/* hostapd callback mgmt frame */
 
-		skb = dev_alloc_skb(size + sizeof(struct wilc_wfi_radiotap_cb_hdr));
+		skb = dev_alloc_skb(size +
+				    sizeof(struct wilc_wfi_radiotap_cb_hdr));
 		if (!skb)
 			return;
 
@@ -80,11 +81,12 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 
 		cb_hdr->hdr.it_version = 0; /* PKTHDR_RADIOTAP_VERSION; */
 
-		cb_hdr->hdr.it_len = cpu_to_le16(sizeof(struct wilc_wfi_radiotap_cb_hdr));
+		cb_hdr->hdr.it_len =
+			cpu_to_le16(sizeof(struct wilc_wfi_radiotap_cb_hdr));
 
-		cb_hdr->hdr.it_present = cpu_to_le32(
-				(1 << IEEE80211_RADIOTAP_RATE) |
-				(1 << IEEE80211_RADIOTAP_TX_FLAGS));
+		cb_hdr->hdr.it_present =
+			cpu_to_le32((1 << IEEE80211_RADIOTAP_RATE) |
+				    (1 << IEEE80211_RADIOTAP_TX_FLAGS));
 
 		cb_hdr->rate = 5; /* txrate->bitrate / 5; */
 
@@ -96,7 +98,8 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 		}
 
 	} else {
-		skb = dev_alloc_skb(size + sizeof(struct wilc_wfi_radiotap_hdr));
+		skb = dev_alloc_skb(size +
+				    sizeof(struct wilc_wfi_radiotap_hdr));
 
 		if (!skb)
 			return;
@@ -105,7 +108,8 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 		hdr = skb_push(skb, sizeof(*hdr));
 		memset(hdr, 0, sizeof(struct wilc_wfi_radiotap_hdr));
 		hdr->hdr.it_version = 0; /* PKTHDR_RADIOTAP_VERSION; */
-		hdr->hdr.it_len = cpu_to_le16(sizeof(struct wilc_wfi_radiotap_hdr));
+		hdr->hdr.it_len =
+			cpu_to_le16(sizeof(struct wilc_wfi_radiotap_hdr));
 		hdr->hdr.it_present = cpu_to_le32
 				(1 << IEEE80211_RADIOTAP_RATE); /* | */
 		hdr->rate = 5; /* txrate->bitrate / 5; */
@@ -197,7 +201,8 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 	skb_pull(skb, rtap_len);
 
 	if (skb->data[0] == 0xc0 && (!(memcmp(broadcast, &skb->data[4], 6)))) {
-		skb2 = dev_alloc_skb(skb->len + sizeof(struct wilc_wfi_radiotap_cb_hdr));
+		skb2 = dev_alloc_skb(skb->len +
+				     sizeof(struct wilc_wfi_radiotap_cb_hdr));
 		if (!skb2)
 			return -ENOMEM;
 
@@ -208,11 +213,12 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 
 		cb_hdr->hdr.it_version = 0; /* PKTHDR_RADIOTAP_VERSION; */
 
-		cb_hdr->hdr.it_len = cpu_to_le16(sizeof(struct wilc_wfi_radiotap_cb_hdr));
+		cb_hdr->hdr.it_len =
+			cpu_to_le16(sizeof(struct wilc_wfi_radiotap_cb_hdr));
 
-		cb_hdr->hdr.it_present = cpu_to_le32(
-				(1 << IEEE80211_RADIOTAP_RATE) |
-				(1 << IEEE80211_RADIOTAP_TX_FLAGS));
+		cb_hdr->hdr.it_present =
+			cpu_to_le32((1 << IEEE80211_RADIOTAP_RATE) |
+				    (1 << IEEE80211_RADIOTAP_TX_FLAGS));
 
 		cb_hdr->rate = 5; /* txrate->bitrate / 5; */
 		cb_hdr->tx_flags = 0x0004;
-- 
2.7.4
