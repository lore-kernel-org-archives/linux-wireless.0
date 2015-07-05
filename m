Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:6121 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844AbbGEIqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2015 04:46:22 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 12/13] wil6210: improve mgmt frame handling
Date: Sun,  5 Jul 2015 10:24:39 +0300
Message-Id: <1436081080-27305-13-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150705_104651_041771_3AC064C6)
In-Reply-To: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check event length;
hex dump both Rx and Tx frames

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 54 +++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 0678fff..d3f75de 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -312,22 +312,44 @@ static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
 	struct wiphy *wiphy = wil_to_wiphy(wil);
 	struct ieee80211_mgmt *rx_mgmt_frame =
 			(struct ieee80211_mgmt *)data->payload;
-	int ch_no = data->info.channel+1;
-	u32 freq = ieee80211_channel_to_frequency(ch_no,
-			IEEE80211_BAND_60GHZ);
-	struct ieee80211_channel *channel = ieee80211_get_channel(wiphy, freq);
-	s32 signal = data->info.sqi;
-	__le16 fc = rx_mgmt_frame->frame_control;
-	u32 d_len = le32_to_cpu(data->info.len);
-	u16 d_status = le16_to_cpu(data->info.status);
-
-	wil_dbg_wmi(wil, "MGMT: channel %d MCS %d SNR %d SQI %d%%\n",
+	int flen = len - offsetof(struct wmi_rx_mgmt_packet_event, payload);
+	int ch_no;
+	u32 freq;
+	struct ieee80211_channel *channel;
+	s32 signal;
+	__le16 fc;
+	u32 d_len;
+	u16 d_status;
+
+	if (flen < 0) {
+		wil_err(wil, "MGMT Rx: short event, len %d\n", len);
+		return;
+	}
+
+	d_len = le32_to_cpu(data->info.len);
+	if (d_len != flen) {
+		wil_err(wil,
+			"MGMT Rx: length mismatch, d_len %d should be %d\n",
+			d_len, flen);
+		return;
+	}
+
+	ch_no = data->info.channel + 1;
+	freq = ieee80211_channel_to_frequency(ch_no, IEEE80211_BAND_60GHZ);
+	channel = ieee80211_get_channel(wiphy, freq);
+	signal = data->info.sqi;
+	d_status = le16_to_cpu(data->info.status);
+	fc = rx_mgmt_frame->frame_control;
+
+	wil_dbg_wmi(wil, "MGMT Rx: channel %d MCS %d SNR %d SQI %d%%\n",
 		    data->info.channel, data->info.mcs, data->info.snr,
 		    data->info.sqi);
 	wil_dbg_wmi(wil, "status 0x%04x len %d fc 0x%04x\n", d_status, d_len,
 		    le16_to_cpu(fc));
 	wil_dbg_wmi(wil, "qid %d mid %d cid %d\n",
 		    data->info.qid, data->info.mid, data->info.cid);
+	wil_hex_dump_wmi("MGMT Rx ", DUMP_PREFIX_OFFSET, 16, 1, rx_mgmt_frame,
+			 d_len, true);
 
 	if (!channel) {
 		wil_err(wil, "Frame on unsupported channel\n");
@@ -363,6 +385,17 @@ static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
 	}
 }
 
+static void wmi_evt_tx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
+{
+	struct wmi_tx_mgmt_packet_event *data = d;
+	struct ieee80211_mgmt *mgmt_frame =
+			(struct ieee80211_mgmt *)data->payload;
+	int flen = len - offsetof(struct wmi_tx_mgmt_packet_event, payload);
+
+	wil_hex_dump_wmi("MGMT Tx ", DUMP_PREFIX_OFFSET, 16, 1, mgmt_frame,
+			 flen, true);
+}
+
 static void wmi_evt_scan_complete(struct wil6210_priv *wil, int id,
 				  void *d, int len)
 {
@@ -680,6 +713,7 @@ static const struct {
 	{WMI_READY_EVENTID,			wmi_evt_ready},
 	{WMI_FW_READY_EVENTID,			wmi_evt_fw_ready},
 	{WMI_RX_MGMT_PACKET_EVENTID,		wmi_evt_rx_mgmt},
+	{WMI_TX_MGMT_PACKET_EVENTID,		wmi_evt_tx_mgmt},
 	{WMI_SCAN_COMPLETE_EVENTID,		wmi_evt_scan_complete},
 	{WMI_ACS_PASSIVE_SCAN_COMPLETE_EVENTID, wmi_evt_survey_complete},
 	{WMI_CONNECT_EVENTID,			wmi_evt_connect},
-- 
2.1.4

