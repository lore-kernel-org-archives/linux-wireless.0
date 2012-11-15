Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3385 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933248Ab2KOCqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:46:35 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/19] brcmfmac: rework firmware event handling code
Date: Wed, 14 Nov 2012 18:46:05 -0800
Message-ID: <1352947583-25341-2-git-send-email-frankyl@broadcom.com> (sfid-20121115_041527_203896_09D810F5)
In-Reply-To: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
References: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Handling of firmware event has been reworked into a seperate
code file. The change is needed as firmware event can be received
in interrupt context. Decoupling of the event handling has been
lowered to allow event processing to sleep.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |  110 +----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |  399 ----------------
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   39 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |  498 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h     |  207 ++++++++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  246 ++--------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   31 --
 9 files changed, 763 insertions(+), 770 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fweh.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fweh.h

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index fe80b63..1a6661a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_BRCMFMAC) += brcmfmac.o
 brcmfmac-objs += \
 		wl_cfg80211.o \
 		fwil.o \
+		fweh.o \
 		dhd_cdc.o \
 		dhd_common.o \
 		dhd_linux.o
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 9807092..10d92b5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -23,6 +23,8 @@
 
 #define BRCMF_VERSION_STR		"4.218.248.5"
 
+#include "fweh.h"
+
 /*******************************************************************************
  * IO codes that are interpreted by dongle firmware
  ******************************************************************************/
@@ -117,10 +119,6 @@
 #define DOT11_BSSTYPE_ANY			2
 #define DOT11_MAX_DEFAULT_KEYS	4
 
-#define BRCMF_EVENT_MSG_LINK		0x01
-#define BRCMF_EVENT_MSG_FLUSHTXQ	0x02
-#define BRCMF_EVENT_MSG_GROUP		0x04
-
 #define BRCMF_ESCAN_REQ_VERSION 1
 
 #define WLC_BSS_RSSI_ON_CHANNEL		0x0002
@@ -128,108 +126,6 @@
 #define BRCMF_MAXRATES_IN_SET		16	/* max # of rates in rateset */
 #define BRCMF_STA_ASSOC			0x10		/* Associated */
 
-struct brcmf_event_msg {
-	__be16 version;
-	__be16 flags;
-	__be32 event_type;
-	__be32 status;
-	__be32 reason;
-	__be32 auth_type;
-	__be32 datalen;
-	u8 addr[ETH_ALEN];
-	char ifname[IFNAMSIZ];
-	u8 ifidx;
-	u8 bsscfgidx;
-} __packed;
-
-struct brcm_ethhdr {
-	u16 subtype;
-	u16 length;
-	u8 version;
-	u8 oui[3];
-	u16 usr_subtype;
-} __packed;
-
-struct brcmf_event {
-	struct ethhdr eth;
-	struct brcm_ethhdr hdr;
-	struct brcmf_event_msg msg;
-} __packed;
-
-/* event codes sent by the dongle to this driver */
-#define BRCMF_E_SET_SSID			0
-#define BRCMF_E_JOIN				1
-#define BRCMF_E_START				2
-#define BRCMF_E_AUTH				3
-#define BRCMF_E_AUTH_IND			4
-#define BRCMF_E_DEAUTH				5
-#define BRCMF_E_DEAUTH_IND			6
-#define BRCMF_E_ASSOC				7
-#define BRCMF_E_ASSOC_IND			8
-#define BRCMF_E_REASSOC				9
-#define BRCMF_E_REASSOC_IND			10
-#define BRCMF_E_DISASSOC			11
-#define BRCMF_E_DISASSOC_IND			12
-#define BRCMF_E_QUIET_START			13
-#define BRCMF_E_QUIET_END			14
-#define BRCMF_E_BEACON_RX			15
-#define BRCMF_E_LINK				16
-#define BRCMF_E_MIC_ERROR			17
-#define BRCMF_E_NDIS_LINK			18
-#define BRCMF_E_ROAM				19
-#define BRCMF_E_TXFAIL				20
-#define BRCMF_E_PMKID_CACHE			21
-#define BRCMF_E_RETROGRADE_TSF			22
-#define BRCMF_E_PRUNE				23
-#define BRCMF_E_AUTOAUTH			24
-#define BRCMF_E_EAPOL_MSG			25
-#define BRCMF_E_SCAN_COMPLETE			26
-#define BRCMF_E_ADDTS_IND			27
-#define BRCMF_E_DELTS_IND			28
-#define BRCMF_E_BCNSENT_IND			29
-#define BRCMF_E_BCNRX_MSG			30
-#define BRCMF_E_BCNLOST_MSG			31
-#define BRCMF_E_ROAM_PREP			32
-#define BRCMF_E_PFN_NET_FOUND			33
-#define BRCMF_E_PFN_NET_LOST			34
-#define BRCMF_E_RESET_COMPLETE			35
-#define BRCMF_E_JOIN_START			36
-#define BRCMF_E_ROAM_START			37
-#define BRCMF_E_ASSOC_START			38
-#define BRCMF_E_IBSS_ASSOC			39
-#define BRCMF_E_RADIO				40
-#define BRCMF_E_PSM_WATCHDOG			41
-#define BRCMF_E_PROBREQ_MSG			44
-#define BRCMF_E_SCAN_CONFIRM_IND		45
-#define BRCMF_E_PSK_SUP				46
-#define BRCMF_E_COUNTRY_CODE_CHANGED		47
-#define	BRCMF_E_EXCEEDED_MEDIUM_TIME		48
-#define BRCMF_E_ICV_ERROR			49
-#define BRCMF_E_UNICAST_DECODE_ERROR		50
-#define BRCMF_E_MULTICAST_DECODE_ERROR		51
-#define BRCMF_E_TRACE				52
-#define BRCMF_E_IF				54
-#define BRCMF_E_RSSI				56
-#define BRCMF_E_PFN_SCAN_COMPLETE		57
-#define BRCMF_E_EXTLOG_MSG			58
-#define BRCMF_E_ACTION_FRAME			59
-#define BRCMF_E_ACTION_FRAME_COMPLETE		60
-#define BRCMF_E_PRE_ASSOC_IND			61
-#define BRCMF_E_PRE_REASSOC_IND			62
-#define BRCMF_E_CHANNEL_ADOPTED			63
-#define BRCMF_E_AP_STARTED			64
-#define BRCMF_E_DFS_AP_STOP			65
-#define BRCMF_E_DFS_AP_RESUME			66
-#define BRCMF_E_RESERVED1			67
-#define BRCMF_E_RESERVED2			68
-#define BRCMF_E_ESCAN_RESULT			69
-#define BRCMF_E_ACTION_FRAME_OFF_CHAN_COMPLETE	70
-#define BRCMF_E_DCS_REQUEST			73
-
-#define BRCMF_E_FIFO_CREDIT_MAP			74
-
-#define BRCMF_E_LAST				75
-
 #define BRCMF_E_STATUS_SUCCESS			0
 #define BRCMF_E_STATUS_FAIL			1
 #define BRCMF_E_STATUS_TIMEOUT			2
@@ -622,6 +518,8 @@ struct brcmf_pub {
 	u8 macvalue[ETH_ALEN];
 	atomic_t pend_8021x_cnt;
 	wait_queue_head_t pend_8021x_wait;
+
+	struct brcmf_fweh_info fweh;
 #ifdef DEBUG
 	struct dentry *dbgfs_dir;
 #endif
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 265580f..a8bb5d2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -85,7 +85,7 @@ extern bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 			 struct sk_buff *pkt, int prec);
 
 /* Receive frame for delivery to OS.  Callee disposes of rxp. */
-extern void brcmf_rx_frame(struct device *dev, int ifidx,
+extern void brcmf_rx_frame(struct device *dev, u8 ifidx,
 			   struct sk_buff_head *rxlist);
 static inline void brcmf_rx_packet(struct device *dev, int ifidx,
 				   struct sk_buff *pkt)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 3b31139..3d59332 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -118,405 +118,6 @@ bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 	return p != NULL;
 }
 
-#ifdef DEBUG
-static void
-brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
-{
-	uint i, status, reason;
-	bool group = false, flush_txq = false, link = false;
-	char *auth_str, *event_name;
-	unsigned char *buf;
-	char err_msg[256], eabuf[ETHER_ADDR_STR_LEN];
-	static struct {
-		uint event;
-		char *event_name;
-	} event_names[] = {
-		{
-		BRCMF_E_SET_SSID, "SET_SSID"}, {
-		BRCMF_E_JOIN, "JOIN"}, {
-		BRCMF_E_START, "START"}, {
-		BRCMF_E_AUTH, "AUTH"}, {
-		BRCMF_E_AUTH_IND, "AUTH_IND"}, {
-		BRCMF_E_DEAUTH, "DEAUTH"}, {
-		BRCMF_E_DEAUTH_IND, "DEAUTH_IND"}, {
-		BRCMF_E_ASSOC, "ASSOC"}, {
-		BRCMF_E_ASSOC_IND, "ASSOC_IND"}, {
-		BRCMF_E_REASSOC, "REASSOC"}, {
-		BRCMF_E_REASSOC_IND, "REASSOC_IND"}, {
-		BRCMF_E_DISASSOC, "DISASSOC"}, {
-		BRCMF_E_DISASSOC_IND, "DISASSOC_IND"}, {
-		BRCMF_E_QUIET_START, "START_QUIET"}, {
-		BRCMF_E_QUIET_END, "END_QUIET"}, {
-		BRCMF_E_BEACON_RX, "BEACON_RX"}, {
-		BRCMF_E_LINK, "LINK"}, {
-		BRCMF_E_MIC_ERROR, "MIC_ERROR"}, {
-		BRCMF_E_NDIS_LINK, "NDIS_LINK"}, {
-		BRCMF_E_ROAM, "ROAM"}, {
-		BRCMF_E_TXFAIL, "TXFAIL"}, {
-		BRCMF_E_PMKID_CACHE, "PMKID_CACHE"}, {
-		BRCMF_E_RETROGRADE_TSF, "RETROGRADE_TSF"}, {
-		BRCMF_E_PRUNE, "PRUNE"}, {
-		BRCMF_E_AUTOAUTH, "AUTOAUTH"}, {
-		BRCMF_E_EAPOL_MSG, "EAPOL_MSG"}, {
-		BRCMF_E_SCAN_COMPLETE, "SCAN_COMPLETE"}, {
-		BRCMF_E_ADDTS_IND, "ADDTS_IND"}, {
-		BRCMF_E_DELTS_IND, "DELTS_IND"}, {
-		BRCMF_E_BCNSENT_IND, "BCNSENT_IND"}, {
-		BRCMF_E_BCNRX_MSG, "BCNRX_MSG"}, {
-		BRCMF_E_BCNLOST_MSG, "BCNLOST_MSG"}, {
-		BRCMF_E_ROAM_PREP, "ROAM_PREP"}, {
-		BRCMF_E_PFN_NET_FOUND, "PNO_NET_FOUND"}, {
-		BRCMF_E_PFN_NET_LOST, "PNO_NET_LOST"}, {
-		BRCMF_E_RESET_COMPLETE, "RESET_COMPLETE"}, {
-		BRCMF_E_JOIN_START, "JOIN_START"}, {
-		BRCMF_E_ROAM_START, "ROAM_START"}, {
-		BRCMF_E_ASSOC_START, "ASSOC_START"}, {
-		BRCMF_E_IBSS_ASSOC, "IBSS_ASSOC"}, {
-		BRCMF_E_RADIO, "RADIO"}, {
-		BRCMF_E_PSM_WATCHDOG, "PSM_WATCHDOG"}, {
-		BRCMF_E_PROBREQ_MSG, "PROBREQ_MSG"}, {
-		BRCMF_E_SCAN_CONFIRM_IND, "SCAN_CONFIRM_IND"}, {
-		BRCMF_E_PSK_SUP, "PSK_SUP"}, {
-		BRCMF_E_COUNTRY_CODE_CHANGED, "COUNTRY_CODE_CHANGED"}, {
-		BRCMF_E_EXCEEDED_MEDIUM_TIME, "EXCEEDED_MEDIUM_TIME"}, {
-		BRCMF_E_ICV_ERROR, "ICV_ERROR"}, {
-		BRCMF_E_UNICAST_DECODE_ERROR, "UNICAST_DECODE_ERROR"}, {
-		BRCMF_E_MULTICAST_DECODE_ERROR, "MULTICAST_DECODE_ERROR"}, {
-		BRCMF_E_TRACE, "TRACE"}, {
-		BRCMF_E_ACTION_FRAME, "ACTION FRAME"}, {
-		BRCMF_E_ACTION_FRAME_COMPLETE, "ACTION FRAME TX COMPLETE"}, {
-		BRCMF_E_IF, "IF"}, {
-		BRCMF_E_RSSI, "RSSI"}, {
-		BRCMF_E_PFN_SCAN_COMPLETE, "SCAN_COMPLETE"}, {
-		BRCMF_E_ESCAN_RESULT, "ESCAN_RESULT"}
-	};
-	uint event_type, flags, auth_type, datalen;
-	static u32 seqnum_prev;
-	struct msgtrace_hdr hdr;
-	u32 nblost;
-	char *s, *p;
-
-	event_type = be32_to_cpu(event->event_type);
-	flags = be16_to_cpu(event->flags);
-	status = be32_to_cpu(event->status);
-	reason = be32_to_cpu(event->reason);
-	auth_type = be32_to_cpu(event->auth_type);
-	datalen = be32_to_cpu(event->datalen);
-	/* debug dump of event messages */
-	sprintf(eabuf, "%pM", event->addr);
-
-	event_name = "UNKNOWN";
-	for (i = 0; i < ARRAY_SIZE(event_names); i++) {
-		if (event_names[i].event == event_type)
-			event_name = event_names[i].event_name;
-	}
-
-	brcmf_dbg(EVENT, "EVENT: %s, event ID = %d\n", event_name, event_type);
-	brcmf_dbg(EVENT, "flags 0x%04x, status %d, reason %d, auth_type %d MAC %s\n",
-		  flags, status, reason, auth_type, eabuf);
-
-	if (flags & BRCMF_EVENT_MSG_LINK)
-		link = true;
-	if (flags & BRCMF_EVENT_MSG_GROUP)
-		group = true;
-	if (flags & BRCMF_EVENT_MSG_FLUSHTXQ)
-		flush_txq = true;
-
-	switch (event_type) {
-	case BRCMF_E_START:
-	case BRCMF_E_DEAUTH:
-	case BRCMF_E_DISASSOC:
-		brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s\n", event_name, eabuf);
-		break;
-
-	case BRCMF_E_ASSOC_IND:
-	case BRCMF_E_REASSOC_IND:
-		brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s\n", event_name, eabuf);
-		break;
-
-	case BRCMF_E_ASSOC:
-	case BRCMF_E_REASSOC:
-		if (status == BRCMF_E_STATUS_SUCCESS)
-			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, SUCCESS\n",
-				  event_name, eabuf);
-		else if (status == BRCMF_E_STATUS_TIMEOUT)
-			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, TIMEOUT\n",
-				  event_name, eabuf);
-		else if (status == BRCMF_E_STATUS_FAIL)
-			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, FAILURE, reason %d\n",
-				  event_name, eabuf, (int)reason);
-		else
-			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, unexpected status %d\n",
-				  event_name, eabuf, (int)status);
-		break;
-
-	case BRCMF_E_DEAUTH_IND:
-	case BRCMF_E_DISASSOC_IND:
-		brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, reason %d\n",
-			  event_name, eabuf, (int)reason);
-		break;
-
-	case BRCMF_E_AUTH:
-	case BRCMF_E_AUTH_IND:
-		if (auth_type == WLAN_AUTH_OPEN)
-			auth_str = "Open System";
-		else if (auth_type == WLAN_AUTH_SHARED_KEY)
-			auth_str = "Shared Key";
-		else {
-			sprintf(err_msg, "AUTH unknown: %d", (int)auth_type);
-			auth_str = err_msg;
-		}
-		if (event_type == BRCMF_E_AUTH_IND)
-			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, %s\n",
-				  event_name, eabuf, auth_str);
-		else if (status == BRCMF_E_STATUS_SUCCESS)
-			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, %s, SUCCESS\n",
-				  event_name, eabuf, auth_str);
-		else if (status == BRCMF_E_STATUS_TIMEOUT)
-			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, %s, TIMEOUT\n",
-				  event_name, eabuf, auth_str);
-		else if (status == BRCMF_E_STATUS_FAIL) {
-			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, %s, FAILURE, reason %d\n",
-				  event_name, eabuf, auth_str, (int)reason);
-		}
-
-		break;
-
-	case BRCMF_E_JOIN:
-	case BRCMF_E_ROAM:
-	case BRCMF_E_SET_SSID:
-		if (status == BRCMF_E_STATUS_SUCCESS)
-			brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s\n",
-				  event_name, eabuf);
-		else if (status == BRCMF_E_STATUS_FAIL)
-			brcmf_dbg(EVENT, "MACEVENT: %s, failed\n", event_name);
-		else if (status == BRCMF_E_STATUS_NO_NETWORKS)
-			brcmf_dbg(EVENT, "MACEVENT: %s, no networks found\n",
-				  event_name);
-		else
-			brcmf_dbg(EVENT, "MACEVENT: %s, unexpected status %d\n",
-				  event_name, (int)status);
-		break;
-
-	case BRCMF_E_BEACON_RX:
-		if (status == BRCMF_E_STATUS_SUCCESS)
-			brcmf_dbg(EVENT, "MACEVENT: %s, SUCCESS\n", event_name);
-		else if (status == BRCMF_E_STATUS_FAIL)
-			brcmf_dbg(EVENT, "MACEVENT: %s, FAIL\n", event_name);
-		else
-			brcmf_dbg(EVENT, "MACEVENT: %s, status %d\n",
-				  event_name, status);
-		break;
-
-	case BRCMF_E_LINK:
-		brcmf_dbg(EVENT, "MACEVENT: %s %s\n",
-			  event_name, link ? "UP" : "DOWN");
-		break;
-
-	case BRCMF_E_MIC_ERROR:
-		brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s, Group %d, Flush %d\n",
-			  event_name, eabuf, group, flush_txq);
-		break;
-
-	case BRCMF_E_ICV_ERROR:
-	case BRCMF_E_UNICAST_DECODE_ERROR:
-	case BRCMF_E_MULTICAST_DECODE_ERROR:
-		brcmf_dbg(EVENT, "MACEVENT: %s, MAC %s\n", event_name, eabuf);
-		break;
-
-	case BRCMF_E_TXFAIL:
-		brcmf_dbg(EVENT, "MACEVENT: %s, RA %s\n", event_name, eabuf);
-		break;
-
-	case BRCMF_E_SCAN_COMPLETE:
-	case BRCMF_E_PMKID_CACHE:
-		brcmf_dbg(EVENT, "MACEVENT: %s\n", event_name);
-		break;
-
-	case BRCMF_E_ESCAN_RESULT:
-		brcmf_dbg(EVENT, "MACEVENT: %s\n", event_name);
-		datalen = 0;
-		break;
-
-	case BRCMF_E_PFN_NET_FOUND:
-	case BRCMF_E_PFN_NET_LOST:
-	case BRCMF_E_PFN_SCAN_COMPLETE:
-		brcmf_dbg(EVENT, "PNOEVENT: %s\n", event_name);
-		break;
-
-	case BRCMF_E_PSK_SUP:
-	case BRCMF_E_PRUNE:
-		brcmf_dbg(EVENT, "MACEVENT: %s, status %d, reason %d\n",
-			  event_name, (int)status, (int)reason);
-		break;
-
-	case BRCMF_E_TRACE:
-		buf = (unsigned char *) event_data;
-		memcpy(&hdr, buf, sizeof(struct msgtrace_hdr));
-
-		if (hdr.version != MSGTRACE_VERSION) {
-			brcmf_dbg(ERROR,
-				  "MACEVENT: %s [unsupported version --> brcmf"
-				  " version:%d dongle version:%d]\n",
-				  event_name, MSGTRACE_VERSION, hdr.version);
-			/* Reset datalen to avoid display below */
-			datalen = 0;
-			break;
-		}
-
-		/* There are 2 bytes available at the end of data */
-		*(buf + sizeof(struct msgtrace_hdr)
-			 + be16_to_cpu(hdr.len)) = '\0';
-
-		if (be32_to_cpu(hdr.discarded_bytes)
-		    || be32_to_cpu(hdr.discarded_printf))
-			brcmf_dbg(ERROR,
-				  "WLC_E_TRACE: [Discarded traces in dongle -->"
-				  " discarded_bytes %d discarded_printf %d]\n",
-				  be32_to_cpu(hdr.discarded_bytes),
-				  be32_to_cpu(hdr.discarded_printf));
-
-		nblost = be32_to_cpu(hdr.seqnum) - seqnum_prev - 1;
-		if (nblost > 0)
-			brcmf_dbg(ERROR, "WLC_E_TRACE: [Event lost --> seqnum "
-				  " %d nblost %d\n", be32_to_cpu(hdr.seqnum),
-				  nblost);
-		seqnum_prev = be32_to_cpu(hdr.seqnum);
-
-		/* Display the trace buffer. Advance from \n to \n to
-		 * avoid display big
-		 * printf (issue with Linux printk )
-		 */
-		p = (char *)&buf[sizeof(struct msgtrace_hdr)];
-		while ((s = strstr(p, "\n")) != NULL) {
-			*s = '\0';
-			pr_debug("%s\n", p);
-			p = s + 1;
-		}
-		pr_debug("%s\n", p);
-
-		/* Reset datalen to avoid display below */
-		datalen = 0;
-		break;
-
-	case BRCMF_E_RSSI:
-		brcmf_dbg(EVENT, "MACEVENT: %s %d\n",
-			  event_name, be32_to_cpu(*((__be32 *)event_data)));
-		break;
-
-	default:
-		brcmf_dbg(EVENT,
-			  "MACEVENT: %s %d, MAC %s, status %d, reason %d, "
-			  "auth %d\n", event_name, event_type, eabuf,
-			  (int)status, (int)reason, (int)auth_type);
-		break;
-	}
-
-	/* show any appended data */
-	brcmf_dbg_hex_dump(datalen, event_data, datalen, "Received data");
-}
-#endif				/* DEBUG */
-
-int
-brcmf_c_host_event(struct brcmf_pub *drvr, int *ifidx, void *pktdata,
-		   struct brcmf_event_msg *event, void **data_ptr)
-{
-	/* check whether packet is a BRCM event pkt */
-	struct brcmf_event *pvt_data = (struct brcmf_event *) pktdata;
-	struct brcmf_if_event *ifevent;
-	struct brcmf_if *ifp;
-	char *event_data;
-	u32 type, status;
-	u16 flags;
-	int evlen;
-
-	if (memcmp(BRCM_OUI, &pvt_data->hdr.oui[0], DOT11_OUI_LEN)) {
-		brcmf_dbg(ERROR, "mismatched OUI, bailing\n");
-		return -EBADE;
-	}
-
-	/* BRCM event pkt may be unaligned - use xxx_ua to load user_subtype. */
-	if (get_unaligned_be16(&pvt_data->hdr.usr_subtype) !=
-	    BCMILCP_BCM_SUBTYPE_EVENT) {
-		brcmf_dbg(ERROR, "mismatched subtype, bailing\n");
-		return -EBADE;
-	}
-
-	*data_ptr = &pvt_data[1];
-	event_data = *data_ptr;
-
-	/* memcpy since BRCM event pkt may be unaligned. */
-	memcpy(event, &pvt_data->msg, sizeof(struct brcmf_event_msg));
-
-	type = get_unaligned_be32(&event->event_type);
-	flags = get_unaligned_be16(&event->flags);
-	status = get_unaligned_be32(&event->status);
-	evlen = get_unaligned_be32(&event->datalen) +
-		sizeof(struct brcmf_event);
-
-	switch (type) {
-	case BRCMF_E_IF:
-		ifevent = (struct brcmf_if_event *) event_data;
-		brcmf_dbg(TRACE, "if event\n");
-
-		if (ifevent->ifidx > 0 && ifevent->ifidx < BRCMF_MAX_IFS) {
-			if (ifevent->action == BRCMF_E_IF_ADD) {
-				ifp = brcmf_add_if(drvr->dev, ifevent->ifidx,
-						   ifevent->bssidx,
-						   event->ifname,
-						   pvt_data->eth.h_dest);
-				if (IS_ERR(ifp))
-					return PTR_ERR(ifp);
-				brcmf_net_attach(ifp);
-			} else {
-				brcmf_del_if(drvr, ifevent->ifidx);
-			}
-		} else {
-			brcmf_dbg(ERROR, "Invalid ifidx %d for %s\n",
-				  ifevent->ifidx, event->ifname);
-		}
-
-		/* send up the if event: btamp user needs it */
-		*ifidx = brcmf_ifname2idx(drvr, event->ifname);
-		break;
-
-		/* These are what external supplicant/authenticator wants */
-	case BRCMF_E_LINK:
-	case BRCMF_E_ASSOC_IND:
-	case BRCMF_E_REASSOC_IND:
-	case BRCMF_E_DISASSOC_IND:
-	case BRCMF_E_MIC_ERROR:
-	default:
-		/* Fall through: this should get _everything_  */
-
-		*ifidx = brcmf_ifname2idx(drvr, event->ifname);
-		brcmf_dbg(TRACE, "MAC event %d, flags %x, status %x\n",
-			  type, flags, status);
-
-		/* put it back to BRCMF_E_NDIS_LINK */
-		if (type == BRCMF_E_NDIS_LINK) {
-			u32 temp1;
-			__be32 temp2;
-
-			temp1 = get_unaligned_be32(&event->event_type);
-			brcmf_dbg(TRACE, "Converted to WLC_E_LINK type %d\n",
-				  temp1);
-
-			temp2 = cpu_to_be32(BRCMF_E_NDIS_LINK);
-			memcpy((void *)(&pvt_data->msg.event_type), &temp2,
-			       sizeof(pvt_data->msg.event_type));
-		}
-		break;
-	}
-
-#ifdef DEBUG
-	if (BRCMF_EVENT_ON())
-		brcmf_c_show_host_event(event, event_data);
-#endif /* DEBUG */
-
-	return 0;
-}
-
 /* Convert user's input in hex pattern to byte-size mask */
 static int brcmf_c_pattern_atoh(char *src, char *dst)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index c2cd28e..60907de 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -294,33 +294,13 @@ void brcmf_txflowblock(struct device *dev, bool state)
 		}
 }
 
-static int brcmf_host_event(struct brcmf_pub *drvr, int *ifidx,
-			    void *pktdata, struct brcmf_event_msg *event,
-			    void **data)
-{
-	int bcmerror = 0;
-
-	bcmerror = brcmf_c_host_event(drvr, ifidx, pktdata, event, data);
-	if (bcmerror != 0)
-		return bcmerror;
-
-	/* only forward if interface has netdev */
-	if (drvr->iflist[*ifidx]->ndev)
-		brcmf_cfg80211_event(drvr->iflist[*ifidx],
-				     event, *data);
-
-	return bcmerror;
-}
-
-void brcmf_rx_frame(struct device *dev, int ifidx,
+void brcmf_rx_frame(struct device *dev, u8 ifidx,
 		    struct sk_buff_head *skb_list)
 {
 	unsigned char *eth;
 	uint len;
-	void *data;
 	struct sk_buff *skb, *pnext;
 	struct brcmf_if *ifp;
-	struct brcmf_event_msg event;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
 
@@ -367,10 +347,7 @@ void brcmf_rx_frame(struct device *dev, int ifidx,
 		skb_pull(skb, ETH_HLEN);
 
 		/* Process special event packets and then discard them */
-		if (ntohs(skb->protocol) == ETH_P_LINK_CTL)
-			brcmf_host_event(drvr, &ifidx,
-					  skb_mac_header(skb),
-					  &event, &data);
+		brcmf_fweh_process_skb(drvr, skb, &ifidx);
 
 		if (drvr->iflist[ifidx]) {
 			ifp = drvr->iflist[ifidx];
@@ -823,6 +800,9 @@ int brcmf_attach(uint bus_hdrlen, struct device *dev)
 		goto fail;
 	}
 
+	/* attach firmware event handler */
+	brcmf_fweh_attach(drvr);
+
 	INIT_WORK(&drvr->setmacaddr_work, _brcmf_set_mac_address);
 	INIT_WORK(&drvr->multicast_work, _brcmf_set_multicast_list);
 
@@ -873,10 +853,14 @@ int brcmf_bus_start(struct device *dev)
 		goto fail;
 	}
 
+	ret = brcmf_fweh_activate_events(ifp);
+	if (ret < 0)
+		goto fail;
+
 	ret = brcmf_net_attach(ifp);
 fail:
 	if (ret < 0) {
-		brcmf_dbg(ERROR, "brcmf_net_attach failed");
+		brcmf_dbg(ERROR, "failed: %d\n", ret);
 		if (drvr->config)
 			brcmf_cfg80211_detach(drvr->config);
 		free_netdev(drvr->iflist[0]->ndev);
@@ -911,6 +895,9 @@ void brcmf_detach(struct device *dev)
 	if (drvr == NULL)
 		return;
 
+	/* stop firmware event handling */
+	brcmf_fweh_detach(drvr);
+
 	/* make sure primary interface removed last */
 	for (i = BRCMF_MAX_IFS-1; i > -1; i--)
 		if (drvr->iflist[i])
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
new file mode 100644
index 0000000..c091c12
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -0,0 +1,498 @@
+/*
+ * Copyright (c) 2012 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include <linux/netdevice.h>
+
+#include "defs.h"
+#include "brcmu_wifi.h"
+#include "brcmu_utils.h"
+
+#include "dhd.h"
+#include "dhd_dbg.h"
+#include "fweh.h"
+#include "fwil.h"
+
+/**
+ * struct brcm_ethhdr - broadcom specific ether header.
+ *
+ * @subtype: subtype for this packet.
+ * @length: TODO: length of appended data.
+ * @version: version indication.
+ * @oui: OUI of this packet.
+ * @usr_subtype: subtype for this OUI.
+ */
+struct brcm_ethhdr {
+	__be16 subtype;
+	__be16 length;
+	u8 version;
+	u8 oui[3];
+	__be16 usr_subtype;
+} __packed;
+
+struct brcmf_event_msg_be {
+	__be16 version;
+	__be16 flags;
+	__be32 event_type;
+	__be32 status;
+	__be32 reason;
+	__be32 auth_type;
+	__be32 datalen;
+	u8 addr[ETH_ALEN];
+	char ifname[IFNAMSIZ];
+	u8 ifidx;
+	u8 bsscfgidx;
+} __packed;
+
+/**
+ * struct brcmf_event - contents of broadcom event packet.
+ *
+ * @eth: standard ether header.
+ * @hdr: broadcom specific ether header.
+ * @msg: common part of the actual event message.
+ */
+struct brcmf_event {
+	struct ethhdr eth;
+	struct brcm_ethhdr hdr;
+	struct brcmf_event_msg_be msg;
+} __packed;
+
+/**
+ * struct brcmf_fweh_queue_item - event item on event queue.
+ *
+ * @q: list element for queuing.
+ * @code: event code.
+ * @ifidx: interface index related to this event.
+ * @ifaddr: ethernet address for interface.
+ * @emsg: common parameters of the firmware event message.
+ * @data: event specific data part of the firmware event.
+ */
+struct brcmf_fweh_queue_item {
+	struct list_head q;
+	enum brcmf_fweh_event_code code;
+	u8 ifidx;
+	u8 ifaddr[ETH_ALEN];
+	struct brcmf_event_msg_be emsg;
+	u8 data[0];
+};
+
+/**
+ * struct brcmf_fweh_event_name - code, name mapping entry.
+ */
+struct brcmf_fweh_event_name {
+	enum brcmf_fweh_event_code code;
+	const char *name;
+};
+
+#ifdef DEBUG
+/* array for mapping code to event name */
+static struct brcmf_fweh_event_name fweh_event_names[] = {
+	{ BRCMF_E_SET_SSID, "SET_SSID" },
+	{ BRCMF_E_JOIN, "JOIN" },
+	{ BRCMF_E_START, "START" },
+	{ BRCMF_E_AUTH, "AUTH" },
+	{ BRCMF_E_AUTH_IND, "AUTH_IND" },
+	{ BRCMF_E_DEAUTH, "DEAUTH" },
+	{ BRCMF_E_DEAUTH_IND, "DEAUTH_IND" },
+	{ BRCMF_E_ASSOC, "ASSOC" },
+	{ BRCMF_E_ASSOC_IND, "ASSOC_IND" },
+	{ BRCMF_E_REASSOC, "REASSOC" },
+	{ BRCMF_E_REASSOC_IND, "REASSOC_IND" },
+	{ BRCMF_E_DISASSOC, "DISASSOC" },
+	{ BRCMF_E_DISASSOC_IND, "DISASSOC_IND" },
+	{ BRCMF_E_QUIET_START, "START_QUIET" },
+	{ BRCMF_E_QUIET_END, "END_QUIET" },
+	{ BRCMF_E_BEACON_RX, "BEACON_RX" },
+	{ BRCMF_E_LINK, "LINK" },
+	{ BRCMF_E_MIC_ERROR, "MIC_ERROR" },
+	{ BRCMF_E_NDIS_LINK, "NDIS_LINK" },
+	{ BRCMF_E_ROAM, "ROAM" },
+	{ BRCMF_E_TXFAIL, "TXFAIL" },
+	{ BRCMF_E_PMKID_CACHE, "PMKID_CACHE" },
+	{ BRCMF_E_RETROGRADE_TSF, "RETROGRADE_TSF" },
+	{ BRCMF_E_PRUNE, "PRUNE" },
+	{ BRCMF_E_AUTOAUTH, "AUTOAUTH" },
+	{ BRCMF_E_EAPOL_MSG, "EAPOL_MSG" },
+	{ BRCMF_E_SCAN_COMPLETE, "SCAN_COMPLETE" },
+	{ BRCMF_E_ADDTS_IND, "ADDTS_IND" },
+	{ BRCMF_E_DELTS_IND, "DELTS_IND" },
+	{ BRCMF_E_BCNSENT_IND, "BCNSENT_IND" },
+	{ BRCMF_E_BCNRX_MSG, "BCNRX_MSG" },
+	{ BRCMF_E_BCNLOST_MSG, "BCNLOST_MSG" },
+	{ BRCMF_E_ROAM_PREP, "ROAM_PREP" },
+	{ BRCMF_E_PFN_NET_FOUND, "PNO_NET_FOUND" },
+	{ BRCMF_E_PFN_NET_LOST, "PNO_NET_LOST" },
+	{ BRCMF_E_RESET_COMPLETE, "RESET_COMPLETE" },
+	{ BRCMF_E_JOIN_START, "JOIN_START" },
+	{ BRCMF_E_ROAM_START, "ROAM_START" },
+	{ BRCMF_E_ASSOC_START, "ASSOC_START" },
+	{ BRCMF_E_IBSS_ASSOC, "IBSS_ASSOC" },
+	{ BRCMF_E_RADIO, "RADIO" },
+	{ BRCMF_E_PSM_WATCHDOG, "PSM_WATCHDOG" },
+	{ BRCMF_E_PROBREQ_MSG, "PROBREQ_MSG" },
+	{ BRCMF_E_SCAN_CONFIRM_IND, "SCAN_CONFIRM_IND" },
+	{ BRCMF_E_PSK_SUP, "PSK_SUP" },
+	{ BRCMF_E_COUNTRY_CODE_CHANGED, "COUNTRY_CODE_CHANGED" },
+	{ BRCMF_E_EXCEEDED_MEDIUM_TIME, "EXCEEDED_MEDIUM_TIME" },
+	{ BRCMF_E_ICV_ERROR, "ICV_ERROR" },
+	{ BRCMF_E_UNICAST_DECODE_ERROR, "UNICAST_DECODE_ERROR" },
+	{ BRCMF_E_MULTICAST_DECODE_ERROR, "MULTICAST_DECODE_ERROR" },
+	{ BRCMF_E_TRACE, "TRACE" },
+	{ BRCMF_E_IF, "IF" },
+	{ BRCMF_E_RSSI, "RSSI" },
+	{ BRCMF_E_PFN_SCAN_COMPLETE, "PFN_SCAN_COMPLETE" },
+	{ BRCMF_E_EXTLOG_MSG, "EXTLOG_MSG" },
+	{ BRCMF_E_ACTION_FRAME, "ACTION_FRAME" },
+	{ BRCMF_E_ACTION_FRAME_COMPLETE, "ACTION_FRAME_COMPLETE" },
+	{ BRCMF_E_PRE_ASSOC_IND, "PRE_ASSOC_IND" },
+	{ BRCMF_E_PRE_REASSOC_IND, "PRE_REASSOC_IND" },
+	{ BRCMF_E_CHANNEL_ADOPTED, "CHANNEL_ADOPTED" },
+	{ BRCMF_E_AP_STARTED, "AP_STARTED" },
+	{ BRCMF_E_DFS_AP_STOP, "DFS_AP_STOP" },
+	{ BRCMF_E_DFS_AP_RESUME, "DFS_AP_RESUME" },
+	{ BRCMF_E_ESCAN_RESULT, "ESCAN_RESULT" },
+	{ BRCMF_E_ACTION_FRAME_OFF_CHAN_COMPLETE, "ACTION_FRM_OFF_CHAN_CMPLT" },
+	{ BRCMF_E_DCS_REQUEST, "DCS_REQUEST" },
+	{ BRCMF_E_FIFO_CREDIT_MAP, "FIFO_CREDIT_MAP"}
+};
+
+/**
+ * brcmf_fweh_event_name() - returns name for given event code.
+ *
+ * @code: code to lookup.
+ */
+static const char *brcmf_fweh_event_name(enum brcmf_fweh_event_code code)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(fweh_event_names); i++) {
+		if (fweh_event_names[i].code == code)
+			return fweh_event_names[i].name;
+	}
+	return "unknown";
+}
+#else
+static const char *brcmf_fweh_event_name(enum brcmf_fweh_event_code code)
+{
+	return "nodebug";
+}
+#endif
+
+/**
+ * brcmf_fweh_queue_event() - create and queue event.
+ *
+ * @ifp: firmware interface object.
+ * @code: event code.
+ * @pkt: event ether packet.
+ */
+static void brcmf_fweh_queue_event(struct brcmf_if *ifp,
+				   enum brcmf_fweh_event_code code,
+				   struct brcmf_event *pkt)
+{
+	struct brcmf_fweh_info *fweh = &ifp->drvr->fweh;
+	struct brcmf_fweh_queue_item *event;
+	gfp_t alloc_flag = GFP_KERNEL;
+	ulong flags;
+	void *data;
+	u32 datalen;
+
+	/* determine event data */
+	datalen = get_unaligned_be32(&pkt->msg.datalen);
+	data = &pkt[1];
+
+	if (!ifp->ndev || (code != BRCMF_E_IF && !fweh->evt_handler[code])) {
+		brcmf_dbg(EVENT, "event ignored: code=%d\n", code);
+		brcmf_dbg_hex_dump(BRCMF_EVENT_ON(), data, datalen, "event:");
+		return;
+	}
+
+	if (in_interrupt())
+		alloc_flag = GFP_ATOMIC;
+
+	event = kzalloc(sizeof(*event) + datalen, alloc_flag);
+	event->code = code;
+	event->ifidx = ifp->idx;
+
+	/* use memcpy to get aligned event message */
+	memcpy(&event->emsg, &pkt->msg, sizeof(event->emsg));
+	memcpy(event->data, data, datalen);
+	memcpy(event->ifaddr, pkt->eth.h_dest, ETH_ALEN);
+
+	spin_lock_irqsave(&fweh->evt_q_lock, flags);
+	list_add_tail(&event->q, &fweh->event_q);
+	spin_unlock_irqrestore(&fweh->evt_q_lock, flags);
+	schedule_work(&fweh->event_work);
+}
+
+/**
+ * brcmf_fweh_process_if_event() - handle IF event.
+ *
+ * @drvr: driver information object.
+ * @item: queue entry.
+ * @ifpp: interface object (may change upon ADD action).
+ */
+static int brcmf_fweh_process_if_event(struct brcmf_pub *drvr,
+				       struct brcmf_fweh_queue_item *item,
+				       struct brcmf_if **ifpp)
+{
+	struct brcmf_event_msg_be *event = &item->emsg;
+	struct brcmf_if_event *ifevent = (struct brcmf_if_event *)item->data;
+	struct brcmf_if *ifp;
+	int err = 0;
+
+	brcmf_dbg(EVENT, "action: %u idx: %u bsscfg: %u flags: %u\n",
+		  ifevent->action, ifevent->ifidx,
+		  ifevent->bssidx, ifevent->flags);
+
+	if (ifevent->ifidx >= BRCMF_MAX_IFS) {
+		brcmf_dbg(ERROR, "invalid interface index: %u\n",
+			  ifevent->ifidx);
+		return -EINVAL;
+	}
+
+	switch (ifevent->action) {
+	case BRCMF_E_IF_ADD:
+		brcmf_dbg(EVENT, "adding %s (%pM, %pM)\n", event->ifname,
+			  event->addr, item->ifaddr);
+		ifp = brcmf_add_if(drvr->dev, ifevent->ifidx, ifevent->bssidx,
+				   event->ifname, item->ifaddr);
+		if (!IS_ERR(ifp)) {
+			*ifpp = ifp;
+			err = brcmf_net_attach(ifp);
+		} else {
+			err = PTR_ERR(ifp);
+		}
+		break;
+	case BRCMF_E_IF_DEL:
+		brcmf_del_if(drvr, ifevent->ifidx);
+		break;
+	case BRCMF_E_IF_CHANGE:
+		/* nothing to do here */
+		break;
+	default:
+		brcmf_dbg(ERROR, "unknown event action: %u\n", ifevent->action);
+		err = -EBADE;
+		break;
+	}
+	return err;
+}
+
+/**
+ * brcmf_fweh_dequeue_event() - get event from the queue.
+ *
+ * @fweh: firmware event handling info.
+ */
+static struct brcmf_fweh_queue_item *
+brcmf_fweh_dequeue_event(struct brcmf_fweh_info *fweh)
+{
+	struct brcmf_fweh_queue_item *event = NULL;
+	ulong flags;
+
+	spin_lock_irqsave(&fweh->evt_q_lock, flags);
+	if (!list_empty(&fweh->event_q)) {
+		event = list_first_entry(&fweh->event_q,
+					 struct brcmf_fweh_queue_item, q);
+		list_del(&event->q);
+	}
+	spin_unlock_irqrestore(&fweh->evt_q_lock, flags);
+
+	return event;
+}
+
+/**
+ * brcmf_fweh_event_worker() - firmware event worker.
+ *
+ * @work: worker object.
+ */
+static void brcmf_fweh_event_worker(struct work_struct *work)
+{
+	struct brcmf_pub *drvr;
+	struct brcmf_if *ifp;
+	struct brcmf_fweh_info *fweh;
+	struct brcmf_fweh_queue_item *event;
+	int err = 0;
+	struct brcmf_event_msg_be *emsg_be;
+	struct brcmf_event_msg emsg;
+
+	fweh = container_of(work, struct brcmf_fweh_info, event_work);
+	drvr = container_of(fweh, struct brcmf_pub, fweh);
+
+	while ((event = brcmf_fweh_dequeue_event(fweh))) {
+		ifp = drvr->iflist[event->ifidx];
+
+		brcmf_dbg(EVENT, "event %s (%u) ifidx %u bsscfg %u addr %pM:\n",
+			  brcmf_fweh_event_name(event->code), event->code,
+			  event->emsg.ifidx, event->emsg.bsscfgidx,
+			  event->emsg.addr);
+
+		/* handle interface event */
+		if (event->code == BRCMF_E_IF) {
+			err = brcmf_fweh_process_if_event(drvr, event, &ifp);
+			if (err)
+				goto event_free;
+		}
+
+		/* convert event message */
+		emsg_be = &event->emsg;
+		emsg.version = be16_to_cpu(emsg_be->version);
+		emsg.flags = be16_to_cpu(emsg_be->flags);
+		emsg.event_code = event->code;
+		emsg.status = be32_to_cpu(emsg_be->status);
+		emsg.reason = be32_to_cpu(emsg_be->reason);
+		emsg.auth_type = be32_to_cpu(emsg_be->auth_type);
+		emsg.datalen = be32_to_cpu(emsg_be->datalen);
+		memcpy(emsg.addr, emsg_be->addr, ETH_ALEN);
+		memcpy(emsg.ifname, emsg_be->ifname, sizeof(emsg.ifname));
+		emsg.ifidx = emsg_be->ifidx;
+		emsg.bsscfgidx = emsg_be->bsscfgidx;
+
+		brcmf_dbg(EVENT, "  version %u flags %u status %u reason %u\n",
+			  emsg.version, emsg.flags, emsg.status, emsg.reason);
+		brcmf_dbg_hex_dump(BRCMF_EVENT_ON(), event->data,
+				   min_t(u32, emsg.datalen, 64),
+				   "appended:");
+
+		/* handle the event if valid interface and handler */
+		if (ifp->ndev && fweh->evt_handler[event->code])
+			err = fweh->evt_handler[event->code](ifp, &emsg,
+							     event->data);
+		else
+			brcmf_dbg(ERROR, "unhandled event %d ignored\n",
+				  event->code);
+		if (err) {
+			brcmf_dbg(ERROR, "event handler failed (%d)\n",
+				  event->code);
+			err = 0;
+		}
+event_free:
+		kfree(event);
+	}
+}
+
+/**
+ * brcmf_fweh_attach() - initialize firmware event handling.
+ *
+ * @drvr: driver information object.
+ */
+void brcmf_fweh_attach(struct brcmf_pub *drvr)
+{
+	struct brcmf_fweh_info *fweh = &drvr->fweh;
+	INIT_WORK(&fweh->event_work, brcmf_fweh_event_worker);
+	spin_lock_init(&fweh->evt_q_lock);
+	INIT_LIST_HEAD(&fweh->event_q);
+}
+
+/**
+ * brcmf_fweh_detach() - cleanup firmware event handling.
+ *
+ * @drvr: driver information object.
+ */
+void brcmf_fweh_detach(struct brcmf_pub *drvr)
+{
+	struct brcmf_fweh_info *fweh = &drvr->fweh;
+	struct brcmf_if *ifp = drvr->iflist[0];
+	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
+
+	/* clear all events */
+	memset(eventmask, 0, BRCMF_EVENTING_MASK_LEN);
+	(void)brcmf_fil_iovar_data_set(ifp, "event_msgs",
+				       eventmask, BRCMF_EVENTING_MASK_LEN);
+
+	/* cancel the worker */
+	cancel_work_sync(&fweh->event_work);
+	WARN_ON(!list_empty(&fweh->event_q));
+	memset(fweh->evt_handler, 0, sizeof(fweh->evt_handler));
+}
+
+/**
+ * brcmf_fweh_register() - register handler for given event code.
+ *
+ * @drvr: driver information object.
+ * @code: event code.
+ * @handler: handler for the given event code.
+ */
+int brcmf_fweh_register(struct brcmf_pub *drvr, enum brcmf_fweh_event_code code,
+			brcmf_fweh_handler_t handler)
+{
+	if (drvr->fweh.evt_handler[code]) {
+		brcmf_dbg(ERROR, "event code %d already registered\n", code);
+		return -ENOSPC;
+	}
+	drvr->fweh.evt_handler[code] = handler;
+	brcmf_dbg(TRACE, "event handler registered for code %d\n", code);
+	return 0;
+}
+
+/**
+ * brcmf_fweh_unregister() - remove handler for given code.
+ *
+ * @drvr: driver information object.
+ * @code: event code.
+ */
+void brcmf_fweh_unregister(struct brcmf_pub *drvr,
+			   enum brcmf_fweh_event_code code)
+{
+	brcmf_dbg(TRACE, "event handler cleared for code %d\n", code);
+	drvr->fweh.evt_handler[code] = NULL;
+}
+
+/**
+ * brcmf_fweh_activate_events() - enables firmware events registered.
+ *
+ * @ifp: primary interface object.
+ */
+int brcmf_fweh_activate_events(struct brcmf_if *ifp)
+{
+	int i, err;
+	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
+
+	for (i = 0; i < BRCMF_E_LAST; i++) {
+		if (ifp->drvr->fweh.evt_handler[i]) {
+			brcmf_dbg(EVENT, "enable event %s\n",
+				  brcmf_fweh_event_name(i));
+			setbit(eventmask, i);
+		}
+	}
+
+	/* want to handle IF event as well */
+	setbit(eventmask, BRCMF_E_IF);
+
+	err = brcmf_fil_iovar_data_set(ifp, "event_msgs",
+				       eventmask, BRCMF_EVENTING_MASK_LEN);
+	if (err)
+		brcmf_dbg(ERROR, "Set event_msgs error (%d)\n", err);
+
+	return err;
+}
+
+/**
+ * brcmf_fweh_process_event() - process skb as firmware event.
+ *
+ * @drvr: driver information object.
+ * @event_packet: event packet to process.
+ * @ifidx: index of the firmware interface (may change).
+ *
+ * If the packet buffer contains a firmware event message it will
+ * dispatch the event to a registered handler (using worker).
+ */
+void brcmf_fweh_process_event(struct brcmf_pub *drvr,
+			      struct brcmf_event *event_packet, u8 *ifidx)
+{
+	enum brcmf_fweh_event_code code;
+
+	/* determine event code and interface index */
+	code = get_unaligned_be32(&event_packet->msg.event_type);
+	*ifidx = event_packet->msg.ifidx;
+
+	brcmf_fweh_queue_event(drvr->iflist[*ifidx], code, event_packet);
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
new file mode 100644
index 0000000..13bd333
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
@@ -0,0 +1,207 @@
+/*
+ * Copyright (c) 2012 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+
+#ifndef FWEH_H_
+#define FWEH_H_
+
+#include <linux/unaligned/access_ok.h>
+#include <linux/skbuff.h>
+#include <linux/if_ether.h>
+#include <linux/if.h>
+
+/* formward declarations */
+struct brcmf_pub;
+struct brcmf_if;
+struct brcmf_cfg80211_info;
+struct brcmf_event;
+
+/* firmware event codes sent by the dongle */
+enum brcmf_fweh_event_code {
+	BRCMF_E_SET_SSID		= 0,
+	BRCMF_E_JOIN			= 1,
+	BRCMF_E_START			= 2,
+	BRCMF_E_AUTH			= 3,
+	BRCMF_E_AUTH_IND		= 4,
+	BRCMF_E_DEAUTH			= 5,
+	BRCMF_E_DEAUTH_IND		= 6,
+	BRCMF_E_ASSOC			= 7,
+	BRCMF_E_ASSOC_IND		= 8,
+	BRCMF_E_REASSOC			= 9,
+	BRCMF_E_REASSOC_IND		= 10,
+	BRCMF_E_DISASSOC		= 11,
+	BRCMF_E_DISASSOC_IND		= 12,
+	BRCMF_E_QUIET_START		= 13,
+	BRCMF_E_QUIET_END		= 14,
+	BRCMF_E_BEACON_RX		= 15,
+	BRCMF_E_LINK			= 16,
+	BRCMF_E_MIC_ERROR		= 17,
+	BRCMF_E_NDIS_LINK		= 18,
+	BRCMF_E_ROAM			= 19,
+	BRCMF_E_TXFAIL			= 20,
+	BRCMF_E_PMKID_CACHE		= 21,
+	BRCMF_E_RETROGRADE_TSF		= 22,
+	BRCMF_E_PRUNE			= 23,
+	BRCMF_E_AUTOAUTH		= 24,
+	BRCMF_E_EAPOL_MSG		= 25,
+	BRCMF_E_SCAN_COMPLETE		= 26,
+	BRCMF_E_ADDTS_IND		= 27,
+	BRCMF_E_DELTS_IND		= 28,
+	BRCMF_E_BCNSENT_IND		= 29,
+	BRCMF_E_BCNRX_MSG		= 30,
+	BRCMF_E_BCNLOST_MSG		= 31,
+	BRCMF_E_ROAM_PREP		= 32,
+	BRCMF_E_PFN_NET_FOUND		= 33,
+	BRCMF_E_PFN_NET_LOST		= 34,
+	BRCMF_E_RESET_COMPLETE		= 35,
+	BRCMF_E_JOIN_START		= 36,
+	BRCMF_E_ROAM_START		= 37,
+	BRCMF_E_ASSOC_START		= 38,
+	BRCMF_E_IBSS_ASSOC		= 39,
+	BRCMF_E_RADIO			= 40,
+	BRCMF_E_PSM_WATCHDOG		= 41,
+	BRCMF_E_PROBREQ_MSG		= 44,
+	BRCMF_E_SCAN_CONFIRM_IND	= 45,
+	BRCMF_E_PSK_SUP			= 46,
+	BRCMF_E_COUNTRY_CODE_CHANGED	= 47,
+	BRCMF_E_EXCEEDED_MEDIUM_TIME	= 48,
+	BRCMF_E_ICV_ERROR		= 49,
+	BRCMF_E_UNICAST_DECODE_ERROR	= 50,
+	BRCMF_E_MULTICAST_DECODE_ERROR	= 51,
+	BRCMF_E_TRACE			= 52,
+	BRCMF_E_IF			= 54,
+	BRCMF_E_RSSI			= 56,
+	BRCMF_E_PFN_SCAN_COMPLETE	= 57,
+	BRCMF_E_EXTLOG_MSG		= 58,
+	BRCMF_E_ACTION_FRAME		= 59,
+	BRCMF_E_ACTION_FRAME_COMPLETE	= 60,
+	BRCMF_E_PRE_ASSOC_IND		= 61,
+	BRCMF_E_PRE_REASSOC_IND		= 62,
+	BRCMF_E_CHANNEL_ADOPTED		= 63,
+	BRCMF_E_AP_STARTED		= 64,
+	BRCMF_E_DFS_AP_STOP		= 65,
+	BRCMF_E_DFS_AP_RESUME		= 66,
+	BRCMF_E_ESCAN_RESULT		= 69,
+	BRCMF_E_ACTION_FRAME_OFF_CHAN_COMPLETE	= 70,
+	BRCMF_E_DCS_REQUEST		= 73,
+	BRCMF_E_FIFO_CREDIT_MAP		= 74,
+	BRCMF_E_LAST
+};
+
+/* flags field values in struct brcmf_event_msg */
+#define BRCMF_EVENT_MSG_LINK		0x01
+#define BRCMF_EVENT_MSG_FLUSHTXQ	0x02
+#define BRCMF_EVENT_MSG_GROUP		0x04
+
+/**
+ * definitions for event packet validation.
+ */
+#define BRCMF_EVENT_OUI_OFFSET		19
+#define BRCM_OUI			"\x00\x10\x18"
+#define DOT11_OUI_LEN			3
+#define BCMILCP_BCM_SUBTYPE_EVENT	1
+
+
+/**
+ * struct brcmf_event_msg - firmware event message.
+ *
+ * @version: version information.
+ * @flags: event flags.
+ * @event_code: firmware event code.
+ * @status: status information.
+ * @reason: reason code.
+ * @auth_type: authentication type.
+ * @datalen: lenght of event data buffer.
+ * @addr: ether address.
+ * @ifname: interface name.
+ * @ifidx: interface index.
+ * @bsscfgidx: bsscfg index.
+ */
+struct brcmf_event_msg {
+	u16 version;
+	u16 flags;
+	u32 event_code;
+	u32 status;
+	u32 reason;
+	s32 auth_type;
+	u32 datalen;
+	u8 addr[ETH_ALEN];
+	char ifname[IFNAMSIZ];
+	u8 ifidx;
+	u8 bsscfgidx;
+};
+
+typedef int (*brcmf_fweh_handler_t)(struct brcmf_if *ifp,
+				    const struct brcmf_event_msg *evtmsg,
+				    void *data);
+
+/**
+ * struct brcmf_fweh_info - firmware event handling information.
+ *
+ * @event_work: event worker.
+ * @evt_q_lock: lock for event queue protection.
+ * @event_q: event queue.
+ * @evt_handler: registered event handlers.
+ */
+struct brcmf_fweh_info {
+	struct work_struct event_work;
+	struct spinlock evt_q_lock;
+	struct list_head event_q;
+	int (*evt_handler[BRCMF_E_LAST])(struct brcmf_if *ifp,
+					 const struct brcmf_event_msg *evtmsg,
+					 void *data);
+};
+
+void brcmf_fweh_attach(struct brcmf_pub *drvr);
+void brcmf_fweh_detach(struct brcmf_pub *drvr);
+int brcmf_fweh_register(struct brcmf_pub *drvr, enum brcmf_fweh_event_code code,
+			int (*handler)(struct brcmf_if *ifp,
+				       const struct brcmf_event_msg *evtmsg,
+				       void *data));
+void brcmf_fweh_unregister(struct brcmf_pub *drvr,
+			   enum brcmf_fweh_event_code code);
+int brcmf_fweh_activate_events(struct brcmf_if *ifp);
+void brcmf_fweh_process_event(struct brcmf_pub *drvr,
+			      struct brcmf_event *event_packet, u8 *ifidx);
+
+static inline void brcmf_fweh_process_skb(struct brcmf_pub *drvr,
+					  struct sk_buff *skb, u8 *ifidx)
+{
+	struct brcmf_event *event_packet;
+	u8 *data;
+	u16 usr_stype;
+
+	/* only process events when protocol matches */
+	if (skb->protocol != cpu_to_be16(ETH_P_LINK_CTL))
+		return;
+
+	/* check for BRCM oui match */
+	event_packet = (struct brcmf_event *)skb_mac_header(skb);
+	data = (u8 *)event_packet;
+	data += BRCMF_EVENT_OUI_OFFSET;
+	if (memcmp(BRCM_OUI, data, DOT11_OUI_LEN))
+		return;
+
+	/* final match on usr_subtype */
+	data += DOT11_OUI_LEN;
+	usr_stype = get_unaligned_be16(data);
+	if (usr_stype != BCMILCP_BCM_SUBTYPE_EVENT)
+		return;
+
+	brcmf_fweh_process_event(drvr, event_packet, ifidx);
+}
+
+#endif /* FWEH_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 4387ca5..b836722 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2468,7 +2468,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 	u32 i;
 	bool aborted;
 
-	status = be32_to_cpu(e->status);
+	status = e->status;
 
 	if (!ndev || !test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
 		WL_ERR("scan not ready ndev %p drv_status %x\n", ndev,
@@ -2549,9 +2549,8 @@ exit:
 
 static void brcmf_init_escan(struct brcmf_cfg80211_info *cfg)
 {
-
-	cfg->el.handler[BRCMF_E_ESCAN_RESULT] =
-		brcmf_cfg80211_escan_handler;
+	brcmf_fweh_register(cfg->pub, BRCMF_E_ESCAN_RESULT,
+			    brcmf_cfg80211_escan_handler);
 	cfg->escan_info.escan_state = WL_ESCAN_STATE_IDLE;
 	/* Init scan_timeout timer */
 	init_timer(&cfg->escan_timeout);
@@ -2792,7 +2791,7 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 
 	WL_SCAN("Enter\n");
 
-	if (e->event_type == cpu_to_be32(BRCMF_E_PFN_NET_LOST)) {
+	if (e->event_code == BRCMF_E_PFN_NET_LOST) {
 		WL_SCAN("PFN NET LOST event. Do Nothing\n");
 		return 0;
 	}
@@ -3857,8 +3856,8 @@ static void brcmf_free_vif(struct brcmf_cfg80211_vif *vif)
 static bool brcmf_is_linkup(struct brcmf_cfg80211_info *cfg,
 			    const struct brcmf_event_msg *e)
 {
-	u32 event = be32_to_cpu(e->event_type);
-	u32 status = be32_to_cpu(e->status);
+	u32 event = e->event_code;
+	u32 status = e->status;
 
 	if (event == BRCMF_E_SET_SSID && status == BRCMF_E_STATUS_SUCCESS) {
 		WL_CONN("Processing set ssid\n");
@@ -3872,8 +3871,8 @@ static bool brcmf_is_linkup(struct brcmf_cfg80211_info *cfg,
 static bool brcmf_is_linkdown(struct brcmf_cfg80211_info *cfg,
 			      const struct brcmf_event_msg *e)
 {
-	u32 event = be32_to_cpu(e->event_type);
-	u16 flags = be16_to_cpu(e->flags);
+	u32 event = e->event_code;
+	u16 flags = e->flags;
 
 	if (event == BRCMF_E_LINK && (!(flags & BRCMF_EVENT_MSG_LINK))) {
 		WL_CONN("Processing link down\n");
@@ -3885,13 +3884,12 @@ static bool brcmf_is_linkdown(struct brcmf_cfg80211_info *cfg,
 static bool brcmf_is_nonetwork(struct brcmf_cfg80211_info *cfg,
 			       const struct brcmf_event_msg *e)
 {
-	u32 event = be32_to_cpu(e->event_type);
-	u32 status = be32_to_cpu(e->status);
+	u32 event = e->event_code;
+	u32 status = e->status;
 
 	if (event == BRCMF_E_LINK && status == BRCMF_E_STATUS_NO_NETWORKS) {
 		WL_CONN("Processing Link %s & no network found\n",
-				be16_to_cpu(e->flags) & BRCMF_EVENT_MSG_LINK ?
-				"up" : "down");
+			e->flags & BRCMF_EVENT_MSG_LINK ? "up" : "down");
 		return true;
 	}
 
@@ -4079,9 +4077,9 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 			       const struct brcmf_event_msg *e, void *data)
 {
 	s32 err = 0;
-	u32 event = be32_to_cpu(e->event_type);
-	u32 reason = be32_to_cpu(e->reason);
-	u32 len = be32_to_cpu(e->datalen);
+	u32 event = e->event_code;
+	u32 reason = e->reason;
+	u32 len = e->datalen;
 	static int generation;
 
 	struct station_info sinfo;
@@ -4170,8 +4168,8 @@ brcmf_notify_roaming_status(struct brcmf_if *ifp,
 {
 	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
 	s32 err = 0;
-	u32 event = be32_to_cpu(e->event_type);
-	u32 status = be32_to_cpu(e->status);
+	u32 event = e->event_code;
+	u32 status = e->status;
 
 	if (event == BRCMF_E_ROAM && status == BRCMF_E_STATUS_SUCCESS) {
 		if (test_bit(BRCMF_VIF_STATUS_CONNECTED, &ifp->vif->sme_state))
@@ -4187,7 +4185,7 @@ static s32
 brcmf_notify_mic_status(struct brcmf_if *ifp,
 			const struct brcmf_event_msg *e, void *data)
 {
-	u16 flags = be16_to_cpu(e->flags);
+	u16 flags = e->flags;
 	enum nl80211_key_type key_type;
 
 	if (flags & BRCMF_EVENT_MSG_GROUP)
@@ -4211,19 +4209,28 @@ static void brcmf_init_conf(struct brcmf_cfg80211_conf *conf)
 	conf->tx_power = -1;
 }
 
-static void brcmf_init_eloop_handler(struct brcmf_cfg80211_event_loop *el)
+static void brcmf_register_event_handlers(struct brcmf_cfg80211_info *cfg)
 {
-	memset(el, 0, sizeof(*el));
-	el->handler[BRCMF_E_LINK] = brcmf_notify_connect_status;
-	el->handler[BRCMF_E_DEAUTH_IND] = brcmf_notify_connect_status;
-	el->handler[BRCMF_E_DEAUTH] = brcmf_notify_connect_status;
-	el->handler[BRCMF_E_DISASSOC_IND] = brcmf_notify_connect_status;
-	el->handler[BRCMF_E_ASSOC_IND] = brcmf_notify_connect_status;
-	el->handler[BRCMF_E_REASSOC_IND] = brcmf_notify_connect_status;
-	el->handler[BRCMF_E_ROAM] = brcmf_notify_roaming_status;
-	el->handler[BRCMF_E_MIC_ERROR] = brcmf_notify_mic_status;
-	el->handler[BRCMF_E_SET_SSID] = brcmf_notify_connect_status;
-	el->handler[BRCMF_E_PFN_NET_FOUND] = brcmf_notify_sched_scan_results;
+	brcmf_fweh_register(cfg->pub, BRCMF_E_LINK,
+			    brcmf_notify_connect_status);
+	brcmf_fweh_register(cfg->pub, BRCMF_E_DEAUTH_IND,
+			    brcmf_notify_connect_status);
+	brcmf_fweh_register(cfg->pub, BRCMF_E_DEAUTH,
+			    brcmf_notify_connect_status);
+	brcmf_fweh_register(cfg->pub, BRCMF_E_DISASSOC_IND,
+			    brcmf_notify_connect_status);
+	brcmf_fweh_register(cfg->pub, BRCMF_E_ASSOC_IND,
+			    brcmf_notify_connect_status);
+	brcmf_fweh_register(cfg->pub, BRCMF_E_REASSOC_IND,
+			    brcmf_notify_connect_status);
+	brcmf_fweh_register(cfg->pub, BRCMF_E_ROAM,
+			    brcmf_notify_roaming_status);
+	brcmf_fweh_register(cfg->pub, BRCMF_E_MIC_ERROR,
+			    brcmf_notify_mic_status);
+	brcmf_fweh_register(cfg->pub, BRCMF_E_SET_SSID,
+			    brcmf_notify_connect_status);
+	brcmf_fweh_register(cfg->pub, BRCMF_E_PFN_NET_FOUND,
+			    brcmf_notify_sched_scan_results);
 }
 
 static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_info *cfg)
@@ -4261,115 +4268,6 @@ init_priv_mem_out:
 	return -ENOMEM;
 }
 
-/*
-* retrieve first queued event from head
-*/
-
-static struct brcmf_cfg80211_event_q *brcmf_deq_event(
-	struct brcmf_cfg80211_info *cfg)
-{
-	struct brcmf_cfg80211_event_q *e = NULL;
-
-	spin_lock_irq(&cfg->evt_q_lock);
-	if (!list_empty(&cfg->evt_q_list)) {
-		e = list_first_entry(&cfg->evt_q_list,
-				     struct brcmf_cfg80211_event_q, evt_q_list);
-		list_del(&e->evt_q_list);
-	}
-	spin_unlock_irq(&cfg->evt_q_lock);
-
-	return e;
-}
-
-/*
-*	push event to tail of the queue
-*
-*	remark: this function may not sleep as it is called in atomic context.
-*/
-
-static s32
-brcmf_enq_event(struct brcmf_if *ifp, u32 event,
-		const struct brcmf_event_msg *msg, void *data)
-{
-	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
-	struct brcmf_cfg80211_event_q *e;
-	s32 err = 0;
-	ulong flags;
-	u32 data_len;
-	u32 total_len;
-
-	total_len = sizeof(struct brcmf_cfg80211_event_q);
-	if (data)
-		data_len = be32_to_cpu(msg->datalen);
-	else
-		data_len = 0;
-	total_len += data_len;
-	e = kzalloc(total_len, GFP_ATOMIC);
-	if (!e)
-		return -ENOMEM;
-
-	e->etype = event;
-	e->ifp = ifp;
-	memcpy(&e->emsg, msg, sizeof(struct brcmf_event_msg));
-	if (data)
-		memcpy(&e->edata, data, data_len);
-
-	spin_lock_irqsave(&cfg->evt_q_lock, flags);
-	list_add_tail(&e->evt_q_list, &cfg->evt_q_list);
-	spin_unlock_irqrestore(&cfg->evt_q_lock, flags);
-
-	return err;
-}
-
-static void brcmf_put_event(struct brcmf_cfg80211_event_q *e)
-{
-	kfree(e);
-}
-
-static void brcmf_cfg80211_event_handler(struct work_struct *work)
-{
-	struct brcmf_cfg80211_info *cfg =
-			container_of(work, struct brcmf_cfg80211_info,
-				     event_work);
-	struct brcmf_cfg80211_event_q *e;
-
-	e = brcmf_deq_event(cfg);
-	if (unlikely(!e)) {
-		WL_ERR("event queue empty...\n");
-		return;
-	}
-
-	do {
-		WL_INFO("event type (%d)\n", e->etype);
-		if (cfg->el.handler[e->etype])
-			cfg->el.handler[e->etype](e->ifp, &e->emsg, e->edata);
-		else
-			WL_INFO("Unknown Event (%d): ignoring\n", e->etype);
-		brcmf_put_event(e);
-	} while ((e = brcmf_deq_event(cfg)));
-
-}
-
-static void brcmf_init_eq(struct brcmf_cfg80211_info *cfg)
-{
-	spin_lock_init(&cfg->evt_q_lock);
-	INIT_LIST_HEAD(&cfg->evt_q_list);
-}
-
-static void brcmf_flush_eq(struct brcmf_cfg80211_info *cfg)
-{
-	struct brcmf_cfg80211_event_q *e;
-
-	spin_lock_irq(&cfg->evt_q_lock);
-	while (!list_empty(&cfg->evt_q_list)) {
-		e = list_first_entry(&cfg->evt_q_list,
-				     struct brcmf_cfg80211_event_q, evt_q_list);
-		list_del(&e->evt_q_list);
-		kfree(e);
-	}
-	spin_unlock_irq(&cfg->evt_q_lock);
-}
-
 static s32 wl_init_priv(struct brcmf_cfg80211_info *cfg)
 {
 	s32 err = 0;
@@ -4381,12 +4279,10 @@ static s32 wl_init_priv(struct brcmf_cfg80211_info *cfg)
 	cfg->active_scan = true;	/* we do active scan for
 				 specific scan per default */
 	cfg->dongle_up = false;	/* dongle is not up yet */
-	brcmf_init_eq(cfg);
 	err = brcmf_init_priv_mem(cfg);
 	if (err)
 		return err;
-	INIT_WORK(&cfg->event_work, brcmf_cfg80211_event_handler);
-	brcmf_init_eloop_handler(&cfg->el);
+	brcmf_register_event_handlers(cfg);
 	mutex_init(&cfg->usr_sync);
 	brcmf_init_escan(cfg);
 	brcmf_init_conf(cfg->conf);
@@ -4397,9 +4293,7 @@ static s32 wl_init_priv(struct brcmf_cfg80211_info *cfg)
 
 static void wl_deinit_priv(struct brcmf_cfg80211_info *cfg)
 {
-	cancel_work_sync(&cfg->event_work);
 	cfg->dongle_up = false;	/* dongle down */
-	brcmf_flush_eq(cfg);
 	brcmf_link_down(cfg);
 	brcmf_abort_scanning(cfg);
 	brcmf_deinit_priv_mem(cfg);
@@ -4461,64 +4355,6 @@ void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg)
 	}
 }
 
-void brcmf_cfg80211_event(struct brcmf_if *ifp,
-			  const struct brcmf_event_msg *e, void *data)
-{
-	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
-	u32 event_type = be32_to_cpu(e->event_type);
-
-	if (!brcmf_enq_event(ifp, event_type, e, data))
-		schedule_work(&cfg->event_work);
-}
-
-static s32 brcmf_dongle_eventmsg(struct net_device *ndev)
-{
-	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
-	s32 err = 0;
-
-	WL_TRACE("Enter\n");
-
-	/* Setup event_msgs */
-	err = brcmf_fil_iovar_data_get(netdev_priv(ndev), "event_msgs",
-				       eventmask, BRCMF_EVENTING_MASK_LEN);
-	if (err) {
-		WL_ERR("Get event_msgs error (%d)\n", err);
-		goto dongle_eventmsg_out;
-	}
-
-	setbit(eventmask, BRCMF_E_SET_SSID);
-	setbit(eventmask, BRCMF_E_ROAM);
-	setbit(eventmask, BRCMF_E_PRUNE);
-	setbit(eventmask, BRCMF_E_AUTH);
-	setbit(eventmask, BRCMF_E_REASSOC);
-	setbit(eventmask, BRCMF_E_REASSOC_IND);
-	setbit(eventmask, BRCMF_E_DEAUTH_IND);
-	setbit(eventmask, BRCMF_E_DISASSOC_IND);
-	setbit(eventmask, BRCMF_E_DISASSOC);
-	setbit(eventmask, BRCMF_E_JOIN);
-	setbit(eventmask, BRCMF_E_ASSOC_IND);
-	setbit(eventmask, BRCMF_E_PSK_SUP);
-	setbit(eventmask, BRCMF_E_LINK);
-	setbit(eventmask, BRCMF_E_NDIS_LINK);
-	setbit(eventmask, BRCMF_E_MIC_ERROR);
-	setbit(eventmask, BRCMF_E_PMKID_CACHE);
-	setbit(eventmask, BRCMF_E_TXFAIL);
-	setbit(eventmask, BRCMF_E_JOIN_START);
-	setbit(eventmask, BRCMF_E_ESCAN_RESULT);
-	setbit(eventmask, BRCMF_E_PFN_NET_FOUND);
-
-	err = brcmf_fil_iovar_data_set(netdev_priv(ndev), "event_msgs",
-				       eventmask, BRCMF_EVENTING_MASK_LEN);
-	if (err) {
-		WL_ERR("Set event_msgs error (%d)\n", err);
-		goto dongle_eventmsg_out;
-	}
-
-dongle_eventmsg_out:
-	WL_TRACE("Exit\n");
-	return err;
-}
-
 static s32
 brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 {
@@ -4658,10 +4494,6 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 	brcmf_dongle_scantime(ndev, WL_SCAN_CHANNEL_TIME,
 			WL_SCAN_UNASSOC_TIME, WL_SCAN_PASSIVE_TIME);
 
-	err = brcmf_dongle_eventmsg(ndev);
-	if (err)
-		goto default_conf_out;
-
 	power_mode = cfg->pwr_save ? PM_FAST : PM_OFF;
 	err = brcmf_fil_cmd_int_set(netdev_priv(ndev), BRCMF_C_SET_PM,
 				    power_mode);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 399925d..80ba2ea 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -226,25 +226,6 @@ struct brcmf_cfg80211_vif {
 	struct list_head list;
 };
 
-/* forward declaration */
-struct brcmf_cfg80211_info;
-
-/* cfg80211 main event loop */
-struct brcmf_cfg80211_event_loop {
-	s32(*handler[BRCMF_E_LAST]) (struct brcmf_if *ifp,
-				     const struct brcmf_event_msg *e,
-				     void *data);
-};
-
-/* event queue for cfg80211 main event */
-struct brcmf_cfg80211_event_q {
-	struct list_head evt_q_list;
-	u32 etype;
-	struct brcmf_if *ifp;
-	struct brcmf_event_msg emsg;
-	s8 edata[1];
-};
-
 /* association inform */
 struct brcmf_cfg80211_connect_info {
 	u8 *req_ie;
@@ -365,9 +346,6 @@ struct brcmf_pno_scanresults_le {
  * @wiphy: wiphy object for cfg80211 interface.
  * @conf: dongle configuration.
  * @scan_request: cfg80211 scan request object.
- * @el: main event loop.
- * @evt_q_list: used for event queue.
- * @evt_q_lock: for event queue synchronization.
  * @usr_sync: mainly for dongle up/down synchronization.
  * @bss_list: bss_list holding scanned ap information.
  * @scan_req_int: internal scan request object.
@@ -375,7 +353,6 @@ struct brcmf_pno_scanresults_le {
  * @ie: information element object for internal purpose.
  * @conn_info: association info.
  * @pmk_list: wpa2 pmk list.
- * @event_work: event handler work struct.
  * @scan_status: scan activity on the dongle.
  * @pub: common driver information.
  * @channel: current channel.
@@ -401,9 +378,6 @@ struct brcmf_cfg80211_info {
 	struct wiphy *wiphy;
 	struct brcmf_cfg80211_conf *conf;
 	struct cfg80211_scan_request *scan_request;
-	struct brcmf_cfg80211_event_loop el;
-	struct list_head evt_q_list;
-	spinlock_t	 evt_q_lock;
 	struct mutex usr_sync;
 	struct brcmf_scan_results *bss_list;
 	struct brcmf_cfg80211_scan_req scan_req_int;
@@ -411,7 +385,6 @@ struct brcmf_cfg80211_info {
 	struct brcmf_cfg80211_ie ie;
 	struct brcmf_cfg80211_connect_info conn_info;
 	struct brcmf_cfg80211_pmk_list *pmk_list;
-	struct work_struct event_work;
 	unsigned long scan_status;
 	struct brcmf_pub *pub;
 	u32 channel;
@@ -482,10 +455,6 @@ brcmf_cfg80211_connect_info *cfg_to_conn(struct brcmf_cfg80211_info *cfg)
 
 struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr);
 void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg);
-
-/* event handler from dongle */
-void brcmf_cfg80211_event(struct brcmf_if *ifp, const struct brcmf_event_msg *e,
-			  void *data);
 s32 brcmf_cfg80211_up(struct brcmf_cfg80211_info *cfg);
 s32 brcmf_cfg80211_down(struct brcmf_cfg80211_info *cfg);
 
-- 
1.7.9.5


