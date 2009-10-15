Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:64627 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502AbZJOHfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2009 03:35:14 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] wl1271: added missing packed modifier in some acx structs
Date: Thu, 15 Oct 2009 10:33:28 +0300
Message-Id: <1255592010-10287-4-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255592010-10287-1-git-send-email-luciano.coelho@nokia.com>
References: <1255592010-10287-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of the struct definitions in the wl1271_acx.h file were missing the
__attribute__ ((packed)) modifier.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 1580314..5085497 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -75,7 +75,7 @@ struct acx_header {
 
 	/* payload length (not including headers */
 	u16 len;
-};
+} __attribute__ ((packed));
 
 struct acx_error_counter {
 	struct acx_header header;
@@ -390,7 +390,7 @@ struct acx_conn_monit_params {
 
        u32 synch_fail_thold; /* number of beacons missed */
        u32 bss_lose_timeout; /* number of TU's from synch fail */
-};
+} __attribute__ ((packed));
 
 enum {
 	SG_ENABLE = 0,
@@ -420,19 +420,19 @@ struct acx_smart_reflex_state {
 
 	u8 enable;
 	u8 padding[3];
-};
+} __attribute__ ((packed));
 
 struct smart_reflex_err_table {
 	u8 len;
 	s8 upper_limit;
 	s8 values[14];
-};
+} __attribute__ ((packed));
 
 struct acx_smart_reflex_config_params {
 	struct acx_header header;
 
 	struct smart_reflex_err_table error_table[3];
-};
+} __attribute__ ((packed));
 
 #define PTA_ANTENNA_TYPE_DEF		  (0)
 #define PTA_BT_HP_MAXTIME_DEF		  (2000)
-- 
1.5.6.5

