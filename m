Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4837 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759577Ab1KWBWP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 20:22:15 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 15/24] brcm80211: fmac: rename structure brcmf_bus to
 brcmf_sdio
Date: Tue, 22 Nov 2011 17:21:50 -0800
Message-ID: <1322011319-24863-16-git-send-email-frankyl@broadcom.com> (sfid-20111123_022235_862971_9AF91F05)
In-Reply-To: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
References: <1322011319-24863-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename sdio bus structure brcmf_bus to brcmf_sdio for preparation
of USB bus support. This patch is part of the fullmac bus interface
refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   12 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  120 ++++++++++----------
 4 files changed, 70 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 046a9e4..451b34b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -572,7 +572,7 @@ struct brcmf_dcmd {
 };
 
 /* Forward decls for struct brcmf_pub (see below) */
-struct brcmf_bus;		/* device bus info */
+struct brcmf_sdio;		/* device bus info */
 struct brcmf_proto;	/* device communication protocol info */
 struct brcmf_info;	/* device driver info */
 struct brcmf_cfg80211_dev; /* cfg80211 device info */
@@ -580,7 +580,7 @@ struct brcmf_cfg80211_dev; /* cfg80211 device info */
 /* Common structure for module and instance linkage */
 struct brcmf_pub {
 	/* Linkage ponters */
-	struct brcmf_bus *bus;
+	struct brcmf_sdio *bus;
 	struct brcmf_proto *prot;
 	struct brcmf_info *info;
 	struct brcmf_cfg80211_dev *config;
@@ -681,7 +681,7 @@ extern uint brcmf_c_mkiovar(char *name, char *data, uint datalen,
  * Returned structure should have bus and prot pointers filled in.
  * bus_hdrlen specifies required headroom for bus module header.
  */
-extern struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus,
+extern struct brcmf_pub *brcmf_attach(struct brcmf_sdio *bus,
 				      uint bus_hdrlen);
 extern int brcmf_net_attach(struct brcmf_pub *drvr, int idx);
 extern int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 118216b..81fc1db 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -28,26 +28,26 @@
  */
 
 /* obtain linux device object providing bus function */
-extern struct device *brcmf_bus_get_device(struct brcmf_bus *bus);
+extern struct device *brcmf_bus_get_device(struct brcmf_sdio *bus);
 
 /* Stop bus module: clear pending frames, disable data flow */
-extern void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus);
+extern void brcmf_sdbrcm_bus_stop(struct brcmf_sdio *bus);
 
 /* Initialize bus module: prepare for communication w/dongle */
 extern int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr);
 
 /* Send a data frame to the dongle.  Callee disposes of txp. */
-extern int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *txp);
+extern int brcmf_sdbrcm_bus_txdata(struct brcmf_sdio *bus, struct sk_buff *txp);
 
 /* Send/receive a control message to/from the dongle.
  * Expects caller to enforce a single outstanding transaction.
  */
 extern int
-brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen);
+brcmf_sdbrcm_bus_txctl(struct brcmf_sdio *bus, unsigned char *msg, uint msglen);
 
 extern int
-brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen);
+brcmf_sdbrcm_bus_rxctl(struct brcmf_sdio *bus, unsigned char *msg, uint msglen);
 
-extern void brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick);
+extern void brcmf_sdbrcm_wd_timer(struct brcmf_sdio *bus, uint wdtick);
 
 #endif				/* _BRCMF_BUS_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 683a7ed..e8f7f78 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -940,7 +940,7 @@ void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 	}
 }
 
-struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
+struct brcmf_pub *brcmf_attach(struct brcmf_sdio *bus, uint bus_hdrlen)
 {
 	struct brcmf_info *drvr_priv = NULL;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index f01da6a..9ab906a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -449,7 +449,7 @@ struct sdpcm_shared_le {
 
 /* misc chip info needed by some of the routines */
 /* Private data for SDIO bus interaction */
-struct brcmf_bus {
+struct brcmf_sdio {
 	struct brcmf_pub *drvr;
 
 	struct brcmf_sdio_dev *sdiodev;	/* sdio device handler */
@@ -604,7 +604,7 @@ static void pkt_align(struct sk_buff *p, int len, int align)
 }
 
 /* To check if there's window offered */
-static bool data_ok(struct brcmf_bus *bus)
+static bool data_ok(struct brcmf_sdio *bus)
 {
 	return (u8)(bus->tx_max - bus->tx_seq) != 0 &&
 	       ((u8)(bus->tx_max - bus->tx_seq) & 0x80) == 0;
@@ -615,7 +615,7 @@ static bool data_ok(struct brcmf_bus *bus)
  * adresses on the 32 bit backplane bus.
  */
 static void
-r_sdreg32(struct brcmf_bus *bus, u32 *regvar, u32 reg_offset, u32 *retryvar)
+r_sdreg32(struct brcmf_sdio *bus, u32 *regvar, u32 reg_offset, u32 *retryvar)
 {
 	u8 idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
 	*retryvar = 0;
@@ -635,7 +635,7 @@ r_sdreg32(struct brcmf_bus *bus, u32 *regvar, u32 reg_offset, u32 *retryvar)
 }
 
 static void
-w_sdreg32(struct brcmf_bus *bus, u32 regval, u32 reg_offset, u32 *retryvar)
+w_sdreg32(struct brcmf_sdio *bus, u32 regval, u32 reg_offset, u32 *retryvar)
 {
 	u8 idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
 	*retryvar = 0;
@@ -660,14 +660,14 @@ w_sdreg32(struct brcmf_bus *bus, u32 regval, u32 reg_offset, u32 *retryvar)
 /* Packet free applicable unconditionally for sdio and sdspi.
  * Conditional if bufpool was present for gspi bus.
  */
-static void brcmf_sdbrcm_pktfree2(struct brcmf_bus *bus, struct sk_buff *pkt)
+static void brcmf_sdbrcm_pktfree2(struct brcmf_sdio *bus, struct sk_buff *pkt)
 {
 	if (bus->usebufpool)
 		brcmu_pkt_buf_free_skb(pkt);
 }
 
 /* Turn backplane clock on or off */
-static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
+static int brcmf_sdbrcm_htclk(struct brcmf_sdio *bus, bool on, bool pendok)
 {
 	int err;
 	u8 clkctl, clkreq, devctl;
@@ -788,7 +788,7 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 }
 
 /* Change idle/active SD state */
-static int brcmf_sdbrcm_sdclk(struct brcmf_bus *bus, bool on)
+static int brcmf_sdbrcm_sdclk(struct brcmf_sdio *bus, bool on)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -801,7 +801,7 @@ static int brcmf_sdbrcm_sdclk(struct brcmf_bus *bus, bool on)
 }
 
 /* Transition SD and backplane clock readiness */
-static int brcmf_sdbrcm_clkctl(struct brcmf_bus *bus, uint target, bool pendok)
+static int brcmf_sdbrcm_clkctl(struct brcmf_sdio *bus, uint target, bool pendok)
 {
 #ifdef BCMDBG
 	uint oldstate = bus->clkstate;
@@ -857,7 +857,7 @@ static int brcmf_sdbrcm_clkctl(struct brcmf_bus *bus, uint target, bool pendok)
 	return 0;
 }
 
-static int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
+static int brcmf_sdbrcm_bussleep(struct brcmf_sdio *bus, bool sleep)
 {
 	uint retries = 0;
 
@@ -929,13 +929,13 @@ static int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 	return 0;
 }
 
-static void bus_wake(struct brcmf_bus *bus)
+static void bus_wake(struct brcmf_sdio *bus)
 {
 	if (bus->sleeping)
 		brcmf_sdbrcm_bussleep(bus, false);
 }
 
-static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
+static u32 brcmf_sdbrcm_hostmail(struct brcmf_sdio *bus)
 {
 	u32 intstatus = 0;
 	u32 hmb_data;
@@ -1011,7 +1011,7 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 	return intstatus;
 }
 
-static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
+static void brcmf_sdbrcm_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 {
 	uint retries = 0;
 	u16 lastrbc;
@@ -1072,7 +1072,7 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
 }
 
 /* copy a buffer into a pkt buffer chain */
-static uint brcmf_sdbrcm_glom_from_buf(struct brcmf_bus *bus, uint len)
+static uint brcmf_sdbrcm_glom_from_buf(struct brcmf_sdio *bus, uint len)
 {
 	uint n, ret = 0;
 	struct sk_buff *p;
@@ -1095,7 +1095,7 @@ static uint brcmf_sdbrcm_glom_from_buf(struct brcmf_bus *bus, uint len)
 }
 
 /* return total length of buffer chain */
-static uint brcmf_sdbrcm_glom_len(struct brcmf_bus *bus)
+static uint brcmf_sdbrcm_glom_len(struct brcmf_sdio *bus)
 {
 	struct sk_buff *p;
 	uint total;
@@ -1106,7 +1106,7 @@ static uint brcmf_sdbrcm_glom_len(struct brcmf_bus *bus)
 	return total;
 }
 
-static void brcmf_sdbrcm_free_glom(struct brcmf_bus *bus)
+static void brcmf_sdbrcm_free_glom(struct brcmf_sdio *bus)
 {
 	struct sk_buff *cur, *next;
 
@@ -1116,7 +1116,7 @@ static void brcmf_sdbrcm_free_glom(struct brcmf_bus *bus)
 	}
 }
 
-static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
+static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 {
 	u16 dlen, totlen;
 	u8 *dptr, num = 0;
@@ -1471,7 +1471,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 	return num;
 }
 
-static int brcmf_sdbrcm_dcmd_resp_wait(struct brcmf_bus *bus, uint *condition,
+static int brcmf_sdbrcm_dcmd_resp_wait(struct brcmf_sdio *bus, uint *condition,
 					bool *pending)
 {
 	DECLARE_WAITQUEUE(wait, current);
@@ -1493,7 +1493,7 @@ static int brcmf_sdbrcm_dcmd_resp_wait(struct brcmf_bus *bus, uint *condition,
 	return timeout;
 }
 
-static int brcmf_sdbrcm_dcmd_resp_wake(struct brcmf_bus *bus)
+static int brcmf_sdbrcm_dcmd_resp_wake(struct brcmf_sdio *bus)
 {
 	if (waitqueue_active(&bus->dcmd_resp_wait))
 		wake_up_interruptible(&bus->dcmd_resp_wait);
@@ -1501,7 +1501,7 @@ static int brcmf_sdbrcm_dcmd_resp_wake(struct brcmf_bus *bus)
 	return 0;
 }
 static void
-brcmf_sdbrcm_read_control(struct brcmf_bus *bus, u8 *hdr, uint len, uint doff)
+brcmf_sdbrcm_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 {
 	uint rdlen, pad;
 
@@ -1590,7 +1590,7 @@ done:
 }
 
 /* Pad read to blocksize for efficiency */
-static void brcmf_pad(struct brcmf_bus *bus, u16 *pad, u16 *rdlen)
+static void brcmf_pad(struct brcmf_sdio *bus, u16 *pad, u16 *rdlen)
 {
 	if (bus->roundup && bus->blocksize && *rdlen > bus->blocksize) {
 		*pad = bus->blocksize - (*rdlen % bus->blocksize);
@@ -1603,7 +1603,7 @@ static void brcmf_pad(struct brcmf_bus *bus, u16 *pad, u16 *rdlen)
 }
 
 static void
-brcmf_alloc_pkt_and_read(struct brcmf_bus *bus, u16 rdlen,
+brcmf_alloc_pkt_and_read(struct brcmf_sdio *bus, u16 rdlen,
 			 struct sk_buff **pkt, u8 **rxbuf)
 {
 	int sdret;		/* Return code from calls */
@@ -1635,7 +1635,7 @@ brcmf_alloc_pkt_and_read(struct brcmf_bus *bus, u16 rdlen,
 
 /* Checks the header */
 static int
-brcmf_check_rxbuf(struct brcmf_bus *bus, struct sk_buff *pkt, u8 *rxbuf,
+brcmf_check_rxbuf(struct brcmf_sdio *bus, struct sk_buff *pkt, u8 *rxbuf,
 		  u8 rxseq, u16 nextlen, u16 *len)
 {
 	u16 check;
@@ -1691,7 +1691,7 @@ fail:
 
 /* Return true if there may be more frames to read */
 static uint
-brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
+brcmf_sdbrcm_readframes(struct brcmf_sdio *bus, uint maxframes, bool *finished)
 {
 	u16 len, check;	/* Extracted hardware header fields */
 	u8 chan, seq, doff;	/* Extracted software header fields */
@@ -2082,7 +2082,7 @@ deliver:
 }
 
 static void
-brcmf_sdbrcm_wait_for_event(struct brcmf_bus *bus, bool *lockvar)
+brcmf_sdbrcm_wait_for_event(struct brcmf_sdio *bus, bool *lockvar)
 {
 	up(&bus->sdsem);
 	wait_event_interruptible_timeout(bus->ctrl_wait,
@@ -2092,7 +2092,7 @@ brcmf_sdbrcm_wait_for_event(struct brcmf_bus *bus, bool *lockvar)
 }
 
 static void
-brcmf_sdbrcm_wait_event_wakeup(struct brcmf_bus *bus)
+brcmf_sdbrcm_wait_event_wakeup(struct brcmf_sdio *bus)
 {
 	if (waitqueue_active(&bus->ctrl_wait))
 		wake_up_interruptible(&bus->ctrl_wait);
@@ -2101,7 +2101,7 @@ brcmf_sdbrcm_wait_event_wakeup(struct brcmf_bus *bus)
 
 /* Writes a HW/SW header into the packet and sends it. */
 /* Assumes: (a) header space already there, (b) caller holds lock */
-static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
+static int brcmf_sdbrcm_txpkt(struct brcmf_sdio *bus, struct sk_buff *pkt,
 			      uint chan, bool free_pkt)
 {
 	int ret;
@@ -2238,7 +2238,7 @@ done:
 	return ret;
 }
 
-static uint brcmf_sdbrcm_sendfromq(struct brcmf_bus *bus, uint maxframes)
+static uint brcmf_sdbrcm_sendfromq(struct brcmf_sdio *bus, uint maxframes)
 {
 	struct sk_buff *pkt;
 	u32 intstatus = 0;
@@ -2293,7 +2293,7 @@ static uint brcmf_sdbrcm_sendfromq(struct brcmf_bus *bus, uint maxframes)
 	return cnt;
 }
 
-static bool brcmf_sdbrcm_dpc(struct brcmf_bus *bus)
+static bool brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 {
 	u32 intstatus, newstatus = 0;
 	uint retries = 0;
@@ -2539,7 +2539,7 @@ clkwait:
 
 static int brcmf_sdbrcm_dpc_thread(void *data)
 {
-	struct brcmf_bus *bus = (struct brcmf_bus *) data;
+	struct brcmf_sdio *bus = (struct brcmf_sdio *) data;
 
 	allow_signal(SIGTERM);
 	/* Run until signal received */
@@ -2564,7 +2564,7 @@ static int brcmf_sdbrcm_dpc_thread(void *data)
 	return 0;
 }
 
-int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
+int brcmf_sdbrcm_bus_txdata(struct brcmf_sdio *bus, struct sk_buff *pkt)
 {
 	int ret = -EBADE;
 	uint datalen, prec;
@@ -2615,7 +2615,7 @@ int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 }
 
 static int
-brcmf_sdbrcm_membytes(struct brcmf_bus *bus, bool write, u32 address, u8 *data,
+brcmf_sdbrcm_membytes(struct brcmf_sdio *bus, bool write, u32 address, u8 *data,
 		 uint size)
 {
 	int bcmerror = 0;
@@ -2676,7 +2676,7 @@ xfer_done:
 #ifdef BCMDBG
 #define CONSOLE_LINE_MAX	192
 
-static int brcmf_sdbrcm_readconsole(struct brcmf_bus *bus)
+static int brcmf_sdbrcm_readconsole(struct brcmf_sdio *bus)
 {
 	struct brcmf_console *c = &bus->console;
 	u8 line[CONSOLE_LINE_MAX], ch;
@@ -2753,7 +2753,7 @@ break2:
 }
 #endif				/* BCMDBG */
 
-static int brcmf_tx_frame(struct brcmf_bus *bus, u8 *frame, u16 len)
+static int brcmf_tx_frame(struct brcmf_sdio *bus, u8 *frame, u16 len)
 {
 	int i;
 	int ret;
@@ -2796,7 +2796,7 @@ static int brcmf_tx_frame(struct brcmf_bus *bus, u8 *frame, u16 len)
 }
 
 int
-brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
+brcmf_sdbrcm_bus_txctl(struct brcmf_sdio *bus, unsigned char *msg, uint msglen)
 {
 	u8 *frame;
 	u16 len;
@@ -2911,7 +2911,7 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 }
 
 int
-brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
+brcmf_sdbrcm_bus_rxctl(struct brcmf_sdio *bus, unsigned char *msg, uint msglen)
 {
 	int timeleft;
 	uint rxlen = 0;
@@ -2948,7 +2948,7 @@ brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	return rxlen ? (int)rxlen : -ETIMEDOUT;
 }
 
-static int brcmf_sdbrcm_downloadvars(struct brcmf_bus *bus, void *arg, int len)
+static int brcmf_sdbrcm_downloadvars(struct brcmf_sdio *bus, void *arg, int len)
 {
 	int bcmerror = 0;
 
@@ -2981,7 +2981,7 @@ err:
 	return bcmerror;
 }
 
-static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
+static int brcmf_sdbrcm_write_vars(struct brcmf_sdio *bus)
 {
 	int bcmerror = 0;
 	u32 varsize;
@@ -3068,7 +3068,7 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 	return bcmerror;
 }
 
-static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
+static int brcmf_sdbrcm_download_state(struct brcmf_sdio *bus, bool enter)
 {
 	uint retries;
 	int bcmerror = 0;
@@ -3117,7 +3117,7 @@ fail:
 	return bcmerror;
 }
 
-static int brcmf_sdbrcm_get_image(char *buf, int len, struct brcmf_bus *bus)
+static int brcmf_sdbrcm_get_image(char *buf, int len, struct brcmf_sdio *bus)
 {
 	if (bus->firmware->size < bus->fw_ptr + len)
 		len = bus->firmware->size - bus->fw_ptr;
@@ -3127,7 +3127,7 @@ static int brcmf_sdbrcm_get_image(char *buf, int len, struct brcmf_bus *bus)
 	return len;
 }
 
-static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus)
+static int brcmf_sdbrcm_download_code_file(struct brcmf_sdio *bus)
 {
 	int offset = 0;
 	uint len;
@@ -3226,7 +3226,7 @@ static uint brcmf_process_nvram_vars(char *varbuf, uint len)
 	return buf_len;
 }
 
-static int brcmf_sdbrcm_download_nvram(struct brcmf_bus *bus)
+static int brcmf_sdbrcm_download_nvram(struct brcmf_sdio *bus)
 {
 	uint len;
 	char *memblock = NULL;
@@ -3273,7 +3273,7 @@ err:
 	return ret;
 }
 
-static int _brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus)
+static int _brcmf_sdbrcm_download_firmware(struct brcmf_sdio *bus)
 {
 	int bcmerror = -1;
 
@@ -3306,7 +3306,7 @@ err:
 }
 
 static bool
-brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus)
+brcmf_sdbrcm_download_firmware(struct brcmf_sdio *bus)
 {
 	bool ret;
 
@@ -3320,7 +3320,7 @@ brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus)
 	return ret;
 }
 
-void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus)
+void brcmf_sdbrcm_bus_stop(struct brcmf_sdio *bus)
 {
 	u32 local_hostintmask;
 	u8 saveclk;
@@ -3400,7 +3400,7 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus)
 
 int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr)
 {
-	struct brcmf_bus *bus = drvr->bus;
+	struct brcmf_sdio *bus = drvr->bus;
 	unsigned long timeout;
 	uint retries = 0;
 	u8 ready, enable;
@@ -3502,7 +3502,7 @@ exit:
 
 void brcmf_sdbrcm_isr(void *arg)
 {
-	struct brcmf_bus *bus = (struct brcmf_bus *) arg;
+	struct brcmf_sdio *bus = (struct brcmf_sdio *) arg;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3536,7 +3536,7 @@ void brcmf_sdbrcm_isr(void *arg)
 
 static bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
 {
-	struct brcmf_bus *bus;
+	struct brcmf_sdio *bus;
 
 	brcmf_dbg(TIMER, "Enter\n");
 
@@ -3623,7 +3623,7 @@ static bool brcmf_sdbrcm_chipmatch(u16 chipid)
 	return false;
 }
 
-static void brcmf_sdbrcm_release_malloc(struct brcmf_bus *bus)
+static void brcmf_sdbrcm_release_malloc(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3635,7 +3635,7 @@ static void brcmf_sdbrcm_release_malloc(struct brcmf_bus *bus)
 	bus->databuf = NULL;
 }
 
-static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus)
+static bool brcmf_sdbrcm_probe_malloc(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3671,7 +3671,7 @@ fail:
 }
 
 static bool
-brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
+brcmf_sdbrcm_probe_attach(struct brcmf_sdio *bus, u32 regsva)
 {
 	u8 clkctl = 0;
 	int err = 0;
@@ -3756,7 +3756,7 @@ fail:
 	return false;
 }
 
-static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus)
+static bool brcmf_sdbrcm_probe_init(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3791,7 +3791,7 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus)
 static int
 brcmf_sdbrcm_watchdog_thread(void *data)
 {
-	struct brcmf_bus *bus = (struct brcmf_bus *)data;
+	struct brcmf_sdio *bus = (struct brcmf_sdio *)data;
 
 	allow_signal(SIGTERM);
 	/* Run until signal received */
@@ -3811,7 +3811,7 @@ brcmf_sdbrcm_watchdog_thread(void *data)
 static void
 brcmf_sdbrcm_watchdog(unsigned long data)
 {
-	struct brcmf_bus *bus = (struct brcmf_bus *)data;
+	struct brcmf_sdio *bus = (struct brcmf_sdio *)data;
 
 	if (bus->watchdog_tsk) {
 		complete(&bus->watchdog_wait);
@@ -3822,7 +3822,7 @@ brcmf_sdbrcm_watchdog(unsigned long data)
 	}
 }
 
-static void brcmf_sdbrcm_release_dongle(struct brcmf_bus *bus)
+static void brcmf_sdbrcm_release_dongle(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3839,7 +3839,7 @@ static void brcmf_sdbrcm_release_dongle(struct brcmf_bus *bus)
 }
 
 /* Detach and free everything */
-static void brcmf_sdbrcm_release(struct brcmf_bus *bus)
+static void brcmf_sdbrcm_release(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3864,7 +3864,7 @@ static void brcmf_sdbrcm_release(struct brcmf_bus *bus)
 void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 {
 	int ret;
-	struct brcmf_bus *bus;
+	struct brcmf_sdio *bus;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3872,7 +3872,7 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	 * regsva == SI_ENUM_BASE*/
 
 	/* Allocate private bus interface state */
-	bus = kzalloc(sizeof(struct brcmf_bus), GFP_ATOMIC);
+	bus = kzalloc(sizeof(struct brcmf_sdio), GFP_ATOMIC);
 	if (!bus)
 		goto fail;
 
@@ -3976,7 +3976,7 @@ fail:
 
 void brcmf_sdbrcm_disconnect(void *ptr)
 {
-	struct brcmf_bus *bus = (struct brcmf_bus *)ptr;
+	struct brcmf_sdio *bus = (struct brcmf_sdio *)ptr;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3986,13 +3986,13 @@ void brcmf_sdbrcm_disconnect(void *ptr)
 	brcmf_dbg(TRACE, "Disconnected\n");
 }
 
-struct device *brcmf_bus_get_device(struct brcmf_bus *bus)
+struct device *brcmf_bus_get_device(struct brcmf_sdio *bus)
 {
 	return &bus->sdiodev->func[2]->dev;
 }
 
 void
-brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick)
+brcmf_sdbrcm_wd_timer(struct brcmf_sdio *bus, uint wdtick)
 {
 	/* Totally stop the timer */
 	if (!wdtick && bus->wd_timer_valid == true) {
-- 
1.7.5.4


