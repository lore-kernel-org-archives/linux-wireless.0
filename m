Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:56958 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab1DZW0B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 18:26:01 -0400
Date: Tue, 26 Apr 2011 15:25:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Cc: james_p_freyensee@linux.intel.com, Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: use kernel-doc notation, fix comment style
Message-Id: <20110426152529.61adfa64.randy.dunlap@oracle.com> (sfid-20110427_002607_486494_AD29E486)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Convert all libertas/ files to use kernel-doc notation instead
of whatever it was (doxygen?).

Add or fix function parameters in several places.

Use expected style for multi-line comments in lots of places.

Remove erroneous /** in multiple places.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wireless/libertas/cfg.c     |   45 ++--
 drivers/net/wireless/libertas/cmd.c     |  245 +++++++++++-----------
 drivers/net/wireless/libertas/cmdresp.c |   19 -
 drivers/net/wireless/libertas/debugfs.c |   36 +--
 drivers/net/wireless/libertas/decl.h    |    8 
 drivers/net/wireless/libertas/defs.h    |  113 +++++-----
 drivers/net/wireless/libertas/dev.h     |   20 -
 drivers/net/wireless/libertas/ethtool.c |    3 
 drivers/net/wireless/libertas/host.h    |   33 +-
 drivers/net/wireless/libertas/if_cs.c   |   35 ++-
 drivers/net/wireless/libertas/if_spi.c  |  134 +++++++-----
 drivers/net/wireless/libertas/if_spi.h  |   68 +++---
 drivers/net/wireless/libertas/if_usb.c  |  113 +++++-----
 drivers/net/wireless/libertas/if_usb.h  |   14 -
 drivers/net/wireless/libertas/main.c    |   99 ++++----
 drivers/net/wireless/libertas/mesh.c    |  210 ++++++++++++------
 drivers/net/wireless/libertas/mesh.h    |    6 
 drivers/net/wireless/libertas/rx.c      |   34 +--
 drivers/net/wireless/libertas/tx.c      |   34 +--
 drivers/net/wireless/libertas/types.h   |   18 -
 20 files changed, 730 insertions(+), 557 deletions(-)

--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/decl.h
+++ lnx-2639-rc4/drivers/net/wireless/libertas/decl.h
@@ -1,8 +1,8 @@
 
-/**
-  *  This file contains declaration referring to
-  *  functions defined in other source files
-  */
+/*
+ *  This file contains declaration referring to
+ *  functions defined in other source files
+ */
 
 #ifndef _LBS_DECL_H_
 #define _LBS_DECL_H_
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/defs.h
+++ lnx-2639-rc4/drivers/net/wireless/libertas/defs.h
@@ -1,7 +1,7 @@
-/**
-  * This header file contains global constant/enum definitions,
-  * global variable declaration.
-  */
+/*
+ * This header file contains global constant/enum definitions,
+ * global variable declaration.
+ */
 #ifndef _LBS_DEFS_H_
 #define _LBS_DEFS_H_
 
@@ -123,19 +123,19 @@ static inline void lbs_deb_hex(unsigned 
 
 
 
-/** Buffer Constants */
+/* Buffer Constants */
 
 /*	The size of SQ memory PPA, DPA are 8 DWORDs, that keep the physical
-*	addresses of TxPD buffers. Station has only 8 TxPD available, Whereas
-*	driver has more local TxPDs. Each TxPD on the host memory is associated
-*	with a Tx control node. The driver maintains 8 RxPD descriptors for
-*	station firmware to store Rx packet information.
-*
-*	Current version of MAC has a 32x6 multicast address buffer.
-*
-*	802.11b can have up to  14 channels, the driver keeps the
-*	BSSID(MAC address) of each APs or Ad hoc stations it has sensed.
-*/
+ *	addresses of TxPD buffers. Station has only 8 TxPD available, Whereas
+ *	driver has more local TxPDs. Each TxPD on the host memory is associated
+ *	with a Tx control node. The driver maintains 8 RxPD descriptors for
+ *	station firmware to store Rx packet information.
+ *
+ *	Current version of MAC has a 32x6 multicast address buffer.
+ *
+ *	802.11b can have up to  14 channels, the driver keeps the
+ *	BSSID(MAC address) of each APs or Ad hoc stations it has sensed.
+ */
 
 #define MRVDRV_MAX_MULTICAST_LIST_SIZE	32
 #define LBS_NUM_CMD_BUFFERS             10
@@ -166,7 +166,7 @@ static inline void lbs_deb_hex(unsigned 
 #define WOL_RESULT_NOSPC_ERR		1
 #define WOL_RESULT_EEXIST_ERR		2
 
-/** Misc constants */
+/* Misc constants */
 /* This section defines 802.11 specific contants */
 
 #define MRVDRV_MAX_BSS_DESCRIPTS		16
@@ -183,7 +183,8 @@ static inline void lbs_deb_hex(unsigned 
 
 #define MARVELL_MESH_IE_LENGTH		9
 
-/* Values used to populate the struct mrvl_mesh_ie.  The only time you need this
+/*
+ * Values used to populate the struct mrvl_mesh_ie.  The only time you need this
  * is when enabling the mesh using CMD_MESH_CONFIG.
  */
 #define MARVELL_MESH_IE_TYPE		4
@@ -193,7 +194,7 @@ static inline void lbs_deb_hex(unsigned 
 #define MARVELL_MESH_METRIC_ID		0
 #define MARVELL_MESH_CAPABILITY		0
 
-/** INT status Bit Definition*/
+/* INT status Bit Definition */
 #define MRVDRV_TX_DNLD_RDY		0x0001
 #define MRVDRV_RX_UPLD_RDY		0x0002
 #define MRVDRV_CMD_DNLD_RDY		0x0004
@@ -208,59 +209,63 @@ static inline void lbs_deb_hex(unsigned 
 #define TPC_DEFAULT_P1 10
 #define TPC_DEFAULT_P2 13
 
-/** TxPD status */
+/* TxPD status */
 
-/*	Station firmware use TxPD status field to report final Tx transmit
-*	result, Bit masks are used to present combined situations.
-*/
+/*
+ *	Station firmware use TxPD status field to report final Tx transmit
+ *	result, Bit masks are used to present combined situations.
+ */
 
 #define MRVDRV_TxPD_POWER_MGMT_NULL_PACKET 0x01
 #define MRVDRV_TxPD_POWER_MGMT_LAST_PACKET 0x08
 
-/** Tx mesh flag */
-/* Currently we are using normal WDS flag as mesh flag.
+/* Tx mesh flag */
+/*
+ * Currently we are using normal WDS flag as mesh flag.
  * TODO: change to proper mesh flag when MAC understands it.
  */
 #define TxPD_CONTROL_WDS_FRAME (1<<17)
 #define TxPD_MESH_FRAME TxPD_CONTROL_WDS_FRAME
 
-/** Mesh interface ID */
+/* Mesh interface ID */
 #define MESH_IFACE_ID					0x0001
-/** Mesh id should be in bits 14-13-12 */
+/* Mesh id should be in bits 14-13-12 */
 #define MESH_IFACE_BIT_OFFSET				0x000c
-/** Mesh enable bit in FW capability */
+/* Mesh enable bit in FW capability */
 #define MESH_CAPINFO_ENABLE_MASK			(1<<16)
 
-/** FW definition from Marvell v4 */
+/* FW definition from Marvell v4 */
 #define MRVL_FW_V4					(0x04)
-/** FW definition from Marvell v5 */
+/* FW definition from Marvell v5 */
 #define MRVL_FW_V5					(0x05)
-/** FW definition from Marvell v10 */
+/* FW definition from Marvell v10 */
 #define MRVL_FW_V10					(0x0a)
-/** FW major revision definition */
+/* FW major revision definition */
 #define MRVL_FW_MAJOR_REV(x)				((x)>>24)
 
-/** RxPD status */
+/* RxPD status */
 
 #define MRVDRV_RXPD_STATUS_OK                0x0001
 
-/** RxPD status - Received packet types */
-/** Rx mesh flag */
-/* Currently we are using normal WDS flag as mesh flag.
+/* RxPD status - Received packet types */
+/* Rx mesh flag */
+/*
+ * Currently we are using normal WDS flag as mesh flag.
  * TODO: change to proper mesh flag when MAC understands it.
  */
 #define RxPD_CONTROL_WDS_FRAME (0x40)
 #define RxPD_MESH_FRAME RxPD_CONTROL_WDS_FRAME
 
-/** RSSI-related defines */
-/*	RSSI constants are used to implement 802.11 RSSI threshold
-*	indication. if the Rx packet signal got too weak for 5 consecutive
-*	times, miniport driver (driver) will report this event to wrapper
-*/
+/* RSSI-related defines */
+/*
+ *	RSSI constants are used to implement 802.11 RSSI threshold
+ *	indication. if the Rx packet signal got too weak for 5 consecutive
+ *	times, miniport driver (driver) will report this event to wrapper
+ */
 
 #define MRVDRV_NF_DEFAULT_SCAN_VALUE		(-96)
 
-/** RTS/FRAG related defines */
+/* RTS/FRAG related defines */
 #define MRVDRV_RTS_MIN_VALUE		0
 #define MRVDRV_RTS_MAX_VALUE		2347
 #define MRVDRV_FRAG_MIN_VALUE		256
@@ -300,36 +305,36 @@ static inline void lbs_deb_hex(unsigned 
 
 #define	MAX_LEDS			8
 
-/** Global Variable Declaration */
+/* Global Variable Declaration */
 extern const char lbs_driver_version[];
 extern u16 lbs_region_code_to_index[MRVDRV_MAX_REGION_CODE];
 
 
-/** ENUM definition*/
-/** SNRNF_TYPE */
+/* ENUM definition */
+/* SNRNF_TYPE */
 enum SNRNF_TYPE {
 	TYPE_BEACON = 0,
 	TYPE_RXPD,
 	MAX_TYPE_B
 };
 
-/** SNRNF_DATA*/
+/* SNRNF_DATA */
 enum SNRNF_DATA {
 	TYPE_NOAVG = 0,
 	TYPE_AVG,
 	MAX_TYPE_AVG
 };
 
-/** LBS_802_11_POWER_MODE */
+/* LBS_802_11_POWER_MODE */
 enum LBS_802_11_POWER_MODE {
 	LBS802_11POWERMODECAM,
 	LBS802_11POWERMODEMAX_PSP,
 	LBS802_11POWERMODEFAST_PSP,
-	/*not a real mode, defined as an upper bound */
+	/* not a real mode, defined as an upper bound */
 	LBS802_11POWEMODEMAX
 };
 
-/** PS_STATE */
+/* PS_STATE */
 enum PS_STATE {
 	PS_STATE_FULL_POWER,
 	PS_STATE_AWAKE,
@@ -337,7 +342,7 @@ enum PS_STATE {
 	PS_STATE_SLEEP
 };
 
-/** DNLD_STATE */
+/* DNLD_STATE */
 enum DNLD_STATE {
 	DNLD_RES_RECEIVED,
 	DNLD_DATA_SENT,
@@ -345,19 +350,19 @@ enum DNLD_STATE {
 	DNLD_BOOTCMD_SENT,
 };
 
-/** LBS_MEDIA_STATE */
+/* LBS_MEDIA_STATE */
 enum LBS_MEDIA_STATE {
 	LBS_CONNECTED,
 	LBS_DISCONNECTED
 };
 
-/** LBS_802_11_PRIVACY_FILTER */
+/* LBS_802_11_PRIVACY_FILTER */
 enum LBS_802_11_PRIVACY_FILTER {
 	LBS802_11PRIVFILTERACCEPTALL,
 	LBS802_11PRIVFILTER8021XWEP
 };
 
-/** mv_ms_type */
+/* mv_ms_type */
 enum mv_ms_type {
 	MVMS_DAT = 0,
 	MVMS_CMD = 1,
@@ -365,14 +370,14 @@ enum mv_ms_type {
 	MVMS_EVENT
 };
 
-/** KEY_TYPE_ID */
+/* KEY_TYPE_ID */
 enum KEY_TYPE_ID {
 	KEY_TYPE_ID_WEP = 0,
 	KEY_TYPE_ID_TKIP,
 	KEY_TYPE_ID_AES
 };
 
-/** KEY_INFO_WPA (applies to both TKIP and AES/CCMP) */
+/* KEY_INFO_WPA (applies to both TKIP and AES/CCMP) */
 enum KEY_INFO_WPA {
 	KEY_INFO_WPA_MCAST = 0x01,
 	KEY_INFO_WPA_UNICAST = 0x02,
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/dev.h
+++ lnx-2639-rc4/drivers/net/wireless/libertas/dev.h
@@ -1,8 +1,8 @@
-/**
-  * This file contains definitions and data structures specific
-  * to Marvell 802.11 NIC. It contains the Device Information
-  * structure struct lbs_private..
-  */
+/*
+ * This file contains definitions and data structures specific
+ * to Marvell 802.11 NIC. It contains the Device Information
+ * structure struct lbs_private..
+ */
 #ifndef _LBS_DEV_H_
 #define _LBS_DEV_H_
 
@@ -12,7 +12,7 @@
 
 #include <linux/kfifo.h>
 
-/** sleep_params */
+/* sleep_params */
 struct sleep_params {
 	uint16_t sp_error;
 	uint16_t sp_offset;
@@ -23,7 +23,7 @@ struct sleep_params {
 };
 
 
-/** Private structure for the MV device */
+/* Private structure for the MV device */
 struct lbs_private {
 
 	/* Basic networking */
@@ -125,12 +125,12 @@ struct lbs_private {
 	/* Events sent from hardware to driver */
 	struct kfifo event_fifo;
 
-	/** thread to service interrupts */
+	/* thread to service interrupts */
 	struct task_struct *main_thread;
 	wait_queue_head_t waitq;
 	struct workqueue_struct *work_thread;
 
-	/** Encryption stuff */
+	/* Encryption stuff */
 	u8 authtype_auto;
 	u8 wep_tx_key;
 	u8 wep_key[4][WLAN_KEY_LEN_WEP104];
@@ -162,7 +162,7 @@ struct lbs_private {
 	s16 txpower_min;
 	s16 txpower_max;
 
-	/** Scanning */
+	/* Scanning */
 	struct delayed_work scan_work;
 	int scan_channel;
 	/* Queue of things waiting for scan completion */
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/host.h
+++ lnx-2639-rc4/drivers/net/wireless/libertas/host.h
@@ -1,7 +1,7 @@
-/**
-  * This file function prototypes, data structure
-  * and  definitions for all the host/station commands
-  */
+/*
+ * This file function prototypes, data structure
+ * and  definitions for all the host/station commands
+ */
 
 #ifndef _LBS_HOST_H_
 #define _LBS_HOST_H_
@@ -13,9 +13,10 @@
 
 #define CMD_OPTION_WAITFORRSP                   0x0002
 
-/** Host command IDs */
+/* Host command IDs */
 
-/* Return command are almost always the same as the host command, but with
+/*
+ * Return command are almost always the same as the host command, but with
  * bit 15 set high.  There are a few exceptions, though...
  */
 #define CMD_RET(cmd)                            (0x8000 | cmd)
@@ -251,7 +252,7 @@ enum cmd_mesh_config_types {
 	CMD_TYPE_MESH_GET_MESH_IE, /* GET_DEFAULTS is superset of GET_MESHIE */
 };
 
-/** Card Event definition */
+/* Card Event definition */
 #define MACREG_INT_CODE_TX_PPA_FREE		0
 #define MACREG_INT_CODE_TX_DMA_DONE		1
 #define MACREG_INT_CODE_LINK_LOST_W_SCAN	2
@@ -624,12 +625,14 @@ struct cmd_ds_802_11_rf_channel {
 struct cmd_ds_802_11_rssi {
 	struct cmd_header hdr;
 
-	/* request:  number of beacons (N) to average the SNR and NF over
+	/*
+	 * request:  number of beacons (N) to average the SNR and NF over
 	 * response: SNR of most recent beacon
 	 */
 	__le16 n_or_snr;
 
-	/* The following fields are only set in the response.
+	/*
+	 * The following fields are only set in the response.
 	 * In the request these are reserved and should be set to 0.
 	 */
 	__le16 nf;       /* most recent beacon noise floor */
@@ -680,14 +683,16 @@ struct cmd_ds_802_11_ps_mode {
 
 	__le16 action;
 
-	/* Interval for keepalive in PS mode:
+	/*
+	 * Interval for keepalive in PS mode:
 	 * 0x0000 = don't change
 	 * 0x001E = firmware default
 	 * 0xFFFF = disable
 	 */
 	__le16 nullpktinterval;
 
-	/* Number of DTIM intervals to wake up for:
+	/*
+	 * Number of DTIM intervals to wake up for:
 	 * 0 = don't change
 	 * 1 = firmware default
 	 * 5 = max
@@ -697,7 +702,8 @@ struct cmd_ds_802_11_ps_mode {
 	__le16 reserved;
 	__le16 locallisteninterval;
 
-	/* AdHoc awake period (FW v9+ only):
+	/*
+	 * AdHoc awake period (FW v9+ only):
 	 * 0 = don't change
 	 * 1 = always awake (IEEE standard behavior)
 	 * 2 - 31 = sleep for (n - 1) periods and awake for 1 period
@@ -771,7 +777,8 @@ struct adhoc_bssdesc {
 	__le16 capability;
 	u8 rates[MAX_RATES];
 
-	/* DO NOT ADD ANY FIELDS TO THIS STRUCTURE. It is used below in the
+	/*
+	 * DO NOT ADD ANY FIELDS TO THIS STRUCTURE. It is used below in the
 	 * Adhoc join command and will cause a binary layout mismatch with
 	 * the firmware
 	 */
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/if_spi.h
+++ lnx-2639-rc4/drivers/net/wireless/libertas/if_spi.h
@@ -86,34 +86,34 @@
 #define IF_SPI_DEVICEID_CTRL_REG_TO_CARD_REV(dc) (dc & 0x000000ff)
 
 /***************** IF_SPI_HOST_INT_CTRL_REG *****************/
-/** Host Interrupt Control bit : Wake up */
+/* Host Interrupt Control bit : Wake up */
 #define IF_SPI_HICT_WAKE_UP				(1<<0)
-/** Host Interrupt Control bit : WLAN ready */
+/* Host Interrupt Control bit : WLAN ready */
 #define IF_SPI_HICT_WLAN_READY				(1<<1)
 /*#define IF_SPI_HICT_FIFO_FIRST_HALF_EMPTY		(1<<2) */
 /*#define IF_SPI_HICT_FIFO_SECOND_HALF_EMPTY		(1<<3) */
 /*#define IF_SPI_HICT_IRQSRC_WLAN			(1<<4) */
-/** Host Interrupt Control bit : Tx auto download */
+/* Host Interrupt Control bit : Tx auto download */
 #define IF_SPI_HICT_TX_DOWNLOAD_OVER_AUTO		(1<<5)
-/** Host Interrupt Control bit : Rx auto upload */
+/* Host Interrupt Control bit : Rx auto upload */
 #define IF_SPI_HICT_RX_UPLOAD_OVER_AUTO			(1<<6)
-/** Host Interrupt Control bit : Command auto download */
+/* Host Interrupt Control bit : Command auto download */
 #define IF_SPI_HICT_CMD_DOWNLOAD_OVER_AUTO		(1<<7)
-/** Host Interrupt Control bit : Command auto upload */
+/* Host Interrupt Control bit : Command auto upload */
 #define IF_SPI_HICT_CMD_UPLOAD_OVER_AUTO		(1<<8)
 
 /***************** IF_SPI_CARD_INT_CAUSE_REG *****************/
-/** Card Interrupt Case bit : Tx download over */
+/* Card Interrupt Case bit : Tx download over */
 #define IF_SPI_CIC_TX_DOWNLOAD_OVER			(1<<0)
-/** Card Interrupt Case bit : Rx upload over */
+/* Card Interrupt Case bit : Rx upload over */
 #define IF_SPI_CIC_RX_UPLOAD_OVER			(1<<1)
-/** Card Interrupt Case bit : Command download over */
+/* Card Interrupt Case bit : Command download over */
 #define IF_SPI_CIC_CMD_DOWNLOAD_OVER			(1<<2)
-/** Card Interrupt Case bit : Host event */
+/* Card Interrupt Case bit : Host event */
 #define IF_SPI_CIC_HOST_EVENT				(1<<3)
-/** Card Interrupt Case bit : Command upload over */
+/* Card Interrupt Case bit : Command upload over */
 #define IF_SPI_CIC_CMD_UPLOAD_OVER			(1<<4)
-/** Card Interrupt Case bit : Power down */
+/* Card Interrupt Case bit : Power down */
 #define IF_SPI_CIC_POWER_DOWN				(1<<5)
 
 /***************** IF_SPI_CARD_INT_STATUS_REG *****************/
@@ -138,51 +138,51 @@
 #define IF_SPI_HICU_CMD_RD_FIFO_UNDERFLOW		(1<<10)
 
 /***************** IF_SPI_HOST_INT_STATUS_REG *****************/
-/** Host Interrupt Status bit : Tx download ready */
+/* Host Interrupt Status bit : Tx download ready */
 #define IF_SPI_HIST_TX_DOWNLOAD_RDY			(1<<0)
-/** Host Interrupt Status bit : Rx upload ready */
+/* Host Interrupt Status bit : Rx upload ready */
 #define IF_SPI_HIST_RX_UPLOAD_RDY			(1<<1)
-/** Host Interrupt Status bit : Command download ready */
+/* Host Interrupt Status bit : Command download ready */
 #define IF_SPI_HIST_CMD_DOWNLOAD_RDY			(1<<2)
-/** Host Interrupt Status bit : Card event */
+/* Host Interrupt Status bit : Card event */
 #define IF_SPI_HIST_CARD_EVENT				(1<<3)
-/** Host Interrupt Status bit : Command upload ready */
+/* Host Interrupt Status bit : Command upload ready */
 #define IF_SPI_HIST_CMD_UPLOAD_RDY			(1<<4)
-/** Host Interrupt Status bit : I/O write FIFO overflow */
+/* Host Interrupt Status bit : I/O write FIFO overflow */
 #define IF_SPI_HIST_IO_WR_FIFO_OVERFLOW			(1<<5)
-/** Host Interrupt Status bit : I/O read FIFO underflow */
+/* Host Interrupt Status bit : I/O read FIFO underflow */
 #define IF_SPI_HIST_IO_RD_FIFO_UNDRFLOW			(1<<6)
-/** Host Interrupt Status bit : Data write FIFO overflow */
+/* Host Interrupt Status bit : Data write FIFO overflow */
 #define IF_SPI_HIST_DATA_WR_FIFO_OVERFLOW		(1<<7)
-/** Host Interrupt Status bit : Data read FIFO underflow */
+/* Host Interrupt Status bit : Data read FIFO underflow */
 #define IF_SPI_HIST_DATA_RD_FIFO_UNDERFLOW		(1<<8)
-/** Host Interrupt Status bit : Command write FIFO overflow */
+/* Host Interrupt Status bit : Command write FIFO overflow */
 #define IF_SPI_HIST_CMD_WR_FIFO_OVERFLOW		(1<<9)
-/** Host Interrupt Status bit : Command read FIFO underflow */
+/* Host Interrupt Status bit : Command read FIFO underflow */
 #define IF_SPI_HIST_CMD_RD_FIFO_UNDERFLOW		(1<<10)
 
 /***************** IF_SPI_HOST_INT_STATUS_MASK_REG *****************/
-/** Host Interrupt Status Mask bit : Tx download ready */
+/* Host Interrupt Status Mask bit : Tx download ready */
 #define IF_SPI_HISM_TX_DOWNLOAD_RDY			(1<<0)
-/** Host Interrupt Status Mask bit : Rx upload ready */
+/* Host Interrupt Status Mask bit : Rx upload ready */
 #define IF_SPI_HISM_RX_UPLOAD_RDY			(1<<1)
-/** Host Interrupt Status Mask bit : Command download ready */
+/* Host Interrupt Status Mask bit : Command download ready */
 #define IF_SPI_HISM_CMD_DOWNLOAD_RDY			(1<<2)
-/** Host Interrupt Status Mask bit : Card event */
+/* Host Interrupt Status Mask bit : Card event */
 #define IF_SPI_HISM_CARDEVENT				(1<<3)
-/** Host Interrupt Status Mask bit : Command upload ready */
+/* Host Interrupt Status Mask bit : Command upload ready */
 #define IF_SPI_HISM_CMD_UPLOAD_RDY			(1<<4)
-/** Host Interrupt Status Mask bit : I/O write FIFO overflow */
+/* Host Interrupt Status Mask bit : I/O write FIFO overflow */
 #define IF_SPI_HISM_IO_WR_FIFO_OVERFLOW			(1<<5)
-/** Host Interrupt Status Mask bit : I/O read FIFO underflow */
+/* Host Interrupt Status Mask bit : I/O read FIFO underflow */
 #define IF_SPI_HISM_IO_RD_FIFO_UNDERFLOW		(1<<6)
-/** Host Interrupt Status Mask bit : Data write FIFO overflow */
+/* Host Interrupt Status Mask bit : Data write FIFO overflow */
 #define IF_SPI_HISM_DATA_WR_FIFO_OVERFLOW		(1<<7)
-/** Host Interrupt Status Mask bit : Data write FIFO underflow */
+/* Host Interrupt Status Mask bit : Data write FIFO underflow */
 #define IF_SPI_HISM_DATA_RD_FIFO_UNDERFLOW		(1<<8)
-/** Host Interrupt Status Mask bit : Command write FIFO overflow */
+/* Host Interrupt Status Mask bit : Command write FIFO overflow */
 #define IF_SPI_HISM_CMD_WR_FIFO_OVERFLOW		(1<<9)
-/** Host Interrupt Status Mask bit : Command write FIFO underflow */
+/* Host Interrupt Status Mask bit : Command write FIFO underflow */
 #define IF_SPI_HISM_CMD_RD_FIFO_UNDERFLOW		(1<<10)
 
 /***************** IF_SPI_SPU_BUS_MODE_REG *****************/
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/if_usb.h
+++ lnx-2639-rc4/drivers/net/wireless/libertas/if_usb.h
@@ -6,9 +6,9 @@
 
 struct lbs_private;
 
-/**
-  * This file contains definition for USB interface.
-  */
+/*
+ * This file contains definition for USB interface.
+ */
 #define CMD_TYPE_REQUEST		0xF00DFACE
 #define CMD_TYPE_DATA			0xBEADC0DE
 #define CMD_TYPE_INDICATION		0xBEEFFACE
@@ -40,7 +40,7 @@ struct bootcmdresp
 	uint8_t	pad[2];
 };
 
-/** USB card description structure*/
+/* USB card description structure*/
 struct if_usb_card {
 	struct usb_device *udev;
 	uint32_t model;  /* MODEL_* */
@@ -77,7 +77,7 @@ struct if_usb_card {
 	__le16 boot2_version;
 };
 
-/** fwheader */
+/* fwheader */
 struct fwheader {
 	__le32 dnldcmd;
 	__le32 baseaddr;
@@ -86,14 +86,14 @@ struct fwheader {
 };
 
 #define FW_MAX_DATA_BLK_SIZE	600
-/** FWData */
+/* FWData */
 struct fwdata {
 	struct fwheader hdr;
 	__le32 seqnum;
 	uint8_t data[0];
 };
 
-/** fwsyncheader */
+/* fwsyncheader */
 struct fwsyncheader {
 	__le32 cmd;
 	__le32 seqnum;
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/mesh.h
+++ lnx-2639-rc4/drivers/net/wireless/libertas/mesh.h
@@ -1,6 +1,6 @@
-/**
-  * Contains all definitions needed for the Libertas' MESH implementation.
-  */
+/*
+ * Contains all definitions needed for the Libertas' MESH implementation.
+ */
 #ifndef _LBS_MESH_H_
 #define _LBS_MESH_H_
 
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/types.h
+++ lnx-2639-rc4/drivers/net/wireless/libertas/types.h
@@ -1,6 +1,6 @@
-/**
-  * This header file contains definition for global types
-  */
+/*
+ * This header file contains definition for global types
+ */
 #ifndef _LBS_TYPES_H_
 #define _LBS_TYPES_H_
 
@@ -54,7 +54,7 @@ union ieee_phy_param_set {
 	struct ieee_ie_ds_param_set ds;
 } __packed;
 
-/** TLV  type ID definition */
+/* TLV  type ID definition */
 #define PROPRIETARY_TLV_BASE_ID		0x0100
 
 /* Terminating TLV type */
@@ -96,7 +96,7 @@ union ieee_phy_param_set {
 #define TLV_TYPE_MESH_ID            (PROPRIETARY_TLV_BASE_ID + 37)
 #define TLV_TYPE_OLD_MESH_ID        (PROPRIETARY_TLV_BASE_ID + 291)
 
-/** TLV related data structures*/
+/* TLV related data structures */
 struct mrvl_ie_header {
 	__le16 type;
 	__le16 len;
@@ -177,7 +177,7 @@ struct mrvl_ie_auth_type {
 	__le16 auth;
 } __packed;
 
-/**  Local Power capability */
+/*  Local Power capability */
 struct mrvl_ie_power_capability {
 	struct mrvl_ie_header header;
 	s8 minpower;
@@ -235,9 +235,11 @@ struct mrvl_ie_ledbhv {
 	struct led_bhv ledbhv[1];
 } __packed;
 
-/* Meant to be packed as the value member of a struct ieee80211_info_element.
+/*
+ * Meant to be packed as the value member of a struct ieee80211_info_element.
  * Note that the len member of the ieee80211_info_element varies depending on
- * the mesh_id_len */
+ * the mesh_id_len
+ */
 struct mrvl_meshie_val {
 	uint8_t oui[3];
 	uint8_t type;
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/cfg.c
+++ lnx-2639-rc4/drivers/net/wireless/libertas/cfg.c
@@ -122,8 +122,10 @@ static u8 lbs_auth_to_authtype(enum nl80
 }
 
 
-/* Various firmware commands need the list of supported rates, but with
-   the hight-bit set for basic rates */
+/*
+ * Various firmware commands need the list of supported rates, but with
+ * the hight-bit set for basic rates
+ */
 static int lbs_add_rates(u8 *rates)
 {
 	size_t i;
@@ -425,7 +427,7 @@ static int lbs_add_wpa_tlv(u8 *tlv, cons
 	return ie_len + 2;
 }
 
-/***************************************************************************
+/*
  * Set Channel
  */
 
@@ -452,7 +454,7 @@ static int lbs_cfg_set_channel(struct wi
 
 
 
-/***************************************************************************
+/*
  * Scanning
  */
 
@@ -538,8 +540,10 @@ static int lbs_ret_scan(struct lbs_priva
 		goto done;
 	}
 
-	/* Validity check: the TLV holds TSF values with 8 bytes each, so
-	 * the size in the TLV must match the nr_sets value */
+	/*
+	 * Validity check: the TLV holds TSF values with 8 bytes each, so
+	 * the size in the TLV must match the nr_sets value
+	 */
 	i = get_unaligned_le16(tsfdesc);
 	tsfdesc += 2;
 	if (i / 8 != scanresp->nr_sets) {
@@ -581,8 +585,10 @@ static int lbs_ret_scan(struct lbs_priva
 
 		/* To find out the channel, we must parse the IEs */
 		ie = pos;
-		/* 6+1+8+2+2: size of BSSID, RSSI, time stamp, beacon
-		   interval, capabilities */
+		/*
+		 * 6+1+8+2+2: size of BSSID, RSSI, time stamp, beacon
+		 * interval, capabilities
+		 */
 		ielen = left = len - (6 + 1 + 8 + 2 + 2);
 		while (left >= 2) {
 			u8 id, elen;
@@ -790,7 +796,7 @@ static int lbs_cfg_scan(struct wiphy *wi
 
 
 
-/***************************************************************************
+/*
  * Events
  */
 
@@ -825,7 +831,7 @@ void lbs_send_mic_failureevent(struct lb
 
 
 
-/***************************************************************************
+/*
  * Connect/disconnect
  */
 
@@ -950,8 +956,10 @@ static int lbs_enable_rsn(struct lbs_pri
  * Set WPA/WPA key material
  */
 
-/* like "struct cmd_ds_802_11_key_material", but with cmd_header. Once we
- * get rid of WEXT, this should go into host.h */
+/*
+ * like "struct cmd_ds_802_11_key_material", but with cmd_header. Once we
+ * get rid of WEXT, this should go into host.h
+ */
 
 struct cmd_key_material {
 	struct cmd_header hdr;
@@ -1536,7 +1544,7 @@ static int lbs_cfg_del_key(struct wiphy 
 }
 
 
-/***************************************************************************
+/*
  * Get station
  */
 
@@ -1581,7 +1589,7 @@ static int lbs_cfg_get_station(struct wi
 
 
 
-/***************************************************************************
+/*
  * "Site survey", here just current channel and noise level
  */
 
@@ -1614,7 +1622,7 @@ static int lbs_get_survey(struct wiphy *
 
 
 
-/***************************************************************************
+/*
  * Change interface
  */
 
@@ -1656,11 +1664,12 @@ static int lbs_change_intf(struct wiphy 
 
 
 
-/***************************************************************************
+/*
  * IBSS (Ad-Hoc)
  */
 
-/* The firmware needs the following bits masked out of the beacon-derived
+/*
+ * The firmware needs the following bits masked out of the beacon-derived
  * capability field when associating/joining to a BSS:
  *  9 (QoS), 11 (APSD), 12 (unused), 14 (unused), 15 (unused)
  */
@@ -1999,7 +2008,7 @@ static int lbs_leave_ibss(struct wiphy *
 
 
 
-/***************************************************************************
+/*
  * Initialization
  */
 
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/cmd.c
+++ lnx-2639-rc4/drivers/net/wireless/libertas/cmd.c
@@ -1,7 +1,7 @@
-/**
-  * This file contains the handling of command.
-  * It prepares command and sends it to firmware when it is ready.
-  */
+/*
+ * This file contains the handling of command.
+ * It prepares command and sends it to firmware when it is ready.
+ */
 
 #include <linux/kfifo.h>
 #include <linux/sched.h>
@@ -16,14 +16,14 @@
 #define CAL_RSSI(snr, nf)	((s32)((s32)(snr) + CAL_NF(nf)))
 
 /**
- *  @brief Simple callback that copies response back into command
+ * lbs_cmd_copyback - Simple callback that copies response back into command
  *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param extra  	A pointer to the original command structure for which
- *                      'resp' is a response
- *  @param resp         A pointer to the command response
+ * @priv:	A pointer to &struct lbs_private structure
+ * @extra:	A pointer to the original command structure for which
+ *		'resp' is a response
+ * @resp:	A pointer to the command response
  *
- *  @return 	   	0 on success, error on failure
+ * returns:	0 on success, error on failure
  */
 int lbs_cmd_copyback(struct lbs_private *priv, unsigned long extra,
 		     struct cmd_header *resp)
@@ -38,15 +38,15 @@ int lbs_cmd_copyback(struct lbs_private 
 EXPORT_SYMBOL_GPL(lbs_cmd_copyback);
 
 /**
- *  @brief Simple callback that ignores the result. Use this if
- *  you just want to send a command to the hardware, but don't
+ *  lbs_cmd_async_callback - Simple callback that ignores the result.
+ *  Use this if you just want to send a command to the hardware, but don't
  *  care for the result.
  *
- *  @param priv         ignored
- *  @param extra        ignored
- *  @param resp         ignored
+ *  @priv:	ignored
+ *  @extra:	ignored
+ *  @resp:	ignored
  *
- *  @return 	   	0 for success
+ *  returns:	0 for success
  */
 static int lbs_cmd_async_callback(struct lbs_private *priv, unsigned long extra,
 		     struct cmd_header *resp)
@@ -56,10 +56,11 @@ static int lbs_cmd_async_callback(struct
 
 
 /**
- *  @brief Checks whether a command is allowed in Power Save mode
+ *  is_command_allowed_in_ps - tests if a command is allowed in Power Save mode
+ *
+ *  @cmd:	the command ID
  *
- *  @param command the command ID
- *  @return 	   1 if allowed, 0 if not allowed
+ *  returns:	1 if allowed, 0 if not allowed
  */
 static u8 is_command_allowed_in_ps(u16 cmd)
 {
@@ -75,11 +76,12 @@ static u8 is_command_allowed_in_ps(u16 c
 }
 
 /**
- *  @brief Updates the hardware details like MAC address and regulatory region
+ *  lbs_update_hw_spec - Updates the hardware details like MAC address
+ *  and regulatory region
  *
- *  @param priv    	A pointer to struct lbs_private structure
+ *  @priv:	A pointer to &struct lbs_private structure
  *
- *  @return 	   	0 on success, error on failure
+ *  returns:	0 on success, error on failure
  */
 int lbs_update_hw_spec(struct lbs_private *priv)
 {
@@ -217,14 +219,14 @@ int lbs_host_sleep_cfg(struct lbs_privat
 EXPORT_SYMBOL_GPL(lbs_host_sleep_cfg);
 
 /**
- *  @brief Sets the Power Save mode
+ *  lbs_set_ps_mode - Sets the Power Save mode
  *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param cmd_action	The Power Save operation (PS_MODE_ACTION_ENTER_PS or
+ *  @priv:	A pointer to &struct lbs_private structure
+ *  @cmd_action: The Power Save operation (PS_MODE_ACTION_ENTER_PS or
  *                         PS_MODE_ACTION_EXIT_PS)
- *  @param block	Whether to block on a response or not
+ *  @block:	Whether to block on a response or not
  *
- *  @return 	   	0 on success, error on failure
+ *  returns:	0 on success, error on failure
  */
 int lbs_set_ps_mode(struct lbs_private *priv, u16 cmd_action, bool block)
 {
@@ -417,13 +419,13 @@ int lbs_set_host_sleep(struct lbs_privat
 }
 
 /**
- *  @brief Set an SNMP MIB value
+ *  lbs_set_snmp_mib - Set an SNMP MIB value
  *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param oid  	The OID to set in the firmware
- *  @param val  	Value to set the OID to
+ *  @priv:	A pointer to &struct lbs_private structure
+ *  @oid:	The OID to set in the firmware
+ *  @val:	Value to set the OID to
  *
- *  @return 	   	0 on success, error on failure
+ *  returns: 	   	0 on success, error on failure
  */
 int lbs_set_snmp_mib(struct lbs_private *priv, u32 oid, u16 val)
 {
@@ -467,13 +469,13 @@ out:
 }
 
 /**
- *  @brief Get an SNMP MIB value
+ *  lbs_get_snmp_mib - Get an SNMP MIB value
  *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param oid  	The OID to retrieve from the firmware
- *  @param out_val  	Location for the returned value
+ *  @priv:	A pointer to &struct lbs_private structure
+ *  @oid:	The OID to retrieve from the firmware
+ *  @out_val:	Location for the returned value
  *
- *  @return 	   	0 on success, error on failure
+ *  returns:	0 on success, error on failure
  */
 int lbs_get_snmp_mib(struct lbs_private *priv, u32 oid, u16 *out_val)
 {
@@ -510,14 +512,14 @@ out:
 }
 
 /**
- *  @brief Get the min, max, and current TX power
+ *  lbs_get_tx_power - Get the min, max, and current TX power
  *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param curlevel  	Current power level in dBm
- *  @param minlevel  	Minimum supported power level in dBm (optional)
- *  @param maxlevel  	Maximum supported power level in dBm (optional)
+ *  @priv:	A pointer to &struct lbs_private structure
+ *  @curlevel:	Current power level in dBm
+ *  @minlevel:	Minimum supported power level in dBm (optional)
+ *  @maxlevel:	Maximum supported power level in dBm (optional)
  *
- *  @return 	   	0 on success, error on failure
+ *  returns:	0 on success, error on failure
  */
 int lbs_get_tx_power(struct lbs_private *priv, s16 *curlevel, s16 *minlevel,
 		     s16 *maxlevel)
@@ -545,12 +547,12 @@ int lbs_get_tx_power(struct lbs_private 
 }
 
 /**
- *  @brief Set the TX power
+ *  lbs_set_tx_power - Set the TX power
  *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param dbm  	The desired power level in dBm
+ *  @priv:	A pointer to &struct lbs_private structure
+ *  @dbm:	The desired power level in dBm
  *
- *  @return 	   	0 on success, error on failure
+ *  returns: 	   	0 on success, error on failure
  */
 int lbs_set_tx_power(struct lbs_private *priv, s16 dbm)
 {
@@ -573,12 +575,13 @@ int lbs_set_tx_power(struct lbs_private 
 }
 
 /**
- *  @brief Enable or disable monitor mode (only implemented on OLPC usb8388 FW)
+ *  lbs_set_monitor_mode - Enable or disable monitor mode
+ *  (only implemented on OLPC usb8388 FW)
  *
- *  @param priv        A pointer to struct lbs_private structure
- *  @param enable      1 to enable monitor mode, 0 to disable
+ *  @priv:	A pointer to &struct lbs_private structure
+ *  @enable:	1 to enable monitor mode, 0 to disable
  *
- *  @return            0 on success, error on failure
+ *  returns:	0 on success, error on failure
  */
 int lbs_set_monitor_mode(struct lbs_private *priv, int enable)
 {
@@ -604,11 +607,11 @@ int lbs_set_monitor_mode(struct lbs_priv
 }
 
 /**
- *  @brief Get the radio channel
+ *  lbs_get_channel - Get the radio channel
  *
- *  @param priv    	A pointer to struct lbs_private structure
+ *  @priv:	A pointer to &struct lbs_private structure
  *
- *  @return 	   	The channel on success, error on failure
+ *  returns:	The channel on success, error on failure
  */
 static int lbs_get_channel(struct lbs_private *priv)
 {
@@ -650,12 +653,12 @@ int lbs_update_channel(struct lbs_privat
 }
 
 /**
- *  @brief Set the radio channel
+ *  lbs_set_channel - Set the radio channel
  *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param channel  	The desired channel, or 0 to clear a locked channel
+ *  @priv:	A pointer to &struct lbs_private structure
+ *  @channel:	The desired channel, or 0 to clear a locked channel
  *
- *  @return 	   	0 on success, error on failure
+ *  returns:	0 on success, error on failure
  */
 int lbs_set_channel(struct lbs_private *priv, u8 channel)
 {
@@ -686,12 +689,13 @@ out:
 }
 
 /**
- *  @brief Get current RSSI and noise floor
+ * lbs_get_rssi - Get current RSSI and noise floor
  *
- *  @param priv		A pointer to struct lbs_private structure
- *  @param rssi		On successful return, signal level in mBm
+ * @priv:	A pointer to &struct lbs_private structure
+ * @rssi:	On successful return, signal level in mBm
+ * @nf:		On successful return, Noise floor
  *
- *  @return 	   	The channel on success, error on failure
+ * returns:	The channel on success, error on failure
  */
 int lbs_get_rssi(struct lbs_private *priv, s8 *rssi, s8 *nf)
 {
@@ -719,13 +723,14 @@ int lbs_get_rssi(struct lbs_private *pri
 }
 
 /**
- *  @brief Send regulatory and 802.11d domain information to the firmware
+ *  lbs_set_11d_domain_info - Send regulatory and 802.11d domain information
+ *  to the firmware
  *
- *  @param priv		pointer to struct lbs_private
- *  @param request	cfg80211 regulatory request structure
- *  @param bands	the device's supported bands and channels
+ *  @priv:	pointer to &struct lbs_private
+ *  @request:	cfg80211 regulatory request structure
+ *  @bands:	the device's supported bands and channels
  *
- *  @return		0 on success, error code on failure
+ *  returns:	0 on success, error code on failure
 */
 int lbs_set_11d_domain_info(struct lbs_private *priv,
 			    struct regulatory_request *request,
@@ -842,15 +847,15 @@ int lbs_set_11d_domain_info(struct lbs_p
 }
 
 /**
- *  @brief Read a MAC, Baseband, or RF register
+ *  lbs_get_reg - Read a MAC, Baseband, or RF register
  *
- *  @param priv		pointer to struct lbs_private
- *  @param cmd		register command, one of CMD_MAC_REG_ACCESS,
- *                        CMD_BBP_REG_ACCESS, or CMD_RF_REG_ACCESS
- *  @param offset       byte offset of the register to get
- *  @param value        on success, the value of the register at 'offset'
+ *  @priv:	pointer to &struct lbs_private
+ *  @reg:	register command, one of CMD_MAC_REG_ACCESS,
+ *		CMD_BBP_REG_ACCESS, or CMD_RF_REG_ACCESS
+ *  @offset:	byte offset of the register to get
+ *  @value:	on success, the value of the register at 'offset'
  *
- *  @return		0 on success, error code on failure
+ *  returns:	0 on success, error code on failure
 */
 int lbs_get_reg(struct lbs_private *priv, u16 reg, u16 offset, u32 *value)
 {
@@ -886,15 +891,15 @@ out:
 }
 
 /**
- *  @brief Write a MAC, Baseband, or RF register
+ *  lbs_set_reg - Write a MAC, Baseband, or RF register
  *
- *  @param priv		pointer to struct lbs_private
- *  @param cmd		register command, one of CMD_MAC_REG_ACCESS,
- *                        CMD_BBP_REG_ACCESS, or CMD_RF_REG_ACCESS
- *  @param offset       byte offset of the register to set
- *  @param value        the value to write to the register at 'offset'
+ *  @priv:	pointer to &struct lbs_private
+ *  @reg:	register command, one of CMD_MAC_REG_ACCESS,
+ *		CMD_BBP_REG_ACCESS, or CMD_RF_REG_ACCESS
+ *  @offset:	byte offset of the register to set
+ *  @value:	the value to write to the register at 'offset'
  *
- *  @return		0 on success, error code on failure
+ *  returns:	0 on success, error code on failure
 */
 int lbs_set_reg(struct lbs_private *priv, u16 reg, u16 offset, u32 value)
 {
@@ -1023,7 +1028,7 @@ static void lbs_submit_command(struct lb
 	lbs_deb_leave(LBS_DEB_HOST);
 }
 
-/**
+/*
  *  This function inserts command node to cmdfreeq
  *  after cleans it. Requires priv->driver_lock held.
  */
@@ -1125,11 +1130,12 @@ void lbs_set_mac_control(struct lbs_priv
 }
 
 /**
- *  @brief This function allocates the command buffer and link
- *  it to command free queue.
+ *  lbs_allocate_cmd_buffer - allocates the command buffer and links
+ *  it to command free queue
+ *
+ *  @priv:	A pointer to &struct lbs_private structure
  *
- *  @param priv		A pointer to struct lbs_private structure
- *  @return 		0 or -1
+ *  returns:	0 for success or -1 on error
  */
 int lbs_allocate_cmd_buffer(struct lbs_private *priv)
 {
@@ -1171,10 +1177,11 @@ done:
 }
 
 /**
- *  @brief This function frees the command buffer.
+ *  lbs_free_cmd_buffer - free the command buffer
  *
- *  @param priv		A pointer to struct lbs_private structure
- *  @return 		0 or -1
+ *  @priv:	A pointer to &struct lbs_private structure
+ *
+ *  returns:	0 for success
  */
 int lbs_free_cmd_buffer(struct lbs_private *priv)
 {
@@ -1211,11 +1218,13 @@ done:
 }
 
 /**
- *  @brief This function gets a free command node if available in
- *  command free queue.
+ *  lbs_get_free_cmd_node - gets a free command node if available in
+ *  command free queue
+ *
+ *  @priv:	A pointer to &struct lbs_private structure
  *
- *  @param priv		A pointer to struct lbs_private structure
- *  @return cmd_ctrl_node A pointer to cmd_ctrl_node structure or NULL
+ *  returns:	A pointer to &cmd_ctrl_node structure on success
+ *		or %NULL on error
  */
 static struct cmd_ctrl_node *lbs_get_free_cmd_node(struct lbs_private *priv)
 {
@@ -1245,12 +1254,12 @@ static struct cmd_ctrl_node *lbs_get_fre
 }
 
 /**
- *  @brief This function executes next command in command
- *  pending queue. It will put firmware back to PS mode
- *  if applicable.
+ *  lbs_execute_next_command - execute next command in command
+ *  pending queue. Will put firmware back to PS mode if applicable.
  *
- *  @param priv     A pointer to struct lbs_private structure
- *  @return 	   0 or -1
+ *  @priv:	A pointer to &struct lbs_private structure
+ *
+ *  returns:	0 on success or -1 on error
  */
 int lbs_execute_next_command(struct lbs_private *priv)
 {
@@ -1454,12 +1463,12 @@ out:
 }
 
 /**
- *  @brief This function checks condition and prepares to
- *  send sleep confirm command to firmware if ok.
+ * lbs_ps_confirm_sleep - checks condition and prepares to
+ * send sleep confirm command to firmware if ok
+ *
+ * @priv:	A pointer to &struct lbs_private structure
  *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param psmode  	Power Saving mode
- *  @return 	   	n/a
+ * returns:	n/a
  */
 void lbs_ps_confirm_sleep(struct lbs_private *priv)
 {
@@ -1499,16 +1508,16 @@ void lbs_ps_confirm_sleep(struct lbs_pri
 
 
 /**
- * @brief Configures the transmission power control functionality.
+ * lbs_set_tpc_cfg - Configures the transmission power control functionality
  *
- * @param priv		A pointer to struct lbs_private structure
- * @param enable	Transmission power control enable
- * @param p0		Power level when link quality is good (dBm).
- * @param p1		Power level when link quality is fair (dBm).
- * @param p2		Power level when link quality is poor (dBm).
- * @param usesnr	Use Signal to Noise Ratio in TPC
+ * @priv:	A pointer to &struct lbs_private structure
+ * @enable:	Transmission power control enable
+ * @p0:		Power level when link quality is good (dBm).
+ * @p1:		Power level when link quality is fair (dBm).
+ * @p2:		Power level when link quality is poor (dBm).
+ * @usesnr:	Use Signal to Noise Ratio in TPC
  *
- * @return 0 on success
+ * returns:	0 on success
  */
 int lbs_set_tpc_cfg(struct lbs_private *priv, int enable, int8_t p0, int8_t p1,
 		int8_t p2, int usesnr)
@@ -1531,15 +1540,15 @@ int lbs_set_tpc_cfg(struct lbs_private *
 }
 
 /**
- * @brief Configures the power adaptation settings.
+ * lbs_set_power_adapt_cfg - Configures the power adaptation settings
  *
- * @param priv		A pointer to struct lbs_private structure
- * @param enable	Power adaptation enable
- * @param p0		Power level for 1, 2, 5.5 and 11 Mbps (dBm).
- * @param p1		Power level for 6, 9, 12, 18, 22, 24 and 36 Mbps (dBm).
- * @param p2		Power level for 48 and 54 Mbps (dBm).
+ * @priv:	A pointer to &struct lbs_private structure
+ * @enable:	Power adaptation enable
+ * @p0:		Power level for 1, 2, 5.5 and 11 Mbps (dBm).
+ * @p1:		Power level for 6, 9, 12, 18, 22, 24 and 36 Mbps (dBm).
+ * @p2:		Power level for 48 and 54 Mbps (dBm).
  *
- * @return 0 on Success
+ * returns:	0 on Success
  */
 
 int lbs_set_power_adapt_cfg(struct lbs_private *priv, int enable, int8_t p0,
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/cmdresp.c
+++ lnx-2639-rc4/drivers/net/wireless/libertas/cmdresp.c
@@ -1,7 +1,7 @@
-/**
-  * This file contains the handling of command
-  * responses as well as events generated by firmware.
-  */
+/*
+ * This file contains the handling of command
+ * responses as well as events generated by firmware.
+ */
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
@@ -12,12 +12,13 @@
 #include "cmd.h"
 
 /**
- *  @brief This function handles disconnect event. it
- *  reports disconnect to upper layer, clean tx/rx packets,
- *  reset link state etc.
+ * lbs_mac_event_disconnected - handles disconnect event. It
+ * reports disconnect to upper layer, clean tx/rx packets,
+ * reset link state etc.
+ *
+ * @priv:	A pointer to struct lbs_private structure
  *
- *  @param priv    A pointer to struct lbs_private structure
- *  @return 	   n/a
+ * returns:	n/a
  */
 void lbs_mac_event_disconnected(struct lbs_private *priv)
 {
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/debugfs.c
+++ lnx-2639-rc4/drivers/net/wireless/libertas/debugfs.c
@@ -849,15 +849,14 @@ static struct debug_data items[] = {
 static int num_of_items = ARRAY_SIZE(items);
 
 /**
- *  @brief proc read function
+ * lbs_debugfs_read - proc read function
  *
- *  @param page	   pointer to buffer
- *  @param s       read data starting position
- *  @param off     offset
- *  @param cnt     counter
- *  @param eof     end of file flag
- *  @param data    data to output
- *  @return 	   number of output data
+ * @file:	file to read
+ * @userbuf:	pointer to buffer
+ * @count:	number of bytes to read
+ * @ppos:	read data starting position
+ *
+ * returns:	amount of data read or negative error code
  */
 static ssize_t lbs_debugfs_read(struct file *file, char __user *userbuf,
 			size_t count, loff_t *ppos)
@@ -897,13 +896,14 @@ static ssize_t lbs_debugfs_read(struct f
 }
 
 /**
- *  @brief proc write function
+ * lbs_debugfs_write - proc write function
+ *
+ * @f:		file pointer
+ * @buf:	pointer to data buffer
+ * @cnt:	data number to write
+ * @ppos:	file position
  *
- *  @param f	   file pointer
- *  @param buf     pointer to data buffer
- *  @param cnt     data number to write
- *  @param data    data to write
- *  @return 	   number of data
+ * returns:	amount of data written
  */
 static ssize_t lbs_debugfs_write(struct file *f, const char __user *buf,
 			    size_t cnt, loff_t *ppos)
@@ -966,11 +966,11 @@ static const struct file_operations lbs_
 };
 
 /**
- *  @brief create debug proc file
+ * lbs_debug_init - create debug proc file
+ *
+ * @priv:	pointer to &struct lbs_private
  *
- *  @param priv	   pointer struct lbs_private
- *  @param dev     pointer net_device
- *  @return 	   N/A
+ * returns:	N/A
  */
 static void lbs_debug_init(struct lbs_private *priv)
 {
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/ethtool.c
+++ lnx-2639-rc4/drivers/net/wireless/libertas/ethtool.c
@@ -20,7 +20,8 @@ static void lbs_ethtool_get_drvinfo(stru
 	strcpy(info->version, lbs_driver_version);
 }
 
-/* All 8388 parts have 16KiB EEPROM size at the time of writing.
+/*
+ * All 8388 parts have 16KiB EEPROM size at the time of writing.
  * In case that changes this needs fixing.
  */
 #define LBS_EEPROM_LEN 16384
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/if_cs.c
+++ lnx-2639-rc4/drivers/net/wireless/libertas/if_cs.c
@@ -312,7 +312,8 @@ static int if_cs_poll_while_fw_download(
 #define CF8385_MANFID		0x02df
 #define CF8385_CARDID		0x8103
 
-/* FIXME: just use the 'driver_info' field of 'struct pcmcia_device_id' when
+/*
+ * FIXME: just use the 'driver_info' field of 'struct pcmcia_device_id' when
  * that gets fixed.  Currently there's no way to access it from the probe hook.
  */
 static inline u32 get_model(u16 manf_id, u16 card_id)
@@ -621,8 +622,10 @@ static int if_cs_prog_helper(struct if_c
 		if (remain < count)
 			count = remain;
 
-		/* "write the number of bytes to be sent to the I/O Command
-		 * write length register" */
+		/*
+		 * "write the number of bytes to be sent to the I/O Command
+		 * write length register"
+		 */
 		if_cs_write16(card, IF_CS_CMD_LEN, count);
 
 		/* "write this to I/O Command port register as 16 bit writes */
@@ -631,16 +634,22 @@ static int if_cs_prog_helper(struct if_c
 				&fw->data[sent],
 				count >> 1);
 
-		/* "Assert the download over interrupt command in the Host
-		 * status register" */
+		/*
+		 * "Assert the download over interrupt command in the Host
+		 * status register"
+		 */
 		if_cs_write8(card, IF_CS_HOST_STATUS, IF_CS_BIT_COMMAND);
 
-		/* "Assert the download over interrupt command in the Card
-		 * interrupt case register" */
+		/*
+		 * "Assert the download over interrupt command in the Card
+		 * interrupt case register"
+		 */
 		if_cs_write16(card, IF_CS_HOST_INT_CAUSE, IF_CS_BIT_COMMAND);
 
-		/* "The host polls the Card Status register ... for 50 ms before
-		   declaring a failure */
+		/*
+		 * "The host polls the Card Status register ... for 50 ms before
+		 * declaring a failure"
+		 */
 		ret = if_cs_poll_while_fw_download(card, IF_CS_CARD_STATUS,
 			IF_CS_BIT_COMMAND);
 		if (ret < 0) {
@@ -841,7 +850,7 @@ static int if_cs_probe(struct pcmcia_dev
 
 	/*
 	 * Most of the libertas cards can do unaligned register access, but some
-	 * weird ones can not. That's especially true for the CF8305 card.
+	 * weird ones cannot. That's especially true for the CF8305 card.
 	 */
 	card->align_regs = 0;
 
@@ -913,8 +922,10 @@ static int if_cs_probe(struct pcmcia_dev
 		goto out3;
 	}
 
-	/* Clear any interrupt cause that happened while sending
-	 * firmware/initializing card */
+	/*
+	 * Clear any interrupt cause that happened while sending
+	 * firmware/initializing card
+	 */
 	if_cs_write16(card, IF_CS_CARD_INT_CAUSE, IF_CS_BIT_MASK);
 	if_cs_enable_ints(card);
 
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/if_spi.c
+++ lnx-2639-rc4/drivers/net/wireless/libertas/if_spi.c
@@ -139,8 +139,10 @@ static void spu_transaction_finish(struc
 	card->prev_xfer_time = jiffies;
 }
 
-/* Write out a byte buffer to an SPI register,
- * using a series of 16-bit transfers. */
+/*
+ * Write out a byte buffer to an SPI register,
+ * using a series of 16-bit transfers.
+ */
 static int spu_write(struct if_spi_card *card, u16 reg, const u8 *buf, int len)
 {
 	int err = 0;
@@ -204,8 +206,10 @@ static int spu_read(struct if_spi_card *
 	struct spi_transfer dummy_trans;
 	struct spi_transfer data_trans;
 
-	/* You must take an even number of bytes from the SPU, even if you
-	 * don't care about the last one.  */
+	/*
+	 * You must take an even number of bytes from the SPU, even if you
+	 * don't care about the last one.
+	 */
 	BUG_ON(len & 0x1);
 
 	spu_transaction_init(card);
@@ -254,8 +258,10 @@ static inline int spu_read_u16(struct if
 	return ret;
 }
 
-/* Read 32 bits from an SPI register.
- * The low 16 bits are read first. */
+/*
+ * Read 32 bits from an SPI register.
+ * The low 16 bits are read first.
+ */
 static int spu_read_u32(struct if_spi_card *card, u16 reg, u32 *val)
 {
 	__le32 buf;
@@ -267,13 +273,15 @@ static int spu_read_u32(struct if_spi_ca
 	return err;
 }
 
-/* Keep reading 16 bits from an SPI register until you get the correct result.
+/*
+ * Keep reading 16 bits from an SPI register until you get the correct result.
  *
  * If mask = 0, the correct result is any non-zero number.
  * If mask != 0, the correct result is any number where
  * number & target_mask == target
  *
- * Returns -ETIMEDOUT if a second passes without the correct result. */
+ * Returns -ETIMEDOUT if a second passes without the correct result.
+ */
 static int spu_wait_for_u16(struct if_spi_card *card, u16 reg,
 			u16 target_mask, u16 target)
 {
@@ -301,8 +309,10 @@ static int spu_wait_for_u16(struct if_sp
 	}
 }
 
-/* Read 16 bits from an SPI register until you receive a specific value.
- * Returns -ETIMEDOUT if a 4 tries pass without success. */
+/*
+ * Read 16 bits from an SPI register until you receive a specific value.
+ * Returns -ETIMEDOUT if a 4 tries pass without success.
+ */
 static int spu_wait_for_u32(struct if_spi_card *card, u32 reg, u32 target)
 {
 	int err, try;
@@ -324,8 +334,10 @@ static int spu_set_interrupt_mode(struct
 {
 	int err = 0;
 
-	/* We can suppress a host interrupt by clearing the appropriate
-	 * bit in the "host interrupt status mask" register */
+	/*
+	 * We can suppress a host interrupt by clearing the appropriate
+	 * bit in the "host interrupt status mask" register
+	 */
 	if (suppress_host_int) {
 		err = spu_write_u16(card, IF_SPI_HOST_INT_STATUS_MASK_REG, 0);
 		if (err)
@@ -341,10 +353,12 @@ static int spu_set_interrupt_mode(struct
 			return err;
 	}
 
-	/* If auto-interrupts are on, the completion of certain transactions
+	/*
+	 * If auto-interrupts are on, the completion of certain transactions
 	 * will trigger an interrupt automatically. If auto-interrupts
 	 * are off, we need to set the "Card Interrupt Cause" register to
-	 * trigger a card interrupt. */
+	 * trigger a card interrupt.
+	 */
 	if (auto_int) {
 		err = spu_write_u16(card, IF_SPI_HOST_INT_CTRL_REG,
 				IF_SPI_HICT_TX_DOWNLOAD_OVER_AUTO |
@@ -398,8 +412,10 @@ static int spu_init(struct if_spi_card *
 	int err = 0;
 	u32 delay;
 
-	/* We have to start up in timed delay mode so that we can safely
-	 * read the Delay Read Register. */
+	/*
+	 * We have to start up in timed delay mode so that we can safely
+	 * read the Delay Read Register.
+	 */
 	card->use_dummy_writes = 0;
 	err = spu_set_bus_mode(card,
 				IF_SPI_BUS_MODE_SPI_CLOCK_PHASE_RISING |
@@ -455,8 +471,10 @@ static int if_spi_prog_helper_firmware(s
 
 	/* Load helper firmware image */
 	while (bytes_remaining > 0) {
-		/* Scratch pad 1 should contain the number of bytes we
-		 * want to download to the firmware */
+		/*
+		 * Scratch pad 1 should contain the number of bytes we
+		 * want to download to the firmware
+		 */
 		err = spu_write_u16(card, IF_SPI_SCRATCH_1_REG,
 					HELPER_FW_LOAD_CHUNK_SZ);
 		if (err)
@@ -468,8 +486,10 @@ static int if_spi_prog_helper_firmware(s
 		if (err)
 			goto out;
 
-		/* Feed the data into the command read/write port reg
-		 * in chunks of 64 bytes */
+		/*
+		 * Feed the data into the command read/write port reg
+		 * in chunks of 64 bytes
+		 */
 		memset(temp, 0, sizeof(temp));
 		memcpy(temp, fw,
 		       min(bytes_remaining, HELPER_FW_LOAD_CHUNK_SZ));
@@ -491,9 +511,11 @@ static int if_spi_prog_helper_firmware(s
 		fw += HELPER_FW_LOAD_CHUNK_SZ;
 	}
 
-	/* Once the helper / single stage firmware download is complete,
+	/*
+	 * Once the helper / single stage firmware download is complete,
 	 * write 0 to scratch pad 1 and interrupt the
-	 * bootloader. This completes the helper download. */
+	 * bootloader. This completes the helper download.
+	 */
 	err = spu_write_u16(card, IF_SPI_SCRATCH_1_REG, FIRMWARE_DNLD_OK);
 	if (err)
 		goto out;
@@ -513,16 +535,20 @@ out:
 	return err;
 }
 
-/* Returns the length of the next packet the firmware expects us to send
- * Sets crc_err if the previous transfer had a CRC error. */
+/*
+ * Returns the length of the next packet the firmware expects us to send.
+ * Sets crc_err if the previous transfer had a CRC error.
+ */
 static int if_spi_prog_main_firmware_check_len(struct if_spi_card *card,
 						int *crc_err)
 {
 	u16 len;
 	int err = 0;
 
-	/* wait until the host interrupt status register indicates
-	 * that we are ready to download */
+	/*
+	 * wait until the host interrupt status register indicates
+	 * that we are ready to download
+	 */
 	err = spu_wait_for_u16(card, IF_SPI_HOST_INT_STATUS_REG,
 				IF_SPI_HIST_CMD_DOWNLOAD_RDY,
 				IF_SPI_HIST_CMD_DOWNLOAD_RDY);
@@ -583,8 +609,10 @@ static int if_spi_prog_main_firmware(str
 			goto out;
 		}
 		if (bytes < 0) {
-			/* If there are no more bytes left, we would normally
-			 * expect to have terminated with len = 0 */
+			/*
+			 * If there are no more bytes left, we would normally
+			 * expect to have terminated with len = 0
+			 */
 			lbs_pr_err("Firmware load wants more bytes "
 				   "than we have to offer.\n");
 			break;
@@ -656,14 +684,18 @@ static int if_spi_c2h_cmd(struct if_spi_
 	u16 len;
 	u8 i;
 
-	/* We need a buffer big enough to handle whatever people send to
-	 * hw_host_to_card */
+	/*
+	 * We need a buffer big enough to handle whatever people send to
+	 * hw_host_to_card
+	 */
 	BUILD_BUG_ON(IF_SPI_CMD_BUF_SIZE < LBS_CMD_BUFFER_SIZE);
 	BUILD_BUG_ON(IF_SPI_CMD_BUF_SIZE < LBS_UPLD_SIZE);
 
-	/* It's just annoying if the buffer size isn't a multiple of 4, because
-	 * then we might have len <  IF_SPI_CMD_BUF_SIZE but
-	 * ALIGN(len, 4) > IF_SPI_CMD_BUF_SIZE */
+	/*
+	 * It's just annoying if the buffer size isn't a multiple of 4, because
+	 * then we might have len < IF_SPI_CMD_BUF_SIZE but
+	 * ALIGN(len, 4) > IF_SPI_CMD_BUF_SIZE
+	 */
 	BUILD_BUG_ON(IF_SPI_CMD_BUF_SIZE % 4 != 0);
 
 	lbs_deb_enter(LBS_DEB_SPI);
@@ -834,8 +866,10 @@ static void if_spi_host_to_card_worker(s
 
 	lbs_deb_enter(LBS_DEB_SPI);
 
-	/* Read the host interrupt status register to see what we
-	 * can do. */
+	/*
+	 * Read the host interrupt status register to see what we
+	 * can do.
+	 */
 	err = spu_read_u16(card, IF_SPI_HOST_INT_STATUS_REG,
 				&hiStatus);
 	if (err) {
@@ -854,12 +888,15 @@ static void if_spi_host_to_card_worker(s
 			goto err;
 	}
 
-	/* workaround: in PS mode, the card does not set the Command
-	 * Download Ready bit, but it sets TX Download Ready. */
+	/*
+	 * workaround: in PS mode, the card does not set the Command
+	 * Download Ready bit, but it sets TX Download Ready.
+	 */
 	if (hiStatus & IF_SPI_HIST_CMD_DOWNLOAD_RDY ||
 	   (card->priv->psstate != PS_STATE_FULL_POWER &&
 	    (hiStatus & IF_SPI_HIST_TX_DOWNLOAD_RDY))) {
-		/* This means two things. First of all,
+		/*
+		 * This means two things. First of all,
 		 * if there was a previous command sent, the card has
 		 * successfully received it.
 		 * Secondly, it is now ready to download another
@@ -867,8 +904,7 @@ static void if_spi_host_to_card_worker(s
 		 */
 		lbs_host_to_card_done(card->priv);
 
-		/* Do we have any command packets from the host to
-		 * send? */
+		/* Do we have any command packets from the host to send? */
 		packet = NULL;
 		spin_lock_irqsave(&card->buffer_lock, flags);
 		if (!list_empty(&card->cmd_packet_list)) {
@@ -882,8 +918,7 @@ static void if_spi_host_to_card_worker(s
 			if_spi_h2c(card, packet, MVMS_CMD);
 	}
 	if (hiStatus & IF_SPI_HIST_TX_DOWNLOAD_RDY) {
-		/* Do we have any data packets from the host to
-		 * send? */
+		/* Do we have any data packets from the host to send? */
 		packet = NULL;
 		spin_lock_irqsave(&card->buffer_lock, flags);
 		if (!list_empty(&card->data_packet_list)) {
@@ -910,7 +945,8 @@ err:
  * Host to Card
  *
  * Called from Libertas to transfer some data to the WLAN device
- * We can't sleep here. */
+ * We can't sleep here.
+ */
 static int if_spi_host_to_card(struct lbs_private *priv,
 				u8 type, u8 *buf, u16 nb)
 {
@@ -1099,8 +1135,10 @@ static int __devinit if_spi_probe(struct
 	if (err)
 		goto free_card;
 
-	/* Register our card with libertas.
-	 * This will call alloc_etherdev */
+	/*
+	 * Register our card with libertas.
+	 * This will call alloc_etherdev.
+	 */
 	priv = lbs_add_card(card, &spi->dev);
 	if (!priv) {
 		err = -ENOMEM;
@@ -1125,9 +1163,11 @@ static int __devinit if_spi_probe(struct
 		goto terminate_workqueue;
 	}
 
-	/* Start the card.
+	/*
+	 * Start the card.
 	 * This will call register_netdev, and we'll start
-	 * getting interrupts... */
+	 * getting interrupts...
+	 */
 	err = lbs_start_card(priv);
 	if (err)
 		goto release_irq;
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/if_usb.c
+++ lnx-2639-rc4/drivers/net/wireless/libertas/if_usb.c
@@ -1,6 +1,6 @@
-/**
-  * This file contains functions used in USB interface module.
-  */
+/*
+ * This file contains functions used in USB interface module.
+ */
 #include <linux/delay.h>
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
@@ -66,7 +66,7 @@ static int if_usb_reset_device(struct if
 
 /* sysfs hooks */
 
-/**
+/*
  *  Set function to write firmware to device's persistent memory
  */
 static ssize_t if_usb_firmware_set(struct device *dev,
@@ -85,7 +85,7 @@ static ssize_t if_usb_firmware_set(struc
 	return ret;
 }
 
-/**
+/*
  * lbs_flash_fw attribute to be exported per ethX interface through sysfs
  * (/sys/class/net/ethX/lbs_flash_fw).  Use this like so to write firmware to
  * the device's persistent memory:
@@ -94,7 +94,14 @@ static ssize_t if_usb_firmware_set(struc
 static DEVICE_ATTR(lbs_flash_fw, 0200, NULL, if_usb_firmware_set);
 
 /**
- *  Set function to write firmware to device's persistent memory
+ * if_usb_boot2_set - write firmware to device's persistent memory
+ *
+ * @dev: target device
+ * @attr: device attributes
+ * @buf: firmware buffer to write
+ * @count: number of bytes to write
+ *
+ * returns: number of bytes written or negative error code
  */
 static ssize_t if_usb_boot2_set(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
@@ -112,7 +119,7 @@ static ssize_t if_usb_boot2_set(struct d
 	return ret;
 }
 
-/**
+/*
  * lbs_flash_boot2 attribute to be exported per ethX interface through sysfs
  * (/sys/class/net/ethX/lbs_flash_boot2).  Use this like so to write firmware
  * to the device's persistent memory:
@@ -121,9 +128,10 @@ static ssize_t if_usb_boot2_set(struct d
 static DEVICE_ATTR(lbs_flash_boot2, 0200, NULL, if_usb_boot2_set);
 
 /**
- *  @brief  call back function to handle the status of the URB
- *  @param urb 		pointer to urb structure
- *  @return 	   	N/A
+ * if_usb_write_bulk_callback - callback function to handle the status
+ * of the URB
+ * @urb:	pointer to &urb structure
+ * returns:	N/A
  */
 static void if_usb_write_bulk_callback(struct urb *urb)
 {
@@ -150,9 +158,9 @@ static void if_usb_write_bulk_callback(s
 }
 
 /**
- *  @brief  free tx/rx urb, skb and rx buffer
- *  @param cardp	pointer if_usb_card
- *  @return 	   	N/A
+ * if_usb_free - free tx/rx urb, skb and rx buffer
+ * @cardp:	pointer to &if_usb_card
+ * returns:	N/A
  */
 static void if_usb_free(struct if_usb_card *cardp)
 {
@@ -231,10 +239,10 @@ static void if_usb_reset_olpc_card(struc
 #endif
 
 /**
- *  @brief sets the configuration values
- *  @param ifnum	interface number
- *  @param id		pointer to usb_device_id
- *  @return 	   	0 on success, error code on failure
+ * if_usb_probe - sets the configuration values
+ * @intf:	&usb_interface pointer
+ * @id:	pointer to usb_device_id
+ * returns:	0 on success, error code on failure
  */
 static int if_usb_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
@@ -366,9 +374,9 @@ error:
 }
 
 /**
- *  @brief free resource and cleanup
- *  @param intf		USB interface structure
- *  @return 	   	N/A
+ * if_usb_disconnect - free resource and cleanup
+ * @intf:	USB interface structure
+ * returns:	N/A
  */
 static void if_usb_disconnect(struct usb_interface *intf)
 {
@@ -398,9 +406,9 @@ static void if_usb_disconnect(struct usb
 }
 
 /**
- *  @brief  This function download FW
- *  @param priv		pointer to struct lbs_private
- *  @return 	   	0
+ * if_usb_send_fw_pkt - download FW
+ * @cardp:	pointer to &struct if_usb_card
+ * returns:	0
  */
 static int if_usb_send_fw_pkt(struct if_usb_card *cardp)
 {
@@ -486,11 +494,11 @@ static int if_usb_reset_device(struct if
 }
 
 /**
- *  @brief This function transfer the data to the device.
- *  @param priv 	pointer to struct lbs_private
- *  @param payload	pointer to payload data
- *  @param nb		data length
- *  @return 	   	0 or -1
+ *  usb_tx_block - transfer the data to the device
+ *  @cardp: 	pointer to &struct if_usb_card
+ *  @payload:	pointer to payload data
+ *  @nb:	data length
+ *  returns:	0 for success or negative error code
  */
 static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload, uint16_t nb)
 {
@@ -727,11 +735,11 @@ static inline void process_cmdrequest(in
 }
 
 /**
- *  @brief This function reads of the packet into the upload buff,
- *  wake up the main thread and initialise the Rx callack.
+ *  if_usb_receive - read the packet into the upload buffer,
+ *  wake up the main thread and initialise the Rx callack
  *
- *  @param urb		pointer to struct urb
- *  @return 	   	N/A
+ *  @urb:	pointer to &struct urb
+ *  returns:	N/A
  */
 static void if_usb_receive(struct urb *urb)
 {
@@ -802,12 +810,12 @@ rx_exit:
 }
 
 /**
- *  @brief This function downloads data to FW
- *  @param priv		pointer to struct lbs_private structure
- *  @param type		type of data
- *  @param buf		pointer to data buffer
- *  @param len		number of bytes
- *  @return 	   	0 or -1
+ *  if_usb_host_to_card - downloads data to FW
+ *  @priv:	pointer to &struct lbs_private structure
+ *  @type:	type of data
+ *  @payload:	pointer to data buffer
+ *  @nb:	number of bytes
+ *  returns:	0 for success or negative error code
  */
 static int if_usb_host_to_card(struct lbs_private *priv, uint8_t type,
 			       uint8_t *payload, uint16_t nb)
@@ -831,10 +839,11 @@ static int if_usb_host_to_card(struct lb
 }
 
 /**
- *  @brief This function issues Boot command to the Boot2 code
- *  @param ivalue   1:Boot from FW by USB-Download
- *                  2:Boot from FW in EEPROM
- *  @return 	   	0
+ *  if_usb_issue_boot_command - issues Boot command to the Boot2 code
+ *  @cardp:	pointer to &if_usb_card
+ *  @ivalue:	1:Boot from FW by USB-Download
+ *		2:Boot from FW in EEPROM
+ *  returns:	0 for success or negative error code
  */
 static int if_usb_issue_boot_command(struct if_usb_card *cardp, int ivalue)
 {
@@ -853,11 +862,11 @@ static int if_usb_issue_boot_command(str
 
 
 /**
- *  @brief This function checks the validity of Boot2/FW image.
+ *  check_fwfile_format - check the validity of Boot2/FW image
  *
- *  @param data              pointer to image
- *         len               image length
- *  @return     0 or -1
+ *  @data:	pointer to image
+ *  @totlen:	image length
+ *  returns:     0 (good) or 1 (failure)
  */
 static int check_fwfile_format(const uint8_t *data, uint32_t totlen)
 {
@@ -901,13 +910,13 @@ static int check_fwfile_format(const uin
 
 
 /**
-*  @brief This function programs the firmware subject to cmd
+*  if_usb_prog_firmware - programs the firmware subject to cmd
 *
-*  @param cardp             the if_usb_card descriptor
-*         fwname            firmware or boot2 image file name
-*         cmd               either BOOT_CMD_FW_BY_USB, BOOT_CMD_UPDATE_FW,
-*                           or BOOT_CMD_UPDATE_BOOT2.
-*  @return     0 or error code
+*  @cardp:	the if_usb_card descriptor
+*  @fwname:	firmware or boot2 image file name
+*  @cmd:	either BOOT_CMD_FW_BY_USB, BOOT_CMD_UPDATE_FW,
+*		or BOOT_CMD_UPDATE_BOOT2.
+*  returns:	0 or error code
 */
 static int if_usb_prog_firmware(struct if_usb_card *cardp,
 				const char *fwname, int cmd)
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/main.c
+++ lnx-2639-rc4/drivers/net/wireless/libertas/main.c
@@ -1,8 +1,8 @@
-/**
-  * This file contains the major functions in WLAN
-  * driver. It includes init, exit, open, close and main
-  * thread etc..
-  */
+/*
+ * This file contains the major functions in WLAN
+ * driver. It includes init, exit, open, close and main
+ * thread etc..
+ */
 
 #include <linux/moduleparam.h>
 #include <linux/delay.h>
@@ -35,18 +35,20 @@ EXPORT_SYMBOL_GPL(lbs_debug);
 module_param_named(libertas_debug, lbs_debug, int, 0644);
 
 
-/* This global structure is used to send the confirm_sleep command as
- * fast as possible down to the firmware. */
+/*
+ * This global structure is used to send the confirm_sleep command as
+ * fast as possible down to the firmware.
+ */
 struct cmd_confirm_sleep confirm_sleep;
 
 
-/**
+/*
  * the table to keep region code
  */
 u16 lbs_region_code_to_index[MRVDRV_MAX_REGION_CODE] =
     { 0x10, 0x20, 0x30, 0x31, 0x32, 0x40 };
 
-/**
+/*
  * FW rate table.  FW refers to rates by their index in this table, not by the
  * rate value itself.  Values of 0x00 are
  * reserved positions.
@@ -57,10 +59,10 @@ static u8 fw_data_rates[MAX_RATES] =
 };
 
 /**
- *  @brief use index to get the data rate
+ *  lbs_fw_index_to_data_rate - use index to get the data rate
  *
- *  @param idx                The index of data rate
- *  @return 	   		data rate or 0
+ *  @idx:	The index of data rate
+ *  returns:	data rate or 0
  */
 u32 lbs_fw_index_to_data_rate(u8 idx)
 {
@@ -70,10 +72,10 @@ u32 lbs_fw_index_to_data_rate(u8 idx)
 }
 
 /**
- *  @brief use rate to get the index
+ *  lbs_data_rate_to_fw_index - use rate to get the index
  *
- *  @param rate                 data rate
- *  @return 	   		index or 0
+ *  @rate:	data rate
+ *  returns:	index or 0
  */
 u8 lbs_data_rate_to_fw_index(u32 rate)
 {
@@ -91,10 +93,10 @@ u8 lbs_data_rate_to_fw_index(u32 rate)
 
 
 /**
- *  @brief This function opens the ethX interface
+ *  lbs_dev_open - open the ethX interface
  *
- *  @param dev     A pointer to net_device structure
- *  @return 	   0 or -EBUSY if monitor mode active
+ *  @dev:	A pointer to &net_device structure
+ *  returns:	0 or -EBUSY if monitor mode active
  */
 static int lbs_dev_open(struct net_device *dev)
 {
@@ -120,10 +122,10 @@ static int lbs_dev_open(struct net_devic
 }
 
 /**
- *  @brief This function closes the ethX interface
+ *  lbs_eth_stop - close the ethX interface
  *
- *  @param dev     A pointer to net_device structure
- *  @return 	   0
+ *  @dev:	A pointer to &net_device structure
+ *  returns:	0
  */
 static int lbs_eth_stop(struct net_device *dev)
 {
@@ -336,12 +338,12 @@ void lbs_set_multicast_list(struct net_d
 }
 
 /**
- *  @brief This function handles the major jobs in the LBS driver.
+ *  lbs_thread - handles the major jobs in the LBS driver.
  *  It handles all events generated by firmware, RX data received
  *  from firmware and TX data sent from kernel.
  *
- *  @param data    A pointer to lbs_thread structure
- *  @return 	   0
+ *  @data:	A pointer to &lbs_thread structure
+ *  returns:	0
  */
 static int lbs_thread(void *data)
 {
@@ -540,11 +542,11 @@ static int lbs_thread(void *data)
 }
 
 /**
- * @brief This function gets the HW spec from the firmware and sets
- *        some basic parameters.
+ * lbs_setup_firmware - gets the HW spec from the firmware and sets
+ *        some basic parameters
  *
- *  @param priv    A pointer to struct lbs_private structure
- *  @return        0 or -1
+ *  @priv:	A pointer to &struct lbs_private structure
+ *  returns:	0 or -1
  */
 static int lbs_setup_firmware(struct lbs_private *priv)
 {
@@ -630,8 +632,10 @@ int lbs_resume(struct lbs_private *priv)
 EXPORT_SYMBOL_GPL(lbs_resume);
 
 /**
- *  This function handles the timeout of command sending.
- *  It will re-send the same command again.
+ * lbs_cmd_timeout_handler - handles the timeout of command sending.
+ * It will re-send the same command again.
+ *
+ * @data: &struct lbs_private pointer
  */
 static void lbs_cmd_timeout_handler(unsigned long data)
 {
@@ -655,8 +659,10 @@ out:
 }
 
 /**
- *  This function put the device back to deep sleep mode when timer expires
- *  and no activity (command, event, data etc.) is detected.
+ * auto_deepsleep_timer_fn - put the device back to deep sleep mode when
+ * timer expires and no activity (command, event, data etc.) is detected.
+ * @data:	&struct lbs_private pointer
+ * returns:	N/A
  */
 static void auto_deepsleep_timer_fn(unsigned long data)
 {
@@ -792,11 +798,12 @@ static const struct net_device_ops lbs_n
 };
 
 /**
- * @brief This function adds the card. it will probe the
+ * lbs_add_card - adds the card. It will probe the
  * card, allocate the lbs_priv and initialize the device.
  *
- *  @param card    A pointer to card
- *  @return 	   A pointer to struct lbs_private structure
+ * @card:	A pointer to card
+ * @dmdev:	A pointer to &struct device
+ * returns:	A pointer to &struct lbs_private structure
  */
 struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
 {
@@ -1057,19 +1064,19 @@ void lbs_notify_command_response(struct 
 EXPORT_SYMBOL_GPL(lbs_notify_command_response);
 
 /**
- *  @brief Retrieves two-stage firmware
+ *  lbs_get_firmware - Retrieves two-stage firmware
  *
- *  @param dev     	A pointer to device structure
- *  @param user_helper	User-defined helper firmware file
- *  @param user_mainfw	User-defined main firmware file
- *  @param card_model	Bus-specific card model ID used to filter firmware table
- *                         elements
- *  @param fw_table	Table of firmware file names and device model numbers
- *                         terminated by an entry with a NULL helper name
- *  @param helper	On success, the helper firmware; caller must free
- *  @param mainfw	On success, the main firmware; caller must free
+ *  @dev:     	A pointer to &device structure
+ *  @user_helper: User-defined helper firmware file
+ *  @user_mainfw: User-defined main firmware file
+ *  @card_model: Bus-specific card model ID used to filter firmware table
+ *		elements
+ *  @fw_table:	Table of firmware file names and device model numbers
+ *		terminated by an entry with a NULL helper name
+ *  @helper:	On success, the helper firmware; caller must free
+ *  @mainfw:	On success, the main firmware; caller must free
  *
- *  @return		0 on success, non-zero on failure
+ *  returns:		0 on success, non-zero on failure
  */
 int lbs_get_firmware(struct device *dev, const char *user_helper,
 			const char *user_mainfw, u32 card_model,
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/mesh.c
+++ lnx-2639-rc4/drivers/net/wireless/libertas/mesh.c
@@ -16,12 +16,15 @@
  * Mesh sysfs support
  */
 
-/**
+/*
  * Attributes exported through sysfs
  */
 
 /**
- * @brief Get function for sysfs attribute anycast_mask
+ * lbs_anycast_get - Get function for sysfs attribute anycast_mask
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer where data will be returned
  */
 static ssize_t lbs_anycast_get(struct device *dev,
 		struct device_attribute *attr, char * buf)
@@ -40,7 +43,11 @@ static ssize_t lbs_anycast_get(struct de
 }
 
 /**
- * @brief Set function for sysfs attribute anycast_mask
+ * lbs_anycast_set - Set function for sysfs attribute anycast_mask
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer that contains new attribute value
+ * @count: size of buffer
  */
 static ssize_t lbs_anycast_set(struct device *dev,
 		struct device_attribute *attr, const char * buf, size_t count)
@@ -62,7 +69,10 @@ static ssize_t lbs_anycast_set(struct de
 }
 
 /**
- * @brief Get function for sysfs attribute prb_rsp_limit
+ * lbs_prb_rsp_limit_get - Get function for sysfs attribute prb_rsp_limit
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer where data will be returned
  */
 static ssize_t lbs_prb_rsp_limit_get(struct device *dev,
 		struct device_attribute *attr, char *buf)
@@ -85,7 +95,11 @@ static ssize_t lbs_prb_rsp_limit_get(str
 }
 
 /**
- * @brief Set function for sysfs attribute prb_rsp_limit
+ * lbs_prb_rsp_limit_set - Set function for sysfs attribute prb_rsp_limit
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer that contains new attribute value
+ * @count: size of buffer
  */
 static ssize_t lbs_prb_rsp_limit_set(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
@@ -114,7 +128,10 @@ static ssize_t lbs_prb_rsp_limit_set(str
 }
 
 /**
- * Get function for sysfs attribute mesh
+ * lbs_mesh_get - Get function for sysfs attribute mesh
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer where data will be returned
  */
 static ssize_t lbs_mesh_get(struct device *dev,
 		struct device_attribute *attr, char * buf)
@@ -124,7 +141,11 @@ static ssize_t lbs_mesh_get(struct devic
 }
 
 /**
- *  Set function for sysfs attribute mesh
+ * lbs_mesh_set - Set function for sysfs attribute mesh
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer that contains new attribute value
+ * @count: size of buffer
  */
 static ssize_t lbs_mesh_set(struct device *dev,
 		struct device_attribute *attr, const char * buf, size_t count)
@@ -151,19 +172,19 @@ static ssize_t lbs_mesh_set(struct devic
 	return count;
 }
 
-/**
+/*
  * lbs_mesh attribute to be exported per ethX interface
  * through sysfs (/sys/class/net/ethX/lbs_mesh)
  */
 static DEVICE_ATTR(lbs_mesh, 0644, lbs_mesh_get, lbs_mesh_set);
 
-/**
+/*
  * anycast_mask attribute to be exported per mshX interface
  * through sysfs (/sys/class/net/mshX/anycast_mask)
  */
 static DEVICE_ATTR(anycast_mask, 0644, lbs_anycast_get, lbs_anycast_set);
 
-/**
+/*
  * prb_rsp_limit attribute to be exported per mshX interface
  * through sysfs (/sys/class/net/mshX/prb_rsp_limit)
  */
@@ -274,10 +295,10 @@ int lbs_deinit_mesh(struct lbs_private *
 
 
 /**
- *  @brief This function closes the mshX interface
+ * lbs_mesh_stop - close the mshX interface
  *
- *  @param dev     A pointer to net_device structure
- *  @return 	   0
+ * @dev:	A pointer to &net_device structure
+ * returns:	0
  */
 static int lbs_mesh_stop(struct net_device *dev)
 {
@@ -301,10 +322,10 @@ static int lbs_mesh_stop(struct net_devi
 }
 
 /**
- *  @brief This function opens the mshX interface
+ * lbs_mesh_dev_open - open the mshX interface
  *
- *  @param dev     A pointer to net_device structure
- *  @return 	   0 or -EBUSY if monitor mode active
+ * @dev:	A pointer to &net_device structure
+ * returns:	0 or -EBUSY if monitor mode active
  */
 static int lbs_mesh_dev_open(struct net_device *dev)
 {
@@ -342,10 +363,10 @@ static const struct net_device_ops mesh_
 };
 
 /**
- * @brief This function adds mshX interface
+ * lbs_add_mesh - add mshX interface
  *
- *  @param priv    A pointer to the struct lbs_private structure
- *  @return 	   0 if successful, -X otherwise
+ * @priv:	A pointer to the &struct lbs_private structure
+ * returns:	0 if successful, -X otherwise
  */
 int lbs_add_mesh(struct lbs_private *priv)
 {
@@ -456,13 +477,13 @@ void lbs_mesh_set_txpd(struct lbs_privat
  */
 
 /**
- *  @brief Add or delete Mesh Blinding Table entries
+ * lbs_mesh_bt_add_del - Add or delete Mesh Blinding Table entries
  *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param add  	TRUE to add the entry, FALSE to delete it
- *  @param addr1        Destination address to blind or unblind
+ * @priv:	A pointer to &struct lbs_private structure
+ * @add:	TRUE to add the entry, FALSE to delete it
+ * @addr1:	Destination address to blind or unblind
  *
- *  @return 	   	0 on success, error on failure
+ * returns:	0 on success, error on failure
  */
 int lbs_mesh_bt_add_del(struct lbs_private *priv, bool add, u8 *addr1)
 {
@@ -493,11 +514,11 @@ int lbs_mesh_bt_add_del(struct lbs_priva
 }
 
 /**
- *  @brief Reset/clear the mesh blinding table
+ * lbs_mesh_bt_reset - Reset/clear the mesh blinding table
  *
- *  @param priv    	A pointer to struct lbs_private structure
+ * @priv:	A pointer to &struct lbs_private structure
  *
- *  @return 	   	0 on success, error on failure
+ * returns:	0 on success, error on failure
  */
 int lbs_mesh_bt_reset(struct lbs_private *priv)
 {
@@ -517,17 +538,18 @@ int lbs_mesh_bt_reset(struct lbs_private
 }
 
 /**
- *  @brief Gets the inverted status of the mesh blinding table
+ * lbs_mesh_bt_get_inverted - Gets the inverted status of the mesh
+ * blinding table
  *
- *  Normally the firmware "blinds" or ignores traffic from mesh nodes in the
- *  table, but an inverted table allows *only* traffic from nodes listed in
- *  the table.
+ * Normally the firmware "blinds" or ignores traffic from mesh nodes in the
+ * table, but an inverted table allows *only* traffic from nodes listed in
+ * the table.
  *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param invert  	On success, TRUE if the blinding table is inverted,
- *                        FALSE if it is not inverted
+ * @priv:	A pointer to &struct lbs_private structure
+ * @inverted:  	On success, TRUE if the blinding table is inverted,
+ *		FALSE if it is not inverted
  *
- *  @return 	   	0 on success, error on failure
+ * returns:	0 on success, error on failure
  */
 int lbs_mesh_bt_get_inverted(struct lbs_private *priv, bool *inverted)
 {
@@ -551,18 +573,19 @@ int lbs_mesh_bt_get_inverted(struct lbs_
 }
 
 /**
- *  @brief Sets the inverted status of the mesh blinding table
+ * lbs_mesh_bt_set_inverted - Sets the inverted status of the mesh
+ * blinding table
  *
- *  Normally the firmware "blinds" or ignores traffic from mesh nodes in the
- *  table, but an inverted table allows *only* traffic from nodes listed in
- *  the table.
+ * Normally the firmware "blinds" or ignores traffic from mesh nodes in the
+ * table, but an inverted table allows *only* traffic from nodes listed in
+ * the table.
  *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param invert  	TRUE to invert the blinding table (only traffic from
- *                         listed nodes allowed), FALSE to return it
- *                         to normal state (listed nodes ignored)
+ * @priv:	A pointer to &struct lbs_private structure
+ * @inverted:	TRUE to invert the blinding table (only traffic from
+ *		listed nodes allowed), FALSE to return it
+ *		to normal state (listed nodes ignored)
  *
- *  @return 	   	0 on success, error on failure
+ * returns:	0 on success, error on failure
  */
 int lbs_mesh_bt_set_inverted(struct lbs_private *priv, bool inverted)
 {
@@ -583,13 +606,13 @@ int lbs_mesh_bt_set_inverted(struct lbs_
 }
 
 /**
- *  @brief List an entry in the mesh blinding table
+ * lbs_mesh_bt_get_entry - List an entry in the mesh blinding table
  *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param id		The ID of the entry to list
- *  @param addr1	MAC address associated with the table entry
+ * @priv:	A pointer to &struct lbs_private structure
+ * @id:		The ID of the entry to list
+ * @addr1:	MAC address associated with the table entry
  *
- *  @return 	   	0 on success, error on failure
+ * returns: 	   	0 on success, error on failure
  */
 int lbs_mesh_bt_get_entry(struct lbs_private *priv, u32 id, u8 *addr1)
 {
@@ -614,14 +637,14 @@ int lbs_mesh_bt_get_entry(struct lbs_pri
 }
 
 /**
- *  @brief Access the mesh forwarding table
+ * lbs_cmd_fwt_access - Access the mesh forwarding table
  *
- *  @param priv    	A pointer to struct lbs_private structure
- *  @param cmd_action	The forwarding table action to perform
- *  @param cmd		The pre-filled FWT_ACCESS command
+ * @priv:	A pointer to &struct lbs_private structure
+ * @cmd_action:	The forwarding table action to perform
+ * @cmd:	The pre-filled FWT_ACCESS command
  *
- *  @return 	   	0 on success and 'cmd' will be filled with the
- *                        firmware's response
+ * returns:	0 on success and 'cmd' will be filled with the
+ *		firmware's response
  */
 int lbs_cmd_fwt_access(struct lbs_private *priv, u16 cmd_action,
 			struct cmd_ds_fwt_access *cmd)
@@ -774,7 +797,10 @@ static int mesh_get_default_parameters(s
 }
 
 /**
- * @brief Get function for sysfs attribute bootflag
+ * bootflag_get - Get function for sysfs attribute bootflag
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer where data will be returned
  */
 static ssize_t bootflag_get(struct device *dev,
 			    struct device_attribute *attr, char *buf)
@@ -791,7 +817,11 @@ static ssize_t bootflag_get(struct devic
 }
 
 /**
- * @brief Set function for sysfs attribute bootflag
+ * bootflag_set - Set function for sysfs attribute bootflag
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer that contains new attribute value
+ * @count: size of buffer
  */
 static ssize_t bootflag_set(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
@@ -817,7 +847,10 @@ static ssize_t bootflag_set(struct devic
 }
 
 /**
- * @brief Get function for sysfs attribute boottime
+ * boottime_get - Get function for sysfs attribute boottime
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer where data will be returned
  */
 static ssize_t boottime_get(struct device *dev,
 			    struct device_attribute *attr, char *buf)
@@ -834,7 +867,11 @@ static ssize_t boottime_get(struct devic
 }
 
 /**
- * @brief Set function for sysfs attribute boottime
+ * boottime_set - Set function for sysfs attribute boottime
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer that contains new attribute value
+ * @count: size of buffer
  */
 static ssize_t boottime_set(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
@@ -869,7 +906,10 @@ static ssize_t boottime_set(struct devic
 }
 
 /**
- * @brief Get function for sysfs attribute channel
+ * channel_get - Get function for sysfs attribute channel
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer where data will be returned
  */
 static ssize_t channel_get(struct device *dev,
 			   struct device_attribute *attr, char *buf)
@@ -886,7 +926,11 @@ static ssize_t channel_get(struct device
 }
 
 /**
- * @brief Set function for sysfs attribute channel
+ * channel_set - Set function for sysfs attribute channel
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer that contains new attribute value
+ * @count: size of buffer
  */
 static ssize_t channel_set(struct device *dev, struct device_attribute *attr,
 			   const char *buf, size_t count)
@@ -912,7 +956,10 @@ static ssize_t channel_set(struct device
 }
 
 /**
- * @brief Get function for sysfs attribute mesh_id
+ * mesh_id_get - Get function for sysfs attribute mesh_id
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer where data will be returned
  */
 static ssize_t mesh_id_get(struct device *dev, struct device_attribute *attr,
 			   char *buf)
@@ -938,7 +985,11 @@ static ssize_t mesh_id_get(struct device
 }
 
 /**
- * @brief Set function for sysfs attribute mesh_id
+ * mesh_id_set - Set function for sysfs attribute mesh_id
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer that contains new attribute value
+ * @count: size of buffer
  */
 static ssize_t mesh_id_set(struct device *dev, struct device_attribute *attr,
 			   const char *buf, size_t count)
@@ -980,7 +1031,10 @@ static ssize_t mesh_id_set(struct device
 }
 
 /**
- * @brief Get function for sysfs attribute protocol_id
+ * protocol_id_get - Get function for sysfs attribute protocol_id
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer where data will be returned
  */
 static ssize_t protocol_id_get(struct device *dev,
 			       struct device_attribute *attr, char *buf)
@@ -997,7 +1051,11 @@ static ssize_t protocol_id_get(struct de
 }
 
 /**
- * @brief Set function for sysfs attribute protocol_id
+ * protocol_id_set - Set function for sysfs attribute protocol_id
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer that contains new attribute value
+ * @count: size of buffer
  */
 static ssize_t protocol_id_set(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
@@ -1034,7 +1092,10 @@ static ssize_t protocol_id_set(struct de
 }
 
 /**
- * @brief Get function for sysfs attribute metric_id
+ * metric_id_get - Get function for sysfs attribute metric_id
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer where data will be returned
  */
 static ssize_t metric_id_get(struct device *dev,
 		struct device_attribute *attr, char *buf)
@@ -1051,7 +1112,11 @@ static ssize_t metric_id_get(struct devi
 }
 
 /**
- * @brief Set function for sysfs attribute metric_id
+ * metric_id_set - Set function for sysfs attribute metric_id
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer that contains new attribute value
+ * @count: size of buffer
  */
 static ssize_t metric_id_set(struct device *dev, struct device_attribute *attr,
 			     const char *buf, size_t count)
@@ -1088,7 +1153,10 @@ static ssize_t metric_id_set(struct devi
 }
 
 /**
- * @brief Get function for sysfs attribute capability
+ * capability_get - Get function for sysfs attribute capability
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer where data will be returned
  */
 static ssize_t capability_get(struct device *dev,
 		struct device_attribute *attr, char *buf)
@@ -1105,7 +1173,11 @@ static ssize_t capability_get(struct dev
 }
 
 /**
- * @brief Set function for sysfs attribute capability
+ * capability_set - Set function for sysfs attribute capability
+ * @dev: the &struct device
+ * @attr: device attributes
+ * @buf: buffer that contains new attribute value
+ * @count: size of buffer
  */
 static ssize_t capability_set(struct device *dev, struct device_attribute *attr,
 			      const char *buf, size_t count)
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/rx.c
+++ lnx-2639-rc4/drivers/net/wireless/libertas/rx.c
@@ -1,6 +1,6 @@
-/**
-  * This file contains the handling of RX in wlan driver.
-  */
+/*
+ * This file contains the handling of RX in wlan driver.
+ */
 #include <linux/etherdevice.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -40,12 +40,12 @@ static int process_rxed_802_11_packet(st
 	struct sk_buff *skb);
 
 /**
- *  @brief This function processes received packet and forwards it
- *  to kernel/upper layer
+ * lbs_process_rxed_packet - processes received packet and forwards it
+ * to kernel/upper layer
  *
- *  @param	priv	A pointer to struct lbs_private
- *  @param	skb		A pointer to skb which includes the received packet
- *  @return	0 or -1
+ * @priv:	A pointer to &struct lbs_private
+ * @skb:	A pointer to skb which includes the received packet
+ * returns:	0 or -1
  */
 int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
 {
@@ -156,11 +156,11 @@ done:
 EXPORT_SYMBOL_GPL(lbs_process_rxed_packet);
 
 /**
- *  @brief This function converts Tx/Rx rates from the Marvell WLAN format
- *  (see Table 2 in Section 3.1) to IEEE80211_RADIOTAP_RATE units (500 Kb/s)
+ * convert_mv_rate_to_radiotap - converts Tx/Rx rates from Marvell WLAN format
+ * (see Table 2 in Section 3.1) to IEEE80211_RADIOTAP_RATE units (500 Kb/s)
  *
- *  @param	rate	Input rate
- *  @return	Output Rate (0 if invalid)
+ * @rate:	Input rate
+ * returns:	Output Rate (0 if invalid)
  */
 static u8 convert_mv_rate_to_radiotap(u8 rate)
 {
@@ -196,12 +196,12 @@ static u8 convert_mv_rate_to_radiotap(u8
 }
 
 /**
- *  @brief This function processes a received 802.11 packet and forwards it
- *  to kernel/upper layer
+ * process_rxed_802_11_packet - processes a received 802.11 packet and forwards
+ * it to kernel/upper layer
  *
- *  @param	priv	A pointer to struct lbs_private
- *  @param	skb		A pointer to skb which includes the received packet
- *  @return	0 or -1
+ * @priv:	A pointer to &struct lbs_private
+ * @skb:	A pointer to skb which includes the received packet
+ * returns:	0 or -1
  */
 static int process_rxed_802_11_packet(struct lbs_private *priv,
 	struct sk_buff *skb)
--- lnx-2639-rc4.orig/drivers/net/wireless/libertas/tx.c
+++ lnx-2639-rc4/drivers/net/wireless/libertas/tx.c
@@ -1,6 +1,6 @@
-/**
-  * This file contains the handling of TX in wlan driver.
-  */
+/*
+ * This file contains the handling of TX in wlan driver.
+ */
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/sched.h>
@@ -13,11 +13,11 @@
 #include "dev.h"
 
 /**
- *  @brief This function converts Tx/Rx rates from IEEE80211_RADIOTAP_RATE
- *  units (500 Kb/s) into Marvell WLAN format (see Table 8 in Section 3.2.1)
+ * convert_radiotap_rate_to_mv - converts Tx/Rx rates from IEEE80211_RADIOTAP_RATE
+ * units (500 Kb/s) into Marvell WLAN format (see Table 8 in Section 3.2.1)
  *
- *  @param rate    Input rate
- *  @return      Output Rate (0 if invalid)
+ * @rate:	Input rate
+ * returns:	Output Rate (0 if invalid)
  */
 static u32 convert_radiotap_rate_to_mv(u8 rate)
 {
@@ -51,12 +51,12 @@ static u32 convert_radiotap_rate_to_mv(u
 }
 
 /**
- *  @brief This function checks the conditions and sends packet to IF
- *  layer if everything is ok.
+ * lbs_hard_start_xmit - checks the conditions and sends packet to IF
+ * layer if everything is ok
  *
- *  @param priv    A pointer to struct lbs_private structure
- *  @param skb     A pointer to skb which includes TX packet
- *  @return 	   0 or -1
+ * @skb:	A pointer to skb which includes TX packet
+ * @dev:	A pointer to the &struct net_device
+ * returns:	0 or -1
  */
 netdev_tx_t lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
@@ -168,13 +168,13 @@ netdev_tx_t lbs_hard_start_xmit(struct s
 }
 
 /**
- *  @brief This function sends to the host the last transmitted packet,
- *  filling the radiotap headers with transmission information.
+ * lbs_send_tx_feedback - sends to the host the last transmitted packet,
+ * filling the radiotap headers with transmission information.
  *
- *  @param priv     A pointer to struct lbs_private structure
- *  @param status   A 32 bit value containing transmission status.
+ * @priv:	A pointer to &struct lbs_private structure
+ * @try_count:	A 32-bit value containing transmission retry status.
  *
- *  @returns void
+ * returns:	void
  */
 void lbs_send_tx_feedback(struct lbs_private *priv, u32 try_count)
 {
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
