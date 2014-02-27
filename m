Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:15624 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbaB0OWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:22:07 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 13/16] wil6210: Provide signal strength indication
Date: Thu, 27 Feb 2014 16:20:52 +0200
Message-ID: <1393510855-17566-14-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140227_152214_654082_D0BD5578)
In-Reply-To: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When notifying about Rx mgmt (ex: during scan), extract
signal strength reported by the hardware.
signal is not MBM, it is arbitrary units 0..100

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  7 ++++---
 drivers/net/wireless/ath/wil6210/wmi.c      | 12 ++++++------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 12e0539..c19e895 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -125,12 +125,13 @@ static int wil_cid_fill_sinfo(struct wil6210_priv *wil, int cid,
 
 	wil_dbg_wmi(wil, "Link status for CID %d: {\n"
 		    "  MCS %d TSF 0x%016llx\n"
-		    "  BF status 0x%08x SNR 0x%08x\n"
+		    "  BF status 0x%08x SNR 0x%08x SQI %d%%\n"
 		    "  Tx Tpt %d goodput %d Rx goodput %d\n"
 		    "  Sectors(rx:tx) my %d:%d peer %d:%d\n""}\n",
 		    cid, le16_to_cpu(reply.evt.bf_mcs),
 		    le64_to_cpu(reply.evt.tsf), reply.evt.status,
 		    le32_to_cpu(reply.evt.snr_val),
+		    reply.evt.sqi,
 		    le32_to_cpu(reply.evt.tx_tpt),
 		    le32_to_cpu(reply.evt.tx_goodput),
 		    le32_to_cpu(reply.evt.rx_goodput),
@@ -163,7 +164,7 @@ static int wil_cid_fill_sinfo(struct wil6210_priv *wil, int cid,
 
 	if (test_bit(wil_status_fwconnected, &wil->status)) {
 		sinfo->filled |= STATION_INFO_SIGNAL;
-		sinfo->signal = 12; /* TODO: provide real value */
+		sinfo->signal = reply.evt.sqi;
 	}
 
 	return rc;
@@ -698,7 +699,7 @@ static void wil_wiphy_init(struct wiphy *wiphy)
 	wiphy->bands[IEEE80211_BAND_60GHZ] = &wil_band_60ghz;
 
 	/* TODO: figure this out */
-	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+	wiphy->signal_type = CFG80211_SIGNAL_TYPE_UNSPEC;
 
 	wiphy->cipher_suites = wil_cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(wil_cipher_suites);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 8de7ffd..70b3a9b 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -307,14 +307,14 @@ static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
 	u32 freq = ieee80211_channel_to_frequency(ch_no,
 			IEEE80211_BAND_60GHZ);
 	struct ieee80211_channel *channel = ieee80211_get_channel(wiphy, freq);
-	/* TODO convert LE to CPU */
-	s32 signal = 0; /* TODO */
+	s32 signal = data->info.sqi;
 	__le16 fc = rx_mgmt_frame->frame_control;
 	u32 d_len = le32_to_cpu(data->info.len);
 	u16 d_status = le16_to_cpu(data->info.status);
 
-	wil_dbg_wmi(wil, "MGMT: channel %d MCS %d SNR %d\n",
-		    data->info.channel, data->info.mcs, data->info.snr);
+	wil_dbg_wmi(wil, "MGMT: channel %d MCS %d SNR %d SQI %d%%\n",
+		    data->info.channel, data->info.mcs, data->info.snr,
+		    data->info.sqi);
 	wil_dbg_wmi(wil, "status 0x%04x len %d fc 0x%04x\n", d_status, d_len,
 		    le16_to_cpu(fc));
 	wil_dbg_wmi(wil, "qid %d mid %d cid %d\n",
@@ -487,11 +487,11 @@ static void wmi_evt_notify(struct wil6210_priv *wil, int id, void *d, int len)
 	wil->stats.peer_rx_sector = le16_to_cpu(evt->other_rx_sector);
 	wil->stats.peer_tx_sector = le16_to_cpu(evt->other_tx_sector);
 	wil_dbg_wmi(wil, "Link status, MCS %d TSF 0x%016llx\n"
-		    "BF status 0x%08x SNR 0x%08x\n"
+		    "BF status 0x%08x SNR 0x%08x SQI %d%%\n"
 		    "Tx Tpt %d goodput %d Rx goodput %d\n"
 		    "Sectors(rx:tx) my %d:%d peer %d:%d\n",
 		    wil->stats.bf_mcs, wil->stats.tsf, evt->status,
-		    wil->stats.snr, le32_to_cpu(evt->tx_tpt),
+		    wil->stats.snr, evt->sqi, le32_to_cpu(evt->tx_tpt),
 		    le32_to_cpu(evt->tx_goodput), le32_to_cpu(evt->rx_goodput),
 		    wil->stats.my_rx_sector, wil->stats.my_tx_sector,
 		    wil->stats.peer_rx_sector, wil->stats.peer_tx_sector);
-- 
1.8.3.2

