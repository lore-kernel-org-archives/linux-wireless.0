Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZDJICw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 04:02:52 -0400
Subject: [PATCH] ar9170: fix struct layout on arm
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	chunkeey <chunkeey@web.de>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 10:02:45 +0200
Message-Id: <1239350565.17031.21.camel@johannes.local> (sfid-20090410_100257_183385_61D44863)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

arm will pad even between u8's, so mark the structs/unions
packed. Fixes a build bug on arm due to BUILD_BUG_ON tests
in the code.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/wireless/ar9170/hw.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ar9170/hw.h	2009-04-10 09:58:05.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ar9170/hw.h	2009-04-10 09:58:33.000000000 +0200
@@ -310,7 +310,7 @@ struct ar9170_tx_control {
 
 struct ar9170_rx_head {
 	u8 plcp[12];
-};
+} __packed;
 
 struct ar9170_rx_tail {
 	union {
@@ -318,16 +318,16 @@ struct ar9170_rx_tail {
 			u8 rssi_ant0, rssi_ant1, rssi_ant2,
 			   rssi_ant0x, rssi_ant1x, rssi_ant2x,
 			   rssi_combined;
-		};
+		} __packed;
 		u8 rssi[7];
-	};
+	} __packed;
 
 	u8 evm_stream0[6], evm_stream1[6];
 	u8 phy_err;
 	u8 SAidx, DAidx;
 	u8 error;
 	u8 status;
-};
+} __packed;
 
 #define AR9170_ENC_ALG_NONE			0x0
 #define AR9170_ENC_ALG_WEP64			0x1


