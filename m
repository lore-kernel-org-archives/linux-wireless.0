Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2064 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757953Ab1F2Xss (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:48 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 106/119] staging: brcm80211: removed last typedefs from
 fullmac
Date: Wed, 29 Jun 2011 16:48:10 -0700
Message-ID: <1309391303-22741-107-git-send-email-frankyl@broadcom.com> (sfid-20110630_015027_823623_5F7EEE61)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h     |   12 ++--
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |   14 +++--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd.h          |   22 ++++----
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |   12 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |    7 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |   20 ++++---
 drivers/staging/brcm80211/brcmfmac/dngl_stats.h   |    4 +-
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |   18 +++---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |   65 +++++++++++----------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h  |    7 +-
 11 files changed, 97 insertions(+), 86 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
index 3dff170..3a09aa3 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
@@ -92,14 +92,11 @@ struct brcmf_sdreg {
 	int value;
 };
 
-/* callback function, taking one arg */
-typedef void (*sdioh_cb_fn_t) (void *);
-
 struct sdioh_info {
 	struct osl_info *osh;		/* osh handler */
 	bool client_intr_enabled;	/* interrupt connnected flag */
 	bool intr_handler_valid;	/* client driver interrupt handler valid */
-	sdioh_cb_fn_t intr_handler;	/* registered interrupt handler */
+	void (*intr_handler)(void *);	/* registered interrupt handler */
 	void *intr_handler_arg;	/* argument to call interrupt handler */
 	u16 intmask;		/* Current active interrupts */
 	void *sdos_info;	/* Pointer to per-OS private data */
@@ -149,8 +146,11 @@ extern void brcmf_sdioh_free_irq(uint irq, struct sdioh_info *sd);
  */
 extern struct sdioh_info *brcmf_sdioh_attach(void *cfghdl, uint irq);
 extern int brcmf_sdioh_detach(struct sdioh_info *si);
-extern int brcmf_sdioh_interrupt_register(struct sdioh_info *si,
-					     sdioh_cb_fn_t fn, void *argh);
+
+extern int
+brcmf_sdioh_interrupt_register(struct sdioh_info *si,
+			       void (*sdioh_cb_fn)(void *), void *argh);
+
 extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *si);
 
 /* query whether SD interrupt is enabled or not */
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index fd36679..ae83403 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -145,8 +145,7 @@ int brcmf_sdcard_intr_disable(struct brcmf_sdio_card *card)
 }
 
 int brcmf_sdcard_intr_reg(struct brcmf_sdio_card *card,
-			  brcmf_sdiocard_cb_fn_t fn,
-			  void *argh)
+			  void (*fn)(void *), void *argh)
 {
 	ASSERT(card);
 
@@ -161,8 +160,7 @@ int brcmf_sdcard_intr_dereg(struct brcmf_sdio_card *card)
 }
 
 int brcmf_sdcard_devremove_reg(struct brcmf_sdio_card *card,
-			       brcmf_sdiocard_cb_fn_t fn,
-			       void *argh)
+			       void (*fn)(void *), void *argh)
 {
 	ASSERT(card);
 
@@ -443,7 +441,9 @@ int
 brcmf_sdcard_recv_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
 		      uint flags,
 		      u8 *buf, uint nbytes, struct sk_buff *pkt,
-		      brcmf_sdio_cmplt_fn_t complete, void *handle)
+		      void (*complete)(void *handle, int status,
+				       bool sync_waiting),
+		      void *handle)
 {
 	int status;
 	uint incr_fix;
@@ -486,7 +486,9 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
 int
 brcmf_sdcard_send_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
 		      uint flags, u8 *buf, uint nbytes, void *pkt,
-		      brcmf_sdio_cmplt_fn_t complete, void *handle)
+		      void (*complete)(void *handle, int status,
+				       bool sync_waiting),
+		      void *handle)
 {
 	uint incr_fix;
 	uint width;
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 4f4ec47..2be9b08 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -188,7 +188,7 @@ extern int brcmf_sdioh_detach(struct sdioh_info *sd)
 
 /* Configure callback to client when we receive client interrupt */
 extern int
-brcmf_sdioh_interrupt_register(struct sdioh_info *sd, sdioh_cb_fn_t fn,
+brcmf_sdioh_interrupt_register(struct sdioh_info *sd, void (*fn)(void *),
 			       void *argh)
 {
 	sd_trace(("%s: Entering\n", __func__));
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index f76a3dd..a67d1ed 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -135,7 +135,7 @@
 #define BRCMF_EVENT_MSG_FLUSHTXQ	0x02
 #define BRCMF_EVENT_MSG_GROUP		0x04
 
-typedef struct brcmf_event_msg {
+struct brcmf_event_msg {
 	u16 version;
 	u16 flags;
 	u32 event_type;
@@ -145,7 +145,7 @@ typedef struct brcmf_event_msg {
 	u32 datalen;
 	u8 addr[ETH_ALEN];
 	char ifname[IFNAMSIZ];
-} __packed brcmf_event_msg_t;
+} __packed;
 
 struct brcm_ethhdr {
 	u16 subtype;
@@ -155,11 +155,11 @@ struct brcm_ethhdr {
 	u16 usr_subtype;
 } __packed;
 
-typedef struct brcmf_event {
+struct brcmf_event {
 	struct ethhdr eth;
 	struct brcm_ethhdr hdr;
 	struct brcmf_event_msg msg;
-} __packed brcmf_event_t;
+} __packed;
 
 #define BRCMF_E_SET_SSID			0
 #define BRCMF_E_JOIN				1
@@ -547,7 +547,7 @@ struct brcmf_pub {
 	bool iswl;		/* Dongle-resident driver is wl */
 	unsigned long drv_version;	/* Version of dongle-resident driver */
 	u8 mac[ETH_ALEN];			/* MAC address obtained from dongle */
-	dngl_stats_t dstats;		/* Stats for dongle-based data */
+	struct dngl_stats dstats;	/* Stats for dongle-based data */
 
 	/* Additional stats for the bus level */
 	unsigned long tx_packets;	/* Data packets sent to dongle */
@@ -609,10 +609,10 @@ struct brcmf_timeout {
 	u32 tick;		/* O/S tick time (usec) */
 };
 
-typedef struct {
+struct bcmevent_name {
 	uint event;
 	const char *name;
-} bcmevent_name_t;
+};
 
 #if defined(CONFIG_PM_SLEEP)
 extern atomic_t brcmf_mmc_suspend;
@@ -704,7 +704,7 @@ extern uint brcmf_pktgen_len;
 #endif
 
 extern u32 g_assert_type;
-extern const bcmevent_name_t bcmevent_names[];
+extern const struct bcmevent_name bcmevent_names[];
 extern const int bcmevent_names_size;
 
 
@@ -808,7 +808,7 @@ extern int brcmf_timeout_expired(struct brcmf_timeout *tmo);
 
 extern int brcmf_ifname2idx(struct brcmf_info *drvr_priv, char *name);
 extern int brcmf_c_host_event(struct brcmf_info *drvr_priv, int *idx,
-			      void *pktdata, brcmf_event_msg_t *,
+			      void *pktdata, struct brcmf_event_msg *,
 			      void **data_ptr);
 
 extern void brcmf_c_init(void);
@@ -885,7 +885,7 @@ struct brcmf_c_ioctl {
 
 #ifdef SDTEST
 /* For pktgen iovar */
-typedef struct brcmf_pktgen {
+struct brcmf_pktgen {
 	uint version;		/* To allow structure change tracking */
 	uint freq;		/* Max ticks between tx/rx attempts */
 	uint count;		/* Test packets to send/rcv each attempt */
@@ -898,7 +898,7 @@ typedef struct brcmf_pktgen {
 	uint numfail;		/* Count of test send failures */
 	uint mode;		/* Test mode (type of test packets) */
 	uint stop;		/* Stop after this many tx failures */
-} brcmf_pktgen_t;
+};
 
 /* Version in case structure changes */
 #define BRCMF_PKTGEN_VERSION	2
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 14dc98d..ddc2085 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -449,7 +449,8 @@ int brcmf_c_ioctl(struct brcmf_pub *drvr, struct brcmf_c_ioctl *ioc, void *buf,
 }
 
 #ifdef SHOW_EVENTS
-static void brcmf_c_show_host_event(brcmf_event_msg_t *event, void *event_data)
+static void
+brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 {
 	uint i, status, reason;
 	bool group = false, flush_txq = false, link = false;
@@ -756,10 +757,10 @@ static void brcmf_c_show_host_event(brcmf_event_msg_t *event, void *event_data)
 
 int
 brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
-	      brcmf_event_msg_t *event, void **data_ptr)
+		   struct brcmf_event_msg *event, void **data_ptr)
 {
 	/* check whether packet is a BRCM event pkt */
-	brcmf_event_t *pvt_data = (brcmf_event_t *) pktdata;
+	struct brcmf_event *pvt_data = (struct brcmf_event *) pktdata;
 	char *event_data;
 	u32 type, status;
 	u16 flags;
@@ -781,12 +782,13 @@ brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 	event_data = *data_ptr;
 
 	/* memcpy since BRCM event pkt may be unaligned. */
-	memcpy(event, &pvt_data->msg, sizeof(brcmf_event_msg_t));
+	memcpy(event, &pvt_data->msg, sizeof(struct brcmf_event_msg));
 
 	type = get_unaligned_be32(&event->event_type);
 	flags = get_unaligned_be16(&event->flags);
 	status = get_unaligned_be32(&event->status);
-	evlen = get_unaligned_be32(&event->datalen) + sizeof(brcmf_event_t);
+	evlen = get_unaligned_be32(&event->datalen) +
+		sizeof(struct brcmf_event);
 
 	switch (type) {
 	case BRCMF_E_IF:
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index aa2f81f..fc9abba 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -185,7 +185,8 @@ module_param(brcmf_pktgen_len, uint, 0);
 static int brcmf_toe_get(struct brcmf_info *drvr_priv, int idx, u32 *toe_ol);
 static int brcmf_toe_set(struct brcmf_info *drvr_priv, int idx, u32 toe_ol);
 static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
-			     brcmf_event_msg_t *event_ptr, void **data_ptr);
+			    struct brcmf_event_msg *event_ptr,
+			    void **data_ptr);
 
 static void brcmf_set_packet_filter(int value, struct brcmf_pub *drvr)
 {
@@ -858,7 +859,7 @@ void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx, struct sk_buff *skb,
 	struct sk_buff *pnext, *save_pktbuf;
 	int i;
 	struct brcmf_if *ifp;
-	brcmf_event_msg_t event;
+	struct brcmf_event_msg event;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -1858,7 +1859,7 @@ int brcmf_os_ioctl_resp_wake(struct brcmf_pub *drvr)
 }
 
 static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
-			    brcmf_event_msg_t *event, void **data)
+			    struct brcmf_event_msg *event, void **data)
 {
 	int bcmerror = 0;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index ba3ea59..3cbfacb 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -410,7 +410,7 @@ BRCMF_SPINWAIT_SLEEP_INIT(sdioh_spinwait_sleep);
 #define CORE_BUS_REG(base, field) \
 		(base + offsetof(struct sdpcmd_regs, field))
 #define CORE_SB(base, field) \
-		(base + SBCONFIGOFF + offsetof(sbconfig_t, field))
+		(base + SBCONFIGOFF + offsetof(struct sbconfig, field))
 
 /* core registers */
 struct sdpcmd_regs {
@@ -697,7 +697,7 @@ struct brcmf_bus {
 	u32 fw_ptr;
 };
 
-typedef volatile struct _sbconfig {
+struct sbconfig {
 	u32 PAD[2];
 	u32 sbipsflag;	/* initiator port ocp slave flag */
 	u32 PAD[3];
@@ -735,7 +735,7 @@ typedef volatile struct _sbconfig {
 	u32 PAD[3];
 	u32 sbidlow;		/* identification */
 	u32 sbidhigh;	/* identification */
-} sbconfig_t;
+};
 
 /* clkstate */
 #define CLK_NONE	0
@@ -893,7 +893,9 @@ static void brcmf_sdbrcm_setmemsize(struct brcmf_bus *bus, int mem_size);
 static int brcmf_sdbrcm_send_buf(struct brcmf_bus *bus, u32 addr, uint fn,
 			       uint flags, u8 *buf, uint nbytes,
 			       struct sk_buff *pkt,
-			       brcmf_sdio_cmplt_fn_t complete, void *handle);
+			       void (*complete)(void *handle, int status,
+						      bool sync_waiting),
+			       void *handle);
 
 static bool brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus, void *card);
 static int  _brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus);
@@ -1865,7 +1867,7 @@ const struct brcmu_iovar dhdsdio_iovars[] = {
 #ifdef SDTEST
 	{"extloop", IOV_EXTLOOP, 0, IOVT_BOOL, 0}
 	,
-	{"pktgen", IOV_PKTGEN, 0, IOVT_BUFFER, sizeof(brcmf_pktgen_t)}
+	{"pktgen", IOV_PKTGEN, 0, IOVT_BUFFER, sizeof(struct brcmf_pktgen)}
 	,
 #endif				/* SDTEST */
 
@@ -2001,7 +2003,7 @@ void brcmf_bus_clearcounts(struct brcmf_pub *drvr)
 #ifdef SDTEST
 static int brcmf_sdbrcm_pktgen_get(struct brcmf_bus *bus, u8 *arg)
 {
-	brcmf_pktgen_t pktgen;
+	struct brcmf_pktgen pktgen;
 
 	pktgen.version = BRCMF_PKTGEN_VERSION;
 	pktgen.freq = bus->pktgen_freq;
@@ -2023,7 +2025,7 @@ static int brcmf_sdbrcm_pktgen_get(struct brcmf_bus *bus, u8 *arg)
 
 static int brcmf_sdbrcm_pktgen_set(struct brcmf_bus *bus, u8 *arg)
 {
-	brcmf_pktgen_t pktgen;
+	struct brcmf_pktgen pktgen;
 	uint oldcnt, oldmode;
 
 	memcpy(&pktgen, arg, sizeof(pktgen));
@@ -6035,7 +6037,9 @@ err:
 static int
 brcmf_sdbrcm_send_buf(struct brcmf_bus *bus, u32 addr, uint fn, uint flags,
 		    u8 *buf, uint nbytes, struct sk_buff *pkt,
-		    brcmf_sdio_cmplt_fn_t complete, void *handle)
+		    void (*complete)(void *handle, int status,
+				     bool sync_waiting),
+		    void *handle)
 {
 	return brcmf_sdcard_send_buf
 		(bus->card, addr, fn, flags, buf, nbytes, pkt, complete,
diff --git a/drivers/staging/brcm80211/brcmfmac/dngl_stats.h b/drivers/staging/brcm80211/brcmfmac/dngl_stats.h
index 699cbff..53a50f6 100644
--- a/drivers/staging/brcm80211/brcmfmac/dngl_stats.h
+++ b/drivers/staging/brcm80211/brcmfmac/dngl_stats.h
@@ -17,7 +17,7 @@
 #ifndef _dngl_stats_h_
 #define _dngl_stats_h_
 
-typedef struct {
+struct dngl_stats {
 	unsigned long rx_packets;	/* total packets received */
 	unsigned long tx_packets;	/* total packets transmitted */
 	unsigned long rx_bytes;	/* total bytes received */
@@ -27,6 +27,6 @@ typedef struct {
 	unsigned long rx_dropped;	/* packets dropped by dongle */
 	unsigned long tx_dropped;	/* packets dropped by dongle */
 	unsigned long multicast;	/* multicast packets received */
-} dngl_stats_t;
+};
 
 #endif				/* _dngl_stats_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 02c820b..5d2178d 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -43,7 +43,6 @@ extern const uint brcmf_sdio_msglevel;
 
 /* forward declarations */
 struct brcmf_sdio_card;
-typedef void (*brcmf_sdiocard_cb_fn_t) (void *);
 
 /* Attach and build an interface to the underlying SD host driver.
  *  - Allocates resources (structs, arrays, mem, OS handles, etc) needed by
@@ -68,8 +67,8 @@ extern int brcmf_sdcard_intr_disable(struct brcmf_sdio_card *card);
 
 /* Register/deregister device interrupt handler. */
 extern int
-brcmf_sdcard_intr_reg(struct brcmf_sdio_card *card, brcmf_sdiocard_cb_fn_t fn,
-		      void *argh);
+brcmf_sdcard_intr_reg(struct brcmf_sdio_card *card,
+		      void (*fn)(void *), void *argh);
 
 extern int brcmf_sdcard_intr_dereg(struct brcmf_sdio_card *card);
 
@@ -78,8 +77,7 @@ extern int brcmf_sdcard_intr_dereg(struct brcmf_sdio_card *card);
  */
 extern int
 brcmf_sdcard_devremove_reg(struct brcmf_sdio_card *card,
-			   brcmf_sdiocard_cb_fn_t fn,
-			   void *argh);
+			   void (*fn)(void *), void *argh);
 
 /* Access SDIO address space (e.g. CCCR) using CMD52 (single-byte interface).
  *   fn:   function number
@@ -138,16 +136,18 @@ extern bool brcmf_sdcard_regfail(struct brcmf_sdio_card *card);
  * Returns 0 or error code.
  * NOTE: Async operation is not currently supported.
  */
-typedef void (*brcmf_sdio_cmplt_fn_t)
-		(void *handle, int status, bool sync_waiting);
 extern int
 brcmf_sdcard_send_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
 		      uint flags, u8 *buf, uint nbytes, void *pkt,
-		      brcmf_sdio_cmplt_fn_t complete, void *handle);
+		      void (*complete)(void *handle, int status,
+				       bool sync_waiting),
+		      void *handle);
 extern int
 brcmf_sdcard_recv_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
 		      uint flags, u8 *buf, uint nbytes, struct sk_buff *pkt,
-		      brcmf_sdio_cmplt_fn_t complete, void *handle);
+		      void (*complete)(void *handle, int status,
+				       bool sync_waiting),
+		      void *handle);
 
 /* Flags bits */
 #define SDIO_REQ_4BYTE	0x1	/* Four-byte target (backplane) width (vs. two-byte) */
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index b0ac780..85ff00b 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -117,24 +117,24 @@ static void brcmf_init_eq_lock(struct wl_priv *wl);
 static void brcmf_init_eloop_handler(struct wl_event_loop *el);
 static struct wl_event_q *brcmf_deq_event(struct wl_priv *wl);
 static s32 brcmf_enq_event(struct wl_priv *wl, u32 type,
-			  const brcmf_event_msg_t *msg, void *data);
+			   const struct brcmf_event_msg *msg, void *data);
 static void brcmf_put_event(struct wl_event_q *e);
 static void brcmf_wakeup_event(struct wl_priv *wl);
-static s32 brcmf_notify_connect_status(struct wl_priv *wl,
-				      struct net_device *ndev,
-				      const brcmf_event_msg_t *e, void *data);
-static s32 brcmf_notify_roaming_status(struct wl_priv *wl,
-				      struct net_device *ndev,
-				      const brcmf_event_msg_t *e, void *data);
+static s32 brcmf_notify_connect_status(struct wl_priv *wl, struct net_device *ndev,
+				       const struct brcmf_event_msg *e,
+				       void *data);
+static s32 brcmf_notify_roaming_status(struct wl_priv *wl, struct net_device *ndev,
+				    const struct brcmf_event_msg *e,
+				    void *data);
 static s32 brcmf_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
-				   const brcmf_event_msg_t *e, void *data);
+				    const struct brcmf_event_msg *e, void *data);
 static s32 brcmf_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
-				 const brcmf_event_msg_t *e, void *data,
-				bool completed);
+				  const struct brcmf_event_msg *e, void *data,
+				  bool completed);
 static s32 brcmf_bss_roaming_done(struct wl_priv *wl, struct net_device *ndev,
-				 const brcmf_event_msg_t *e, void *data);
+				  const struct brcmf_event_msg *e, void *data);
 static s32 brcmf_notify_mic_status(struct wl_priv *wl, struct net_device *ndev,
-				  const brcmf_event_msg_t *e, void *data);
+				   const struct brcmf_event_msg *e, void *data);
 
 /*
 ** register/deregister sdio function
@@ -165,8 +165,8 @@ static s32 brcmf_set_retry(struct net_device *dev, u32 retry, bool l);
 /*
 ** wl profile utilities
 */
-static s32 brcmf_update_prof(struct wl_priv *wl, const brcmf_event_msg_t *e,
-			    void *data, s32 item);
+static s32 brcmf_update_prof(struct wl_priv *wl, const struct brcmf_event_msg *e,
+			     void *data, s32 item);
 static void *brcmf_read_prof(struct wl_priv *wl, s32 item);
 static void brcmf_init_prof(struct wl_profile *prof);
 
@@ -231,9 +231,10 @@ static bool brcmf_is_ibssmode(struct wl_priv *wl);
 /*
 ** dongle up/down , default configuration utilities
 */
-static bool brcmf_is_linkdown(struct wl_priv *wl, const brcmf_event_msg_t *e);
-static bool brcmf_is_linkup(struct wl_priv *wl, const brcmf_event_msg_t *e);
-static bool brcmf_is_nonetwork(struct wl_priv *wl, const brcmf_event_msg_t *e);
+static bool brcmf_is_linkdown(struct wl_priv *wl, const struct brcmf_event_msg *e);
+static bool brcmf_is_linkup(struct wl_priv *wl, const struct brcmf_event_msg *e);
+static bool brcmf_is_nonetwork(struct wl_priv *wl,
+			       const struct brcmf_event_msg *e);
 static void brcmf_link_down(struct wl_priv *wl);
 static s32 brcmf_dongle_mode(struct net_device *ndev, s32 iftype);
 static s32 __brcmf_cfg80211_up(struct wl_priv *wl);
@@ -2536,7 +2537,7 @@ CleanUp:
 	return err;
 }
 
-static bool brcmf_is_linkup(struct wl_priv *wl, const brcmf_event_msg_t *e)
+static bool brcmf_is_linkup(struct wl_priv *wl, const struct brcmf_event_msg *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
 	u32 status = be32_to_cpu(e->status);
@@ -2550,7 +2551,7 @@ static bool brcmf_is_linkup(struct wl_priv *wl, const brcmf_event_msg_t *e)
 	return false;
 }
 
-static bool brcmf_is_linkdown(struct wl_priv *wl, const brcmf_event_msg_t *e)
+static bool brcmf_is_linkdown(struct wl_priv *wl, const struct brcmf_event_msg *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
 	u16 flags = be16_to_cpu(e->flags);
@@ -2562,7 +2563,7 @@ static bool brcmf_is_linkdown(struct wl_priv *wl, const brcmf_event_msg_t *e)
 	return false;
 }
 
-static bool brcmf_is_nonetwork(struct wl_priv *wl, const brcmf_event_msg_t *e)
+static bool brcmf_is_nonetwork(struct wl_priv *wl, const struct brcmf_event_msg *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
 	u32 status = be32_to_cpu(e->status);
@@ -2584,7 +2585,7 @@ static bool brcmf_is_nonetwork(struct wl_priv *wl, const brcmf_event_msg_t *e)
 
 static s32
 brcmf_notify_connect_status(struct wl_priv *wl, struct net_device *ndev,
-			 const brcmf_event_msg_t *e, void *data)
+			    const struct brcmf_event_msg *e, void *data)
 {
 	s32 err = 0;
 
@@ -2628,7 +2629,7 @@ brcmf_notify_connect_status(struct wl_priv *wl, struct net_device *ndev,
 
 static s32
 brcmf_notify_roaming_status(struct wl_priv *wl, struct net_device *ndev,
-			 const brcmf_event_msg_t *e, void *data)
+			    const struct brcmf_event_msg *e, void *data)
 {
 	s32 err = 0;
 	u32 event = be32_to_cpu(e->event_type);
@@ -2840,7 +2841,7 @@ update_bss_info_out:
 
 static s32
 brcmf_bss_roaming_done(struct wl_priv *wl, struct net_device *ndev,
-		    const brcmf_event_msg_t *e, void *data)
+		       const struct brcmf_event_msg *e, void *data)
 {
 	struct wl_connect_info *conn_info = wl_to_conn(wl);
 	s32 err = 0;
@@ -2864,7 +2865,7 @@ brcmf_bss_roaming_done(struct wl_priv *wl, struct net_device *ndev,
 
 static s32
 brcmf_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
-		    const brcmf_event_msg_t *e, void *data, bool completed)
+		       const struct brcmf_event_msg *e, void *data, bool completed)
 {
 	struct wl_connect_info *conn_info = wl_to_conn(wl);
 	s32 err = 0;
@@ -2896,7 +2897,7 @@ brcmf_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
 
 static s32
 brcmf_notify_mic_status(struct wl_priv *wl, struct net_device *ndev,
-		     const brcmf_event_msg_t *e, void *data)
+			const struct brcmf_event_msg *e, void *data)
 {
 	u16 flags = be16_to_cpu(e->flags);
 	enum nl80211_key_type key_type;
@@ -2916,7 +2917,7 @@ brcmf_notify_mic_status(struct wl_priv *wl, struct net_device *ndev,
 
 static s32
 brcmf_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
-		      const brcmf_event_msg_t *e, void *data)
+			 const struct brcmf_event_msg *e, void *data)
 {
 	struct brcmf_channel_info channel_inform;
 	struct brcmf_scan_results *bss_list;
@@ -3484,7 +3485,7 @@ static s32 brcmf_event_handler(void *data)
 
 void
 wl_cfg80211_event(struct net_device *ndev,
-		  const brcmf_event_msg_t *e, void *data)
+		  const struct brcmf_event_msg *e, void *data)
 {
 	u32 event_type = be32_to_cpu(e->event_type);
 	struct wl_priv *wl = ndev_to_wl(ndev);
@@ -3535,8 +3536,8 @@ static struct wl_event_q *brcmf_deq_event(struct wl_priv *wl)
 */
 
 static s32
-brcmf_enq_event(struct wl_priv *wl, u32 event, const brcmf_event_msg_t *msg,
-	     void *data)
+brcmf_enq_event(struct wl_priv *wl, u32 event, const struct brcmf_event_msg *msg,
+		void *data)
 {
 	struct wl_event_q *e;
 	s32 err = 0;
@@ -3548,7 +3549,7 @@ brcmf_enq_event(struct wl_priv *wl, u32 event, const brcmf_event_msg_t *msg,
 	}
 
 	e->etype = event;
-	memcpy(&e->emsg, msg, sizeof(brcmf_event_msg_t));
+	memcpy(&e->emsg, msg, sizeof(struct brcmf_event_msg));
 	if (data) {
 	}
 	brcmf_lock_eq(wl);
@@ -3927,8 +3928,8 @@ static void *brcmf_read_prof(struct wl_priv *wl, s32 item)
 }
 
 static s32
-brcmf_update_prof(struct wl_priv *wl, const brcmf_event_msg_t *e, void *data,
-	       s32 item)
+brcmf_update_prof(struct wl_priv *wl, const struct brcmf_event_msg *e, void *data,
+		  s32 item)
 {
 	s32 err = 0;
 	struct brcmf_ssid *ssid;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index e6df203..af62cee 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -183,7 +183,8 @@ struct wl_conf {
 struct wl_event_loop {
 	s32(*handler[BRCMF_E_LAST]) (struct wl_priv *wl,
 				     struct net_device *ndev,
-				     const brcmf_event_msg_t *e, void *data);
+				     const struct brcmf_event_msg *e,
+				     void *data);
 };
 
 /* representing interface of cfg80211 plane */
@@ -219,7 +220,7 @@ struct wl_ie {
 struct wl_event_q {
 	struct list_head eq_list;
 	u32 etype;
-	brcmf_event_msg_t emsg;
+	struct brcmf_event_msg emsg;
 	s8 edata[1];
 };
 
@@ -370,7 +371,7 @@ extern s32 wl_cfg80211_attach(struct net_device *ndev, void *data);
 extern void wl_cfg80211_detach(void);
 /* event handler from dongle */
 extern void wl_cfg80211_event(struct net_device *ndev,
-			      const brcmf_event_msg_t *e, void *data);
+			      const struct brcmf_event_msg *e, void *data);
 extern void wl_cfg80211_sdio_func(void *func);	/* set sdio function info */
 extern struct sdio_func *wl_cfg80211_get_sdio_func(void);	/* set sdio function info */
 extern s32 wl_cfg80211_up(void);	/* dongle up */
-- 
1.7.1


