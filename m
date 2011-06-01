Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2233 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758840Ab1FALqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:34 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 59/83] staging: brcm80211: removed wl_ (vendor specific
 acronym)
Date: Wed, 1 Jun 2011 13:45:44 +0200
Message-ID: <1306928768-7501-59-git-send-email-rvossen@broadcom.com> (sfid-20110601_134910_995199_A727F98D)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replaced by brcms_, which is short hand for 'Broadcom softmac'.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |    2 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |   10 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    2 +-
 drivers/staging/brcm80211/brcmsmac/wl_dbg.h        |   67 +--
 drivers/staging/brcm80211/brcmsmac/wl_export.h     |   40 +-
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |  624 ++++++++++----------
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.h   |   38 +-
 drivers/staging/brcm80211/brcmsmac/wl_ucode.h      |   13 +-
 .../staging/brcm80211/brcmsmac/wl_ucode_loader.c   |   74 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |   40 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |   43 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.h      |   15 +-
 drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c  |   15 +-
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h       |    8 +-
 drivers/staging/brcm80211/brcmsmac/wlc_types.h     |    4 +-
 drivers/staging/brcm80211/include/bcmdefs.h        |    4 +-
 16 files changed, 480 insertions(+), 519 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 2e5e996..7e642cd 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -46,7 +46,7 @@ static struct sdio_func *cfg80211_sdio_func;
 static struct wl_dev *wl_cfg80211_dev;
 static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
 
-u32 wl_dbg_level = WL_DBG_ERR;
+u32 brcmf_dbg_level = WL_DBG_ERR;
 
 #define WL_4329_FW_FILE "brcm/bcm4329-fullmac-4.bin"
 #define WL_4329_NVRAM_FILE "brcm/bcm4329-fullmac-4.txt"
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 33fb03a..2469b90 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -34,7 +34,7 @@ struct wl_ibss;
 
 #define	WL_ERR(fmt, args...)					\
 do {								\
-	if (wl_dbg_level & WL_DBG_ERR) {			\
+	if (brcmf_dbg_level & WL_DBG_ERR) {			\
 		if (net_ratelimit()) {				\
 			printk(KERN_ERR "ERROR @%s : " fmt,	\
 				__func__, ##args);		\
@@ -45,7 +45,7 @@ do {								\
 #if (defined BCMDBG)
 #define	WL_INFO(fmt, args...)					\
 do {								\
-	if (wl_dbg_level & WL_DBG_INFO) {			\
+	if (brcmf_dbg_level & WL_DBG_INFO) {			\
 		if (net_ratelimit()) {				\
 			printk(KERN_ERR "INFO @%s : " fmt,	\
 				__func__, ##args);		\
@@ -55,7 +55,7 @@ do {								\
 
 #define	WL_TRACE(fmt, args...)					\
 do {								\
-	if (wl_dbg_level & WL_DBG_TRACE) {			\
+	if (brcmf_dbg_level & WL_DBG_TRACE) {			\
 		if (net_ratelimit()) {				\
 			printk(KERN_ERR "TRACE @%s : " fmt,	\
 				__func__, ##args);		\
@@ -65,7 +65,7 @@ do {								\
 
 #define	WL_SCAN(fmt, args...)					\
 do {								\
-	if (wl_dbg_level & WL_DBG_SCAN) {			\
+	if (brcmf_dbg_level & WL_DBG_SCAN) {			\
 		if (net_ratelimit()) {				\
 			printk(KERN_ERR "SCAN @%s : " fmt,	\
 				__func__, ##args);		\
@@ -75,7 +75,7 @@ do {								\
 
 #define	WL_CONN(fmt, args...)					\
 do {								\
-	if (wl_dbg_level & WL_DBG_CONN) {			\
+	if (brcmf_dbg_level & WL_DBG_CONN) {			\
 		if (net_ratelimit()) {				\
 			printk(KERN_ERR "CONN @%s : " fmt,	\
 				__func__, ##args);		\
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index 47960de..974a6e0 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -69,7 +69,7 @@ wl_iw_extra_params_t g_wl_iw_params;
 extern bool wl_iw_conn_status_str(u32 event_type, u32 status,
 				  u32 reason, char *stringBuf, uint buflen);
 
-uint wl_msg_level = WL_ERROR_VAL;
+uint brcm_msg_level = LOG_ERROR_VAL;
 
 #define MAX_WLIW_IOCTL_LEN 1024
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
index 8cc6b1a..253c464 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
+++ b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
@@ -19,74 +19,15 @@
 
 #include <linux/device.h>			/* dev_err() */
 
-/* wl_msg_level is a bit vector with defs in bcmdefs.h */
-extern u32 wl_msg_level;
+/* brcm_msg_level is a bit vector with defs in bcmdefs.h */
+extern u32 brcm_msg_level;
 
 #define BCMMSG(dev, fmt, args...)		\
 do {						\
-	if (wl_msg_level & WL_TRACE_VAL)	\
+	if (brcm_msg_level & LOG_TRACE_VAL)	\
 		wiphy_err(dev, "%s: " fmt, __func__, ##args);	\
 } while (0)
 
-#ifdef BCMDBG
-
-
-/* Extra message control for AMPDU debugging */
-#define   WL_AMPDU_UPDN_VAL	0x00000001	/* Config up/down related  */
-#define   WL_AMPDU_ERR_VAL	0x00000002	/* Calls to beaocn update  */
-#define   WL_AMPDU_TX_VAL	0x00000004	/* Transmit data path */
-#define   WL_AMPDU_RX_VAL	0x00000008	/* Receive data path  */
-#define   WL_AMPDU_CTL_VAL	0x00000010	/* TSF-related items  */
-#define   WL_AMPDU_HW_VAL       0x00000020	/* AMPDU_HW */
-#define   WL_AMPDU_HWTXS_VAL    0x00000040	/* AMPDU_HWTXS */
-#define   WL_AMPDU_HWDBG_VAL    0x00000080	/* AMPDU_DBG */
-
-extern u32 wl_ampdu_dbg;
-
-#define WL_AMPDU_PRINT(level, fmt, args...)	\
-do {						\
-	if (wl_ampdu_dbg & level) {		\
-		WL_AMPDU(fmt, ##args);		\
-	}					\
-} while (0)
-
-#define WL_AMPDU_UPDN(fmt, args...)			\
-	WL_AMPDU_PRINT(WL_AMPDU_UPDN_VAL, fmt, ##args)
-#define WL_AMPDU_RX(fmt, args...)			\
-	WL_AMPDU_PRINT(WL_AMPDU_RX_VAL, fmt, ##args)
-#define WL_AMPDU_ERR(fmt, args...)			\
-	WL_AMPDU_PRINT(WL_AMPDU_ERR_VAL, fmt, ##args)
-#define WL_AMPDU_TX(fmt, args...)			\
-	WL_AMPDU_PRINT(WL_AMPDU_TX_VAL, fmt, ##args)
-#define WL_AMPDU_CTL(fmt, args...)			\
-	WL_AMPDU_PRINT(WL_AMPDU_CTL_VAL, fmt, ##args)
-#define WL_AMPDU_HW(fmt, args...)			\
-	WL_AMPDU_PRINT(WL_AMPDU_HW_VAL, fmt, ##args)
-#define WL_AMPDU_HWTXS(fmt, args...)			\
-	WL_AMPDU_PRINT(WL_AMPDU_HWTXS_VAL, fmt, ##args)
-#define WL_AMPDU_HWDBG(fmt, args...)			\
-	WL_AMPDU_PRINT(WL_AMPDU_HWDBG_VAL, fmt, ##args)
-#define WL_AMPDU_ERR_ON() (wl_ampdu_dbg & WL_AMPDU_ERR_VAL)
-#define WL_AMPDU_HW_ON() (wl_ampdu_dbg & WL_AMPDU_HW_VAL)
-#define WL_AMPDU_HWTXS_ON() (wl_ampdu_dbg & WL_AMPDU_HWTXS_VAL)
-
-#else				/* BCMDBG */
-
-
-#define WL_AMPDU_UPDN(fmt, args...)	no_printk(fmt, ##args)
-#define WL_AMPDU_RX(fmt, args...)	no_printk(fmt, ##args)
-#define WL_AMPDU_ERR(fmt, args...)	no_printk(fmt, ##args)
-#define WL_AMPDU_TX(fmt, args...)	no_printk(fmt, ##args)
-#define WL_AMPDU_CTL(fmt, args...)	no_printk(fmt, ##args)
-#define WL_AMPDU_HW(fmt, args...)	no_printk(fmt, ##args)
-#define WL_AMPDU_HWTXS(fmt, args...)	no_printk(fmt, ##args)
-#define WL_AMPDU_HWDBG(fmt, args...)	no_printk(fmt, ##args)
-#define WL_AMPDU_ERR_ON()       0
-#define WL_AMPDU_HW_ON()        0
-#define WL_AMPDU_HWTXS_ON()     0
-
-#endif				/* BCMDBG */
-
-#define WL_ERROR_ON()		(wl_msg_level & WL_ERROR_VAL)
+#define WL_ERROR_ON()		(brcm_msg_level & LOG_ERROR_VAL)
 
 #endif				/* _wl_dbg_h_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_export.h b/drivers/staging/brcm80211/brcmsmac/wl_export.h
index 0fe0b24..01d3696 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_export.h
+++ b/drivers/staging/brcm80211/brcmsmac/wl_export.h
@@ -18,30 +18,30 @@
 #define _wl_export_h_
 
 /* misc callbacks */
-struct wl_info;
-struct wl_if;
+struct brcms_info;
+struct brcms_if;
 struct wlc_if;
-extern void wl_init(struct wl_info *wl);
-extern uint wl_reset(struct wl_info *wl);
-extern void wl_intrson(struct wl_info *wl);
-extern u32 wl_intrsoff(struct wl_info *wl);
-extern void wl_intrsrestore(struct wl_info *wl, u32 macintmask);
-extern int wl_up(struct wl_info *wl);
-extern void wl_down(struct wl_info *wl);
-extern void wl_txflowcontrol(struct wl_info *wl, struct wl_if *wlif, bool state,
-			     int prio);
-extern bool wl_alloc_dma_resources(struct wl_info *wl, uint dmaddrwidth);
-extern bool wl_rfkill_set_hw_state(struct wl_info *wl);
+extern void brcms_init(struct brcms_info *wl);
+extern uint brcms_reset(struct brcms_info *wl);
+extern void brcms_intrson(struct brcms_info *wl);
+extern u32 brcms_intrsoff(struct brcms_info *wl);
+extern void brcms_intrsrestore(struct brcms_info *wl, u32 macintmask);
+extern int brcms_up(struct brcms_info *wl);
+extern void brcms_down(struct brcms_info *wl);
+extern void brcms_txflowcontrol(struct brcms_info *wl, struct brcms_if *wlif,
+				bool state, int prio);
+extern bool wl_alloc_dma_resources(struct brcms_info *wl, uint dmaddrwidth);
+extern bool brcms_rfkill_set_hw_state(struct brcms_info *wl);
 
 /* timer functions */
-struct wl_timer;
-extern struct wl_timer *wl_init_timer(struct wl_info *wl,
+struct brcms_timer;
+extern struct brcms_timer *brcms_init_timer(struct brcms_info *wl,
 				      void (*fn) (void *arg), void *arg,
 				      const char *name);
-extern void wl_free_timer(struct wl_info *wl, struct wl_timer *timer);
-extern void wl_add_timer(struct wl_info *wl, struct wl_timer *timer, uint ms,
-			 int periodic);
-extern bool wl_del_timer(struct wl_info *wl, struct wl_timer *timer);
-extern void wl_msleep(struct wl_info *wl, uint ms);
+extern void brcms_free_timer(struct brcms_info *wl, struct brcms_timer *timer);
+extern void brcms_add_timer(struct brcms_info *wl, struct brcms_timer *timer,
+			    uint ms, int periodic);
+extern bool brcms_del_timer(struct brcms_info *wl, struct brcms_timer *timer);
+extern void brcms_msleep(struct brcms_info *wl, uint ms);
 
 #endif				/* _wl_export_h_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 6856a60..cc2ed78 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -47,8 +47,28 @@
 
 #define N_TX_QUEUES	4 /* #tx queues on mac80211<->driver interface */
 
-static void wl_timer(unsigned long data);
-static void _wl_timer(struct wl_timer *t);
+#define LOCK(wl)	spin_lock_bh(&(wl)->lock)
+#define UNLOCK(wl)	spin_unlock_bh(&(wl)->lock)
+
+/* locking from inside brcms_isr */
+#define ISR_LOCK(wl, flags)\
+	do {\
+		spin_lock(&(wl)->isr_lock);\
+		(void)(flags); } \
+	while (0)
+
+#define ISR_UNLOCK(wl, flags)\
+	do {\
+		spin_unlock(&(wl)->isr_lock);\
+		(void)(flags); } \
+	while (0)
+
+/* locking under LOCK() to synchronize with brcms_isr */
+#define INT_LOCK(wl, flags)	spin_lock_irqsave(&(wl)->isr_lock, flags)
+#define INT_UNLOCK(wl, flags)	spin_unlock_irqrestore(&(wl)->isr_lock, flags)
+
+static void brcms_timer(unsigned long data);
+static void _brcms_timer(struct brcms_timer *t);
 
 
 static int ieee_hw_init(struct ieee80211_hw *hw);
@@ -65,22 +85,20 @@ static int wl_linux_watchdog(void *ctx);
 	FIF_OTHER_BSS | \
 	FIF_BCN_PRBRESP_PROMISC)
 
-static int wl_found;
+static int n_adapters_found;
 
-#define WL_DEV_IF(dev)		((struct wl_if *)netdev_priv(dev))
-#define	WL_INFO(dev)		((struct wl_info *)(WL_DEV_IF(dev)->wl))
-static int wl_request_fw(struct wl_info *wl, struct pci_dev *pdev);
-static void wl_release_fw(struct wl_info *wl);
+static int brcms_request_fw(struct brcms_info *wl, struct pci_dev *pdev);
+static void brcms_release_fw(struct brcms_info *wl);
 
 /* local prototypes */
-static void wl_dpc(unsigned long data);
-static irqreturn_t wl_isr(int irq, void *dev_id);
+static void brcms_dpc(unsigned long data);
+static irqreturn_t brcms_isr(int irq, void *dev_id);
 
-static int __devinit wl_pci_probe(struct pci_dev *pdev,
+static int __devinit brcms_pci_probe(struct pci_dev *pdev,
 				  const struct pci_device_id *ent);
-static void wl_remove(struct pci_dev *pdev);
-static void wl_free(struct wl_info *wl);
-static void wl_set_basic_rate(struct wl_rateset *rs, u16 rate, bool is_br);
+static void brcms_remove(struct pci_dev *pdev);
+static void brcms_free(struct brcms_info *wl);
+static void brcms_set_basic_rate(struct wl_rateset *rs, u16 rate, bool is_br);
 
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN driver.");
@@ -88,7 +106,7 @@ MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN cards");
 MODULE_LICENSE("Dual BSD/GPL");
 
 /* recognized PCI IDs */
-static struct pci_device_id wl_id_table[] = {
+static DEFINE_PCI_DEVICE_TABLE(brcms_pci_id_table) = {
 	{PCI_VENDOR_ID_BROADCOM, 0x4357, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},	/* 43225 2G */
 	{PCI_VENDOR_ID_BROADCOM, 0x4353, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},	/* 43224 DUAL */
 	{PCI_VENDOR_ID_BROADCOM, 0x4727, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},	/* 4313 DUAL */
@@ -97,7 +115,7 @@ static struct pci_device_id wl_id_table[] = {
 	{0}
 };
 
-MODULE_DEVICE_TABLE(pci, wl_id_table);
+MODULE_DEVICE_TABLE(pci, brcms_pci_id_table);
 
 #ifdef BCMDBG
 static int msglevel = 0xdeadbeef;
@@ -110,51 +128,52 @@ module_param(phymsglevel, int, 0);
 #define WL_TO_HW(wl)	  (wl->pub->ieee_hw)
 
 /* MAC80211 callback functions */
-static int wl_ops_start(struct ieee80211_hw *hw);
-static void wl_ops_stop(struct ieee80211_hw *hw);
-static int wl_ops_add_interface(struct ieee80211_hw *hw,
+static int brcms_ops_start(struct ieee80211_hw *hw);
+static void brcms_ops_stop(struct ieee80211_hw *hw);
+static int brcms_ops_add_interface(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif);
-static void wl_ops_remove_interface(struct ieee80211_hw *hw,
+static void brcms_ops_remove_interface(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif);
-static int wl_ops_config(struct ieee80211_hw *hw, u32 changed);
-static void wl_ops_bss_info_changed(struct ieee80211_hw *hw,
+static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed);
+static void brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_bss_conf *info,
 				    u32 changed);
-static void wl_ops_configure_filter(struct ieee80211_hw *hw,
+static void brcms_ops_configure_filter(struct ieee80211_hw *hw,
 				    unsigned int changed_flags,
 				    unsigned int *total_flags, u64 multicast);
-static int wl_ops_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+static int brcms_ops_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 			  bool set);
-static void wl_ops_sw_scan_start(struct ieee80211_hw *hw);
-static void wl_ops_sw_scan_complete(struct ieee80211_hw *hw);
-static void wl_ops_set_tsf(struct ieee80211_hw *hw, u64 tsf);
-static int wl_ops_get_stats(struct ieee80211_hw *hw,
+static void brcms_ops_sw_scan_start(struct ieee80211_hw *hw);
+static void brcms_ops_sw_scan_complete(struct ieee80211_hw *hw);
+static void brcms_ops_set_tsf(struct ieee80211_hw *hw, u64 tsf);
+static int brcms_ops_get_stats(struct ieee80211_hw *hw,
 			    struct ieee80211_low_level_stats *stats);
-static void wl_ops_sta_notify(struct ieee80211_hw *hw,
+static void brcms_ops_sta_notify(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      enum sta_notify_cmd cmd,
 			      struct ieee80211_sta *sta);
-static int wl_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
+static int brcms_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			  const struct ieee80211_tx_queue_params *params);
-static u64 wl_ops_get_tsf(struct ieee80211_hw *hw);
-static int wl_ops_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+static u64 brcms_ops_get_tsf(struct ieee80211_hw *hw);
+static int brcms_ops_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		      struct ieee80211_sta *sta);
-static int wl_ops_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			 struct ieee80211_sta *sta);
-static int wl_ops_ampdu_action(struct ieee80211_hw *hw,
+static int brcms_ops_sta_remove(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta);
+static int brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       enum ieee80211_ampdu_mlme_action action,
 			       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
 			       u8 buf_size);
-static void wl_ops_rfkill_poll(struct ieee80211_hw *hw);
-static void wl_ops_flush(struct ieee80211_hw *hw, bool drop);
+static void brcms_ops_rfkill_poll(struct ieee80211_hw *hw);
+static void brcms_ops_flush(struct ieee80211_hw *hw, bool drop);
 
-static void wl_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
-	struct wl_info *wl = hw->priv;
+	struct brcms_info *wl = hw->priv;
 
-	WL_LOCK(wl);
+	LOCK(wl);
 	if (!wl->pub->up) {
 		wiphy_err(wl->wiphy, "ops->tx called while down\n");
 		kfree_skb(skb);
@@ -162,36 +181,36 @@ static void wl_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 	wlc_sendpkt_mac80211(wl->wlc, skb, hw);
  done:
-	WL_UNLOCK(wl);
+	UNLOCK(wl);
 }
 
-static int wl_ops_start(struct ieee80211_hw *hw)
+static int brcms_ops_start(struct ieee80211_hw *hw)
 {
-	struct wl_info *wl = hw->priv;
+	struct brcms_info *wl = hw->priv;
 	bool blocked;
 	/*
 	  struct ieee80211_channel *curchan = hw->conf.channel;
 	*/
 
 	ieee80211_wake_queues(hw);
-	WL_LOCK(wl);
-	blocked = wl_rfkill_set_hw_state(wl);
-	WL_UNLOCK(wl);
+	LOCK(wl);
+	blocked = brcms_rfkill_set_hw_state(wl);
+	UNLOCK(wl);
 	if (!blocked)
 		wiphy_rfkill_stop_polling(wl->pub->ieee_hw->wiphy);
 
 	return 0;
 }
 
-static void wl_ops_stop(struct ieee80211_hw *hw)
+static void brcms_ops_stop(struct ieee80211_hw *hw)
 {
 	ieee80211_stop_queues(hw);
 }
 
 static int
-wl_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
-	struct wl_info *wl;
+	struct brcms_info *wl;
 	int err;
 
 	/* Just STA for now */
@@ -206,28 +225,28 @@ wl_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	}
 
 	wl = HW_TO_WL(hw);
-	WL_LOCK(wl);
-	err = wl_up(wl);
-	WL_UNLOCK(wl);
+	LOCK(wl);
+	err = brcms_up(wl);
+	UNLOCK(wl);
 
 	if (err != 0) {
-		wiphy_err(hw->wiphy, "%s: wl_up() returned %d\n", __func__,
+		wiphy_err(hw->wiphy, "%s: brcms_up() returned %d\n", __func__,
 			  err);
 	}
 	return err;
 }
 
 static void
-wl_ops_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+brcms_ops_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
-	struct wl_info *wl;
+	struct brcms_info *wl;
 
 	wl = HW_TO_WL(hw);
 
 	/* put driver in down state */
-	WL_LOCK(wl);
-	wl_down(wl);
-	WL_UNLOCK(wl);
+	LOCK(wl);
+	brcms_down(wl);
+	UNLOCK(wl);
 }
 
 /*
@@ -237,7 +256,7 @@ static int
 ieee_set_channel(struct ieee80211_hw *hw, struct ieee80211_channel *chan,
 		 enum nl80211_channel_type type)
 {
-	struct wl_info *wl = HW_TO_WL(hw);
+	struct brcms_info *wl = HW_TO_WL(hw);
 	int err = 0;
 
 	switch (type) {
@@ -258,15 +277,15 @@ ieee_set_channel(struct ieee80211_hw *hw, struct ieee80211_channel *chan,
 	return err;
 }
 
-static int wl_ops_config(struct ieee80211_hw *hw, u32 changed)
+static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ieee80211_conf *conf = &hw->conf;
-	struct wl_info *wl = HW_TO_WL(hw);
+	struct brcms_info *wl = HW_TO_WL(hw);
 	int err = 0;
 	int new_int;
 	struct wiphy *wiphy = hw->wiphy;
 
-	WL_LOCK(wl);
+	LOCK(wl);
 	if (changed & IEEE80211_CONF_CHANGE_LISTEN_INTERVAL) {
 		if (wlc_set_par(wl->wlc, IOV_BCN_LI_BCN, conf->listen_interval)
 		    < 0) {
@@ -320,16 +339,16 @@ static int wl_ops_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
  config_out:
-	WL_UNLOCK(wl);
+	UNLOCK(wl);
 	return err;
 }
 
 static void
-wl_ops_bss_info_changed(struct ieee80211_hw *hw,
+brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 			struct ieee80211_vif *vif,
 			struct ieee80211_bss_conf *info, u32 changed)
 {
-	struct wl_info *wl = HW_TO_WL(hw);
+	struct brcms_info *wl = HW_TO_WL(hw);
 	struct wiphy *wiphy = hw->wiphy;
 	int val;
 
@@ -339,9 +358,9 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 		 */
 		wiphy_err(wiphy, "%s: %s: %sassociated\n", KBUILD_MODNAME,
 			  __func__, info->assoc ? "" : "dis");
-		WL_LOCK(wl);
+		LOCK(wl);
 		wlc_associate_upd(wl->wlc, info->assoc);
-		WL_UNLOCK(wl);
+		UNLOCK(wl);
 	}
 	if (changed & BSS_CHANGED_ERP_SLOT) {
 		/* slot timing changed */
@@ -349,23 +368,23 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 			val = 1;
 		else
 			val = 0;
-		WL_LOCK(wl);
+		LOCK(wl);
 		wlc_set(wl->wlc, WLC_SET_SHORTSLOT_OVERRIDE, val);
-		WL_UNLOCK(wl);
+		UNLOCK(wl);
 	}
 
 	if (changed & BSS_CHANGED_HT) {
 		/* 802.11n parameters changed */
 		u16 mode = info->ht_operation_mode;
 
-		WL_LOCK(wl);
+		LOCK(wl);
 		wlc_protection_upd(wl->wlc, WLC_PROT_N_CFG,
 			mode & IEEE80211_HT_OP_MODE_PROTECTION);
 		wlc_protection_upd(wl->wlc, WLC_PROT_N_NONGF,
 			mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
 		wlc_protection_upd(wl->wlc, WLC_PROT_N_OBSS,
 			mode & IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT);
-		WL_UNLOCK(wl);
+		UNLOCK(wl);
 	}
 	if (changed & BSS_CHANGED_BASIC_RATES) {
 		struct ieee80211_supported_band *bi;
@@ -375,10 +394,10 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 		int error;
 
 		/* retrieve the current rates */
-		WL_LOCK(wl);
+		LOCK(wl);
 		error = wlc_ioctl(wl->wlc, WLC_GET_CURR_RATESET,
 				  &rs, sizeof(rs), NULL);
-		WL_UNLOCK(wl);
+		UNLOCK(wl);
 		if (error) {
 			wiphy_err(wiphy, "%s: retrieve rateset failed: %d\n",
 				  __func__, error);
@@ -391,27 +410,27 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 			rate = (bi->bitrates[i].bitrate << 1) / 10;
 
 			/* set/clear basic rate flag */
-			wl_set_basic_rate(&rs, rate, br_mask & 1);
+			brcms_set_basic_rate(&rs, rate, br_mask & 1);
 			br_mask >>= 1;
 		}
 
 		/* update the rate set */
-		WL_LOCK(wl);
+		LOCK(wl);
 		wlc_ioctl(wl->wlc, WLC_SET_RATESET, &rs, sizeof(rs), NULL);
-		WL_UNLOCK(wl);
+		UNLOCK(wl);
 	}
 	if (changed & BSS_CHANGED_BEACON_INT) {
 		/* Beacon interval changed */
-		WL_LOCK(wl);
+		LOCK(wl);
 		wlc_set(wl->wlc, WLC_SET_BCNPRD, info->beacon_int);
-		WL_UNLOCK(wl);
+		UNLOCK(wl);
 	}
 	if (changed & BSS_CHANGED_BSSID) {
 		/* BSSID changed, for whatever reason (IBSS and managed mode) */
-		WL_LOCK(wl);
+		LOCK(wl);
 		wlc_set_addrmatch(wl->wlc, RCM_BSSID_OFFSET,
 				  info->bssid);
-		WL_UNLOCK(wl);
+		UNLOCK(wl);
 	}
 	if (changed & BSS_CHANGED_BEACON) {
 		/* Beacon data changed, retrieve new beacon (beaconing modes) */
@@ -456,11 +475,11 @@ wl_ops_bss_info_changed(struct ieee80211_hw *hw,
 }
 
 static void
-wl_ops_configure_filter(struct ieee80211_hw *hw,
+brcms_ops_configure_filter(struct ieee80211_hw *hw,
 			unsigned int changed_flags,
 			unsigned int *total_flags, u64 multicast)
 {
-	struct wl_info *wl = hw->priv;
+	struct brcms_info *wl = hw->priv;
 	struct wiphy *wiphy = hw->wiphy;
 
 	changed_flags &= MAC_FILTERS;
@@ -478,7 +497,7 @@ wl_ops_configure_filter(struct ieee80211_hw *hw,
 	if (changed_flags & FIF_OTHER_BSS)
 		wiphy_err(wiphy, "FIF_OTHER_BSS\n");
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		WL_LOCK(wl);
+		LOCK(wl);
 		if (*total_flags & FIF_BCN_PRBRESP_PROMISC) {
 			wl->pub->mac80211_state |= MAC80211_PROMISC_BCNS;
 			wlc_mac_bcn_promisc_change(wl->wlc, 1);
@@ -486,60 +505,60 @@ wl_ops_configure_filter(struct ieee80211_hw *hw,
 			wlc_mac_bcn_promisc_change(wl->wlc, 0);
 			wl->pub->mac80211_state &= ~MAC80211_PROMISC_BCNS;
 		}
-		WL_UNLOCK(wl);
+		UNLOCK(wl);
 	}
 	return;
 }
 
 static int
-wl_ops_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta, bool set)
+brcms_ops_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta, bool set)
 {
 	return 0;
 }
 
-static void wl_ops_sw_scan_start(struct ieee80211_hw *hw)
+static void brcms_ops_sw_scan_start(struct ieee80211_hw *hw)
 {
-	struct wl_info *wl = hw->priv;
-	WL_LOCK(wl);
+	struct brcms_info *wl = hw->priv;
+	LOCK(wl);
 	wlc_scan_start(wl->wlc);
-	WL_UNLOCK(wl);
+	UNLOCK(wl);
 	return;
 }
 
-static void wl_ops_sw_scan_complete(struct ieee80211_hw *hw)
+static void brcms_ops_sw_scan_complete(struct ieee80211_hw *hw)
 {
-	struct wl_info *wl = hw->priv;
-	WL_LOCK(wl);
+	struct brcms_info *wl = hw->priv;
+	LOCK(wl);
 	wlc_scan_stop(wl->wlc);
-	WL_UNLOCK(wl);
+	UNLOCK(wl);
 	return;
 }
 
-static void wl_ops_set_tsf(struct ieee80211_hw *hw, u64 tsf)
+static void brcms_ops_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 {
 	wiphy_err(hw->wiphy, "%s: Enter\n", __func__);
 	return;
 }
 
 static int
-wl_ops_get_stats(struct ieee80211_hw *hw,
+brcms_ops_get_stats(struct ieee80211_hw *hw,
 		 struct ieee80211_low_level_stats *stats)
 {
-	struct wl_info *wl = hw->priv;
+	struct brcms_info *wl = hw->priv;
 	struct wl_cnt *cnt;
 
-	WL_LOCK(wl);
+	LOCK(wl);
 	cnt = wl->pub->_cnt;
 	stats->dot11ACKFailureCount = 0;
 	stats->dot11RTSFailureCount = 0;
 	stats->dot11FCSErrorCount = 0;
 	stats->dot11RTSSuccessCount = 0;
-	WL_UNLOCK(wl);
+	UNLOCK(wl);
 	return 0;
 }
 
 static void
-wl_ops_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+brcms_ops_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		  enum sta_notify_cmd cmd, struct ieee80211_sta *sta)
 {
 	switch (cmd) {
@@ -552,32 +571,32 @@ wl_ops_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 
 static int
-wl_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
+brcms_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	       const struct ieee80211_tx_queue_params *params)
 {
-	struct wl_info *wl = hw->priv;
+	struct brcms_info *wl = hw->priv;
 
-	WL_LOCK(wl);
+	LOCK(wl);
 	wlc_wme_setparams(wl->wlc, queue, params, true);
-	WL_UNLOCK(wl);
+	UNLOCK(wl);
 
 	return 0;
 }
 
-static u64 wl_ops_get_tsf(struct ieee80211_hw *hw)
+static u64 brcms_ops_get_tsf(struct ieee80211_hw *hw)
 {
 	wiphy_err(hw->wiphy, "%s: Enter\n", __func__);
 	return 0;
 }
 
 static int
-wl_ops_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+brcms_ops_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	       struct ieee80211_sta *sta)
 {
 	struct scb *scb;
 
 	int i;
-	struct wl_info *wl = hw->priv;
+	struct brcms_info *wl = hw->priv;
 
 	/* Init the scb */
 	scb = (struct scb *)sta->drv_priv;
@@ -606,21 +625,21 @@ wl_ops_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 
 static int
-wl_ops_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+brcms_ops_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		  struct ieee80211_sta *sta)
 {
 	return 0;
 }
 
 static int
-wl_ops_ampdu_action(struct ieee80211_hw *hw,
+brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif,
 		    enum ieee80211_ampdu_mlme_action action,
 		    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
 		    u8 buf_size)
 {
 	struct scb *scb = (struct scb *)sta->drv_priv;
-	struct wl_info *wl = hw->priv;
+	struct brcms_info *wl = hw->priv;
 	int status;
 
 	if (WARN_ON(scb->magic != SCB_MAGIC))
@@ -631,9 +650,9 @@ wl_ops_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_RX_STOP:
 		break;
 	case IEEE80211_AMPDU_TX_START:
-		WL_LOCK(wl);
+		LOCK(wl);
 		status = wlc_aggregatable(wl->wlc, tid);
-		WL_UNLOCK(wl);
+		UNLOCK(wl);
 		if (!status) {
 			wiphy_err(wl->wiphy, "START: tid %d is not agg\'able\n",
 				  tid);
@@ -645,9 +664,9 @@ wl_ops_ampdu_action(struct ieee80211_hw *hw,
 		break;
 
 	case IEEE80211_AMPDU_TX_STOP:
-		WL_LOCK(wl);
+		LOCK(wl);
 		wlc_ampdu_flush(wl->wlc, sta, tid);
-		WL_UNLOCK(wl);
+		UNLOCK(wl);
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
@@ -662,58 +681,58 @@ wl_ops_ampdu_action(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static void wl_ops_rfkill_poll(struct ieee80211_hw *hw)
+static void brcms_ops_rfkill_poll(struct ieee80211_hw *hw)
 {
-	struct wl_info *wl = HW_TO_WL(hw);
+	struct brcms_info *wl = HW_TO_WL(hw);
 	bool blocked;
 
-	WL_LOCK(wl);
+	LOCK(wl);
 	blocked = wlc_check_radio_disabled(wl->wlc);
-	WL_UNLOCK(wl);
+	UNLOCK(wl);
 
 	wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, blocked);
 }
 
-static void wl_ops_flush(struct ieee80211_hw *hw, bool drop)
+static void brcms_ops_flush(struct ieee80211_hw *hw, bool drop)
 {
-	struct wl_info *wl = HW_TO_WL(hw);
+	struct brcms_info *wl = HW_TO_WL(hw);
 
 	no_printk("%s: drop = %s\n", __func__, drop ? "true" : "false");
 
 	/* wait for packet queue and dma fifos to run empty */
-	WL_LOCK(wl);
+	LOCK(wl);
 	wlc_wait_for_tx_completion(wl->wlc, drop);
-	WL_UNLOCK(wl);
+	UNLOCK(wl);
 }
 
-static const struct ieee80211_ops wl_ops = {
-	.tx = wl_ops_tx,
-	.start = wl_ops_start,
-	.stop = wl_ops_stop,
-	.add_interface = wl_ops_add_interface,
-	.remove_interface = wl_ops_remove_interface,
-	.config = wl_ops_config,
-	.bss_info_changed = wl_ops_bss_info_changed,
-	.configure_filter = wl_ops_configure_filter,
-	.set_tim = wl_ops_set_tim,
-	.sw_scan_start = wl_ops_sw_scan_start,
-	.sw_scan_complete = wl_ops_sw_scan_complete,
-	.set_tsf = wl_ops_set_tsf,
-	.get_stats = wl_ops_get_stats,
-	.sta_notify = wl_ops_sta_notify,
-	.conf_tx = wl_ops_conf_tx,
-	.get_tsf = wl_ops_get_tsf,
-	.sta_add = wl_ops_sta_add,
-	.sta_remove = wl_ops_sta_remove,
-	.ampdu_action = wl_ops_ampdu_action,
-	.rfkill_poll = wl_ops_rfkill_poll,
-	.flush = wl_ops_flush,
+static const struct ieee80211_ops brcms_ops = {
+	.tx = brcms_ops_tx,
+	.start = brcms_ops_start,
+	.stop = brcms_ops_stop,
+	.add_interface = brcms_ops_add_interface,
+	.remove_interface = brcms_ops_remove_interface,
+	.config = brcms_ops_config,
+	.bss_info_changed = brcms_ops_bss_info_changed,
+	.configure_filter = brcms_ops_configure_filter,
+	.set_tim = brcms_ops_set_tim,
+	.sw_scan_start = brcms_ops_sw_scan_start,
+	.sw_scan_complete = brcms_ops_sw_scan_complete,
+	.set_tsf = brcms_ops_set_tsf,
+	.get_stats = brcms_ops_get_stats,
+	.sta_notify = brcms_ops_sta_notify,
+	.conf_tx = brcms_ops_conf_tx,
+	.get_tsf = brcms_ops_get_tsf,
+	.sta_add = brcms_ops_sta_add,
+	.sta_remove = brcms_ops_sta_remove,
+	.ampdu_action = brcms_ops_ampdu_action,
+	.rfkill_poll = brcms_ops_rfkill_poll,
+	.flush = brcms_ops_flush,
 };
 
 /*
- * is called in wl_pci_probe() context, therefore no locking required.
+ * is called in brcms_pci_probe() context, therefore no locking required.
  */
-static int wl_set_hint(struct wl_info *wl, char *abbrev)
+static int brcms_set_hint(struct brcms_info *wl, char *abbrev)
 {
 	return regulatory_hint(wl->pub->ieee_hw->wiphy, abbrev);
 }
@@ -724,24 +743,25 @@ static int wl_set_hint(struct wl_info *wl, char *abbrev)
  * Attach to the WL device identified by vendor and device parameters.
  * regs is a host accessible memory address pointing to WL device registers.
  *
- * wl_attach is not defined as static because in the case where no bus
+ * brcms_attach is not defined as static because in the case where no bus
  * is defined, wl_attach will never be called, and thus, gcc will issue
  * a warning that this function is defined but not used if we declare
  * it as static.
  *
  *
- * is called in wl_pci_probe() context, therefore no locking required.
+ * is called in brcms_pci_probe() context, therefore no locking required.
  */
-static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
+static struct brcms_info *brcms_attach(u16 vendor, u16 device,
+				       unsigned long regs,
 			    uint bustype, void *btparam, uint irq)
 {
-	struct wl_info *wl = NULL;
+	struct brcms_info *wl = NULL;
 	int unit, err;
 	unsigned long base_addr;
 	struct ieee80211_hw *hw;
 	u8 perm[ETH_ALEN];
 
-	unit = wl_found;
+	unit = n_adapters_found;
 	err = 0;
 
 	if (unit < 0) {
@@ -759,7 +779,7 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	atomic_set(&wl->callbacks, 0);
 
 	/* setup the bottom half handler */
-	tasklet_init(&wl->tasklet, wl_dpc, (unsigned long) wl);
+	tasklet_init(&wl->tasklet, brcms_dpc, (unsigned long) wl);
 
 
 
@@ -782,18 +802,18 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	spin_lock_init(&wl->isr_lock);
 
 	/* prepare ucode */
-	if (wl_request_fw(wl, (struct pci_dev *)btparam) < 0) {
+	if (brcms_request_fw(wl, (struct pci_dev *)btparam) < 0) {
 		wiphy_err(wl->wiphy, "%s: Failed to find firmware usually in "
 			  "%s\n", KBUILD_MODNAME, "/lib/firmware/brcm");
-		wl_release_fw(wl);
-		wl_remove((struct pci_dev *)btparam);
+		brcms_release_fw(wl);
+		brcms_remove((struct pci_dev *)btparam);
 		return NULL;
 	}
 
 	/* common load-time initialization */
 	wl->wlc = wlc_attach((void *)wl, vendor, device, unit, false,
 			     wl->regsva, wl->bcm_bustype, btparam, &err);
-	wl_release_fw(wl);
+	brcms_release_fw(wl);
 	if (!wl->wlc) {
 		wiphy_err(wl->wiphy, "%s: wlc_attach() failed with code %d\n",
 			  KBUILD_MODNAME, err);
@@ -809,7 +829,7 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	}
 
 	/* register our interrupt handler */
-	if (request_irq(irq, wl_isr, IRQF_SHARED, KBUILD_MODNAME, wl)) {
+	if (request_irq(irq, brcms_isr, IRQF_SHARED, KBUILD_MODNAME, wl)) {
 		wiphy_err(wl->wiphy, "wl%d: request_irq() failed\n", unit);
 		goto fail;
 	}
@@ -836,19 +856,19 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	}
 
 	if (wl->pub->srom_ccode[0])
-		err = wl_set_hint(wl, wl->pub->srom_ccode);
+		err = brcms_set_hint(wl, wl->pub->srom_ccode);
 	else
-		err = wl_set_hint(wl, "US");
+		err = brcms_set_hint(wl, "US");
 	if (err) {
 		wiphy_err(wl->wiphy, "%s: regulatory_hint failed, status %d\n",
 			  __func__, err);
 	}
 
-	wl_found++;
+	n_adapters_found++;
 	return wl;
 
 fail:
-	wl_free(wl);
+	brcms_free(wl);
 	return NULL;
 }
 
@@ -863,7 +883,7 @@ fail:
 	.max_power = 19, \
 }
 
-static struct ieee80211_channel wl_2ghz_chantable[] = {
+static struct ieee80211_channel brcms_2ghz_chantable[] = {
 	CHAN2GHZ(1, 2412, IEEE80211_CHAN_NO_HT40MINUS),
 	CHAN2GHZ(2, 2417, IEEE80211_CHAN_NO_HT40MINUS),
 	CHAN2GHZ(3, 2422, IEEE80211_CHAN_NO_HT40MINUS),
@@ -895,7 +915,7 @@ static struct ieee80211_channel wl_2ghz_chantable[] = {
 	.max_power = 21, \
 }
 
-static struct ieee80211_channel wl_5ghz_nphy_chantable[] = {
+static struct ieee80211_channel brcms_5ghz_nphy_chantable[] = {
 	/* UNII-1 */
 	CHAN5GHZ(36, IEEE80211_CHAN_NO_HT40MINUS),
 	CHAN5GHZ(40, IEEE80211_CHAN_NO_HT40PLUS),
@@ -963,7 +983,7 @@ static struct ieee80211_channel wl_5ghz_nphy_chantable[] = {
 	.hw_value = (rate100m / 5), \
 }
 
-static struct ieee80211_rate wl_legacy_ratetable[] = {
+static struct ieee80211_rate legacy_ratetable[] = {
 	RATE(10, 0),
 	RATE(20, IEEE80211_RATE_SHORT_PREAMBLE),
 	RATE(55, IEEE80211_RATE_SHORT_PREAMBLE),
@@ -978,12 +998,12 @@ static struct ieee80211_rate wl_legacy_ratetable[] = {
 	RATE(540, 0),
 };
 
-static struct ieee80211_supported_band wl_band_2GHz_nphy = {
+static struct ieee80211_supported_band brcms_band_2GHz_nphy = {
 	.band = IEEE80211_BAND_2GHZ,
-	.channels = wl_2ghz_chantable,
-	.n_channels = ARRAY_SIZE(wl_2ghz_chantable),
-	.bitrates = wl_legacy_ratetable,
-	.n_bitrates = ARRAY_SIZE(wl_legacy_ratetable),
+	.channels = brcms_2ghz_chantable,
+	.n_channels = ARRAY_SIZE(brcms_2ghz_chantable),
+	.bitrates = legacy_ratetable,
+	.n_bitrates = ARRAY_SIZE(legacy_ratetable),
 	.ht_cap = {
 		   /* from include/linux/ieee80211.h */
 		   .cap = IEEE80211_HT_CAP_GRN_FLD |
@@ -1000,12 +1020,12 @@ static struct ieee80211_supported_band wl_band_2GHz_nphy = {
 		   }
 };
 
-static struct ieee80211_supported_band wl_band_5GHz_nphy = {
+static struct ieee80211_supported_band brcms_band_5GHz_nphy = {
 	.band = IEEE80211_BAND_5GHZ,
-	.channels = wl_5ghz_nphy_chantable,
-	.n_channels = ARRAY_SIZE(wl_5ghz_nphy_chantable),
-	.bitrates = wl_legacy_ratetable + 4,
-	.n_bitrates = ARRAY_SIZE(wl_legacy_ratetable) - 4,
+	.channels = brcms_5ghz_nphy_chantable,
+	.n_channels = ARRAY_SIZE(brcms_5ghz_nphy_chantable),
+	.bitrates = legacy_ratetable + 4,
+	.n_bitrates = ARRAY_SIZE(legacy_ratetable) - 4,
 	.ht_cap = {
 		   /* use IEEE80211_HT_CAP_* from include/linux/ieee80211.h */
 		   .cap = IEEE80211_HT_CAP_GRN_FLD | IEEE80211_HT_CAP_SGI_20 | IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_40MHZ_INTOLERANT,	/* No 40 mhz yet */
@@ -1021,11 +1041,11 @@ static struct ieee80211_supported_band wl_band_5GHz_nphy = {
 };
 
 /*
- * is called in wl_pci_probe() context, therefore no locking required.
+ * is called in brcms_pci_probe() context, therefore no locking required.
  */
 static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 {
-	struct wl_info *wl = HW_TO_WL(hw);
+	struct brcms_info *wl = HW_TO_WL(hw);
 	int has_5g;
 	char phy_list[4];
 
@@ -1041,10 +1061,10 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 	if (phy_list[0] == 'n' || phy_list[0] == 'c') {
 		if (phy_list[0] == 'c') {
 			/* Single stream */
-			wl_band_2GHz_nphy.ht_cap.mcs.rx_mask[1] = 0;
-			wl_band_2GHz_nphy.ht_cap.mcs.rx_highest = 72;
+			brcms_band_2GHz_nphy.ht_cap.mcs.rx_mask[1] = 0;
+			brcms_band_2GHz_nphy.ht_cap.mcs.rx_highest = 72;
 		}
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl_band_2GHz_nphy;
+		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &brcms_band_2GHz_nphy;
 	} else {
 		return -EPERM;
 	}
@@ -1054,7 +1074,7 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 		has_5g++;
 		if (phy_list[0] == 'n' || phy_list[0] == 'c') {
 			hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			    &wl_band_5GHz_nphy;
+			    &brcms_band_5GHz_nphy;
 		} else {
 			return -EPERM;
 		}
@@ -1063,7 +1083,7 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 }
 
 /*
- * is called in wl_pci_probe() context, therefore no locking required.
+ * is called in brcms_pci_probe() context, therefore no locking required.
  */
 static int ieee_hw_init(struct ieee80211_hw *hw)
 {
@@ -1094,15 +1114,15 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
  * determines if a device is a WL device, and if so, attaches it.
  *
  * This function determines if a device pointed to by pdev is a WL device,
- * and if so, performs a wl_attach() on it.
+ * and if so, performs a brcms_attach() on it.
  *
  * Perimeter lock is initialized in the course of this function.
  */
 static int __devinit
-wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+brcms_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int rc;
-	struct wl_info *wl;
+	struct brcms_info *wl;
 	struct ieee80211_hw *hw;
 	u32 val;
 
@@ -1130,7 +1150,7 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if ((val & 0x0000ff00) != 0)
 		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 
-	hw = ieee80211_alloc_hw(sizeof(struct wl_info), &wl_ops);
+	hw = ieee80211_alloc_hw(sizeof(struct brcms_info), &brcms_ops);
 	if (!hw) {
 		pr_err("%s: ieee80211_alloc_hw failed\n", __func__);
 		return -ENOMEM;
@@ -1142,43 +1162,44 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	memset(hw->priv, 0, sizeof(*wl));
 
-	wl = wl_attach(pdev->vendor, pdev->device, pci_resource_start(pdev, 0),
-		       PCI_BUS, pdev, pdev->irq);
+	wl = brcms_attach(pdev->vendor, pdev->device,
+			  pci_resource_start(pdev, 0), PCI_BUS, pdev,
+			  pdev->irq);
 
 	if (!wl) {
-		pr_err("%s: %s: wl_attach failed!\n", KBUILD_MODNAME,
+		pr_err("%s: %s: brcms_attach failed!\n", KBUILD_MODNAME,
 		       __func__);
 		return -ENODEV;
 	}
 	return 0;
 }
 
-static int wl_suspend(struct pci_dev *pdev, pm_message_t state)
+static int brcms_suspend(struct pci_dev *pdev, pm_message_t state)
 {
-	struct wl_info *wl;
+	struct brcms_info *wl;
 	struct ieee80211_hw *hw;
 
 	hw = pci_get_drvdata(pdev);
 	wl = HW_TO_WL(hw);
 	if (!wl) {
 		wiphy_err(wl->wiphy,
-			  "wl_suspend: pci_get_drvdata failed\n");
+			  "brcms_suspend: pci_get_drvdata failed\n");
 		return -ENODEV;
 	}
 
 	/* only need to flag hw is down for proper resume */
-	WL_LOCK(wl);
+	LOCK(wl);
 	wl->pub->hw_up = false;
-	WL_UNLOCK(wl);
+	UNLOCK(wl);
 
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	return pci_set_power_state(pdev, PCI_D3hot);
 }
 
-static int wl_resume(struct pci_dev *pdev)
+static int brcms_resume(struct pci_dev *pdev)
 {
-	struct wl_info *wl;
+	struct brcms_info *wl;
 	struct ieee80211_hw *hw;
 	int err = 0;
 	u32 val;
@@ -1187,7 +1208,7 @@ static int wl_resume(struct pci_dev *pdev)
 	wl = HW_TO_WL(hw);
 	if (!wl) {
 		wiphy_err(wl->wiphy,
-			  "wl: wl_resume: pci_get_drvdata failed\n");
+			  "wl: brcms_resume: pci_get_drvdata failed\n");
 		return -ENODEV;
 	}
 
@@ -1209,81 +1230,82 @@ static int wl_resume(struct pci_dev *pdev)
 
 	/*
 	*  done. driver will be put in up state
-	*  in wl_ops_add_interface() call.
+	*  in brcms_ops_add_interface() call.
 	*/
 	return err;
 }
 
 /*
-* called from both kernel as from wl_*()
+* called from both kernel as from this kernel module.
 * precondition: perimeter lock is not acquired.
 */
-static void wl_remove(struct pci_dev *pdev)
+static void brcms_remove(struct pci_dev *pdev)
 {
-	struct wl_info *wl;
+	struct brcms_info *wl;
 	struct ieee80211_hw *hw;
 	int status;
 
 	hw = pci_get_drvdata(pdev);
 	wl = HW_TO_WL(hw);
 	if (!wl) {
-		pr_err("wl: wl_remove: pci_get_drvdata failed\n");
+		pr_err("wl: brcms_remove: pci_get_drvdata failed\n");
 		return;
 	}
 
-	WL_LOCK(wl);
+	LOCK(wl);
 	status = wlc_chipmatch(pdev->vendor, pdev->device);
-	WL_UNLOCK(wl);
+	UNLOCK(wl);
 	if (!status) {
-		wiphy_err(wl->wiphy, "wl: wl_remove: wlc_chipmatch failed\n");
+		wiphy_err(wl->wiphy, "wl: brcms_remove: wlc_chipmatch "
+				     "failed\n");
 		return;
 	}
 	if (wl->wlc) {
 		wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, false);
 		wiphy_rfkill_stop_polling(wl->pub->ieee_hw->wiphy);
 		ieee80211_unregister_hw(hw);
-		WL_LOCK(wl);
-		wl_down(wl);
-		WL_UNLOCK(wl);
+		LOCK(wl);
+		brcms_down(wl);
+		UNLOCK(wl);
 	}
 	pci_disable_device(pdev);
 
-	wl_free(wl);
+	brcms_free(wl);
 
 	pci_set_drvdata(pdev, NULL);
 	ieee80211_free_hw(hw);
 }
 
-static struct pci_driver wl_pci_driver = {
+static struct pci_driver brcms_pci_driver = {
 	.name     = KBUILD_MODNAME,
-	.probe    = wl_pci_probe,
-	.suspend  = wl_suspend,
-	.resume   = wl_resume,
-	.remove   = __devexit_p(wl_remove),
-	.id_table = wl_id_table,
+	.probe    = brcms_pci_probe,
+	.suspend  = brcms_suspend,
+	.resume   = brcms_resume,
+	.remove   = __devexit_p(brcms_remove),
+	.id_table = brcms_pci_id_table,
 };
 
 /**
  * This is the main entry point for the WL driver.
  *
  * This function determines if a device pointed to by pdev is a WL device,
- * and if so, performs a wl_attach() on it.
+ * and if so, performs a brcms_attach() on it.
  *
  */
-static int __init wl_module_init(void)
+static int __init brcms_module_init(void)
 {
 	int error = -ENODEV;
 
 #ifdef BCMDBG
 	if (msglevel != 0xdeadbeef)
-		wl_msg_level = msglevel;
+		brcm_msg_level = msglevel;
 	else {
 		char *var = getvar(NULL, "wl_msglevel");
 		if (var) {
 			unsigned long value;
 
 			(void)strict_strtoul(var, 0, &value);
-			wl_msg_level = value;
+			brcm_msg_level = value;
 		}
 	}
 	if (phymsglevel != 0xdeadbeef)
@@ -1299,7 +1321,7 @@ static int __init wl_module_init(void)
 	}
 #endif				/* BCMDBG */
 
-	error = pci_register_driver(&wl_pci_driver);
+	error = pci_register_driver(&brcms_pci_driver);
 	if (!error)
 		return 0;
 
@@ -1315,14 +1337,14 @@ static int __init wl_module_init(void)
  * system.
  *
  */
-static void __exit wl_module_exit(void)
+static void __exit brcms_module_exit(void)
 {
-	pci_unregister_driver(&wl_pci_driver);
+	pci_unregister_driver(&brcms_pci_driver);
 
 }
 
-module_init(wl_module_init);
-module_exit(wl_module_exit);
+module_init(brcms_module_init);
+module_exit(brcms_module_exit);
 
 /**
  * This function frees the WL per-device resources.
@@ -1333,13 +1355,13 @@ module_exit(wl_module_exit);
  * precondition: can both be called locked and unlocked
  *
  */
-static void wl_free(struct wl_info *wl)
+static void brcms_free(struct brcms_info *wl)
 {
-	struct wl_timer *t, *next;
+	struct brcms_timer *t, *next;
 
 	/* free ucode data */
 	if (wl->fw.fw_cnt)
-		wl_ucode_data_free();
+		brcms_ucode_data_free();
 	if (wl->irq)
 		free_irq(wl->irq, wl);
 
@@ -1384,7 +1406,7 @@ static void wl_free(struct wl_info *wl)
 }
 
 /* flags the given rate in rateset as requested */
-static void wl_set_basic_rate(struct wl_rateset *rs, u16 rate, bool is_br)
+static void brcms_set_basic_rate(struct wl_rateset *rs, u16 rate, bool is_br)
 {
 	u32 i;
 
@@ -1403,8 +1425,8 @@ static void wl_set_basic_rate(struct wl_rateset *rs, u16 rate, bool is_br)
 /*
  * precondition: perimeter lock has been acquired
  */
-void wl_txflowcontrol(struct wl_info *wl, struct wl_if *wlif, bool state,
-		      int prio)
+void brcms_txflowcontrol(struct brcms_info *wl, struct brcms_if *wlif,
+			 bool state, int prio)
 {
 	wiphy_err(wl->wiphy, "Shouldn't be here %s\n", __func__);
 }
@@ -1412,10 +1434,10 @@ void wl_txflowcontrol(struct wl_info *wl, struct wl_if *wlif, bool state,
 /*
  * precondition: perimeter lock has been acquired
  */
-void wl_init(struct wl_info *wl)
+void brcms_init(struct brcms_info *wl)
 {
 	BCMMSG(WL_TO_HW(wl)->wiphy, "wl%d\n", wl->pub->unit);
-	wl_reset(wl);
+	brcms_reset(wl);
 
 	wlc_init(wl->wlc);
 }
@@ -1423,7 +1445,7 @@ void wl_init(struct wl_info *wl)
 /*
  * precondition: perimeter lock has been acquired
  */
-uint wl_reset(struct wl_info *wl)
+uint brcms_reset(struct brcms_info *wl)
 {
 	BCMMSG(WL_TO_HW(wl)->wiphy, "wl%d\n", wl->pub->unit);
 	wlc_reset(wl->wlc);
@@ -1438,7 +1460,7 @@ uint wl_reset(struct wl_info *wl)
  * These are interrupt on/off entry points. Disable interrupts
  * during interrupt state transition.
  */
-void wl_intrson(struct wl_info *wl)
+void brcms_intrson(struct brcms_info *wl)
 {
 	unsigned long flags;
 
@@ -1450,12 +1472,12 @@ void wl_intrson(struct wl_info *wl)
 /*
  * precondition: perimeter lock has been acquired
  */
-bool wl_alloc_dma_resources(struct wl_info *wl, uint addrwidth)
+bool wl_alloc_dma_resources(struct brcms_info *wl, uint addrwidth)
 {
 	return true;
 }
 
-u32 wl_intrsoff(struct wl_info *wl)
+u32 brcms_intrsoff(struct brcms_info *wl)
 {
 	unsigned long flags;
 	u32 status;
@@ -1466,7 +1488,7 @@ u32 wl_intrsoff(struct wl_info *wl)
 	return status;
 }
 
-void wl_intrsrestore(struct wl_info *wl, u32 macintmask)
+void brcms_intrsrestore(struct brcms_info *wl, u32 macintmask)
 {
 	unsigned long flags;
 
@@ -1478,7 +1500,7 @@ void wl_intrsrestore(struct wl_info *wl, u32 macintmask)
 /*
  * precondition: perimeter lock has been acquired
  */
-int wl_up(struct wl_info *wl)
+int brcms_up(struct brcms_info *wl)
 {
 	int error = 0;
 
@@ -1493,7 +1515,7 @@ int wl_up(struct wl_info *wl)
 /*
  * precondition: perimeter lock has been acquired
  */
-void wl_down(struct wl_info *wl)
+void brcms_down(struct brcms_info *wl)
 {
 	uint callbacks, ret_val = 0;
 
@@ -1502,25 +1524,25 @@ void wl_down(struct wl_info *wl)
 	callbacks = atomic_read(&wl->callbacks) - ret_val;
 
 	/* wait for down callbacks to complete */
-	WL_UNLOCK(wl);
+	UNLOCK(wl);
 
 	/* For HIGH_only driver, it's important to actually schedule other work,
 	 * not just spin wait since everything runs at schedule level
 	 */
 	SPINWAIT((atomic_read(&wl->callbacks) > callbacks), 100 * 1000);
 
-	WL_LOCK(wl);
+	LOCK(wl);
 }
 
-static irqreturn_t wl_isr(int irq, void *dev_id)
+static irqreturn_t brcms_isr(int irq, void *dev_id)
 {
-	struct wl_info *wl;
+	struct brcms_info *wl;
 	bool ours, wantdpc;
 	unsigned long flags;
 
-	wl = (struct wl_info *) dev_id;
+	wl = (struct brcms_info *) dev_id;
 
-	WL_ISRLOCK(wl, flags);
+	ISR_LOCK(wl, flags);
 
 	/* call common first level interrupt handler */
 	ours = wlc_isr(wl->wlc, &wantdpc);
@@ -1534,18 +1556,18 @@ static irqreturn_t wl_isr(int irq, void *dev_id)
 		}
 	}
 
-	WL_ISRUNLOCK(wl, flags);
+	ISR_UNLOCK(wl, flags);
 
 	return IRQ_RETVAL(ours);
 }
 
-static void wl_dpc(unsigned long data)
+static void brcms_dpc(unsigned long data)
 {
-	struct wl_info *wl;
+	struct brcms_info *wl;
 
-	wl = (struct wl_info *) data;
+	wl = (struct brcms_info *) data;
 
-	WL_LOCK(wl);
+	LOCK(wl);
 
 	/* call the common second level interrupt handler */
 	if (wl->pub->up) {
@@ -1569,27 +1591,27 @@ static void wl_dpc(unsigned long data)
 		tasklet_schedule(&wl->tasklet);
 	else {
 		/* re-enable interrupts */
-		wl_intrson(wl);
+		brcms_intrson(wl);
 	}
 
  done:
-	WL_UNLOCK(wl);
+	UNLOCK(wl);
 }
 
 /*
  * is called by the kernel from software irq context
  */
-static void wl_timer(unsigned long data)
+static void brcms_timer(unsigned long data)
 {
-	_wl_timer((struct wl_timer *) data);
+	_brcms_timer((struct brcms_timer *) data);
 }
 
 /*
 * precondition: perimeter lock is not acquired
  */
-static void _wl_timer(struct wl_timer *t)
+static void _brcms_timer(struct brcms_timer *t)
 {
-	WL_LOCK(t->wl);
+	LOCK(t->wl);
 
 	if (t->set) {
 		if (t->periodic) {
@@ -1605,7 +1627,7 @@ static void _wl_timer(struct wl_timer *t)
 
 	atomic_dec(&t->wl->callbacks);
 
-	WL_UNLOCK(t->wl);
+	UNLOCK(t->wl);
 }
 
 /*
@@ -1614,21 +1636,22 @@ static void _wl_timer(struct wl_timer *t)
  *
  * precondition: perimeter lock has been acquired
  */
-struct wl_timer *wl_init_timer(struct wl_info *wl, void (*fn) (void *arg),
-			       void *arg, const char *name)
+struct brcms_timer *brcms_init_timer(struct brcms_info *wl,
+				     void (*fn) (void *arg),
+				     void *arg, const char *name)
 {
-	struct wl_timer *t;
+	struct brcms_timer *t;
 
-	t = kzalloc(sizeof(struct wl_timer), GFP_ATOMIC);
+	t = kzalloc(sizeof(struct brcms_timer), GFP_ATOMIC);
 	if (!t) {
-		wiphy_err(wl->wiphy, "wl%d: wl_init_timer: out of memory\n",
+		wiphy_err(wl->wiphy, "wl%d: brcms_init_timer: out of memory\n",
 			  wl->pub->unit);
 		return 0;
 	}
 
 	init_timer(&t->timer);
 	t->timer.data = (unsigned long) t;
-	t->timer.function = wl_timer;
+	t->timer.function = brcms_timer;
 	t->wl = wl;
 	t->fn = fn;
 	t->arg = arg;
@@ -1649,7 +1672,8 @@ struct wl_timer *wl_init_timer(struct wl_info *wl, void (*fn) (void *arg),
  *
  * precondition: perimeter lock has been acquired
  */
-void wl_add_timer(struct wl_info *wl, struct wl_timer *t, uint ms, int periodic)
+void brcms_add_timer(struct brcms_info *wl, struct brcms_timer *t, uint ms,
+		     int periodic)
 {
 #ifdef BCMDBG
 	if (t->set) {
@@ -1671,7 +1695,7 @@ void wl_add_timer(struct wl_info *wl, struct wl_timer *t, uint ms, int periodic)
  *
  * precondition: perimeter lock has been acquired
  */
-bool wl_del_timer(struct wl_info *wl, struct wl_timer *t)
+bool brcms_del_timer(struct brcms_info *wl, struct brcms_timer *t)
 {
 	if (t->set) {
 		t->set = false;
@@ -1687,12 +1711,12 @@ bool wl_del_timer(struct wl_info *wl, struct wl_timer *t)
 /*
  * precondition: perimeter lock has been acquired
  */
-void wl_free_timer(struct wl_info *wl, struct wl_timer *t)
+void brcms_free_timer(struct brcms_info *wl, struct brcms_timer *t)
 {
-	struct wl_timer *tmp;
+	struct brcms_timer *tmp;
 
 	/* delete the timer in case it is active */
-	wl_del_timer(wl, t);
+	brcms_del_timer(wl, t);
 
 	if (wl->timers == t) {
 		wl->timers = wl->timers->next;
@@ -1729,13 +1753,13 @@ static int wl_linux_watchdog(void *ctx)
 	return 0;
 }
 
-struct wl_fw_hdr {
+struct firmware_hdr {
 	u32 offset;
 	u32 len;
 	u32 idx;
 };
 
-char *wl_firmwares[WL_MAX_FW] = {
+char *brcms_firmwares[MAX_FW_IMAGES] = {
 	"brcm/bcm43xx",
 	NULL
 };
@@ -1743,13 +1767,13 @@ char *wl_firmwares[WL_MAX_FW] = {
 /*
  * precondition: perimeter lock has been acquired
  */
-int wl_ucode_init_buf(struct wl_info *wl, void **pbuf, u32 idx)
+int brcms_ucode_init_buf(struct brcms_info *wl, void **pbuf, u32 idx)
 {
 	int i, entry;
 	const u8 *pdata;
-	struct wl_fw_hdr *hdr;
+	struct firmware_hdr *hdr;
 	for (i = 0; i < wl->fw.fw_cnt; i++) {
-		hdr = (struct wl_fw_hdr *)wl->fw.fw_hdr[i]->data;
+		hdr = (struct firmware_hdr *)wl->fw.fw_hdr[i]->data;
 		for (entry = 0; entry < wl->fw.hdr_num_entries[i];
 		     entry++, hdr++) {
 			if (hdr->idx == idx) {
@@ -1773,16 +1797,16 @@ fail:
 }
 
 /*
- * Precondition: Since this function is called in wl_pci_probe() context,
+ * Precondition: Since this function is called in brcms_pci_probe() context,
  * no locking is required.
  */
-int wl_ucode_init_uint(struct wl_info *wl, u32 *data, u32 idx)
+int brcms_ucode_init_uint(struct brcms_info *wl, u32 *data, u32 idx)
 {
 	int i, entry;
 	const u8 *pdata;
-	struct wl_fw_hdr *hdr;
+	struct firmware_hdr *hdr;
 	for (i = 0; i < wl->fw.fw_cnt; i++) {
-		hdr = (struct wl_fw_hdr *)wl->fw.fw_hdr[i]->data;
+		hdr = (struct firmware_hdr *)wl->fw.fw_hdr[i]->data;
 		for (entry = 0; entry < wl->fw.hdr_num_entries[i];
 		     entry++, hdr++) {
 			if (hdr->idx == idx) {
@@ -1802,21 +1826,21 @@ int wl_ucode_init_uint(struct wl_info *wl, u32 *data, u32 idx)
 }
 
 /*
- * Precondition: Since this function is called in wl_pci_probe() context,
+ * Precondition: Since this function is called in brcms_pci_probe() context,
  * no locking is required.
  */
-static int wl_request_fw(struct wl_info *wl, struct pci_dev *pdev)
+static int brcms_request_fw(struct brcms_info *wl, struct pci_dev *pdev)
 {
 	int status;
 	struct device *device = &pdev->dev;
 	char fw_name[100];
 	int i;
 
-	memset((void *)&wl->fw, 0, sizeof(struct wl_firmware));
-	for (i = 0; i < WL_MAX_FW; i++) {
-		if (wl_firmwares[i] == NULL)
+	memset((void *)&wl->fw, 0, sizeof(struct brcms_firmware));
+	for (i = 0; i < MAX_FW_IMAGES; i++) {
+		if (brcms_firmwares[i] == NULL)
 			break;
-		sprintf(fw_name, "%s-%d.fw", wl_firmwares[i],
+		sprintf(fw_name, "%s-%d.fw", brcms_firmwares[i],
 			UCODE_LOADER_API_VER);
 		status = request_firmware(&wl->fw.fw_bin[i], fw_name, device);
 		if (status) {
@@ -1824,7 +1848,7 @@ static int wl_request_fw(struct wl_info *wl, struct pci_dev *pdev)
 				  KBUILD_MODNAME, fw_name);
 			return status;
 		}
-		sprintf(fw_name, "%s_hdr-%d.fw", wl_firmwares[i],
+		sprintf(fw_name, "%s_hdr-%d.fw", brcms_firmwares[i],
 			UCODE_LOADER_API_VER);
 		status = request_firmware(&wl->fw.fw_hdr[i], fw_name, device);
 		if (status) {
@@ -1833,28 +1857,28 @@ static int wl_request_fw(struct wl_info *wl, struct pci_dev *pdev)
 			return status;
 		}
 		wl->fw.hdr_num_entries[i] =
-		    wl->fw.fw_hdr[i]->size / (sizeof(struct wl_fw_hdr));
+		    wl->fw.fw_hdr[i]->size / (sizeof(struct firmware_hdr));
 	}
 	wl->fw.fw_cnt = i;
-	return wl_ucode_data_init(wl);
+	return brcms_ucode_data_init(wl);
 }
 
 /*
  * precondition: can both be called locked and unlocked
  */
-void wl_ucode_free_buf(void *p)
+void brcms_ucode_free_buf(void *p)
 {
 	kfree(p);
 }
 
 /*
- * Precondition: Since this function is called in wl_pci_probe() context,
+ * Precondition: Since this function is called in brcms_pci_probe() context,
  * no locking is required.
  */
-static void wl_release_fw(struct wl_info *wl)
+static void brcms_release_fw(struct brcms_info *wl)
 {
 	int i;
-	for (i = 0; i < WL_MAX_FW; i++) {
+	for (i = 0; i < MAX_FW_IMAGES; i++) {
 		release_firmware(wl->fw.fw_bin[i]);
 		release_firmware(wl->fw.fw_hdr[i]);
 	}
@@ -1864,18 +1888,18 @@ static void wl_release_fw(struct wl_info *wl)
 /*
  * checks validity of all firmware images loaded from user space
  *
- * Precondition: Since this function is called in wl_pci_probe() context,
+ * Precondition: Since this function is called in brcms_pci_probe() context,
  * no locking is required.
  */
-int wl_check_firmwares(struct wl_info *wl)
+int brcms_check_firmwares(struct brcms_info *wl)
 {
 	int i;
 	int entry;
 	int rc = 0;
 	const struct firmware *fw;
 	const struct firmware *fw_hdr;
-	struct wl_fw_hdr *ucode_hdr;
-	for (i = 0; i < WL_MAX_FW && rc == 0; i++) {
+	struct firmware_hdr *ucode_hdr;
+	for (i = 0; i < MAX_FW_IMAGES && rc == 0; i++) {
 		fw =  wl->fw.fw_bin[i];
 		fw_hdr = wl->fw.fw_hdr[i];
 		if (fw == NULL && fw_hdr == NULL) {
@@ -1884,10 +1908,10 @@ int wl_check_firmwares(struct wl_info *wl)
 			wiphy_err(wl->wiphy, "%s: invalid bin/hdr fw\n",
 				  __func__);
 			rc = -EBADF;
-		} else if (fw_hdr->size % sizeof(struct wl_fw_hdr)) {
+		} else if (fw_hdr->size % sizeof(struct firmware_hdr)) {
 			wiphy_err(wl->wiphy, "%s: non integral fw hdr file "
 				"size %zu/%zu\n", __func__, fw_hdr->size,
-				sizeof(struct wl_fw_hdr));
+				sizeof(struct firmware_hdr));
 			rc = -EBADF;
 		} else if (fw->size < MIN_FW_SIZE || fw->size > MAX_FW_SIZE) {
 			wiphy_err(wl->wiphy, "%s: out of bounds fw file size "
@@ -1895,7 +1919,7 @@ int wl_check_firmwares(struct wl_info *wl)
 			rc = -EBADF;
 		} else {
 			/* check if ucode section overruns firmware image */
-			ucode_hdr = (struct wl_fw_hdr *)fw_hdr->data;
+			ucode_hdr = (struct firmware_hdr *)fw_hdr->data;
 			for (entry = 0; entry < wl->fw.hdr_num_entries[i] &&
 			     !rc; entry++, ucode_hdr++) {
 				if (ucode_hdr->offset + ucode_hdr->len >
@@ -1919,24 +1943,24 @@ int wl_check_firmwares(struct wl_info *wl)
 /*
  * precondition: perimeter lock has been acquired
  */
-bool wl_rfkill_set_hw_state(struct wl_info *wl)
+bool brcms_rfkill_set_hw_state(struct brcms_info *wl)
 {
 	bool blocked = wlc_check_radio_disabled(wl->wlc);
 
-	WL_UNLOCK(wl);
+	UNLOCK(wl);
 	wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, blocked);
 	if (blocked)
 		wiphy_rfkill_start_polling(wl->pub->ieee_hw->wiphy);
-	WL_LOCK(wl);
+	LOCK(wl);
 	return blocked;
 }
 
 /*
  * precondition: perimeter lock has been acquired
  */
-void wl_msleep(struct wl_info *wl, uint ms)
+void brcms_msleep(struct brcms_info *wl, uint ms)
 {
-	WL_UNLOCK(wl);
+	UNLOCK(wl);
 	msleep(ms);
-	WL_LOCK(wl);
+	LOCK(wl);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
index fafde6a..48ec6b0 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
@@ -25,34 +25,34 @@
  * sleep so perimeter lock has to be a semaphore instead of spinlock. This requires timers to be
  * submitted to workqueue instead of being on kernel timer
  */
-struct wl_timer {
+struct brcms_timer {
 	struct timer_list timer;
-	struct wl_info *wl;
+	struct brcms_info *wl;
 	void (*fn) (void *);
 	void *arg;		/* argument to fn */
 	uint ms;
 	bool periodic;
 	bool set;
-	struct wl_timer *next;
+	struct brcms_timer *next;
 #ifdef BCMDBG
 	char *name;		/* Description of the timer */
 #endif
 };
 
-struct wl_if {
+struct brcms_if {
 	uint subunit;		/* WDS/BSS unit */
 	struct pci_dev *pci_dev;
 };
 
-#define WL_MAX_FW		4
-struct wl_firmware {
+#define MAX_FW_IMAGES		4
+struct brcms_firmware {
 	u32 fw_cnt;
-	const struct firmware *fw_bin[WL_MAX_FW];
-	const struct firmware *fw_hdr[WL_MAX_FW];
-	u32 hdr_num_entries[WL_MAX_FW];
+	const struct firmware *fw_bin[MAX_FW_IMAGES];
+	const struct firmware *fw_hdr[MAX_FW_IMAGES];
+	u32 hdr_num_entries[MAX_FW_IMAGES];
 };
 
-struct wl_info {
+struct brcms_info {
 	struct wlc_pub *pub;		/* pointer to public wlc state */
 	void *wlc;		/* pointer to private common os-independent data */
 	u32 magic;
@@ -62,32 +62,20 @@ struct wl_info {
 	spinlock_t lock;	/* per-device perimeter lock */
 	spinlock_t isr_lock;	/* per-device ISR synchronization lock */
 
-	/* bus type and regsva for unmap in wl_free() */
+	/* bus type and regsva for unmap in brcms_free() */
 	uint bcm_bustype;	/* bus type */
 	void *regsva;		/* opaque chip registers virtual address */
 
 	/* timer related fields */
 	atomic_t callbacks;	/* # outstanding callback functions */
-	struct wl_timer *timers;	/* timer cleanup queue */
+	struct brcms_timer *timers;	/* timer cleanup queue */
 
 	struct tasklet_struct tasklet;	/* dpc tasklet */
 	bool resched;		/* dpc needs to be and is rescheduled */
 #ifdef LINUXSTA_PS
 	u32 pci_psstate[16];	/* pci ps-state save/restore */
 #endif
-	struct wl_firmware fw;
+	struct brcms_firmware fw;
 	struct wiphy *wiphy;
 };
-
-#define WL_LOCK(wl)	spin_lock_bh(&(wl)->lock)
-#define WL_UNLOCK(wl)	spin_unlock_bh(&(wl)->lock)
-
-/* locking from inside wl_isr */
-#define WL_ISRLOCK(wl, flags) do {spin_lock(&(wl)->isr_lock); (void)(flags); } while (0)
-#define WL_ISRUNLOCK(wl, flags) do {spin_unlock(&(wl)->isr_lock); (void)(flags); } while (0)
-
-/* locking under WL_LOCK() to synchronize with wl_isr */
-#define INT_LOCK(wl, flags)	spin_lock_irqsave(&(wl)->isr_lock, flags)
-#define INT_UNLOCK(wl, flags)	spin_unlock_irqrestore(&(wl)->isr_lock, flags)
-
 #endif				/* _wl_mac80211_h_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_ucode.h b/drivers/staging/brcm80211/brcmsmac/wl_ucode.h
index 28838d8..4b90121 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_ucode.h
+++ b/drivers/staging/brcm80211/brcmsmac/wl_ucode.h
@@ -41,11 +41,12 @@ extern u32 bcm43xx_16_mimosz;
 extern u32 *bcm43xx_24_lcn;
 extern u32 bcm43xx_24_lcnsz;
 
-extern int wl_ucode_data_init(struct wl_info *wl);
-extern void wl_ucode_data_free(void);
+extern int brcms_ucode_data_init(struct brcms_info *wl);
+extern void brcms_ucode_data_free(void);
 
-extern int wl_ucode_init_buf(struct wl_info *wl, void **pbuf, unsigned int idx);
-extern int wl_ucode_init_uint(struct wl_info *wl, unsigned *data,
+extern int brcms_ucode_init_buf(struct brcms_info *wl, void **pbuf,
+				unsigned int idx);
+extern int brcms_ucode_init_uint(struct brcms_info *wl, unsigned *data,
 			      unsigned int idx);
-extern void wl_ucode_free_buf(void *);
-extern int  wl_check_firmwares(struct wl_info *wl);
+extern void brcms_ucode_free_buf(void *);
+extern int  brcms_check_firmwares(struct brcms_info *wl);
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_ucode_loader.c b/drivers/staging/brcm80211/brcmsmac/wl_ucode_loader.c
index cc00dd1..cf0be6b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_ucode_loader.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_ucode_loader.c
@@ -53,59 +53,63 @@ u32 bcm43xx_24_lcnsz;
 u32 *bcm43xx_bommajor;
 u32 *bcm43xx_bomminor;
 
-int wl_ucode_data_init(struct wl_info *wl)
+int brcms_ucode_data_init(struct brcms_info *wl)
 {
 	int rc;
-	rc = wl_check_firmwares(wl);
+	rc = brcms_check_firmwares(wl);
 
-	rc = rc < 0 ? rc : wl_ucode_init_buf(wl, (void **)&d11lcn0bsinitvals24,
-					     D11LCN0BSINITVALS24);
-	rc = rc < 0 ? rc : wl_ucode_init_buf(wl, (void **)&d11lcn0initvals24,
+	rc = rc < 0 ? rc :
+		brcms_ucode_init_buf(wl, (void **)&d11lcn0bsinitvals24,
+				     D11LCN0BSINITVALS24);
+	rc = rc < 0 ? rc : brcms_ucode_init_buf(wl, (void **)&d11lcn0initvals24,
 					     D11LCN0INITVALS24);
-	rc = rc < 0 ? rc : wl_ucode_init_buf(wl, (void **)&d11lcn1bsinitvals24,
-					     D11LCN1BSINITVALS24);
-	rc = rc < 0 ? rc : wl_ucode_init_buf(wl, (void **)&d11lcn1initvals24,
+	rc = rc < 0 ? rc :
+		brcms_ucode_init_buf(wl, (void **)&d11lcn1bsinitvals24,
+				     D11LCN1BSINITVALS24);
+	rc = rc < 0 ? rc : brcms_ucode_init_buf(wl, (void **)&d11lcn1initvals24,
 					     D11LCN1INITVALS24);
-	rc = rc < 0 ? rc : wl_ucode_init_buf(wl, (void **)&d11lcn2bsinitvals24,
-					     D11LCN2BSINITVALS24);
-	rc = rc < 0 ? rc : wl_ucode_init_buf(wl, (void **)&d11lcn2initvals24,
+	rc = rc < 0 ? rc :
+		brcms_ucode_init_buf(wl, (void **)&d11lcn2bsinitvals24,
+				     D11LCN2BSINITVALS24);
+	rc = rc < 0 ? rc : brcms_ucode_init_buf(wl, (void **)&d11lcn2initvals24,
 					     D11LCN2INITVALS24);
-	rc = rc < 0 ? rc : wl_ucode_init_buf(wl, (void **)&d11n0absinitvals16,
-					     D11N0ABSINITVALS16);
-	rc = rc < 0 ? rc : wl_ucode_init_buf(wl, (void **)&d11n0bsinitvals16,
+	rc = rc < 0 ? rc :
+		brcms_ucode_init_buf(wl, (void **)&d11n0absinitvals16,
+				     D11N0ABSINITVALS16);
+	rc = rc < 0 ? rc : brcms_ucode_init_buf(wl, (void **)&d11n0bsinitvals16,
 					     D11N0BSINITVALS16);
-	rc = rc < 0 ? rc : wl_ucode_init_buf(wl, (void **)&d11n0initvals16,
+	rc = rc < 0 ? rc : brcms_ucode_init_buf(wl, (void **)&d11n0initvals16,
 					     D11N0INITVALS16);
-	rc = rc < 0 ? rc : wl_ucode_init_buf(wl, (void **)&bcm43xx_16_mimo,
+	rc = rc < 0 ? rc : brcms_ucode_init_buf(wl, (void **)&bcm43xx_16_mimo,
 					     D11UCODE_OVERSIGHT16_MIMO);
-	rc = rc < 0 ? rc : wl_ucode_init_uint(wl, &bcm43xx_16_mimosz,
+	rc = rc < 0 ? rc : brcms_ucode_init_uint(wl, &bcm43xx_16_mimosz,
 					      D11UCODE_OVERSIGHT16_MIMOSZ);
-	rc = rc < 0 ? rc : wl_ucode_init_buf(wl, (void **)&bcm43xx_24_lcn,
+	rc = rc < 0 ? rc : brcms_ucode_init_buf(wl, (void **)&bcm43xx_24_lcn,
 					     D11UCODE_OVERSIGHT24_LCN);
-	rc = rc < 0 ? rc : wl_ucode_init_uint(wl, &bcm43xx_24_lcnsz,
+	rc = rc < 0 ? rc : brcms_ucode_init_uint(wl, &bcm43xx_24_lcnsz,
 					      D11UCODE_OVERSIGHT24_LCNSZ);
-	rc = rc < 0 ? rc : wl_ucode_init_buf(wl, (void **)&bcm43xx_bommajor,
+	rc = rc < 0 ? rc : brcms_ucode_init_buf(wl, (void **)&bcm43xx_bommajor,
 					     D11UCODE_OVERSIGHT_BOMMAJOR);
-	rc = rc < 0 ? rc : wl_ucode_init_buf(wl, (void **)&bcm43xx_bomminor,
+	rc = rc < 0 ? rc : brcms_ucode_init_buf(wl, (void **)&bcm43xx_bomminor,
 					     D11UCODE_OVERSIGHT_BOMMINOR);
 	return rc;
 }
 
-void wl_ucode_data_free(void)
+void brcms_ucode_data_free(void)
 {
-	wl_ucode_free_buf((void *)d11lcn0bsinitvals24);
-	wl_ucode_free_buf((void *)d11lcn0initvals24);
-	wl_ucode_free_buf((void *)d11lcn1bsinitvals24);
-	wl_ucode_free_buf((void *)d11lcn1initvals24);
-	wl_ucode_free_buf((void *)d11lcn2bsinitvals24);
-	wl_ucode_free_buf((void *)d11lcn2initvals24);
-	wl_ucode_free_buf((void *)d11n0absinitvals16);
-	wl_ucode_free_buf((void *)d11n0bsinitvals16);
-	wl_ucode_free_buf((void *)d11n0initvals16);
-	wl_ucode_free_buf((void *)bcm43xx_16_mimo);
-	wl_ucode_free_buf((void *)bcm43xx_24_lcn);
-	wl_ucode_free_buf((void *)bcm43xx_bommajor);
-	wl_ucode_free_buf((void *)bcm43xx_bomminor);
+	brcms_ucode_free_buf((void *)d11lcn0bsinitvals24);
+	brcms_ucode_free_buf((void *)d11lcn0initvals24);
+	brcms_ucode_free_buf((void *)d11lcn1bsinitvals24);
+	brcms_ucode_free_buf((void *)d11lcn1initvals24);
+	brcms_ucode_free_buf((void *)d11lcn2bsinitvals24);
+	brcms_ucode_free_buf((void *)d11lcn2initvals24);
+	brcms_ucode_free_buf((void *)d11n0absinitvals16);
+	brcms_ucode_free_buf((void *)d11n0bsinitvals16);
+	brcms_ucode_free_buf((void *)d11n0initvals16);
+	brcms_ucode_free_buf((void *)bcm43xx_16_mimo);
+	brcms_ucode_free_buf((void *)bcm43xx_24_lcn);
+	brcms_ucode_free_buf((void *)bcm43xx_bommajor);
+	brcms_ucode_free_buf((void *)bcm43xx_bomminor);
 
 	return;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 6bc547a..fe031f2 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -238,7 +238,7 @@ static u32 WLBANDINITFN(wlc_setband_inact) (struct wlc_info *wlc, uint bandunit)
 	WARN_ON((R_REG(&wlc_hw->regs->maccontrol) & MCTL_EN_MAC) != 0);
 
 	/* disable interrupts */
-	macintmask = wl_intrsoff(wlc->wl);
+	macintmask = brcms_intrsoff(wlc->wl);
 
 	/* radio off */
 	wlc_phy_switch_radio(wlc_hw->band->pi, OFF);
@@ -315,7 +315,7 @@ bool wlc_dpc(struct wlc_info *wlc, bool bounded)
 	if (DEVICEREMOVED(wlc)) {
 		wiphy_err(wiphy, "wl%d: %s: dead chip\n", wlc_hw->unit,
 			  __func__);
-		wl_down(wlc->wl);
+		brcms_down(wlc->wl);
 		return false;
 	}
 
@@ -386,7 +386,7 @@ bool wlc_dpc(struct wlc_info *wlc, bool bounded)
 					__func__, wlc_hw->sih->chip,
 					wlc_hw->sih->chiprev);
 		/* big hammer */
-		wl_init(wlc->wl);
+		brcms_init(wlc->wl);
 	}
 
 	/* gptimer timeout */
@@ -397,7 +397,7 @@ bool wlc_dpc(struct wlc_info *wlc, bool bounded)
 	if (macintstatus & MI_RFDISABLE) {
 		BCMMSG(wlc->wiphy, "wl%d: BMAC Detected a change on the"
 		       " RF Disable Input\n", wlc_hw->unit);
-		wl_rfkill_set_hw_state(wlc->wl);
+		brcms_rfkill_set_hw_state(wlc->wl);
 	}
 
 	/* send any enq'd tx packets. Just makes sure to jump start tx */
@@ -408,7 +408,7 @@ bool wlc_dpc(struct wlc_info *wlc, bool bounded)
 	return wlc->macintstatus != 0;
 
  fatal:
-	wl_init(wlc->wl);
+	brcms_init(wlc->wl);
 	return wlc->macintstatus != 0;
 }
 
@@ -526,7 +526,7 @@ static bool wlc_bmac_attach_dmapio(struct wlc_info *wlc, uint j, bool wme)
 					    NULL), DMAREG(wlc_hw, DMA_RX, 0),
 					   (wme ? tune->ntxd : 0), tune->nrxd,
 					   tune->rxbufsz, -1, tune->nrxbufpost,
-					   WL_HWRXOFF, &wl_msg_level);
+					   WL_HWRXOFF, &brcm_msg_level);
 		dma_attach_err |= (NULL == wlc_hw->di[0]);
 
 		/*
@@ -538,7 +538,7 @@ static bool wlc_bmac_attach_dmapio(struct wlc_info *wlc, uint j, bool wme)
 		wlc_hw->di[1] = dma_attach(name, wlc_hw->sih,
 					   DMAREG(wlc_hw, DMA_TX, 1), NULL,
 					   tune->ntxd, 0, 0, -1, 0, 0,
-					   &wl_msg_level);
+					   &brcm_msg_level);
 		dma_attach_err |= (NULL == wlc_hw->di[1]);
 
 		/*
@@ -549,7 +549,7 @@ static bool wlc_bmac_attach_dmapio(struct wlc_info *wlc, uint j, bool wme)
 		wlc_hw->di[2] = dma_attach(name, wlc_hw->sih,
 					   DMAREG(wlc_hw, DMA_TX, 2), NULL,
 					   tune->ntxd, 0, 0, -1, 0, 0,
-					   &wl_msg_level);
+					   &brcm_msg_level);
 		dma_attach_err |= (NULL == wlc_hw->di[2]);
 		/*
 		 * FIFO 3
@@ -559,7 +559,7 @@ static bool wlc_bmac_attach_dmapio(struct wlc_info *wlc, uint j, bool wme)
 		wlc_hw->di[3] = dma_attach(name, wlc_hw->sih,
 					   DMAREG(wlc_hw, DMA_TX, 3),
 					   NULL, tune->ntxd, 0, 0, -1,
-					   0, 0, &wl_msg_level);
+					   0, 0, &brcm_msg_level);
 		dma_attach_err |= (NULL == wlc_hw->di[3]);
 /* Cleaner to leave this as if with AP defined */
 
@@ -1050,7 +1050,7 @@ wlc_bmac_init(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 		wlc_clkctl_clk(wlc_hw, CLK_FAST);
 
 	/* disable interrupts */
-	macintmask = wl_intrsoff(wlc->wl);
+	macintmask = brcms_intrsoff(wlc->wl);
 
 	/* set up the specified band and chanspec */
 	wlc_setxband(wlc_hw, CHSPEC_WLCBANDUNIT(chanspec));
@@ -1070,7 +1070,7 @@ wlc_bmac_init(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 	wlc_bmac_bsinit(wlc, chanspec);
 
 	/* restore macintmask */
-	wl_intrsrestore(wlc->wl, macintmask);
+	brcms_intrsrestore(wlc->wl, macintmask);
 
 	/* seed wake_override with WLC_WAKE_OVERRIDE_MACSUSPEND since the mac is suspended
 	 * and wlc_enable_mac() will clear this override bit.
@@ -1140,7 +1140,7 @@ int wlc_bmac_up_finish(struct wlc_hw_info *wlc_hw)
 
 	/* FULLY enable dynamic power control and d11 core interrupt */
 	wlc_clkctl_clk(wlc_hw, CLK_DYNAMIC);
-	wl_intrson(wlc_hw->wlc->wl);
+	brcms_intrson(wlc_hw->wlc->wl);
 	return 0;
 }
 
@@ -1161,7 +1161,7 @@ int wlc_bmac_down_prep(struct wlc_hw_info *wlc_hw)
 		wlc_hw->wlc->macintmask = 0;
 	else {
 		/* now disable interrupts */
-		wl_intrsoff(wlc_hw->wlc->wl);
+		brcms_intrsoff(wlc_hw->wlc->wl);
 
 		/* ensure we're running on the pll clock again */
 		wlc_clkctl_clk(wlc_hw, CLK_FAST);
@@ -1201,7 +1201,7 @@ int wlc_bmac_down_finish(struct wlc_hw_info *wlc_hw)
 			if (R_REG(&wlc_hw->regs->maccontrol) &
 			    MCTL_EN_MAC)
 				wlc_suspend_mac_and_wait(wlc_hw->wlc);
-			callbacks += wl_reset(wlc_hw->wlc->wl);
+			callbacks += brcms_reset(wlc_hw->wlc->wl);
 			wlc_coredisable(wlc_hw);
 		}
 
@@ -1885,7 +1885,7 @@ WLBANDINITFN(wlc_bmac_setband) (struct wlc_hw_info *wlc_hw, uint bandunit,
 		wlc->macintstatus = MI_DMAINT;
 
 	/* restore macintmask */
-	wl_intrsrestore(wlc->wl, macintmask);
+	brcms_intrsrestore(wlc->wl, macintmask);
 
 	/* ucode should still be suspended.. */
 	WARN_ON((R_REG(&wlc_hw->regs->maccontrol) & MCTL_EN_MAC) != 0);
@@ -2683,7 +2683,7 @@ static u32 wlc_wlintrsoff(struct wlc_info *wlc)
 	if (!wlc->hw->up)
 		return 0;
 
-	return wl_intrsoff(wlc->wl);
+	return brcms_intrsoff(wlc->wl);
 }
 
 static void wlc_wlintrsrestore(struct wlc_info *wlc, u32 macintmask)
@@ -2691,7 +2691,7 @@ static void wlc_wlintrsrestore(struct wlc_info *wlc, u32 macintmask)
 	if (!wlc->hw->up)
 		return;
 
-	wl_intrsrestore(wlc->wl, macintmask);
+	brcms_intrsrestore(wlc->wl, macintmask);
 }
 
 u32 wlc_intrsoff(struct wlc_info *wlc)
@@ -3065,7 +3065,7 @@ void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
 	if (mc == 0xffffffff) {
 		wiphy_err(wiphy, "wl%d: %s: dead chip\n", wlc_hw->unit,
 			  __func__);
-		wl_down(wlc->wl);
+		brcms_down(wlc->wl);
 		return;
 	}
 	WARN_ON(mc & MCTL_PSM_JMP_0);
@@ -3076,7 +3076,7 @@ void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
 	if (mi == 0xffffffff) {
 		wiphy_err(wiphy, "wl%d: %s: dead chip\n", wlc_hw->unit,
 			  __func__);
-		wl_down(wlc->wl);
+		brcms_down(wlc->wl);
 		return;
 	}
 	WARN_ON(mi & MI_MACSSPNDD);
@@ -3101,7 +3101,7 @@ void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
 	if (mc == 0xffffffff) {
 		wiphy_err(wiphy, "wl%d: %s: dead chip\n", wlc_hw->unit,
 			  __func__);
-		wl_down(wlc->wl);
+		brcms_down(wlc->wl);
 		return;
 	}
 	WARN_ON(mc & MCTL_PSM_JMP_0);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 3e34b31..1a2108c 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -191,11 +191,11 @@
 				(!AP_ENAB(wlc->pub)) && (wlc->war16165))
 
 /* debug/trace */
-uint wl_msg_level =
+uint brcm_msg_level =
 #if defined(BCMDBG)
-    WL_ERROR_VAL;
+	LOG_ERROR_VAL;
 #else
-    0;
+	0;
 #endif				/* BCMDBG */
 
 /* Find basic rate for a given rate */
@@ -415,7 +415,7 @@ void wlc_fatal_error(struct wlc_info *wlc)
 {
 	wiphy_err(wlc->wiphy, "wl%d: fatal error, reinitializing\n",
 		  wlc->pub->unit);
-	wl_init(wlc->wl);
+	brcms_init(wlc->wl);
 }
 
 /* Return the channel the driver should initialize during wlc_init.
@@ -1188,7 +1188,7 @@ void wlc_edcf_setparams(struct wlc_info *wlc, bool suspend)
 
 bool wlc_timers_init(struct wlc_info *wlc, int unit)
 {
-	wlc->wdtimer = wl_init_timer(wlc->wl, wlc_watchdog_by_timer,
+	wlc->wdtimer = brcms_init_timer(wlc->wl, wlc_watchdog_by_timer,
 		wlc, "watchdog");
 	if (!wlc->wdtimer) {
 		wiphy_err(wlc->wiphy, "wl%d:  wl_init_timer for wdtimer "
@@ -1196,7 +1196,7 @@ bool wlc_timers_init(struct wlc_info *wlc, int unit)
 		goto fail;
 	}
 
-	wlc->radio_timer = wl_init_timer(wlc->wl, wlc_radio_timer,
+	wlc->radio_timer = brcms_init_timer(wlc->wl, wlc_radio_timer,
 		wlc, "radio");
 	if (!wlc->radio_timer) {
 		wiphy_err(wlc->wiphy, "wl%d:  wl_init_timer for radio_timer "
@@ -1339,7 +1339,7 @@ struct wlc_pub *wlc_pub(void *wlc)
 /*
  * The common driver entry routine. Error codes should be unique
  */
-void *wlc_attach(struct wl_info *wl, u16 vendor, u16 device, uint unit,
+void *wlc_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		 bool piomode, void *regsva, uint bustype, void *btparam,
 		 uint *perr)
 {
@@ -1669,11 +1669,11 @@ static void wlc_timers_deinit(struct wlc_info *wlc)
 {
 	/* free timer state */
 	if (wlc->wdtimer) {
-		wl_free_timer(wlc->wl, wlc->wdtimer);
+		brcms_free_timer(wlc->wl, wlc->wdtimer);
 		wlc->wdtimer = NULL;
 	}
 	if (wlc->radio_timer) {
-		wl_free_timer(wlc->wl, wlc->radio_timer);
+		brcms_free_timer(wlc->wl, wlc->radio_timer);
 		wlc->radio_timer = NULL;
 	}
 }
@@ -1859,7 +1859,7 @@ void wlc_radio_disable(struct wlc_info *wlc)
 	}
 
 	wlc_radio_monitor_start(wlc);
-	wl_down(wlc->wl);
+	brcms_down(wlc->wl);
 }
 
 static void wlc_radio_enable(struct wlc_info *wlc)
@@ -1870,7 +1870,7 @@ static void wlc_radio_enable(struct wlc_info *wlc)
 	if (DEVICEREMOVED(wlc))
 		return;
 
-	wl_up(wlc->wl);
+	brcms_up(wlc->wl);
 }
 
 /* periodical query hw radio button while driver is "down" */
@@ -1881,7 +1881,7 @@ static void wlc_radio_timer(void *arg)
 	if (DEVICEREMOVED(wlc)) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n", wlc->pub->unit,
 			__func__);
-		wl_down(wlc->wl);
+		brcms_down(wlc->wl);
 		return;
 	}
 
@@ -1901,7 +1901,8 @@ static bool wlc_radio_monitor_start(struct wlc_info *wlc)
 
 	wlc->radio_monitor = true;
 	wlc_pllreq(wlc, true, WLC_PLLREQ_RADIO_MON);
-	wl_add_timer(wlc->wl, wlc->radio_timer, TIMER_INTERVAL_RADIOCHK, true);
+	brcms_add_timer(wlc->wl, wlc->radio_timer, TIMER_INTERVAL_RADIOCHK,
+			true);
 	return true;
 }
 
@@ -1912,7 +1913,7 @@ bool wlc_radio_monitor_stop(struct wlc_info *wlc)
 
 	wlc->radio_monitor = false;
 	wlc_pllreq(wlc, false, WLC_PLLREQ_RADIO_MON);
-	return wl_del_timer(wlc->wl, wlc->radio_timer);
+	return brcms_del_timer(wlc->wl, wlc->radio_timer);
 }
 
 static void wlc_watchdog_by_timer(void *arg)
@@ -1935,7 +1936,7 @@ static void wlc_watchdog(void *arg)
 	if (DEVICEREMOVED(wlc)) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n", wlc->pub->unit,
 			  __func__);
-		wl_down(wlc->wl);
+		brcms_down(wlc->wl);
 		return;
 	}
 
@@ -2070,7 +2071,7 @@ int wlc_up(struct wlc_info *wlc)
 		wlc_mhf(wlc, MHF2, MHF2_PCISLOWCLKWAR, MHF2_PCISLOWCLKWAR,
 			WLC_BAND_ALL);
 
-	wl_init(wlc->wl);
+	brcms_init(wlc->wl);
 	wlc->pub->up = true;
 
 	if (wlc->bandinit_pending) {
@@ -2090,7 +2091,7 @@ int wlc_up(struct wlc_info *wlc)
 	wlc_wme_retries_write(wlc);
 
 	/* start one second watchdog timer */
-	wl_add_timer(wlc->wl, wlc->wdtimer, TIMER_INTERVAL_WATCHDOG, true);
+	brcms_add_timer(wlc->wl, wlc->wdtimer, TIMER_INTERVAL_WATCHDOG, true);
 	wlc->WDarmed = true;
 
 	/* ensure antenna config is up to date */
@@ -2168,7 +2169,7 @@ uint wlc_down(struct wlc_info *wlc)
 
 	/* cancel the watchdog timer */
 	if (wlc->WDarmed) {
-		if (!wl_del_timer(wlc->wl, wlc->wdtimer))
+		if (!brcms_del_timer(wlc->wl, wlc->wdtimer))
 			callbacks++;
 		wlc->WDarmed = false;
 	}
@@ -2528,7 +2529,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	if (!wlc->pub->hw_off && DEVICEREMOVED(wlc)) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n", wlc->pub->unit,
 			  __func__);
-		wl_down(wlc->wl);
+		brcms_down(wlc->wl);
 		return -EBADE;
 	}
 
@@ -5817,7 +5818,7 @@ wlc_txflowcontrol_signal(struct wlc_info *wlc, struct wlc_txq_info *qi, bool on,
 
 	for (wlcif = wlc->wlcif_list; wlcif != NULL; wlcif = wlcif->next) {
 		if (wlcif->qi == qi && wlcif->flags & WLC_IF_LINKED)
-			wl_txflowcontrol(wlc->wl, wlcif->wlif, on, prio);
+			brcms_txflowcontrol(wlc->wl, wlcif->wlif, on, prio);
 	}
 #endif
 }
@@ -5923,7 +5924,7 @@ void wlc_wait_for_tx_completion(struct wlc_info *wlc, bool drop)
 	/* wait for queue and DMA fifos to run dry */
 	while (!pktq_empty(&wlc->pkt_queue->q) ||
 	       TXPKTPENDTOT(wlc) > 0) {
-		wl_msleep(wlc->wl, 1);
+		brcms_msleep(wlc->wl, 1);
 	}
 }
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index 0dcb73f..916b2a0 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -401,7 +401,7 @@ struct wlc_if {
 				 * AID2PVBMAP(scb).
 				 */
 	u8 flags;		/* flags for the interface */
-	struct wl_if *wlif;		/* pointer to wlif */
+	struct brcms_if *wlif;		/* pointer to wlif */
 	struct wlc_txq_info *qi;	/* pointer to associated tx queue */
 	union {
 		struct scb *scb;	/* pointer to scb if WLC_IFTYPE_WDS */
@@ -409,8 +409,8 @@ struct wlc_if {
 	} u;
 };
 
-/* flags for the interface */
-#define WLC_IF_LINKED		0x02	/* this interface is linked to a wl_if */
+/* flags for the interface, this interface is linked to a brcms_if */
+#define WLC_IF_LINKED		0x02
 
 struct wlc_hwband {
 	int bandtype;		/* WLC_BAND_2G, WLC_BAND_5G */
@@ -521,7 +521,7 @@ struct wlc_txq_info {
  */
 struct wlc_info {
 	struct wlc_pub *pub;		/* pointer to wlc public state */
-	struct wl_info *wl;	/* pointer to os-specific private state */
+	struct brcms_info *wl;	/* pointer to os-specific private state */
 	d11regs_t *regs;	/* pointer to device registers */
 
 	struct wlc_hw_info *hw;	/* HW related state used primarily by BMAC */
@@ -587,9 +587,10 @@ struct wlc_info {
 	u8 mpc_delay_off;	/* delay radio disable by # of watchdog cnt */
 	u8 prev_non_delay_mpc;	/* prev state wlc_is_non_delay_mpc */
 
-	/* timer */
-	struct wl_timer *wdtimer;	/* timer for watchdog routine */
-	struct wl_timer *radio_timer;	/* timer for hw radio button monitor routine */
+	/* timer for watchdog routine */
+	struct brcms_timer *wdtimer;
+	/* timer for hw radio button monitor routine */
+	struct brcms_timer *radio_timer;
 
 	/* promiscuous */
 	bool monitor;		/* monitor (MPDU sniffing) mode */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
index 6689691..ba5d67e 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
@@ -83,39 +83,40 @@ struct wlapi_timer *wlapi_init_timer(wlc_phy_shim_info_t *physhim,
 				     void (*fn) (void *arg), void *arg,
 				     const char *name)
 {
-	return (struct wlapi_timer *)wl_init_timer(physhim->wl, fn, arg, name);
+	return (struct wlapi_timer *)
+			brcms_init_timer(physhim->wl, fn, arg, name);
 }
 
 void wlapi_free_timer(wlc_phy_shim_info_t *physhim, struct wlapi_timer *t)
 {
-	wl_free_timer(physhim->wl, (struct wl_timer *)t);
+	brcms_free_timer(physhim->wl, (struct brcms_timer *)t);
 }
 
 void
 wlapi_add_timer(wlc_phy_shim_info_t *physhim, struct wlapi_timer *t, uint ms,
 		int periodic)
 {
-	wl_add_timer(physhim->wl, (struct wl_timer *)t, ms, periodic);
+	brcms_add_timer(physhim->wl, (struct brcms_timer *)t, ms, periodic);
 }
 
 bool wlapi_del_timer(wlc_phy_shim_info_t *physhim, struct wlapi_timer *t)
 {
-	return wl_del_timer(physhim->wl, (struct wl_timer *)t);
+	return brcms_del_timer(physhim->wl, (struct brcms_timer *)t);
 }
 
 void wlapi_intrson(wlc_phy_shim_info_t *physhim)
 {
-	wl_intrson(physhim->wl);
+	brcms_intrson(physhim->wl);
 }
 
 u32 wlapi_intrsoff(wlc_phy_shim_info_t *physhim)
 {
-	return wl_intrsoff(physhim->wl);
+	return brcms_intrsoff(physhim->wl);
 }
 
 void wlapi_intrsrestore(wlc_phy_shim_info_t *physhim, u32 macintmask)
 {
-	wl_intrsrestore(physhim->wl, macintmask);
+	brcms_intrsrestore(physhim->wl, macintmask);
 }
 
 void wlapi_bmac_write_shm(wlc_phy_shim_info_t *physhim, uint offset, u16 v)
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index 77b0738..4f0fa20 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -343,7 +343,7 @@ typedef struct wl_rxsts {
 	uint preamble;		/* Unknown, short, long */
 	uint encoding;		/* Unknown, CCK, PBCC, OFDM */
 	uint nfrmtype;		/* special 802.11n frames(AMPDU, AMSDU) */
-	struct wl_if *wlif;	/* wl interface */
+	struct brcms_if *wlif;	/* wl interface */
 } wl_rxsts_t;
 
 /* status per error RX pkt */
@@ -591,9 +591,9 @@ typedef struct {
 } wlc_antselcfg_t;
 
 /* common functions for every port */
-extern void *wlc_attach(struct wl_info *wl, u16 vendor, u16 device, uint unit,
-			bool piomode, void *regsva, uint bustype, void *btparam,
-			uint *perr);
+extern void *wlc_attach(struct brcms_info *wl, u16 vendor, u16 device,
+			uint unit, bool piomode, void *regsva, uint bustype,
+			void *btparam, uint *perr);
 extern uint wlc_detach(struct wlc_info *wlc);
 extern int wlc_up(struct wlc_info *wlc);
 extern uint wlc_down(struct wlc_info *wlc);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_types.h b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
index 5cca063..775d013 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_types.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
@@ -35,11 +35,11 @@
 
 /* forward declarations */
 struct sk_buff;
-struct wl_info;
+struct brcms_info;
 struct wlc_info;
 struct wlc_hw_info;
 struct wlc_if;
-struct wl_if;
+struct brcms_if;
 struct ampdu_info;
 struct antsel_info;
 struct bmac_pmq;
diff --git a/drivers/staging/brcm80211/include/bcmdefs.h b/drivers/staging/brcm80211/include/bcmdefs.h
index 304d8ed..8cb66c2 100644
--- a/drivers/staging/brcm80211/include/bcmdefs.h
+++ b/drivers/staging/brcm80211/include/bcmdefs.h
@@ -88,8 +88,8 @@ typedef struct wl_rateset {
 #define PM_MAX	1
 
 /* Message levels */
-#define WL_ERROR_VAL		0x00000001
-#define WL_TRACE_VAL		0x00000002
+#define LOG_ERROR_VAL		0x00000001
+#define LOG_TRACE_VAL		0x00000002
 
 #define PM_OFF	0
 #define PM_MAX	1
-- 
1.7.4.1


