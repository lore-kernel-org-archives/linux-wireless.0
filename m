Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3340 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982Ab1GVS5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 14:57:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/29] staging: brcm80211: fixed checkpatch warnings for
 fullmac
Date: Fri, 22 Jul 2011 20:56:48 +0200
Message-ID: <1311361036-3175-2-git-send-email-arend@broadcom.com> (sfid-20110722_205844_766647_3537ABEE)
In-Reply-To: <1311361036-3175-1-git-send-email-arend@broadcom.com>
References: <1311361036-3175-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Most of them being 'line longer than 80 chars' type of warning.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |  115 ++++++++++------
 drivers/staging/brcm80211/brcmfmac/dhd_common.c  |   23 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |   27 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c    |  156 +++++++++++++---------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h   |   95 +++++++++-----
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   23 ++--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    3 +-
 7 files changed, 265 insertions(+), 177 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 3c950cc..cd1b90d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -117,11 +117,16 @@
 #define BRCMF_SCAN_RESULTS_ABORTED	3
 #define BRCMF_SCAN_RESULTS_NO_MEM	4
 
-#define WL_SOFT_KEY	(1 << 0)	/* Indicates this key is using soft encrypt */
-#define BRCMF_PRIMARY_KEY	(1 << 1)	/* primary (ie tx) key */
-#define WL_KF_RES_4	(1 << 4)	/* Reserved for backward compat */
-#define WL_KF_RES_5	(1 << 5)	/* Reserved for backward compat */
-#define WL_IBSS_PEER_GROUP_KEY	(1 << 6)	/* Indicates a group key for a IBSS PEER */
+/* Indicates this key is using soft encrypt */
+#define WL_SOFT_KEY	(1 << 0)
+/* primary (ie tx) key */
+#define BRCMF_PRIMARY_KEY	(1 << 1)
+/* Reserved for backward compat */
+#define WL_KF_RES_4	(1 << 4)
+/* Reserved for backward compat */
+#define WL_KF_RES_5	(1 << 5)
+/* Indicates a group key for a IBSS PEER */
+#define WL_IBSS_PEER_GROUP_KEY	(1 << 6)
 
 /* For supporting multiple interfaces */
 #define BRCMF_MAX_IFS	16
@@ -333,13 +338,18 @@ enum brcmf_bus_state {
  * that indicates which bits within the pattern should be matched.
  */
 struct brcmf_pkt_filter_pattern {
-	u32 offset;		/* Offset within received packet to start pattern matching.
-				 * Offset '0' is the first byte of the ethernet header.
-				 */
-	u32 size_bytes;	/* Size of the pattern.  Bitmask must be the same size. */
-	u8 mask_and_pattern[1];	/* Variable length mask and pattern data.  mask starts
-					 * at offset 0.  Pattern immediately follows mask.
-					 */
+	/*
+	 * Offset within received packet to start pattern matching.
+	 * Offset '0' is the first byte of the ethernet header.
+	 */
+	u32 offset;
+	/* Size of the pattern.  Bitmask must be the same size.*/
+	u32 size_bytes;
+	/*
+	 * Variable length mask and pattern data. mask starts at offset 0.
+	 * Pattern immediately follows mask.
+	 */
+	u8 mask_and_pattern[1];
 };
 
 /* IOVAR "pkt_filter_add" parameter. Used to install packet filters. */
@@ -373,8 +383,8 @@ struct brcmf_bss_info {
 	u8 SSID_len;
 	u8 SSID[32];
 	struct {
-		uint count;	/* # rates in this set */
-		u8 rates[16];	/* rates in 500kbps units w/hi bit set if basic */
+		uint count;   /* # rates in this set */
+		u8 rates[16]; /* rates in 500kbps units w/hi bit set if basic */
 	} rateset;		/* supported rates */
 	u16 chanspec;	/* chanspec for bss */
 	u16 atim_window;	/* units are Kusec */
@@ -409,7 +419,7 @@ struct brcmf_scan_params {
 				 * DOT11_BSSTYPE_ANY/INFRASTRUCTURE/INDEPENDENT
 				 */
 	u8 scan_type;	/* flags, 0 use default */
-	s32 nprobes;		/* -1 use default, number of probes per channel */
+	s32 nprobes;	  /* -1 use default, number of probes per channel */
 	s32 active_time;	/* -1 use default, dwell time per channel for
 				 * active scanning
 				 */
@@ -460,11 +470,13 @@ struct brcmf_scan_results {
 
 /* used for association with a specific BSSID and chanspec list */
 struct brcmf_assoc_params {
-	u8 bssid[ETH_ALEN];	/* 00:00:00:00:00:00: broadcast scan */
-	s32 chanspec_num;	/* 0: all available channels,
-				 * otherwise count of chanspecs in chanspec_list
-				 */
-	u16 chanspec_list[1];	/* list of chanspecs */
+	/* 00:00:00:00:00:00: broadcast scan */
+	u8 bssid[ETH_ALEN];
+	/* 0: all available channels, otherwise count of chanspecs in
+	 * chanspec_list */
+	s32 chanspec_num;
+	/* list of chanspecs */
+	u16 chanspec_list[1];
 };
 #define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
 	(sizeof(struct brcmf_assoc_params) - sizeof(u16))
@@ -495,8 +507,8 @@ struct brcmf_wsec_key {
 	u32 len;		/* key length */
 	u8 data[WLAN_MAX_KEY_LEN];	/* key data */
 	u32 pad_1[18];
-	u32 algo;		/* CRYPTO_ALGO_AES_CCM, CRYPTO_ALGO_WEP128, etc */
-	u32 flags;		/* misc flags */
+	u32 algo;	/* CRYPTO_ALGO_AES_CCM, CRYPTO_ALGO_WEP128, etc */
+	u32 flags;	/* misc flags */
 	u32 pad_2[2];
 	int pad_3;
 	int iv_initialized;	/* has IV been initialized already? */
@@ -558,32 +570,45 @@ struct brcmf_pub {
 	/* Dongle media info */
 	bool iswl;		/* Dongle-resident driver is wl */
 	unsigned long drv_version;	/* Version of dongle-resident driver */
-	u8 mac[ETH_ALEN];			/* MAC address obtained from dongle */
+	u8 mac[ETH_ALEN];		/* MAC address obtained from dongle */
 	struct dngl_stats dstats;	/* Stats for dongle-based data */
 
 	/* Additional stats for the bus level */
-	unsigned long tx_packets;	/* Data packets sent to dongle */
-	unsigned long tx_multicast;	/* Multicast data packets sent to dongle */
-	unsigned long tx_errors;	/* Errors in sending data to dongle */
-	unsigned long tx_ctlpkts;	/* Control packets sent to dongle */
-	unsigned long tx_ctlerrs;	/* Errors sending control frames to dongle */
-	unsigned long rx_packets;	/* Packets sent up the network interface */
-	unsigned long rx_multicast;	/* Multicast packets sent up the network
-					 interface */
-	unsigned long rx_errors;	/* Errors processing rx data packets */
-	unsigned long rx_ctlpkts;	/* Control frames processed from dongle */
-	unsigned long rx_ctlerrs;	/* Errors in processing rx control frames */
-	unsigned long rx_dropped;	/* Packets dropped locally (no memory) */
-	unsigned long rx_flushed;	/* Packets flushed due to
-				unscheduled sendup thread */
-	unsigned long wd_dpc_sched;	/* Number of times dpc scheduled by
-					 watchdog timer */
-
-	unsigned long rx_readahead_cnt;	/* Number of packets where header read-ahead
-					 was used. */
-	unsigned long tx_realloc;	/* Number of tx packets we had to realloc for
-					 headroom */
-	unsigned long fc_packets;	/* Number of flow control pkts recvd */
+
+	/* Data packets sent to dongle */
+	unsigned long tx_packets;
+	/* Multicast data packets sent to dongle */
+	unsigned long tx_multicast;
+	/* Errors in sending data to dongle */
+	unsigned long tx_errors;
+	/* Control packets sent to dongle */
+	unsigned long tx_ctlpkts;
+	/* Errors sending control frames to dongle */
+	unsigned long tx_ctlerrs;
+	/* Packets sent up the network interface */
+	unsigned long rx_packets;
+	/* Multicast packets sent up the network interface */
+	unsigned long rx_multicast;
+	/* Errors processing rx data packets */
+	unsigned long rx_errors;
+	/* Control frames processed from dongle */
+	unsigned long rx_ctlpkts;
+
+	/* Errors in processing rx control frames */
+	unsigned long rx_ctlerrs;
+	/* Packets dropped locally (no memory) */
+	unsigned long rx_dropped;
+	/* Packets flushed due to unscheduled sendup thread */
+	unsigned long rx_flushed;
+	/* Number of times dpc scheduled by watchdog timer */
+	unsigned long wd_dpc_sched;
+
+	/* Number of packets where header read-ahead was used. */
+	unsigned long rx_readahead_cnt;
+	/* Number of tx packets we had to realloc for headroom */
+	unsigned long tx_realloc;
+	/* Number of flow control pkts recvd */
+	unsigned long fc_packets;
 
 	/* Last error return */
 	int bcmerror;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index fdd3629..a6704c4 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -660,20 +660,19 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 				 + be16_to_cpu(hdr.len)) = '\0';
 
 			if (be32_to_cpu(hdr.discarded_bytes)
-			    || be32_to_cpu(hdr.discarded_printf)) {
-				BRCMF_ERROR(
-				    ("\nWLC_E_TRACE: [Discarded traces in dongle -->"
-				     "discarded_bytes %d discarded_printf %d]\n",
-				     be32_to_cpu(hdr.discarded_bytes),
-				     be32_to_cpu(hdr.discarded_printf)));
-			}
+			    || be32_to_cpu(hdr.discarded_printf))
+				BRCMF_ERROR(("\nWLC_E_TRACE: [Discarded traces "
+					     "in dongle -->discarded_bytes %d "
+					     "discarded_printf %d]\n",
+					     be32_to_cpu(hdr.discarded_bytes),
+					     be32_to_cpu(hdr.discarded_printf)))
+					     ;
 
 			nblost = be32_to_cpu(hdr.seqnum) - seqnum_prev - 1;
-			if (nblost > 0) {
-				BRCMF_ERROR(
-				    ("\nWLC_E_TRACE: [Event lost --> seqnum %d nblost %d\n",
-				     be32_to_cpu(hdr.seqnum), nblost));
-			}
+			if (nblost > 0)
+				BRCMF_ERROR(("\nWLC_E_TRACE: [Event lost --> "
+					     "seqnum %d nblost %d\n",
+					     be32_to_cpu(hdr.seqnum), nblost));
 			seqnum_prev = be32_to_cpu(hdr.seqnum);
 
 			/* Display the trace buffer. Advance from \n to \n to
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 54b09e0..1100097 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -133,8 +133,8 @@ module_param(brcmf_pktgen_len, uint, 0);
 
 static int brcmf_toe_get(struct brcmf_info *drvr_priv, int idx, u32 *toe_ol);
 static int brcmf_toe_set(struct brcmf_info *drvr_priv, int idx, u32 toe_ol);
-static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
-			    struct brcmf_event_msg *event_ptr,
+static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx,
+			    void *pktdata, struct brcmf_event_msg *event_ptr,
 			    void **data_ptr);
 
 static int brcmf_net2idx(struct brcmf_info *drvr_priv, struct net_device *net)
@@ -303,7 +303,8 @@ static void _brcmf_set_multicast_list(struct brcmf_info *drvr_priv, int ifidx)
 	}
 }
 
-static int _brcmf_set_mac_address(struct brcmf_info *drvr_priv, int ifidx, u8 *addr)
+static int
+_brcmf_set_mac_address(struct brcmf_info *drvr_priv, int ifidx, u8 *addr)
 {
 	char buf[32];
 	struct brcmf_ioctl ioc;
@@ -368,7 +369,8 @@ static void brcmf_op_if(struct brcmf_if *ifp)
 		}
 		if (ret == 0) {
 			strcpy(ifp->net->name, ifp->name);
-			memcpy(netdev_priv(ifp->net), &drvr_priv, sizeof(drvr_priv));
+			memcpy(netdev_priv(ifp->net), &drvr_priv,
+			       sizeof(drvr_priv));
 			err = brcmf_net_attach(&drvr_priv->pub, ifp->idx);
 			if (err != 0) {
 				BRCMF_ERROR(("%s: brcmf_net_attach failed, "
@@ -1024,7 +1026,8 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 
 	/* check for local brcmf ioctl and handle it */
 	if (driver == BRCMF_IOCTL_MAGIC) {
-		bcmerror = brcmf_c_ioctl((void *)&drvr_priv->pub, &ioc, buf, buflen);
+		bcmerror = brcmf_c_ioctl((void *)&drvr_priv->pub, &ioc,
+					 buf, buflen);
 		if (bcmerror)
 			drvr_priv->pub.bcmerror = bcmerror;
 		goto done;
@@ -1054,9 +1057,8 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 	if (is_set_key_cmd)
 		brcmf_netdev_wait_pend8021x(net);
 
-	bcmerror =
-	    brcmf_proto_ioctl(&drvr_priv->pub, ifidx, (struct brcmf_ioctl *)&ioc,
-			      buf, buflen);
+	bcmerror = brcmf_proto_ioctl(&drvr_priv->pub, ifidx,
+				     (struct brcmf_ioctl *)&ioc, buf, buflen);
 
 done:
 	if (!bcmerror && buf && ioc.buf) {
@@ -1253,8 +1255,8 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 
 	if (brcmf_sysioc) {
 		init_waitqueue_head(&drvr_priv->sysioc_waitq);
-		drvr_priv->sysioc_tsk = kthread_run(_brcmf_sysioc_thread, drvr_priv,
-						"_brcmf_sysioc");
+		drvr_priv->sysioc_tsk = kthread_run(_brcmf_sysioc_thread,
+						    drvr_priv, "_brcmf_sysioc");
 		if (IS_ERR(drvr_priv->sysioc_tsk)) {
 			printk(KERN_WARNING
 				"_brcmf_sysioc thread failed to start\n");
@@ -1513,8 +1515,9 @@ int brcmf_os_proto_unblock(struct brcmf_pub *drvr)
 	return 0;
 }
 
-static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
-			    struct brcmf_event_msg *event, void **data)
+static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx,
+			    void *pktdata, struct brcmf_event_msg *event,
+			    void **data)
 {
 	int bcmerror = 0;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index fe11478..6c96f77 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -160,48 +160,63 @@ struct rte_console {
 #endif
 
 /* SBSDIO_DEVICE_CTL */
-#define SBSDIO_DEVCTL_SETBUSY		0x01	/* 1: device will assert busy signal when
-						 * receiving CMD53
-						 */
-#define SBSDIO_DEVCTL_SPI_INTR_SYNC	0x02	/* 1: assertion of sdio interrupt is
-						 * synchronous to the sdio clock
-						 */
-#define SBSDIO_DEVCTL_CA_INT_ONLY	0x04	/* 1: mask all interrupts to host
-						 * except the chipActive (rev 8)
-						 */
-#define SBSDIO_DEVCTL_PADS_ISO		0x08	/* 1: isolate internal sdio signals, put
-						 * external pads in tri-state; requires
-						 * sdio bus power cycle to clear (rev 9)
-						 */
-#define SBSDIO_DEVCTL_SB_RST_CTL	0x30	/* Force SD->SB reset mapping (rev 11) */
-#define SBSDIO_DEVCTL_RST_CORECTL	0x00	/*   Determined by CoreControl bit */
-#define SBSDIO_DEVCTL_RST_BPRESET	0x10	/*   Force backplane reset */
-#define SBSDIO_DEVCTL_RST_NOBPRESET	0x20	/*   Force no backplane reset */
+
+/* 1: device will assert busy signal when receiving CMD53 */
+#define SBSDIO_DEVCTL_SETBUSY		0x01
+/* 1: assertion of sdio interrupt is synchronous to the sdio clock */
+#define SBSDIO_DEVCTL_SPI_INTR_SYNC	0x02
+/* 1: mask all interrupts to host except the chipActive (rev 8) */
+#define SBSDIO_DEVCTL_CA_INT_ONLY	0x04
+/* 1: isolate internal sdio signals, put external pads in tri-state; requires
+ * sdio bus power cycle to clear (rev 9) */
+#define SBSDIO_DEVCTL_PADS_ISO		0x08
+/* Force SD->SB reset mapping (rev 11) */
+#define SBSDIO_DEVCTL_SB_RST_CTL	0x30
+/*   Determined by CoreControl bit */
+#define SBSDIO_DEVCTL_RST_CORECTL	0x00
+/*   Force backplane reset */
+#define SBSDIO_DEVCTL_RST_BPRESET	0x10
+/*   Force no backplane reset */
+#define SBSDIO_DEVCTL_RST_NOBPRESET	0x20
 
 /* SBSDIO_FUNC1_CHIPCLKCSR */
-#define SBSDIO_FORCE_ALP		0x01	/* Force ALP request to backplane */
-#define SBSDIO_FORCE_HT			0x02	/* Force HT request to backplane */
-#define SBSDIO_FORCE_ILP		0x04	/* Force ILP request to backplane */
-#define SBSDIO_ALP_AVAIL_REQ		0x08	/* Make ALP ready (power up xtal) */
-#define SBSDIO_HT_AVAIL_REQ		0x10	/* Make HT ready (power up PLL) */
-#define SBSDIO_FORCE_HW_CLKREQ_OFF	0x20	/* Squelch clock requests from HW */
-#define SBSDIO_ALP_AVAIL		0x40	/* Status: ALP is ready */
-#define SBSDIO_HT_AVAIL			0x80	/* Status: HT is ready */
-
-#define SBSDIO_AVBITS			(SBSDIO_HT_AVAIL | SBSDIO_ALP_AVAIL)
-#define SBSDIO_ALPAV(regval)		((regval) & SBSDIO_AVBITS)
-#define SBSDIO_HTAV(regval)		(((regval) & SBSDIO_AVBITS) == SBSDIO_AVBITS)
-#define SBSDIO_ALPONLY(regval)		(SBSDIO_ALPAV(regval) && !SBSDIO_HTAV(regval))
-#define SBSDIO_CLKAV(regval, alponly)	(SBSDIO_ALPAV(regval) && \
-					(alponly ? 1 : SBSDIO_HTAV(regval)))
+
+/* Force ALP request to backplane */
+#define SBSDIO_FORCE_ALP		0x01
+/* Force HT request to backplane */
+#define SBSDIO_FORCE_HT			0x02
+/* Force ILP request to backplane */
+#define SBSDIO_FORCE_ILP		0x04
+/* Make ALP ready (power up xtal) */
+#define SBSDIO_ALP_AVAIL_REQ		0x08
+/* Make HT ready (power up PLL) */
+#define SBSDIO_HT_AVAIL_REQ		0x10
+/* Squelch clock requests from HW */
+#define SBSDIO_FORCE_HW_CLKREQ_OFF	0x20
+/* Status: ALP is ready */
+#define SBSDIO_ALP_AVAIL		0x40
+/* Status: HT is ready */
+#define SBSDIO_HT_AVAIL			0x80
+
+#define SBSDIO_AVBITS		(SBSDIO_HT_AVAIL | SBSDIO_ALP_AVAIL)
+#define SBSDIO_ALPAV(regval)	((regval) & SBSDIO_AVBITS)
+#define SBSDIO_HTAV(regval)	(((regval) & SBSDIO_AVBITS) == SBSDIO_AVBITS)
+#define SBSDIO_ALPONLY(regval)	(SBSDIO_ALPAV(regval) && !SBSDIO_HTAV(regval))
+
+#define SBSDIO_CLKAV(regval, alponly) \
+	(SBSDIO_ALPAV(regval) && (alponly ? 1 : SBSDIO_HTAV(regval)))
+
 /* direct(mapped) cis space */
-#define SBSDIO_CIS_BASE_COMMON		0x1000	/* MAPPED common CIS address */
-#define SBSDIO_CIS_SIZE_LIMIT		0x200	/* maximum bytes in one CIS */
-#define SBSDIO_CIS_OFT_ADDR_MASK	0x1FFFF	/* cis offset addr is < 17 bits */
 
-#define SBSDIO_CIS_MANFID_TUPLE_LEN	6	/* manfid tuple length, include tuple,
-						 * link bytes
-						 */
+/* MAPPED common CIS address */
+#define SBSDIO_CIS_BASE_COMMON		0x1000
+/* maximum bytes in one CIS */
+#define SBSDIO_CIS_SIZE_LIMIT		0x200
+/* cis offset addr is < 17 bits */
+#define SBSDIO_CIS_OFT_ADDR_MASK	0x1FFFF
+
+/* manfid tuple length, include tuple, link bytes */
+#define SBSDIO_CIS_MANFID_TUPLE_LEN	6
 
 /* intstatus */
 #define I_SMB_SW0	(1 << 0)	/* To SB Mail S/W interrupt 0 */
@@ -408,12 +423,18 @@ struct rte_console {
 #define	SBIM_RJ			0x02000000	/* reject (sonics >= 2.3) */
 
 /* sbtmstatelow */
-#define	SBTML_RESET		0x0001	/* reset */
-#define	SBTML_REJ_MASK		0x0006	/* reject field */
-#define	SBTML_REJ		0x0002	/* reject */
-#define	SBTML_TMPREJ		0x0004	/* temporary reject, for error recovery */
 
-#define	SBTML_SICF_SHIFT	16	/* Shift to locate the SI control flags in sbtml */
+/* reset */
+#define	SBTML_RESET		0x0001
+/* reject field */
+#define	SBTML_REJ_MASK		0x0006
+/* reject */
+#define	SBTML_REJ		0x0002
+/* temporary reject, for error recovery */
+#define	SBTML_TMPREJ		0x0004
+
+/* Shift to locate the SI control flags in sbtml */
+#define	SBTML_SICF_SHIFT	16
 
 /* sbtmstatehigh */
 #define	SBTMH_SERR		0x0001	/* serror */
@@ -421,7 +442,8 @@ struct rte_console {
 #define	SBTMH_BUSY		0x0004	/* busy */
 #define	SBTMH_TO		0x0020	/* timeout (sonics >= 2.3) */
 
-#define	SBTMH_SISF_SHIFT	16	/* Shift to locate the SI status flags in sbtmh */
+/* Shift to locate the SI status flags in sbtmh */
+#define	SBTMH_SISF_SHIFT	16
 
 /* sbidlow */
 #define	SBIDL_INIT		0x80	/* initiator */
@@ -431,7 +453,8 @@ struct rte_console {
 #define	SBIDH_RCE_MASK		0x7000	/* revision code extension field */
 #define	SBIDH_RCE_SHIFT		8
 #define	SBCOREREV(sbidh) \
-	((((sbidh) & SBIDH_RCE_MASK) >> SBIDH_RCE_SHIFT) | ((sbidh) & SBIDH_RC_MASK))
+	((((sbidh) & SBIDH_RCE_MASK) >> SBIDH_RCE_SHIFT) | \
+	  ((sbidh) & SBIDH_RC_MASK))
 #define	SBIDH_CC_MASK		0x8ff0	/* core code */
 #define	SBIDH_CC_SHIFT		4
 #define	SBIDH_VC_MASK		0xffff0000	/* vendor code */
@@ -1333,8 +1356,8 @@ int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 
 /* Writes a HW/SW header into the packet and sends it. */
 /* Assumes: (a) header space already there, (b) caller holds lock */
-static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt, uint chan,
-			 bool free_pkt)
+static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt,
+			      uint chan, bool free_pkt)
 {
 	int ret;
 	u8 *frame;
@@ -1523,7 +1546,8 @@ int brcmf_sdbrcm_bus_txdata(struct brcmf_bus *bus, struct sk_buff *pkt)
 
 		/* Priority based enq */
 		spin_lock_bh(&bus->txqlock);
-		if (brcmf_c_prec_enq(bus->drvr, &bus->txq, pkt, prec) == false) {
+		if (brcmf_c_prec_enq(bus->drvr, &bus->txq, pkt, prec) ==
+		    false) {
 			skb_pull(pkt, SDPCM_HDRLEN);
 			brcmf_txcomplete(bus->drvr, pkt, false);
 			brcmu_pkt_buf_free_skb(pkt);
@@ -1804,7 +1828,8 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	return ret ? -EIO : 0;
 }
 
-int brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
+int
+brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 {
 	int timeleft;
 	uint rxlen = 0;
@@ -2191,7 +2216,8 @@ xfer_done:
 }
 
 #ifdef BCMDBG
-static int brcmf_sdbrcm_readshared(struct brcmf_bus *bus, struct sdpcm_shared *sh)
+static int
+brcmf_sdbrcm_readshared(struct brcmf_bus *bus, struct sdpcm_shared *sh)
 {
 	u32 addr;
 	int rv;
@@ -2530,10 +2556,10 @@ err:
 	return bcmerror;
 }
 
-static int
-brcmf_sdbrcm_doiovar(struct brcmf_bus *bus, const struct brcmu_iovar *vi, u32 actionid,
-		const char *name, void *params, int plen, void *arg, int len,
-		int val_size)
+static int brcmf_sdbrcm_doiovar(struct brcmf_bus *bus,
+				const struct brcmu_iovar *vi, u32 actionid,
+				const char *name, void *params, int plen,
+				void *arg, int len, int val_size)
 {
 	int bcmerror = 0;
 	s32 int_val = 0;
@@ -3957,8 +3983,8 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 					save_pfirst = pnext;
 
 				continue;
-			} else if (brcmf_proto_hdrpull(bus->drvr, &ifidx, pfirst)
-					!= 0) {
+			} else if (brcmf_proto_hdrpull(bus->drvr, &ifidx,
+						       pfirst) != 0) {
 				BRCMF_ERROR(("%s: rx protocol error\n",
 					     __func__));
 				bus->drvr->rx_errors++;
@@ -4080,8 +4106,8 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 						MAX_RX_DATASZ))
 						rdlen += pad;
 				} else if (rdlen % BRCMF_SDALIGN) {
-					rdlen +=
-					    BRCMF_SDALIGN - (rdlen % BRCMF_SDALIGN);
+					rdlen += BRCMF_SDALIGN -
+						 (rdlen % BRCMF_SDALIGN);
 				}
 			}
 
@@ -4103,11 +4129,11 @@ brcmf_sdbrcm_readframes(struct brcmf_bus *bus, uint maxframes, bool *finished)
 					bus->rxctl = bus->rxbuf;
 					if (brcmf_alignctl) {
 						bus->rxctl += firstread;
-						pad = ((unsigned long)bus->rxctl %
-						      BRCMF_SDALIGN);
+						pad = ((unsigned long)bus->rxctl
+							% BRCMF_SDALIGN);
 						if (pad)
 							bus->rxctl +=
-							    (BRCMF_SDALIGN - pad);
+							  (BRCMF_SDALIGN - pad);
 						bus->rxctl -= firstread;
 					}
 					rxbuf = bus->rxctl;
@@ -6503,8 +6529,8 @@ static const struct sdiod_drive_str sdiod_drive_strength_tab3[] = {
 
 #define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
 
-static void
-brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus, u32 drivestrength) {
+static void brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus,
+						   u32 drivestrength) {
 	struct sdiod_drive_str *str_tab = NULL;
 	u32 str_mask = 0;
 	u32 str_shift = 0;
@@ -6775,8 +6801,8 @@ static int brcmf_sdbrcm_get_image(char *buf, int len, struct brcmf_bus *bus)
 MODULE_FIRMWARE(BCM4329_FW_NAME);
 MODULE_FIRMWARE(BCM4329_NV_NAME);
 
-static int
-brcmf_sdbrcm_ioctl_resp_wait(struct brcmf_bus *bus, uint *condition, bool *pending)
+static int brcmf_sdbrcm_ioctl_resp_wait(struct brcmf_bus *bus, uint *condition,
+					bool *pending)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	int timeout = msecs_to_jiffies(brcmf_ioctl_timeout_msec);
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index cf3b8fc..aecc8e3 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -40,46 +40,71 @@
 /* Maximum number of I/O funcs */
 #define SDIOD_MAX_IOFUNCS	7
 
-#define SBSDIO_NUM_FUNCTION		3	/* as of sdiod rev 0, supports 3 functions */
+/* as of sdiod rev 0, supports 3 functions */
+#define SBSDIO_NUM_FUNCTION		3
 
 /* function 1 miscellaneous registers */
-#define SBSDIO_SPROM_CS			0x10000	/* sprom command and status */
-#define SBSDIO_SPROM_INFO		0x10001	/* sprom info register */
-#define SBSDIO_SPROM_DATA_LOW		0x10002	/* sprom indirect access data byte 0 */
-#define SBSDIO_SPROM_DATA_HIGH		0x10003	/* sprom indirect access data byte 1 */
-#define SBSDIO_SPROM_ADDR_LOW		0x10004	/* sprom indirect access addr byte 0 */
-#define SBSDIO_SPROM_ADDR_HIGH		0x10005	/* sprom indirect access addr byte 0 */
-#define SBSDIO_CHIP_CTRL_DATA		0x10006	/* xtal_pu (gpio) output */
-#define SBSDIO_CHIP_CTRL_EN		0x10007	/* xtal_pu (gpio) enable */
-#define SBSDIO_WATERMARK		0x10008	/* rev < 7, watermark for sdio device */
-#define SBSDIO_DEVICE_CTL		0x10009	/* control busy signal generation */
-
-/* registers introduced in rev 8, some content (mask/bits) defs in sbsdpcmdev.h */
-#define SBSDIO_FUNC1_SBADDRLOW		0x1000A	/* SB Address Window Low (b15) */
-#define SBSDIO_FUNC1_SBADDRMID		0x1000B	/* SB Address Window Mid (b23:b16) */
-#define SBSDIO_FUNC1_SBADDRHIGH		0x1000C	/* SB Address Window High (b31:b24)    */
-#define SBSDIO_FUNC1_FRAMECTRL		0x1000D	/* Frame Control (frame term/abort) */
-#define SBSDIO_FUNC1_CHIPCLKCSR		0x1000E	/* ChipClockCSR (ALP/HT ctl/status) */
-#define SBSDIO_FUNC1_SDIOPULLUP		0x1000F	/* SdioPullUp (on cmd, d0-d2) */
-#define SBSDIO_FUNC1_WFRAMEBCLO		0x10019	/* Write Frame Byte Count Low */
-#define SBSDIO_FUNC1_WFRAMEBCHI		0x1001A	/* Write Frame Byte Count High */
-#define SBSDIO_FUNC1_RFRAMEBCLO		0x1001B	/* Read Frame Byte Count Low */
-#define SBSDIO_FUNC1_RFRAMEBCHI		0x1001C	/* Read Frame Byte Count High */
+
+/* sprom command and status */
+#define SBSDIO_SPROM_CS			0x10000
+/* sprom info register */
+#define SBSDIO_SPROM_INFO		0x10001
+/* sprom indirect access data byte 0 */
+#define SBSDIO_SPROM_DATA_LOW		0x10002
+/* sprom indirect access data byte 1 */
+#define SBSDIO_SPROM_DATA_HIGH		0x10003
+/* sprom indirect access addr byte 0 */
+#define SBSDIO_SPROM_ADDR_LOW		0x10004
+/* sprom indirect access addr byte 0 */
+#define SBSDIO_SPROM_ADDR_HIGH		0x10005
+/* xtal_pu (gpio) output */
+#define SBSDIO_CHIP_CTRL_DATA		0x10006
+/* xtal_pu (gpio) enable */
+#define SBSDIO_CHIP_CTRL_EN		0x10007
+/* rev < 7, watermark for sdio device */
+#define SBSDIO_WATERMARK		0x10008
+/* control busy signal generation */
+#define SBSDIO_DEVICE_CTL		0x10009
+
+/* SB Address Window Low (b15) */
+#define SBSDIO_FUNC1_SBADDRLOW		0x1000A
+/* SB Address Window Mid (b23:b16) */
+#define SBSDIO_FUNC1_SBADDRMID		0x1000B
+/* SB Address Window High (b31:b24)    */
+#define SBSDIO_FUNC1_SBADDRHIGH		0x1000C
+/* Frame Control (frame term/abort) */
+#define SBSDIO_FUNC1_FRAMECTRL		0x1000D
+/* ChipClockCSR (ALP/HT ctl/status) */
+#define SBSDIO_FUNC1_CHIPCLKCSR		0x1000E
+/* SdioPullUp (on cmd, d0-d2) */
+#define SBSDIO_FUNC1_SDIOPULLUP		0x1000F
+/* Write Frame Byte Count Low */
+#define SBSDIO_FUNC1_WFRAMEBCLO		0x10019
+/* Write Frame Byte Count High */
+#define SBSDIO_FUNC1_WFRAMEBCHI		0x1001A
+/* Read Frame Byte Count Low */
+#define SBSDIO_FUNC1_RFRAMEBCLO		0x1001B
+/* Read Frame Byte Count High */
+#define SBSDIO_FUNC1_RFRAMEBCHI		0x1001C
 
 #define SBSDIO_FUNC1_MISC_REG_START	0x10000	/* f1 misc register start */
 #define SBSDIO_FUNC1_MISC_REG_LIMIT	0x1001C	/* f1 misc register end */
 
 /* function 1 OCP space */
-#define SBSDIO_SB_OFT_ADDR_MASK		0x07FFF	/* sb offset addr is <= 15 bits, 32k */
+
+/* sb offset addr is <= 15 bits, 32k */
+#define SBSDIO_SB_OFT_ADDR_MASK		0x07FFF
 #define SBSDIO_SB_OFT_ADDR_LIMIT	0x08000
-#define SBSDIO_SB_ACCESS_2_4B_FLAG	0x08000	/* with b15, maps to 32-bit SB access */
+/* with b15, maps to 32-bit SB access */
+#define SBSDIO_SB_ACCESS_2_4B_FLAG	0x08000
 
-/* some duplication with sbsdpcmdev.h here */
 /* valid bits in SBSDIO_FUNC1_SBADDRxxx regs */
+
 #define SBSDIO_SBADDRLOW_MASK		0x80	/* Valid bits in SBADDRLOW */
 #define SBSDIO_SBADDRMID_MASK		0xff	/* Valid bits in SBADDRMID */
 #define SBSDIO_SBADDRHIGH_MASK		0xffU	/* Valid bits in SBADDRHIGH */
-#define SBSDIO_SBWINDOW_MASK		0xffff8000	/* Address bits from SBADDR regs */
+/* Address bits from SBADDR regs */
+#define SBSDIO_SBWINDOW_MASK		0xffff8000
 
 #define SDIOH_READ              0	/* Read request */
 #define SDIOH_WRITE             1	/* Write request */
@@ -103,7 +128,7 @@ struct brcmf_sdreg {
 struct sdioh_info {
 	struct osl_info *osh;		/* osh handler */
 	bool client_intr_enabled;	/* interrupt connnected flag */
-	bool intr_handler_valid;	/* client driver interrupt handler valid */
+	bool intr_handler_valid; /* client driver interrupt handler valid */
 	void (*intr_handler)(void *);	/* registered interrupt handler */
 	void *intr_handler_arg;	/* argument to call interrupt handler */
 	u16 intmask;		/* Current active interrupts */
@@ -119,8 +144,8 @@ struct sdioh_info {
 	u32 com_cis_ptr;
 	u32 func_cis_ptr[SDIOD_MAX_IOFUNCS];
 	uint max_dma_len;
-	uint max_dma_descriptors;	/* DMA Descriptors supported by this controller. */
-	/*	SDDMA_DESCRIPTOR	SGList[32]; *//* Scatter/Gather DMA List */
+	/* DMA Descriptors supported by this controller. */
+	uint max_dma_descriptors;
 };
 
 struct brcmf_sdmmc_instance {
@@ -218,9 +243,13 @@ brcmf_sdcard_recv_buf(struct brcmf_sdio_card *card, u32 addr, uint fn,
 		      void *handle);
 
 /* Flags bits */
-#define SDIO_REQ_4BYTE	0x1	/* Four-byte target (backplane) width (vs. two-byte) */
-#define SDIO_REQ_FIXED	0x2	/* Fixed address (FIFO) (vs. incrementing address) */
-#define SDIO_REQ_ASYNC	0x4	/* Async request (vs. sync request) */
+
+/* Four-byte target (backplane) width (vs. two-byte) */
+#define SDIO_REQ_4BYTE	0x1
+/* Fixed address (FIFO) (vs. incrementing address) */
+#define SDIO_REQ_FIXED	0x2
+/* Async request (vs. sync request) */
+#define SDIO_REQ_ASYNC	0x4
 
 /* Pending (non-error) return code */
 #define BCME_PENDING	1
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index ae0a7eb..b50999c 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -795,8 +795,8 @@ __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 				sizeof(sr->ssid));
 		if (err) {
 			if (err == -EBUSY)
-				WL_INFO("system busy : scan for \"%s\" canceled\n",
-					sr->ssid.SSID);
+				WL_INFO("system busy : scan for \"%s\" "
+					"canceled\n", sr->ssid.SSID);
 			else
 				WL_ERR("WLC_SCAN error (%d)\n", err);
 
@@ -1098,7 +1098,8 @@ done:
 	return err;
 }
 
-static s32 brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
+static s32
+brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
 	s32 err = 0;
@@ -1113,8 +1114,8 @@ static s32 brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev
 	return err;
 }
 
-static s32
-brcmf_set_wpa_version(struct net_device *dev, struct cfg80211_connect_params *sme)
+static s32 brcmf_set_wpa_version(struct net_device *dev,
+				 struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
 	struct brcmf_cfg80211_security *sec;
@@ -1178,7 +1179,8 @@ brcmf_set_auth_type(struct net_device *dev, struct cfg80211_connect_params *sme)
 }
 
 static s32
-brcmf_set_set_cipher(struct net_device *dev, struct cfg80211_connect_params *sme)
+brcmf_set_set_cipher(struct net_device *dev,
+		     struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(dev);
 	struct brcmf_cfg80211_security *sec;
@@ -1428,7 +1430,8 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	memset(&join_params, 0, sizeof(join_params));
 	join_params_size = sizeof(join_params.ssid);
 
-	join_params.ssid.SSID_len = min(sizeof(join_params.ssid.SSID), sme->ssid_len);
+	join_params.ssid.SSID_len =
+		min(sizeof(join_params.ssid.SSID), sme->ssid_len);
 	memcpy(&join_params.ssid.SSID, sme->ssid, join_params.ssid.SSID_len);
 	join_params.ssid.SSID_len = cpu_to_le32(join_params.ssid.SSID_len);
 	brcmf_update_prof(cfg_priv, NULL, &join_params.ssid, WL_PROF_SSID);
@@ -1515,7 +1518,8 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 	/* Make sure radio is off or on as far as software is concerned */
 	disable = WL_RADIO_SW_DISABLE << 16;
 	disable = cpu_to_le32(disable);
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_RADIO, &disable, sizeof(disable));
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_RADIO, &disable,
+			      sizeof(disable));
 	if (unlikely(err))
 		WL_ERR("WLC_SET_RADIO error (%d)\n", err);
 
@@ -2061,7 +2065,8 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 
 	legacy = brcmf_find_msb(mask->control[IEEE80211_BAND_2GHZ].legacy);
 	if (!legacy)
-		legacy = brcmf_find_msb(mask->control[IEEE80211_BAND_5GHZ].legacy);
+		legacy = brcmf_find_msb(
+				mask->control[IEEE80211_BAND_5GHZ].legacy);
 
 	val = wl_g_rates[legacy - 1].bitrate * 100000;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index e25c755..049138b 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -340,7 +340,8 @@ static inline struct brcmf_bss_info *next_bss(struct brcmf_scan_results *list,
 }
 
 #define for_each_bss(list, bss, __i)	\
-	for (__i = 0; __i < list->count && __i < WL_AP_MAX; __i++, bss = next_bss(list, bss))
+	for (__i = 0; __i < list->count && __i < WL_AP_MAX; __i++, \
+	     bss = next_bss(list, bss))
 
 extern s32 brcmf_cfg80211_attach(struct net_device *ndev, void *data);
 extern void brcmf_cfg80211_detach(void);
-- 
1.7.4.1


