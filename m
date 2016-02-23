Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58315 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbcBWNU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 08:20:26 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u1NDKGDw030316
	for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2016 05:20:24 -0800
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0a-0016f401.pphosted.com with ESMTP id 218m5mgrta-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2016 05:20:24 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/4] mwifiex: add delay when tdls confirm frame is queued
Date: Tue, 23 Feb 2016 05:16:16 -0800
Message-ID: <1456233379-12099-1-git-send-email-akarwar@marvell.com> (sfid-20160223_142029_942387_F55961BE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

It is observed that driver may send the data packet to tdls peer
before tdls peer receives tdls setup confirm frame.
Similar race condition exists during tdls teardown procedure also.
This patch adds 10 milliseconds delay to resolve the race.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/tdls.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/tdls.c b/drivers/net/wireless/marvell/mwifiex/tdls.c
index 9275f9c..1506496 100644
--- a/drivers/net/wireless/marvell/mwifiex/tdls.c
+++ b/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -680,6 +680,13 @@ int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv, const u8 *peer,
 	__net_timestamp(skb);
 	mwifiex_queue_tx_pkt(priv, skb);
 
+	/* Delay 10ms to make sure tdls setup confirm/teardown frame
+	 * is received by peer
+	*/
+	if (action_code == WLAN_TDLS_SETUP_CONFIRM ||
+	    action_code == WLAN_TDLS_TEARDOWN)
+		msleep_interruptible(10);
+
 	return 0;
 }
 
-- 
1.8.1.4

