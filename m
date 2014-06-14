Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:44468 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbaFNNuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2014 09:50:44 -0400
Received: by mail-pd0-f171.google.com with SMTP id ft15so2983223pdb.16
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2014 06:50:44 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id fd5sm37773893pad.12.2014.06.14.06.50.42
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sat, 14 Jun 2014 06:50:43 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 04/16] rsi: Add macros for endpoints and set default value of endpoint.
Date: Sat, 14 Jun 2014 19:20:33 +0530
Message-Id: <1402753833-13950-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140614_155047_336229_3AA5404D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added macros for the endpoints and set the default value of endpoint
to 2.4GHz and 20MHz.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c |    1 +
 drivers/net/wireless/rsi/rsi_mgmt.h     |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 2eefbf1..2cdb36a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -217,6 +217,7 @@ static void rsi_set_default_parameters(struct rsi_common *common)
 	common->min_rate = 0xffff;
 	common->fsm_state = FSM_CARD_NOT_READY;
 	common->iface_down = true;
+	common->endpoint = EP_2GHZ_20MHZ;
 }
 
 /**
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 225215a..0641068 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -123,6 +123,11 @@
 #define BW_20MHZ                        0
 #define BW_40MHZ                        1
 
+#define EP_2GHZ_20MHZ			0
+#define EP_2GHZ_40MHZ			1
+#define EP_5GHZ_20MHZ			2
+#define EP_5GHZ_40MHZ			3
+
 #define RSI_SUPP_FILTERS	(FIF_ALLMULTI | FIF_PROBE_REQ |\
 				 FIF_BCN_PRBRESP_PROMISC)
 enum opmode {
-- 
1.7.1

