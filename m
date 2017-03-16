Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43444 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751137AbdCPKqo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 06:46:44 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2GAiWlY023169
        for <linux-wireless@vger.kernel.org>; Thu, 16 Mar 2017 03:46:42 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 297s7dr0aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Thu, 16 Mar 2017 03:46:42 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: send fewer channels to scan while connected
Date: Thu, 16 Mar 2017 16:16:11 +0530
Message-ID: <1489661171-29796-1-git-send-email-akarwar@marvell.com> (sfid-20170316_114647_012529_F1F1BF70)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Application triggers periodic background scans when device is connected.
We will scan less number of channels per scan command so that data
traffic won't get affected.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 1816916..8295a05 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -989,10 +989,15 @@ enum cipher_suite {
 	 *  If a specific BSSID or SSID is used, the number of channels in the
 	 *  scan command will be increased to the absolute maximum.
 	 */
-	if (*filtered_scan)
+	if (*filtered_scan) {
 		*max_chan_per_scan = MWIFIEX_MAX_CHANNELS_PER_SPECIFIC_SCAN;
-	else
-		*max_chan_per_scan = MWIFIEX_DEF_CHANNELS_PER_SCAN_CMD;
+	} else {
+		if (!priv->media_connected)
+			*max_chan_per_scan = MWIFIEX_DEF_CHANNELS_PER_SCAN_CMD;
+		else
+			*max_chan_per_scan =
+					MWIFIEX_DEF_CHANNELS_PER_SCAN_CMD / 2;
+	}
 
 	if (adapter->ext_scan) {
 		bss_mode = (struct mwifiex_ie_types_bss_mode *)tlv_pos;
-- 
1.9.1
