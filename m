Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58994 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaHDIWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2014 04:22:39 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 09/14] wil6210: fix beamforming data reporting
Date: Mon, 4 Aug 2014 11:20:49 +0300
Message-ID: <1407140454-31639-10-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140804_102242_209679_AD2EBB57)
In-Reply-To: <1407140454-31639-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1407140454-31639-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

When reading 'bf' file on debugfs, query beam forming status from firmware.
Ignore CID's that return error or return all zeros.

Remove obsolete code that used to maintain statistics on per-device basis,
as now it is reported be per-CID and current.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 78 +++++++++++++++++++++++++++---
 drivers/net/wireless/ath/wil6210/txrx.c    |  1 -
 drivers/net/wireless/ath/wil6210/wil6210.h | 12 -----
 drivers/net/wireless/ath/wil6210/wmi.c     | 28 -----------
 drivers/net/wireless/ath/wil6210/wmi.h     |  2 +-
 5 files changed, 72 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index d55018b..899c780 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -22,6 +22,7 @@
 #include <linux/power_supply.h>
 
 #include "wil6210.h"
+#include "wmi.h"
 #include "txrx.h"
 
 /* Max threshold supported value by wil6210 is 5sec.
@@ -768,16 +769,79 @@ static const struct file_operations fops_txdesc = {
 };
 
 /*---------beamforming------------*/
+static char *wil_bfstatus_str(u32 status)
+{
+	switch (status) {
+	case 0:
+		return "Failed";
+	case 1:
+		return "OK";
+	case 2:
+		return "Retrying";
+	default:
+		return "??";
+	}
+}
+
+static bool is_all_zeros(void * const x_, size_t sz)
+{
+	/* if reply is all-0, ignore this CID */
+	u32 *x = x_;
+	int n;
+
+	for (n = 0; n < sz / sizeof(*x); n++)
+		if (x[n])
+			return false;
+
+	return true;
+}
+
 static int wil_bf_debugfs_show(struct seq_file *s, void *data)
 {
+	int rc;
+	int i;
 	struct wil6210_priv *wil = s->private;
-	seq_printf(s,
-		   "TSF : 0x%016llx\n"
-		   "TxMCS : %d\n"
-		   "Sectors(rx:tx) my %2d:%2d peer %2d:%2d\n",
-		   wil->stats.tsf, wil->stats.bf_mcs,
-		   wil->stats.my_rx_sector, wil->stats.my_tx_sector,
-		   wil->stats.peer_rx_sector, wil->stats.peer_tx_sector);
+	struct wmi_notify_req_cmd cmd = {
+		.interval_usec = 0,
+	};
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_notify_req_done_event evt;
+	} __packed reply;
+
+	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
+		u32 status;
+
+		cmd.cid = i;
+		rc = wmi_call(wil, WMI_NOTIFY_REQ_CMDID, &cmd, sizeof(cmd),
+			      WMI_NOTIFY_REQ_DONE_EVENTID, &reply,
+			      sizeof(reply), 20);
+		/* if reply is all-0, ignore this CID */
+		if (rc || is_all_zeros(&reply.evt, sizeof(reply.evt)))
+			continue;
+
+		status = le32_to_cpu(reply.evt.status);
+		seq_printf(s, "CID %d {\n"
+			   "  TSF = 0x%016llx\n"
+			   "  TxMCS = %2d TxTpt = %4d\n"
+			   "  SQI = %4d\n"
+			   "  Status = 0x%08x %s\n"
+			   "  Sectors(rx:tx) my %2d:%2d peer %2d:%2d\n"
+			   "  Goodput(rx:tx) %4d:%4d\n"
+			   "}\n",
+			   i,
+			   le64_to_cpu(reply.evt.tsf),
+			   le16_to_cpu(reply.evt.bf_mcs),
+			   le32_to_cpu(reply.evt.tx_tpt),
+			   reply.evt.sqi,
+			   status, wil_bfstatus_str(status),
+			   le16_to_cpu(reply.evt.my_rx_sector),
+			   le16_to_cpu(reply.evt.my_tx_sector),
+			   le16_to_cpu(reply.evt.other_rx_sector),
+			   le16_to_cpu(reply.evt.other_tx_sector),
+			   le32_to_cpu(reply.evt.rx_goodput),
+			   le32_to_cpu(reply.evt.tx_goodput));
+	}
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 9fcc2e3..9bd920d 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -414,7 +414,6 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	cid = wil_rxdesc_cid(d);
 	stats = &wil->sta[cid].stats;
 	stats->last_mcs_rx = wil_rxdesc_mcs(d);
-	wil->stats.last_mcs_rx = stats->last_mcs_rx;
 
 	/* use radiotap header only if required */
 	if (ndev->type == ARPHRD_IEEE80211_RADIOTAP)
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 47d656a..902206c 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -330,17 +330,6 @@ struct wil_tid_ampdu_rx {
 	bool first_time; /* is it 1-st time this buffer used? */
 };
 
-struct wil6210_stats {
-	u64 tsf;
-	u32 snr;
-	u16 last_mcs_rx;
-	u16 bf_mcs; /* last BF, used for Tx */
-	u16 my_rx_sector;
-	u16 my_tx_sector;
-	u16 peer_rx_sector;
-	u16 peer_tx_sector;
-};
-
 enum wil_sta_status {
 	wil_sta_unused = 0,
 	wil_sta_conn_pending = 1,
@@ -433,7 +422,6 @@ struct wil6210_priv {
 
 	struct mutex mutex; /* for wil6210_priv access in wil_{up|down} */
 	/* statistics */
-	struct wil6210_stats stats;
 	atomic_t isr_count_rx, isr_count_tx;
 	/* debugfs */
 	struct dentry *debug;
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index b25a62d..0beb129 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -482,33 +482,6 @@ static void wmi_evt_disconnect(struct wil6210_priv *wil, int id,
 	mutex_unlock(&wil->mutex);
 }
 
-static void wmi_evt_notify(struct wil6210_priv *wil, int id, void *d, int len)
-{
-	struct wmi_notify_req_done_event *evt = d;
-
-	if (len < sizeof(*evt)) {
-		wil_err(wil, "Short NOTIFY event\n");
-		return;
-	}
-
-	wil->stats.tsf = le64_to_cpu(evt->tsf);
-	wil->stats.snr = le32_to_cpu(evt->snr_val);
-	wil->stats.bf_mcs = le16_to_cpu(evt->bf_mcs);
-	wil->stats.my_rx_sector = le16_to_cpu(evt->my_rx_sector);
-	wil->stats.my_tx_sector = le16_to_cpu(evt->my_tx_sector);
-	wil->stats.peer_rx_sector = le16_to_cpu(evt->other_rx_sector);
-	wil->stats.peer_tx_sector = le16_to_cpu(evt->other_tx_sector);
-	wil_dbg_wmi(wil, "Link status, MCS %d TSF 0x%016llx\n"
-		    "BF status 0x%08x SNR 0x%08x SQI %d%%\n"
-		    "Tx Tpt %d goodput %d Rx goodput %d\n"
-		    "Sectors(rx:tx) my %d:%d peer %d:%d\n",
-		    wil->stats.bf_mcs, wil->stats.tsf, evt->status,
-		    wil->stats.snr, evt->sqi, le32_to_cpu(evt->tx_tpt),
-		    le32_to_cpu(evt->tx_goodput), le32_to_cpu(evt->rx_goodput),
-		    wil->stats.my_rx_sector, wil->stats.my_tx_sector,
-		    wil->stats.peer_rx_sector, wil->stats.peer_tx_sector);
-}
-
 /*
  * Firmware reports EAPOL frame using WME event.
  * Reconstruct Ethernet frame and deliver it via normal Rx
@@ -651,7 +624,6 @@ static const struct {
 	{WMI_SCAN_COMPLETE_EVENTID,	wmi_evt_scan_complete},
 	{WMI_CONNECT_EVENTID,		wmi_evt_connect},
 	{WMI_DISCONNECT_EVENTID,	wmi_evt_disconnect},
-	{WMI_NOTIFY_REQ_DONE_EVENTID,	wmi_evt_notify},
 	{WMI_EAPOL_RX_EVENTID,		wmi_evt_eapol_rx},
 	{WMI_DATA_PORT_OPEN_EVENTID,	wmi_evt_linkup},
 	{WMI_WBE_LINKDOWN_EVENTID,	wmi_evt_linkdown},
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index 2f51b46..061618c 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -980,7 +980,7 @@ struct wmi_ready_event {
  * WMI_NOTIFY_REQ_DONE_EVENTID
  */
 struct wmi_notify_req_done_event {
-	__le32 status;
+	__le32 status; /* beamforming status, 0: fail; 1: OK; 2: retrying */
 	__le64 tsf;
 	__le32 snr_val;
 	__le32 tx_tpt;
-- 
1.8.5.2

