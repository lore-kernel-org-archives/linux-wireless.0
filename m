Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3235 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754558AbaIQMCE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 08:02:04 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH] mwifiex: ensure user_scan_in not NULL while setting scan channel gap
Date: Wed, 17 Sep 2014 23:01:26 +0530
Message-ID: <1410975086-8044-1-git-send-email-patila@marvell.com> (sfid-20140917_140208_518210_84680660)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check for scan channel gap only when user_scan_in is not NULL.
user_scan_in is NULL for internal scans and if we check scan channel gap
at this place, it may result into crash.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 67f9cdb..a868552 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -926,6 +926,23 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 		if ((i && ssid_filter) ||
 		    !is_zero_ether_addr(scan_cfg_out->specific_bssid))
 			*filtered_scan = true;
+
+		if (user_scan_in->scan_chan_gap) {
+			dev_dbg(adapter->dev, "info: scan: channel gap = %d\n",
+				user_scan_in->scan_chan_gap);
+			*max_chan_per_scan =
+					MWIFIEX_MAX_CHANNELS_PER_SPECIFIC_SCAN;
+
+			chan_gap_tlv = (void *)tlv_pos;
+			chan_gap_tlv->header.type =
+					 cpu_to_le16(TLV_TYPE_SCAN_CHANNEL_GAP);
+			chan_gap_tlv->header.len =
+				    cpu_to_le16(sizeof(chan_gap_tlv->chan_gap));
+			chan_gap_tlv->chan_gap =
+				     cpu_to_le16((user_scan_in->scan_chan_gap));
+			tlv_pos +=
+				  sizeof(struct mwifiex_ie_types_scan_chan_gap);
+		}
 	} else {
 		scan_cfg_out->bss_mode = (u8) adapter->scan_mode;
 		num_probes = adapter->scan_probes;
@@ -940,22 +957,6 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 	else
 		*max_chan_per_scan = MWIFIEX_DEF_CHANNELS_PER_SCAN_CMD;
 
-	if (user_scan_in->scan_chan_gap) {
-		*max_chan_per_scan = MWIFIEX_MAX_CHANNELS_PER_SPECIFIC_SCAN;
-		dev_dbg(adapter->dev, "info: scan: channel gap = %d\n",
-			user_scan_in->scan_chan_gap);
-
-		chan_gap_tlv = (void *)tlv_pos;
-		chan_gap_tlv->header.type =
-					 cpu_to_le16(TLV_TYPE_SCAN_CHANNEL_GAP);
-		chan_gap_tlv->header.len =
-			cpu_to_le16(sizeof(chan_gap_tlv->chan_gap));
-		chan_gap_tlv->chan_gap =
-				     cpu_to_le16((user_scan_in->scan_chan_gap));
-
-		tlv_pos += sizeof(struct mwifiex_ie_types_scan_chan_gap);
-	}
-
 	/* If the input config or adapter has the number of Probes set,
 	   add tlv */
 	if (num_probes) {
-- 
1.8.1.4

