Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:45197 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751036AbdLPHzi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Dec 2017 02:55:38 -0500
From: Aditya Shankar <aditya.shankar@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <ganesh.krishna@microchip.com>, <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: [PATCH] staging: wilc1000: Fix lines ending with parentheses
Date: Sat, 16 Dec 2017 13:25:19 +0530
Message-ID: <1513410919-6628-1-git-send-email-aditya.shankar@microchip.com> (sfid-20171216_085541_805504_E85C5E53)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the "Lines should not end with a '('"
problem reported by checkpatch

Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>
---
 drivers/staging/wilc1000/linux_mon.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 1c740af..a793c42 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -84,9 +84,9 @@ void WILC_WFI_monitor_rx(u8 *buff, u32 size)
 		cb_hdr->hdr.it_len =
 			cpu_to_le16(sizeof(struct wilc_wfi_radiotap_cb_hdr));
 
-		cb_hdr->hdr.it_present = cpu_to_le32(
-				(1 << IEEE80211_RADIOTAP_RATE) |
-				(1 << IEEE80211_RADIOTAP_TX_FLAGS));
+		cb_hdr->hdr.it_present =
+			cpu_to_le32((1 << IEEE80211_RADIOTAP_RATE) |
+				    (1 << IEEE80211_RADIOTAP_TX_FLAGS));
 
 		cb_hdr->rate = 5; /* txrate->bitrate / 5; */
 
@@ -216,9 +216,9 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 		cb_hdr->hdr.it_len =
 			cpu_to_le16(sizeof(struct wilc_wfi_radiotap_cb_hdr));
 
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
