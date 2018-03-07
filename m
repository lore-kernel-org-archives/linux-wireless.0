Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:33453 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934377AbeCHPLJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:11:09 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 07/10] staging: wilc1000: fix line over 80 char for cfg parse RX and TX function
Date: Wed, 7 Mar 2018 07:02:27 +0530
Message-ID: <1520386350-31607-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_161113_356134_23A146B5)
In-Reply-To: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
References: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 characters' issue found by checkpatch.pl script. Moved
the common code from wilc_wfi_cfg_parse_tx_action() &
wilc_wfi_cfg_parse_rx_action() to new function to avoid checkpatch issue.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 67 +++++++++++------------
 1 file changed, 32 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 92c3213..911af68 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1337,10 +1337,33 @@ static int flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 	return 0;
 }
 
+static inline void wilc_wfi_cfg_parse_ch_attr(u8 *buf, u8 ch_list_attr_idx,
+					      u8 op_ch_attr_idx)
+{
+	int i = 0;
+	int j = 0;
+
+	if (ch_list_attr_idx) {
+		u8 limit = ch_list_attr_idx + 3 + buf[ch_list_attr_idx + 1];
+
+		for (i = ch_list_attr_idx + 3; i < limit; i++) {
+			if (buf[i] == 0x51) {
+				for (j = i + 2; j < ((i + 2) + buf[i + 1]); j++)
+					buf[j] = wlan_channel;
+				break;
+			}
+		}
+	}
+
+	if (op_ch_attr_idx) {
+		buf[op_ch_attr_idx + 6] = 0x51;
+		buf[op_ch_attr_idx + 7] = wlan_channel;
+	}
+}
+
 static void wilc_wfi_cfg_parse_rx_action(u8 *buf, u32 len)
 {
 	u32 index = 0;
-	u32 i = 0, j = 0;
 
 	u8 op_channel_attr_index = 0;
 	u8 channel_list_attr_index = 0;
@@ -1355,28 +1378,15 @@ static void wilc_wfi_cfg_parse_rx_action(u8 *buf, u32 len)
 			op_channel_attr_index = index;
 		index += buf[index + 1] + 3;
 	}
-	if (wlan_channel != INVALID_CHANNEL) {
-		if (channel_list_attr_index) {
-			for (i = channel_list_attr_index + 3; i < ((channel_list_attr_index + 3) + buf[channel_list_attr_index + 1]); i++) {
-				if (buf[i] == 0x51) {
-					for (j = i + 2; j < ((i + 2) + buf[i + 1]); j++)
-						buf[j] = wlan_channel;
-					break;
-				}
-			}
-		}
-
-		if (op_channel_attr_index) {
-			buf[op_channel_attr_index + 6] = 0x51;
-			buf[op_channel_attr_index + 7] = wlan_channel;
-		}
-	}
+	if (wlan_channel != INVALID_CHANNEL)
+		wilc_wfi_cfg_parse_ch_attr(buf, channel_list_attr_index,
+					   op_channel_attr_index);
 }
 
-static void wilc_wfi_cfg_parse_tx_action(u8 *buf, u32 len, bool oper_ch, u8 iftype)
+static void wilc_wfi_cfg_parse_tx_action(u8 *buf, u32 len, bool oper_ch,
+					 u8 iftype)
 {
 	u32 index = 0;
-	u32 i = 0, j = 0;
 
 	u8 op_channel_attr_index = 0;
 	u8 channel_list_attr_index = 0;
@@ -1394,22 +1404,9 @@ static void wilc_wfi_cfg_parse_tx_action(u8 *buf, u32 len, bool oper_ch, u8 ifty
 			op_channel_attr_index = index;
 		index += buf[index + 1] + 3;
 	}
-	if (wlan_channel != INVALID_CHANNEL && oper_ch) {
-		if (channel_list_attr_index) {
-			for (i = channel_list_attr_index + 3; i < ((channel_list_attr_index + 3) + buf[channel_list_attr_index + 1]); i++) {
-				if (buf[i] == 0x51) {
-					for (j = i + 2; j < ((i + 2) + buf[i + 1]); j++)
-						buf[j] = wlan_channel;
-					break;
-				}
-			}
-		}
-
-		if (op_channel_attr_index) {
-			buf[op_channel_attr_index + 6] = 0x51;
-			buf[op_channel_attr_index + 7] = wlan_channel;
-		}
-	}
+	if (wlan_channel != INVALID_CHANNEL && oper_ch)
+		wilc_wfi_cfg_parse_ch_attr(buf, channel_list_attr_index,
+					   op_channel_attr_index);
 }
 
 void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
-- 
2.7.4
