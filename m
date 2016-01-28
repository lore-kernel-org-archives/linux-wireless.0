Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32198 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbcA1SKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 13:10:39 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 3/4] wil6210: protect synchronous wmi commands handling
Date: Thu, 28 Jan 2016 19:24:04 +0200
Message-Id: <1454001845-28414-4-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160128_191044_149267_5D68467B)
In-Reply-To: <1454001845-28414-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1454001845-28414-1-git-send-email-qca_merez@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case there are multiple WMI commands with the same reply_id,
the following scenario can occur:
- Driver sends the first command to the device
- The reply didn’t get on time and there is timeout
- Reply_id, reply_buf and reply_size are set to 0
- Driver sends second wmi command with the same reply_id as the first
- Driver sets wil->reply_id
- Reply for the first wmi command arrives and handled by wmi_recv_cmd
- As its ID fits the reply_id but the reply_buf is not set yet it is
handled as a reply with event handler, and WARN_ON is printed

This patch guarantee atomic setting of all the reply variables and
prevents the above scenario.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index e1a6cb8..493e721 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -838,6 +838,7 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 			struct wil6210_mbox_hdr_wmi *wmi = &evt->event.wmi;
 			u16 id = le16_to_cpu(wmi->id);
 			u32 tstamp = le32_to_cpu(wmi->timestamp);
+			spin_lock_irqsave(&wil->wmi_ev_lock, flags);
 			if (wil->reply_id && wil->reply_id == id) {
 				if (wil->reply_buf) {
 					memcpy(wil->reply_buf, wmi,
@@ -845,6 +846,7 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
 					immed_reply = true;
 				}
 			}
+			spin_unlock_irqrestore(&wil->wmi_ev_lock, flags);
 
 			wil_dbg_wmi(wil, "WMI event 0x%04x MID %d @%d msec\n",
 				    id, wmi->mid, tstamp);
@@ -888,13 +890,16 @@ int wmi_call(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len,
 
 	mutex_lock(&wil->wmi_mutex);
 
+	spin_lock(&wil->wmi_ev_lock);
+	wil->reply_id = reply_id;
+	wil->reply_buf = reply;
+	wil->reply_size = reply_size;
+	spin_unlock(&wil->wmi_ev_lock);
+
 	rc = __wmi_send(wil, cmdid, buf, len);
 	if (rc)
 		goto out;
 
-	wil->reply_id = reply_id;
-	wil->reply_buf = reply;
-	wil->reply_size = reply_size;
 	remain = wait_for_completion_timeout(&wil->wmi_call,
 					     msecs_to_jiffies(to_msec));
 	if (0 == remain) {
@@ -907,10 +912,14 @@ int wmi_call(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len,
 			    cmdid, reply_id,
 			    to_msec - jiffies_to_msecs(remain));
 	}
+
+out:
+	spin_lock(&wil->wmi_ev_lock);
 	wil->reply_id = 0;
 	wil->reply_buf = NULL;
 	wil->reply_size = 0;
- out:
+	spin_unlock(&wil->wmi_ev_lock);
+
 	mutex_unlock(&wil->wmi_mutex);
 
 	return rc;
-- 
1.8.5.2

