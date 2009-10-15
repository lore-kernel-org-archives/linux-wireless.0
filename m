Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:20606 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566AbZJOHfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2009 03:35:15 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/5] wl1271: added missing packed modifier in some cmd structs
Date: Thu, 15 Oct 2009 10:33:30 +0300
Message-Id: <1255592010-10287-6-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255592010-10287-1-git-send-email-luciano.coelho@nokia.com>
References: <1255592010-10287-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of the struct definitions in the wl1271_acx.h file were missing the
__attribute__ ((packed)) modifier.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 57d6905..174b820 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -184,7 +184,7 @@ struct cmd_read_write_memory {
 	   of this field is the Host in WRITE command or the Wilink in READ
 	   command. */
 	u8 value[MAX_READ_SIZE];
-};
+} __attribute__ ((packed));
 
 #define CMDMBOX_HEADER_LEN 4
 #define CMDMBOX_INFO_ELEM_HEADER_LEN 4
@@ -399,12 +399,12 @@ struct wl1271_cmd_trigger_scan_to {
 	struct wl1271_cmd_header header;
 
 	__le32 timeout;
-};
+} __attribute__ ((packed));
 
 struct wl1271_cmd_test_header {
 	u8 id;
 	u8 padding[3];
-};
+} __attribute__ ((packed));
 
 enum wl1271_channel_tune_bands {
 	WL1271_CHANNEL_TUNE_BAND_2_4,
-- 
1.5.6.5

