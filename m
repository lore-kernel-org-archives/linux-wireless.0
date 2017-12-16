Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:9111 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750850AbdLPHy6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Dec 2017 02:54:58 -0500
From: Aditya Shankar <aditya.shankar@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <ganesh.krishna@microchip.com>, <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>, <Claudiu.Beznea@microchip.com>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: [PATCH v2] staging: wilc1000: Fix problems reported by checkpatch
Date: Sat, 16 Dec 2017 13:24:24 +0530
Message-ID: <1513410864-6566-1-git-send-email-aditya.shankar@microchip.com> (sfid-20171216_085503_395119_80975480)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit fixes below style problems in multiple lines
Fix checkpatch WARNING: line over 80 characters

Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
---
 drivers/staging/wilc1000/linux_mon.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 91d49c4..1c740af 100644
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
 
@@ -80,7 +81,8 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 
 		cb_hdr->hdr.it_version = 0; /* PKTHDR_RADIOTAP_VERSION; */
 
-		cb_hdr->hdr.it_len = cpu_to_le16(sizeof(struct wilc_wfi_radiotap_cb_hdr));
+		cb_hdr->hdr.it_len =
+			cpu_to_le16(sizeof(struct wilc_wfi_radiotap_cb_hdr));
 
 		cb_hdr->hdr.it_present = cpu_to_le32(
 				(1 << IEEE80211_RADIOTAP_RATE) |
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
 
@@ -208,7 +213,8 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 
 		cb_hdr->hdr.it_version = 0; /* PKTHDR_RADIOTAP_VERSION; */
 
-		cb_hdr->hdr.it_len = cpu_to_le16(sizeof(struct wilc_wfi_radiotap_cb_hdr));
+		cb_hdr->hdr.it_len =
+			cpu_to_le16(sizeof(struct wilc_wfi_radiotap_cb_hdr));
 
 		cb_hdr->hdr.it_present = cpu_to_le32(
 				(1 << IEEE80211_RADIOTAP_RATE) |
-- 
2.7.4
