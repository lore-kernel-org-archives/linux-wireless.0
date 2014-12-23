Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17835 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbaLWHsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:48:06 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 08/22] wil6210: delba for responder
Date: Tue, 23 Dec 2014 09:47:10 +0200
Message-Id: <1419320844-23989-9-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_084814_190384_B61DF19B)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement delba flow for the responder (Rx) side

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c |  2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h |  3 ++-
 drivers/net/wireless/ath/wil6210/wmi.c     | 15 ++++++++++++++-
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index c57cc2d..316c7c1 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -598,7 +598,7 @@ static ssize_t wil_write_addba(struct file *file, const char __user *buf,
 	if (agg_wsize > 0)
 		wmi_addba(wil, 0, agg_wsize, 0);
 	else
-		wmi_delba(wil, 0, 0);
+		wmi_delba_tx(wil, 0, 0);
 
 	return len;
 }
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 747052d..1b4efd2 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -607,7 +607,8 @@ int wmi_rxon(struct wil6210_priv *wil, bool on);
 int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_m, u32 *t_r);
 int wmi_disconnect_sta(struct wil6210_priv *wil, const u8 *mac, u16 reason);
 int wmi_addba(struct wil6210_priv *wil, u8 ringid, u8 size, u16 timeout);
-int wmi_delba(struct wil6210_priv *wil, u8 ringid, u16 reason);
+int wmi_delba_tx(struct wil6210_priv *wil, u8 ringid, u16 reason);
+int wmi_delba_rx(struct wil6210_priv *wil, u8 cidxtid, u16 reason);
 int wmi_addba_rx_resp(struct wil6210_priv *wil, u8 cid, u8 tid, u8 token,
 		      u16 status, bool amsdu, u16 agg_wsize, u16 timeout);
 int wil_addba_rx_request(struct wil6210_priv *wil, u8 cidxtid,
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 00cba4a..af2ca46 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1184,7 +1184,7 @@ int wmi_addba(struct wil6210_priv *wil, u8 ringid, u8 size, u16 timeout)
 	return wmi_send(wil, WMI_VRING_BA_EN_CMDID, &cmd, sizeof(cmd));
 }
 
-int wmi_delba(struct wil6210_priv *wil, u8 ringid, u16 reason)
+int wmi_delba_tx(struct wil6210_priv *wil, u8 ringid, u16 reason)
 {
 	struct wmi_vring_ba_dis_cmd cmd = {
 		.ringid = ringid,
@@ -1197,6 +1197,19 @@ int wmi_delba(struct wil6210_priv *wil, u8 ringid, u16 reason)
 	return wmi_send(wil, WMI_VRING_BA_DIS_CMDID, &cmd, sizeof(cmd));
 }
 
+int wmi_delba_rx(struct wil6210_priv *wil, u8 cidxtid, u16 reason)
+{
+	struct wmi_rcp_delba_cmd cmd = {
+		.cidxtid = cidxtid,
+		.reason = cpu_to_le16(reason),
+	};
+
+	wil_dbg_wmi(wil, "%s(CID %d TID %d reason %d)\n", __func__,
+		    cidxtid & 0xf, (cidxtid >> 4) & 0xf, reason);
+
+	return wmi_send(wil, WMI_RCP_DELBA_CMDID, &cmd, sizeof(cmd));
+}
+
 int wmi_addba_rx_resp(struct wil6210_priv *wil, u8 cid, u8 tid, u8 token,
 		      u16 status, bool amsdu, u16 agg_wsize, u16 timeout)
 {
-- 
2.1.0

