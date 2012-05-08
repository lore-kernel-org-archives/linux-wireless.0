Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:60448 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965Ab2EHLHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 07:07:32 -0400
Received: by obbuo13 with SMTP id uo13so577547obb.15
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 04:07:31 -0700 (PDT)
From: Yoni Divinsky <yoni.divinsky@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <arik@wizery.com>, <coelho@ti.com>
Subject: [PATCH 4/4] wlcore: fix the CONF_TX_AC_ANY_TID to be 0xff
Date: Tue,  8 May 2012 14:02:14 +0300
Message-Id: <1336474934-22069-4-git-send-email-yoni.divinsky@ti.com> (sfid-20120508_130735_513557_EC5F97DC)
In-Reply-To: <1336474934-22069-1-git-send-email-yoni.divinsky@ti.com>
References: <1336474934-22069-1-git-send-email-yoni.divinsky@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the enum conf_tx_ac CONF_TX_AC_ANY_TID should
be 0xff to match the firmware's implementation.

Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
---
 drivers/net/wireless/ti/wlcore/conf.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index fef0db4..dbea4db 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -504,7 +504,7 @@ enum conf_tx_ac {
 	CONF_TX_AC_VI = 2,         /* video */
 	CONF_TX_AC_VO = 3,         /* voice */
 	CONF_TX_AC_CTS2SELF = 4,   /* fictitious AC, follows AC_VO */
-	CONF_TX_AC_ANY_TID = 0x1f
+	CONF_TX_AC_ANY_TID = 0xff
 };
 
 struct conf_tx_ac_category {
-- 
1.7.0.4

