Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:64841 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbaFPOLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 10:11:32 -0400
Received: by mail-pd0-f182.google.com with SMTP id y13so4478229pdi.13
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2014 07:11:32 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id su8sm19019825pbc.72.2014.06.16.07.11.31
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 16 Jun 2014 07:11:32 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 04/16] rsi: Add macros for endpoints and set default value of endpoint.
Date: Mon, 16 Jun 2014 19:41:22 +0530
Message-Id: <1402927882-3860-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140616_161135_467405_48C45B27)
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

