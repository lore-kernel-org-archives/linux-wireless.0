Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:34889
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750790Ab3GTECa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jul 2013 00:02:30 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH] cw1200:  Fix incorrect endianness annotation in a header field
Date: Sat, 20 Jul 2013 00:02:25 -0400
Message-Id: <1374292945-29753-1-git-send-email-pizza@shaftnet.org> (sfid-20130720_060247_234311_6A38435F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note that the driver doesn't directly use this field, but it should be
correctly defined in any case.

I'd like to see this in 3.11-rc

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/wsm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/cw1200/wsm.h b/drivers/net/wireless/cw1200/wsm.h
index 7afc613..48086e8 100644
--- a/drivers/net/wireless/cw1200/wsm.h
+++ b/drivers/net/wireless/cw1200/wsm.h
@@ -832,7 +832,7 @@ struct wsm_tx {
 	/* the MSDU shall be terminated. Overrides the global */
 	/* dot11MaxTransmitMsduLifeTime setting [optional] */
 	/* Device will set the default value if this is 0. */
-	u32 expire_time;
+	__le32 expire_time;
 
 	/* WSM_HT_TX_... */
 	__le32 ht_tx_parameters;
-- 
1.8.3.1

