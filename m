Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:4690 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaIJNfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:13 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 04/22] wil6210: some more debug for the WMI mechanism
Date: Wed, 10 Sep 2014 16:34:33 +0300
Message-ID: <1410356091-19219-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153537_366791_7C385AA7)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Log worker thread start/stop; as well as every handler invocation

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index b1aaaee..490c278 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1128,6 +1128,9 @@ static void wmi_event_handle(struct wil6210_priv *wil,
 		struct wil6210_mbox_hdr_wmi *wmi = (void *)(&hdr[1]);
 		void *evt_data = (void *)(&wmi[1]);
 		u16 id = le16_to_cpu(wmi->id);
+
+		wil_dbg_wmi(wil, "Handle WMI 0x%04x (reply_id 0x%04x)\n",
+			    id, wil->reply_id);
 		/* check if someone waits for this event */
 		if (wil->reply_id && wil->reply_id == id) {
 			if (wil->reply_buf) {
@@ -1184,9 +1187,11 @@ void wmi_event_worker(struct work_struct *work)
 	struct pending_wmi_event *evt;
 	struct list_head *lh;
 
+	wil_dbg_wmi(wil, "Start %s\n", __func__);
 	while ((lh = next_wmi_ev(wil)) != NULL) {
 		evt = list_entry(lh, struct pending_wmi_event, list);
 		wmi_event_handle(wil, &evt->event.hdr);
 		kfree(evt);
 	}
+	wil_dbg_wmi(wil, "Finished %s\n", __func__);
 }
-- 
1.9.1

