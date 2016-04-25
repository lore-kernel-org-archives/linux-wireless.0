Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6054 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993AbcDYGut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 02:50:49 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u3P6khZ7031149
	for <linux-wireless@vger.kernel.org>; Sun, 24 Apr 2016 23:50:48 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 22g8jfm2f8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 24 Apr 2016 23:50:48 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/2] mwifiex: increase dwell time for active scan
Date: Sun, 24 Apr 2016 23:49:52 -0700
Message-ID: <1461566992-3539-2-git-send-email-akarwar@marvell.com> (sfid-20160425_085055_210904_27228743)
In-Reply-To: <1461566992-3539-1-git-send-email-akarwar@marvell.com>
References: <1461566992-3539-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's been observed that sometimes AP's probe response is
received after scan duration gets completed for the channel.
This happens especially when wildcard scan is performed
along with specific SSID scan.
We will increase the time from 30 msecs to 40 msecs.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 4c742a5..0207af0 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -111,8 +111,8 @@ enum {
 #define SCAN_BEACON_ENTRY_PAD			6
 
 #define MWIFIEX_PASSIVE_SCAN_CHAN_TIME	110
-#define MWIFIEX_ACTIVE_SCAN_CHAN_TIME	30
-#define MWIFIEX_SPECIFIC_SCAN_CHAN_TIME	30
+#define MWIFIEX_ACTIVE_SCAN_CHAN_TIME	40
+#define MWIFIEX_SPECIFIC_SCAN_CHAN_TIME	40
 #define MWIFIEX_DEF_SCAN_CHAN_GAP_TIME  50
 
 #define SCAN_RSSI(RSSI)					(0x100 - ((u8)(RSSI)))
-- 
1.8.1.4

