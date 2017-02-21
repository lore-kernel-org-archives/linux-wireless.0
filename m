Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17504 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752933AbdBUOc1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 09:32:27 -0500
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 07/10] wil6210: protect list of pending wmi events during flush
Date: Tue, 21 Feb 2017 16:32:05 +0200
Message-Id: <1487687528-12832-8-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170221_153234_465446_0DD542DB)
In-Reply-To: <1487687528-12832-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1487687528-12832-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>

When flush is done, pending events list is manipulated
without taking the proper spinlock, which could lead to
memory corruption if list is manipulated by wmi worker
or by interrupt routine.

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index a2a895b..02ccdae 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1738,14 +1738,19 @@ int wmi_new_sta(struct wil6210_priv *wil, const u8 *mac, u8 aid)
 
 void wmi_event_flush(struct wil6210_priv *wil)
 {
+	ulong flags;
 	struct pending_wmi_event *evt, *t;
 
 	wil_dbg_wmi(wil, "event_flush\n");
 
+	spin_lock_irqsave(&wil->wmi_ev_lock, flags);
+
 	list_for_each_entry_safe(evt, t, &wil->pending_wmi_ev, list) {
 		list_del(&evt->list);
 		kfree(evt);
 	}
+
+	spin_unlock_irqrestore(&wil->wmi_ev_lock, flags);
 }
 
 static bool wmi_evt_call_handler(struct wil6210_priv *wil, int id,
-- 
1.9.1
