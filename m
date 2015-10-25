Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29747 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbbJYN7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 09:59:36 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 1/4] wil6210: ignore selected WMI events
Date: Sun, 25 Oct 2015 15:59:21 +0200
Message-Id: <1445781564-24455-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20151025_145939_107234_BE1ADCB5)
In-Reply-To: <1445781564-24455-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1445781564-24455-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some events are ignored for purpose; such events should not
be treated as "unhandled events". Replace info message
saying "unhandled" with debug one saying "ignore", to reduce
dmesg pollution

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 6112189..361f3d8 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -684,6 +684,15 @@ __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 	spin_unlock_bh(&sta->tid_rx_lock);
 }
 
+/**
+ * Some events are ignored for purpose; and need not be interpreted as
+ * "unhandled events"
+ */
+static void wmi_evt_ignore(struct wil6210_priv *wil, int id, void *d, int len)
+{
+	wil_dbg_wmi(wil, "Ignore event 0x%04x len %d\n", id, len);
+}
+
 static const struct {
 	int eventid;
 	void (*handler)(struct wil6210_priv *wil, int eventid,
@@ -701,6 +710,7 @@ static const struct {
 	{WMI_RCP_ADDBA_REQ_EVENTID,	wmi_evt_addba_rx_req},
 	{WMI_DELBA_EVENTID,		wmi_evt_delba},
 	{WMI_VRING_EN_EVENTID,		wmi_evt_vring_en},
+	{WMI_DATA_PORT_OPEN_EVENTID,		wmi_evt_ignore},
 };
 
 /*
-- 
2.1.4

