Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:42690 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbaDMNeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 09:34:37 -0400
Received: by mail-we0-f177.google.com with SMTP id u57so7169575wes.36
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 06:34:36 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl18xx: align event mailbox with current fw
Date: Sun, 13 Apr 2014 16:33:51 +0300
Message-Id: <1397396071-7825-1-git-send-email-eliad@wizery.com> (sfid-20140413_153502_272550_1E1064DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some fields are missing from the event mailbox
struct definitions, which cause issues when
trying to handle some events.

Add the missing fields in order to align the
struct size (without adding actual support
for the new fields).

Reported-and-tested-by: Imre Kaloz <kaloz@openwrt.org>
Cc: stable@vger.kernel.org # 3.14+
Fixes: 028e724 ("wl18xx: move to new firmware (wl18xx-fw-3.bin)")
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/event.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/event.h b/drivers/net/wireless/ti/wl18xx/event.h
index 398f3d2..a76e98e 100644
--- a/drivers/net/wireless/ti/wl18xx/event.h
+++ b/drivers/net/wireless/ti/wl18xx/event.h
@@ -68,6 +68,26 @@ struct wl18xx_event_mailbox {
 
 	/* bitmap of inactive stations (by HLID) */
 	__le32 inactive_sta_bitmap;
+
+	/* rx BA win size indicated by RX_BA_WIN_SIZE_CHANGE_EVENT_ID */
+	u8 rx_ba_role_id;
+	u8 rx_ba_link_id;
+	u8 rx_ba_win_size;
+	u8 padding;
+
+	/* smart config */
+	u8 sc_ssid_len;
+	u8 sc_pwd_len;
+	u8 sc_token_len;
+	u8 padding1;
+	u8 sc_ssid[32];
+	u8 sc_pwd[32];
+	u8 sc_token[32];
+
+	/* smart config sync channel */
+	u8 sc_sync_channel;
+	u8 sc_sync_band;
+	u8 padding2[2];
 } __packed;
 
 int wl18xx_wait_for_event(struct wl1271 *wl, enum wlcore_wait_event event,
-- 
1.8.5.2.229.g4448466.dirty

