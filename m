Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:64443 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab3A1Qck (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:32:40 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/14] wil6210: Refactor rx init/fini
Date: Mon, 28 Jan 2013 18:30:59 +0200
Message-ID: <1359390669-9310-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130128_173244_089450_76CB7D07)
In-Reply-To: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move WMI related operations to wmi.c as helper functions

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c    |   54 +-------------------
 drivers/net/wireless/ath/wil6210/wil6210.h |    2 +
 drivers/net/wireless/ath/wil6210/wmi.c     |   73 ++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 241dd0e..f3b523b 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -484,53 +484,18 @@ void wil_rx_handle(struct wil6210_priv *wil)
 
 int wil_rx_init(struct wil6210_priv *wil)
 {
-	struct net_device *ndev = wil_to_ndev(wil);
-	struct wireless_dev *wdev = wil->wdev;
 	struct vring *vring = &wil->vring_rx;
 	int rc;
-	struct wmi_cfg_rx_chain_cmd cmd = {
-		.action = WMI_RX_CHAIN_ADD,
-		.rx_sw_ring = {
-			.max_mpdu_size = cpu_to_le16(RX_BUF_LEN),
-		},
-		.mid = 0, /* TODO - what is it? */
-		.decap_trans_type = WMI_DECAP_TYPE_802_3,
-	};
-	struct {
-		struct wil6210_mbox_hdr_wmi wmi;
-		struct wmi_cfg_rx_chain_done_event evt;
-	} __packed evt;
 
 	vring->size = WIL6210_RX_RING_SIZE;
 	rc = wil_vring_alloc(wil, vring);
 	if (rc)
 		return rc;
 
-	cmd.rx_sw_ring.ring_mem_base = cpu_to_le64(vring->pa);
-	cmd.rx_sw_ring.ring_size = cpu_to_le16(vring->size);
-	if (wdev->iftype == NL80211_IFTYPE_MONITOR) {
-		struct ieee80211_channel *ch = wdev->preset_chandef.chan;
-
-		cmd.sniffer_cfg.mode = cpu_to_le32(WMI_SNIFFER_ON);
-		if (ch)
-			cmd.sniffer_cfg.channel = ch->hw_value - 1;
-		cmd.sniffer_cfg.phy_info_mode =
-			cpu_to_le32(ndev->type == ARPHRD_IEEE80211_RADIOTAP);
-		cmd.sniffer_cfg.phy_support =
-			cpu_to_le32((wil->monitor_flags & MONITOR_FLAG_CONTROL)
-				    ? WMI_SNIFFER_CP : WMI_SNIFFER_DP);
-	}
-	/* typical time for secure PCP is 840ms */
-	rc = wmi_call(wil, WMI_CFG_RX_CHAIN_CMDID, &cmd, sizeof(cmd),
-		      WMI_CFG_RX_CHAIN_DONE_EVENTID, &evt, sizeof(evt), 2000);
+	rc = wmi_rx_chain_add(wil, vring);
 	if (rc)
 		goto err_free;
 
-	vring->hwtail = le32_to_cpu(evt.evt.rx_ring_tail_ptr);
-
-	wil_dbg_MISC(wil, "Rx init: status %d tail 0x%08x\n",
-		     le32_to_cpu(evt.evt.status), vring->hwtail);
-
 	rc = wil_rx_refill(wil, vring->size);
 	if (rc)
 		goto err_free;
@@ -547,22 +512,7 @@ void wil_rx_fini(struct wil6210_priv *wil)
 	struct vring *vring = &wil->vring_rx;
 
 	if (vring->va) {
-		int rc;
-		struct wmi_cfg_rx_chain_cmd cmd = {
-			.action = cpu_to_le32(WMI_RX_CHAIN_DEL),
-			.rx_sw_ring = {
-				.max_mpdu_size = cpu_to_le16(RX_BUF_LEN),
-			},
-		};
-		struct {
-			struct wil6210_mbox_hdr_wmi wmi;
-			struct wmi_cfg_rx_chain_done_event cfg;
-		} __packed wmi_rx_cfg_reply;
-
-		rc = wmi_call(wil, WMI_CFG_RX_CHAIN_CMDID, &cmd, sizeof(cmd),
-			      WMI_CFG_RX_CHAIN_DONE_EVENTID,
-			      &wmi_rx_cfg_reply, sizeof(wmi_rx_cfg_reply),
-			      100);
+		wmi_rx_chain_del(wil);
 		wil_vring_free(wil, vring, 0);
 	}
 }
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index a9b6f70..9b2ebdd 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -329,6 +329,8 @@ int wmi_add_cipher_key(struct wil6210_priv *wil, u8 key_index,
 		       const void *mac_addr, int key_len, const void *key);
 int wmi_echo(struct wil6210_priv *wil);
 int wmi_set_ie(struct wil6210_priv *wil, u8 type, u16 ie_len, const void *ie);
+int wmi_rx_chain_del(struct wil6210_priv *wil);
+int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring);
 
 int wil6210_init_irq(struct wil6210_priv *wil, int irq);
 void wil6210_fini_irq(struct wil6210_priv *wil, int irq);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 12915f6..d109c3f 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -18,8 +18,10 @@
 #include <linux/io.h>
 #include <linux/list.h>
 #include <linux/etherdevice.h>
+#include <linux/if_arp.h>
 
 #include "wil6210.h"
+#include "txrx.h"
 #include "wmi.h"
 
 /**
@@ -853,6 +855,77 @@ int wmi_set_ie(struct wil6210_priv *wil, u8 type, u16 ie_len, const void *ie)
 	return rc;
 }
 
+int wmi_rx_chain_add(struct wil6210_priv *wil, struct vring *vring)
+{
+	struct wireless_dev *wdev = wil->wdev;
+	struct net_device *ndev = wil_to_ndev(wil);
+	struct wmi_cfg_rx_chain_cmd cmd = {
+		.action = WMI_RX_CHAIN_ADD,
+		.rx_sw_ring = {
+			.max_mpdu_size = cpu_to_le16(RX_BUF_LEN),
+			.ring_mem_base = cpu_to_le64(vring->pa),
+			.ring_size = cpu_to_le16(vring->size),
+		},
+		.mid = 0, /* TODO - what is it? */
+		.decap_trans_type = WMI_DECAP_TYPE_802_3,
+	};
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_cfg_rx_chain_done_event evt;
+	} __packed evt;
+	int rc;
+
+	if (wdev->iftype == NL80211_IFTYPE_MONITOR) {
+		struct ieee80211_channel *ch = wdev->preset_chandef.chan;
+
+		cmd.sniffer_cfg.mode = cpu_to_le32(WMI_SNIFFER_ON);
+		if (ch)
+			cmd.sniffer_cfg.channel = ch->hw_value - 1;
+		cmd.sniffer_cfg.phy_info_mode =
+			cpu_to_le32(ndev->type == ARPHRD_IEEE80211_RADIOTAP);
+		cmd.sniffer_cfg.phy_support =
+			cpu_to_le32((wil->monitor_flags & MONITOR_FLAG_CONTROL)
+				    ? WMI_SNIFFER_CP : WMI_SNIFFER_DP);
+	}
+	/* typical time for secure PCP is 840ms */
+	rc = wmi_call(wil, WMI_CFG_RX_CHAIN_CMDID, &cmd, sizeof(cmd),
+		      WMI_CFG_RX_CHAIN_DONE_EVENTID, &evt, sizeof(evt), 2000);
+	if (rc)
+		return rc;
+
+	vring->hwtail = le32_to_cpu(evt.evt.rx_ring_tail_ptr);
+
+	wil_dbg_MISC(wil, "Rx init: status %d tail 0x%08x\n",
+		     le32_to_cpu(evt.evt.status), vring->hwtail);
+
+	if (le32_to_cpu(evt.evt.status) != WMI_CFG_RX_CHAIN_SUCCESS)
+		rc = -EINVAL;
+
+	return rc;
+}
+
+int wmi_rx_chain_del(struct wil6210_priv *wil)
+{
+	int rc;
+	struct wmi_cfg_rx_chain_cmd cmd = {
+		.action = cpu_to_le32(WMI_RX_CHAIN_DEL),
+		.rx_sw_ring = {
+			.max_mpdu_size = cpu_to_le16(RX_BUF_LEN),
+		},
+	};
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_cfg_rx_chain_done_event cfg;
+	} __packed wmi_rx_cfg_reply;
+
+	rc = wmi_call(wil, WMI_CFG_RX_CHAIN_CMDID, &cmd, sizeof(cmd),
+		      WMI_CFG_RX_CHAIN_DONE_EVENTID,
+		      &wmi_rx_cfg_reply, sizeof(wmi_rx_cfg_reply),
+		      100);
+
+	return rc;
+}
+
 void wmi_event_flush(struct wil6210_priv *wil)
 {
 	struct pending_wmi_event *evt, *t;
-- 
1.7.10.4

