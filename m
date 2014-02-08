Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56492 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbaBHAXl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:23:41 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 05/30] mwifiex: change beacon parameter structure
Date: Fri, 7 Feb 2014 16:23:34 -0800
Message-ID: <1391819017-20995-1-git-send-email-bzhao@marvell.com> (sfid-20140208_012345_160614_9C1331D1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

'mwifiex_bcn_param' structure contains five parameters which
are present in beacon buffer in case of legacy scan.

'rssi' field won't be there in this buffer for extended scan.
Hence 'bssid' and 'rssi' are removed from the structure and it is
renamed as 'mwifiex_fixed_bcn_param' so that we can have common
parsing logic later for both.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h   |  4 +---
 drivers/net/wireless/mwifiex/scan.c | 25 +++++++++++++++----------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index d8014c8..9b26790 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1047,9 +1047,7 @@ struct host_cmd_ds_rf_ant_siso {
 	__le16 ant_mode;
 };
 
-struct mwifiex_bcn_param {
-	u8 bssid[ETH_ALEN];
-	u8 rssi;
+struct mwifiex_fixed_bcn_param {
 	__le64 timestamp;
 	__le16 beacon_period;
 	__le16 cap_info_bitmap;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 0a8a26e..b0be830 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1689,7 +1689,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		u16 cap_info_bitmap;
 		u8 *current_ptr;
 		u64 timestamp;
-		struct mwifiex_bcn_param *bcn_param;
+		struct mwifiex_fixed_bcn_param *bcn_param;
 		struct mwifiex_bss_priv *bss_priv;
 
 		if (bytes_left >= sizeof(beacon_size)) {
@@ -1716,25 +1716,30 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 
 		curr_bcn_bytes = beacon_size;
 
-		/*
-		 * First 5 fields are bssid, RSSI, time stamp, beacon interval,
-		 *   and capability information
+		/* First 5 fields are bssid, RSSI(for legacy scan only),
+		 * time stamp, beacon interval, and capability information
 		 */
-		if (curr_bcn_bytes < sizeof(struct mwifiex_bcn_param)) {
+		if (curr_bcn_bytes < ETH_ALEN + sizeof(u8) +
+		    sizeof(struct mwifiex_fixed_bcn_param)) {
 			dev_err(adapter->dev,
 				"InterpretIE: not enough bytes left\n");
 			continue;
 		}
-		bcn_param = (struct mwifiex_bcn_param *)current_ptr;
-		current_ptr += sizeof(*bcn_param);
-		curr_bcn_bytes -= sizeof(*bcn_param);
 
-		memcpy(bssid, bcn_param->bssid, ETH_ALEN);
+		memcpy(bssid, current_ptr, ETH_ALEN);
+		current_ptr += ETH_ALEN;
+		curr_bcn_bytes -= ETH_ALEN;
 
-		rssi = (s32) bcn_param->rssi;
+		rssi = (s32) *(u8 *)current_ptr;
 		rssi = (-rssi) * 100;		/* Convert dBm to mBm */
+		current_ptr += sizeof(u8);
+		curr_bcn_bytes -= sizeof(u8);
 		dev_dbg(adapter->dev, "info: InterpretIE: RSSI=%d\n", rssi);
 
+		bcn_param = (struct mwifiex_fixed_bcn_param *)current_ptr;
+		current_ptr += sizeof(*bcn_param);
+		curr_bcn_bytes -= sizeof(*bcn_param);
+
 		timestamp = le64_to_cpu(bcn_param->timestamp);
 		beacon_period = le16_to_cpu(bcn_param->beacon_period);
 
-- 
1.8.2.3

