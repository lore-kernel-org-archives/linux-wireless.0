Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42243 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab0HQTrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 15:47:21 -0400
Received: by eyg5 with SMTP id 5so2243619eyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Aug 2010 12:47:20 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 1/4] wl1251: add missing __packed modifier for some structs
Date: Tue, 17 Aug 2010 22:46:52 +0300
Message-Id: <1282074415-6168-2-git-send-email-notasas@gmail.com>
In-Reply-To: <1282074415-6168-1-git-send-email-notasas@gmail.com>
References: <1282074415-6168-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several acx and cmd structures are missing __packed modifier, add it.
This was noticed while comparing them with corresponding wl1271 code.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl12xx/wl1251_acx.h |    6 +++---
 drivers/net/wireless/wl12xx/wl1251_cmd.h |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.h b/drivers/net/wireless/wl12xx/wl1251_acx.h
index 842df31..9864124 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.h
@@ -37,7 +37,7 @@ struct acx_header {
 
 	/* payload length (not including headers */
 	u16 len;
-};
+} __packed;
 
 struct acx_error_counter {
 	struct acx_header header;
@@ -471,7 +471,7 @@ struct acx_conn_monit_params {
 
 	u32 synch_fail_thold; /* number of beacons missed */
 	u32 bss_lose_timeout; /* number of TU's from synch fail */
-};
+} __packed;
 
 enum {
 	SG_ENABLE = 0,
@@ -1056,7 +1056,7 @@ struct acx_rate_class {
 	u8 long_retry_limit;
 	u8 aflags;
 	u8 reserved;
-};
+} __packed;
 
 struct acx_rate_policy {
 	struct acx_header header;
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.h b/drivers/net/wireless/wl12xx/wl1251_cmd.h
index a9e4991..60d7e52 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.h
@@ -111,7 +111,7 @@ struct wl1251_cmd_header {
 struct  wl1251_command {
 	struct wl1251_cmd_header header;
 	u8  parameters[MAX_CMD_PARAMS];
-};
+} __packed;
 
 enum {
 	CMD_MAILBOX_IDLE              		=  0,
@@ -164,7 +164,7 @@ struct cmd_read_write_memory {
 	   of this field is the Host in WRITE command or the Wilink in READ
 	   command. */
 	u8 value[MAX_READ_SIZE];
-};
+} __packed;
 
 #define CMDMBOX_HEADER_LEN 4
 #define CMDMBOX_INFO_ELEM_HEADER_LEN 4
@@ -339,7 +339,7 @@ struct wl1251_cmd_trigger_scan_to {
 	struct wl1251_cmd_header header;
 
 	u32 timeout;
-};
+} __packed;
 
 /* HW encryption keys */
 #define NUM_ACCESS_CATEGORIES_COPY 4
-- 
1.5.6.3

