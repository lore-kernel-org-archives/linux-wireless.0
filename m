Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:49794 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbcCYMUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2016 08:20:04 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/11] staging: wilc1000: removes typedef of struct struct_frame_reg
Date: Fri, 25 Mar 2016 21:16:48 +0900
Message-ID: <1458908216-12100-3-git-send-email-leo.kim@atmel.com> (sfid-20160325_132007_506845_D5A91C51)
In-Reply-To: <1458908216-12100-1-git-send-email-leo.kim@atmel.com>
References: <1458908216-12100-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef of struct struct_frame_reg.
Renames the struct_frame_reg to frame_reg as well.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 4123cff..f394484 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -139,18 +139,17 @@ struct wilc_priv {
 
 };
 
-typedef struct {
+struct frame_reg {
 	u16 frame_type;
 	bool reg;
-
-} struct_frame_reg;
+};
 
 struct wilc_vif {
 	u8 idx;
 	u8 iftype;
 	int monitor_flag;
 	int mac_opened;
-	struct_frame_reg g_struct_frame_reg[num_reg_frame];
+	struct frame_reg g_struct_frame_reg[num_reg_frame];
 	struct net_device_stats netstats;
 	struct wilc *wilc;
 	u8 src_addr[ETH_ALEN];
-- 
1.9.1

