Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:45841 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751865AbdHCN0B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 09:26:01 -0400
Cc: Gidon Studinski <QCA_gidons@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 9/9] wil6210: make debugfs compilation optional
Date: Thu,  3 Aug 2017 16:25:39 +0300
Message-Id: <1501766739-31996-10-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170803_152606_701691_CEDB7D3B)
In-Reply-To: <1501766739-31996-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1501766739-31996-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gidon Studinski <qca_gidons@qca.qualcomm.com>

Since debugfs is a kernel configuration option, enable the driver to
compile without debugfs.

Signed-off-by: Gidon Studinski <qca_gidons@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/Makefile  | 2 +-
 drivers/net/wireless/ath/wil6210/debugfs.c | 6 ++----
 drivers/net/wireless/ath/wil6210/main.c    | 1 +
 drivers/net/wireless/ath/wil6210/txrx.c    | 6 +++---
 drivers/net/wireless/ath/wil6210/wil6210.h | 8 +++++++-
 5 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/Makefile b/drivers/net/wireless/ath/wil6210/Makefile
index 4ae21da..63a751a 100644
--- a/drivers/net/wireless/ath/wil6210/Makefile
+++ b/drivers/net/wireless/ath/wil6210/Makefile
@@ -4,7 +4,7 @@ wil6210-y := main.o
 wil6210-y += netdev.o
 wil6210-y += cfg80211.o
 wil6210-y += pcie_bus.o
-wil6210-y += debugfs.o
+wil6210-$(CONFIG_DEBUG_FS) += debugfs.o
 wil6210-y += wmi.o
 wil6210-y += interrupt.o
 wil6210-y += txrx.o
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index d4e8865..d2afe50 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -20,7 +20,6 @@
 #include <linux/pci.h>
 #include <linux/rtnetlink.h>
 #include <linux/power_supply.h>
-
 #include "wil6210.h"
 #include "wmi.h"
 #include "txrx.h"
@@ -30,7 +29,6 @@
 static u32 mem_addr;
 static u32 dbg_txdesc_index;
 static u32 dbg_vring_index; /* 24+ for Rx, 0..23 for Tx */
-u32 vring_idle_trsh = 16; /* HW fetches up to 16 descriptors at once */
 
 enum dbg_off_type {
 	doff_u32 = 0,
@@ -1763,6 +1761,7 @@ static void wil6210_debugfs_init_isr(struct wil6210_priv *wil,
 	WIL_FIELD(chip_revision, 0444,	doff_u8),
 	WIL_FIELD(abft_len, 0644,		doff_u8),
 	WIL_FIELD(wakeup_trigger, 0644,		doff_u8),
+	WIL_FIELD(vring_idle_trsh, 0644,	doff_u32),
 	{},
 };
 
@@ -1778,8 +1777,6 @@ static void wil6210_debugfs_init_isr(struct wil6210_priv *wil,
 	{"desc_index",	0644, (ulong)&dbg_txdesc_index, doff_u32},
 	{"vring_index",	0644, (ulong)&dbg_vring_index, doff_u32},
 	{"mem_addr",	0644, (ulong)&mem_addr, doff_u32},
-	{"vring_idle_trsh", 0644, (ulong)&vring_idle_trsh,
-	 doff_u32},
 	{"led_polarity", 0644, (ulong)&led_polarity, doff_u8},
 	{},
 };
@@ -1821,3 +1818,4 @@ void wil6210_debugfs_remove(struct wil6210_priv *wil)
 	 */
 	wil_pmc_free(wil, false);
 }
+
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index b89d017..e2ea490 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -581,6 +581,7 @@ int wil_priv_init(struct wil6210_priv *wil)
 			      WMI_WAKEUP_TRIGGER_BCAST;
 	memset(&wil->suspend_stats, 0, sizeof(wil->suspend_stats));
 	wil->suspend_stats.min_suspend_time = ULONG_MAX;
+	wil->vring_idle_trsh = 16;
 
 	return 0;
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index ec57bcc..389c718 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1666,7 +1666,7 @@ static int __wil_tx_vring_tso(struct wil6210_priv *wil, struct vring *vring,
 
 	/* performance monitoring */
 	used = wil_vring_used_tx(vring);
-	if (wil_val_in_range(vring_idle_trsh,
+	if (wil_val_in_range(wil->vring_idle_trsh,
 			     used, used + descs_used)) {
 		txdata->idle += get_cycles() - txdata->last_idle;
 		wil_dbg_txrx(wil,  "Ring[%2d] not idle %d -> %d\n",
@@ -1813,7 +1813,7 @@ static int __wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 
 	/* performance monitoring */
 	used = wil_vring_used_tx(vring);
-	if (wil_val_in_range(vring_idle_trsh,
+	if (wil_val_in_range(wil->vring_idle_trsh,
 			     used, used + nr_frags + 1)) {
 		txdata->idle += get_cycles() - txdata->last_idle;
 		wil_dbg_txrx(wil,  "Ring[%2d] not idle %d -> %d\n",
@@ -2175,7 +2175,7 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 
 	/* performance monitoring */
 	used_new = wil_vring_used_tx(vring);
-	if (wil_val_in_range(vring_idle_trsh,
+	if (wil_val_in_range(wil->vring_idle_trsh,
 			     used_new, used_before_complete)) {
 		wil_dbg_txrx(wil, "Ring[%2d] idle %d -> %d\n",
 			     ringid, used_before_complete, used_new);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index e3c0c2f..d7b1e03 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -30,7 +30,6 @@
 extern unsigned int mtu_max;
 extern unsigned short rx_ring_overflow_thrsh;
 extern int agg_wsize;
-extern u32 vring_idle_trsh;
 extern bool rx_align_2;
 extern bool rx_large_buf;
 extern bool debug_fw;
@@ -693,6 +692,7 @@ struct wil6210_priv {
 	u8 vring2cid_tid[WIL6210_MAX_TX_RINGS][2]; /* [0] - CID, [1] - TID */
 	struct wil_sta_info sta[WIL6210_MAX_CID];
 	int bcast_vring;
+	u32 vring_idle_trsh; /* HW fetches up to 16 descriptors at once  */
 	bool use_extended_dma_addr; /* indicates whether we are using 48 bits */
 	/* scan */
 	struct cfg80211_scan_request *scan_request;
@@ -940,8 +940,14 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 struct cfg80211_mgmt_tx_params *params,
 			 u64 *cookie);
 
+#if defined(CONFIG_DEBUG_FS)
 int wil6210_debugfs_init(struct wil6210_priv *wil);
 void wil6210_debugfs_remove(struct wil6210_priv *wil);
+#else
+static inline int wil6210_debugfs_init(struct wil6210_priv *wil) { return 0; }
+static inline void wil6210_debugfs_remove(struct wil6210_priv *wil) {}
+#endif
+
 int wil_cid_fill_sinfo(struct wil6210_priv *wil, int cid,
 		       struct station_info *sinfo);
 
-- 
1.9.1
