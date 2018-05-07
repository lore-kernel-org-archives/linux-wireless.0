Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:54827 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752204AbeEGIp0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 04:45:26 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 26/30] staging: wilc1000: added #define for setting radiotap header
Date: Mon, 7 May 2018 14:13:30 +0530
Message-ID: <1525682614-3824-27-git-send-email-ajay.kathat@microchip.com> (sfid-20180507_104723_832695_31E8EF3D)
In-Reply-To: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added new macro to resolve below checkpatch issues in linux_mon.

"Lines should not end with a '('"

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_mon.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index c372e0f..1c7e6e1 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -22,6 +22,9 @@ static u8 bssid[6];
 #define IEEE80211_RADIOTAP_F_TX_FAIL	0x0001  /* failed due to excessive*/
 #define GET_PKT_OFFSET(a) (((a) >> 22) & 0x1ff)
 
+#define TX_RADIOTAP_PRESENT ((1 << IEEE80211_RADIOTAP_RATE) |	\
+			     (1 << IEEE80211_RADIOTAP_TX_FLAGS))
+
 void wilc_wfi_monitor_rx(u8 *buff, u32 size)
 {
 	u32 header, pkt_offset;
@@ -59,9 +62,7 @@ void wilc_wfi_monitor_rx(u8 *buff, u32 size)
 
 		cb_hdr->hdr.it_len = cpu_to_le16(sizeof(*cb_hdr));
 
-		cb_hdr->hdr.it_present = cpu_to_le32(
-				(1 << IEEE80211_RADIOTAP_RATE) |
-				(1 << IEEE80211_RADIOTAP_TX_FLAGS));
+		cb_hdr->hdr.it_present = cpu_to_le32(TX_RADIOTAP_PRESENT);
 
 		cb_hdr->rate = 5; /* txrate->bitrate / 5; */
 
@@ -177,9 +178,7 @@ static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
 
 		cb_hdr->hdr.it_len = cpu_to_le16(sizeof(*cb_hdr));
 
-		cb_hdr->hdr.it_present = cpu_to_le32(
-				(1 << IEEE80211_RADIOTAP_RATE) |
-				(1 << IEEE80211_RADIOTAP_TX_FLAGS));
+		cb_hdr->hdr.it_present = cpu_to_le32(TX_RADIOTAP_PRESENT);
 
 		cb_hdr->rate = 5; /* txrate->bitrate / 5; */
 		cb_hdr->tx_flags = 0x0004;
-- 
2.7.4
