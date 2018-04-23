Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:12209 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754308AbeDWIw1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 04:52:27 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codeaurora.org>
Subject: [PATCH v2 05/10] wil6210: change reply_size arg to u16 in wmi_call
Date: Mon, 23 Apr 2018 11:52:08 +0300
Message-Id: <1524473533-24524-6-git-send-email-merez@codeaurora.org> (sfid-20180423_105243_006023_A8CF781E)
In-Reply-To: <1524473533-24524-1-git-send-email-merez@codeaurora.org>
References: <1524473533-24524-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <liord@codeaurora.org>

Change the type of the argument reply_size from u8 to
u16 in order to support reply sizes > 255 bytes.
The driver already supports u16 reply size in all
other places, this was the only missing change.

Signed-off-by: Lior David <liord@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/wil6210.h | 2 +-
 drivers/net/wireless/ath/wil6210/wmi.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index c765ff2..c81fe1d 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -987,7 +987,7 @@ int wmi_read_hdr(struct wil6210_priv *wil, __le32 ptr,
 int wmi_send(struct wil6210_priv *wil, u16 cmdid, u8 mid, void *buf, u16 len);
 void wmi_recv_cmd(struct wil6210_priv *wil);
 int wmi_call(struct wil6210_priv *wil, u16 cmdid, u8 mid, void *buf, u16 len,
-	     u16 reply_id, void *reply, u8 reply_size, int to_msec);
+	     u16 reply_id, void *reply, u16 reply_size, int to_msec);
 void wmi_event_worker(struct work_struct *work);
 void wmi_event_flush(struct wil6210_priv *wil);
 int wmi_set_ssid(struct wil6210_vif *vif, u8 ssid_len, const void *ssid);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 9f2c21b..cdaf80d 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1426,7 +1426,7 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 }
 
 int wmi_call(struct wil6210_priv *wil, u16 cmdid, u8 mid, void *buf, u16 len,
-	     u16 reply_id, void *reply, u8 reply_size, int to_msec)
+	     u16 reply_id, void *reply, u16 reply_size, int to_msec)
 {
 	int rc;
 	unsigned long remain;
-- 
1.9.1
