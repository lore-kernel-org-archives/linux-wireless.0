Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3840 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758823Ab1FALqa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:30 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 28/83] staging: brcm80211: cleaned bcmeth.h and
 bcmevent.h
Date: Wed, 1 Jun 2011 13:45:13 +0200
Message-ID: <1306928768-7501-28-git-send-email-rvossen@broadcom.com> (sfid-20110601_134922_204239_0D733DB4)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Deleted unused definitions and moved others into less
generic files.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h           |  195 +++++++++++++++++++-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |    1 +
 drivers/staging/brcm80211/include/proto/bcmeth.h   |   24 ---
 drivers/staging/brcm80211/include/proto/bcmevent.h |  185 -------------------
 4 files changed, 194 insertions(+), 211 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index eca6732..081cda0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -37,8 +37,6 @@
 #include "bcmdefs.h"
 /* The kernel threading is sdio-specific */
 #include "bcmwifi.h"
-#include "proto/bcmeth.h"
-#include "proto/bcmevent.h"
 
 /* Forward decls */
 struct dhd_bus;
@@ -190,6 +188,191 @@ struct dhd_info;
 #define DOT11_BSSTYPE_ANY			2
 #define DOT11_MAX_DEFAULT_KEYS	4
 
+#define BCM_EVENT_MSG_VERSION		1
+#define BCM_MSG_IFNAME_MAX		16
+
+#define WLC_EVENT_MSG_LINK		0x01
+#define WLC_EVENT_MSG_FLUSHTXQ		0x02
+#define WLC_EVENT_MSG_GROUP		0x04
+
+typedef struct {
+	u16 version;
+	u16 flags;
+	u32 event_type;
+	u32 status;
+	u32 reason;
+	u32 auth_type;
+	u32 datalen;
+	u8 addr[ETH_ALEN];
+	char ifname[BCM_MSG_IFNAME_MAX];
+} __attribute__((packed)) wl_event_msg_t;
+
+typedef  struct bcmeth_hdr {
+	u16 subtype;
+	u16 length;
+	u8 version;
+	u8 oui[3];
+	u16 usr_subtype;
+} __attribute__((packed)) bcmeth_hdr_t;
+
+#ifdef BRCM_FULLMAC
+typedef struct bcm_event {
+	struct ethhdr eth;
+	bcmeth_hdr_t		bcm_hdr;
+	wl_event_msg_t		event;
+} __attribute__((packed)) bcm_event_t;
+#endif
+#define BCM_MSG_LEN	(sizeof(bcm_event_t) - sizeof(bcmeth_hdr_t) - \
+	sizeof(struct ether_header))
+
+#define WLC_E_SET_SSID		0
+#define WLC_E_JOIN		1
+#define WLC_E_START		2
+#define WLC_E_AUTH		3
+#define WLC_E_AUTH_IND		4
+#define WLC_E_DEAUTH		5
+#define WLC_E_DEAUTH_IND	6
+#define WLC_E_ASSOC		7
+#define WLC_E_ASSOC_IND		8
+#define WLC_E_REASSOC		9
+#define WLC_E_REASSOC_IND	10
+#define WLC_E_DISASSOC		11
+#define WLC_E_DISASSOC_IND	12
+#define WLC_E_QUIET_START	13
+#define WLC_E_QUIET_END		14
+#define WLC_E_BEACON_RX		15
+#define WLC_E_LINK		16
+#define WLC_E_MIC_ERROR		17
+#define WLC_E_NDIS_LINK		18
+#define WLC_E_ROAM		19
+#define WLC_E_TXFAIL		20
+#define WLC_E_PMKID_CACHE	21
+#define WLC_E_RETROGRADE_TSF	22
+#define WLC_E_PRUNE		23
+#define WLC_E_AUTOAUTH		24
+#define WLC_E_EAPOL_MSG		25
+#define WLC_E_SCAN_COMPLETE	26
+#define WLC_E_ADDTS_IND		27
+#define WLC_E_DELTS_IND		28
+#define WLC_E_BCNSENT_IND	29
+#define WLC_E_BCNRX_MSG		30
+#define WLC_E_BCNLOST_MSG	31
+#define WLC_E_ROAM_PREP		32
+#define WLC_E_PFN_NET_FOUND	33
+#define WLC_E_PFN_NET_LOST	34
+#define WLC_E_RESET_COMPLETE	35
+#define WLC_E_JOIN_START	36
+#define WLC_E_ROAM_START	37
+#define WLC_E_ASSOC_START	38
+#define WLC_E_IBSS_ASSOC	39
+#define WLC_E_RADIO		40
+#define WLC_E_PSM_WATCHDOG	41
+#define WLC_E_PROBREQ_MSG       44
+#define WLC_E_SCAN_CONFIRM_IND  45
+#define WLC_E_PSK_SUP		46
+#define WLC_E_COUNTRY_CODE_CHANGED 47
+#define	WLC_E_EXCEEDED_MEDIUM_TIME 48
+#define WLC_E_ICV_ERROR		49
+#define WLC_E_UNICAST_DECODE_ERROR 50
+#define WLC_E_MULTICAST_DECODE_ERROR 51
+#define WLC_E_TRACE		52
+#define WLC_E_IF		54
+#define WLC_E_RSSI		56
+#define WLC_E_PFN_SCAN_COMPLETE	57
+#define WLC_E_EXTLOG_MSG	58
+#define WLC_E_ACTION_FRAME      59
+#define WLC_E_ACTION_FRAME_COMPLETE 60
+#define WLC_E_PRE_ASSOC_IND	61
+#define WLC_E_PRE_REASSOC_IND	62
+#define WLC_E_CHANNEL_ADOPTED	63
+#define WLC_E_AP_STARTED	64
+#define WLC_E_DFS_AP_STOP	65
+#define WLC_E_DFS_AP_RESUME	66
+#define WLC_E_RESERVED1		67
+#define WLC_E_RESERVED2		68
+#define WLC_E_ESCAN_RESULT 	69
+#define WLC_E_ACTION_FRAME_OFF_CHAN_COMPLETE 	70
+#define WLC_E_DCS_REQUEST 73
+
+#define WLC_E_FIFO_CREDIT_MAP	74
+
+#define WLC_E_LAST		75
+
+#define WLC_E_STATUS_SUCCESS		0
+#define WLC_E_STATUS_FAIL		1
+#define WLC_E_STATUS_TIMEOUT		2
+#define WLC_E_STATUS_NO_NETWORKS	3
+#define WLC_E_STATUS_ABORT		4
+#define WLC_E_STATUS_NO_ACK		5
+#define WLC_E_STATUS_UNSOLICITED	6
+#define WLC_E_STATUS_ATTEMPT		7
+#define WLC_E_STATUS_PARTIAL		8
+#define WLC_E_STATUS_NEWSCAN		9
+#define WLC_E_STATUS_NEWASSOC		10
+#define WLC_E_STATUS_11HQUIET		11
+#define WLC_E_STATUS_SUPPRESS		12
+#define WLC_E_STATUS_NOCHANS		13
+#define WLC_E_STATUS_CS_ABORT		15
+#define WLC_E_STATUS_ERROR		16
+
+#define WLC_E_REASON_INITIAL_ASSOC	0
+#define WLC_E_REASON_LOW_RSSI		1
+#define WLC_E_REASON_DEAUTH		2
+#define WLC_E_REASON_DISASSOC		3
+#define WLC_E_REASON_BCNS_LOST		4
+#define WLC_E_REASON_MINTXRATE		9
+#define WLC_E_REASON_TXFAIL		10
+
+#define WLC_E_REASON_FAST_ROAM_FAILED	5
+#define WLC_E_REASON_DIRECTED_ROAM	6
+#define WLC_E_REASON_TSPEC_REJECTED	7
+#define WLC_E_REASON_BETTER_AP		8
+
+#define WLC_E_PRUNE_ENCR_MISMATCH	1
+#define WLC_E_PRUNE_BCAST_BSSID		2
+#define WLC_E_PRUNE_MAC_DENY		3
+#define WLC_E_PRUNE_MAC_NA		4
+#define WLC_E_PRUNE_REG_PASSV		5
+#define WLC_E_PRUNE_SPCT_MGMT		6
+#define WLC_E_PRUNE_RADAR		7
+#define WLC_E_RSN_MISMATCH		8
+#define WLC_E_PRUNE_NO_COMMON_RATES	9
+#define WLC_E_PRUNE_BASIC_RATES		10
+#define WLC_E_PRUNE_CIPHER_NA		12
+#define WLC_E_PRUNE_KNOWN_STA		13
+#define WLC_E_PRUNE_WDS_PEER		15
+#define WLC_E_PRUNE_QBSS_LOAD		16
+#define WLC_E_PRUNE_HOME_AP		17
+
+#define WLC_E_SUP_OTHER			0
+#define WLC_E_SUP_DECRYPT_KEY_DATA	1
+#define WLC_E_SUP_BAD_UCAST_WEP128	2
+#define WLC_E_SUP_BAD_UCAST_WEP40	3
+#define WLC_E_SUP_UNSUP_KEY_LEN		4
+#define WLC_E_SUP_PW_KEY_CIPHER		5
+#define WLC_E_SUP_MSG3_TOO_MANY_IE	6
+#define WLC_E_SUP_MSG3_IE_MISMATCH	7
+#define WLC_E_SUP_NO_INSTALL_FLAG	8
+#define WLC_E_SUP_MSG3_NO_GTK		9
+#define WLC_E_SUP_GRP_KEY_CIPHER	10
+#define WLC_E_SUP_GRP_MSG1_NO_GTK	11
+#define WLC_E_SUP_GTK_DECRYPT_FAIL	12
+#define WLC_E_SUP_SEND_FAIL		13
+#define WLC_E_SUP_DEAUTH		14
+
+#define WLC_E_IF_ADD		1
+#define WLC_E_IF_DEL		2
+#define WLC_E_IF_CHANGE		3
+
+#define WLC_E_IF_ROLE_STA		0
+#define WLC_E_IF_ROLE_AP		1
+#define WLC_E_IF_ROLE_WDS		2
+
+#define WLC_E_LINK_BCN_LOSS	1
+#define WLC_E_LINK_DISASSOC	2
+#define WLC_E_LINK_ASSOC_REC	3
+#define WLC_E_LINK_BSSCFG_DIS	4
+
 enum cust_gpio_modes {
 	WLAN_RESET_ON,
 	WLAN_RESET_OFF,
@@ -600,6 +783,11 @@ typedef struct {
 	u32 tick;		/* O/S tick time (usec) */
 } dhd_timeout_t;
 
+typedef struct {
+	uint event;
+	const char *name;
+} bcmevent_name_t;
+
 #if defined(CONFIG_PM_SLEEP)
 extern atomic_t dhd_mmc_suspend;
 #define DHD_PM_RESUME_WAIT_INIT(a) DECLARE_WAIT_QUEUE_HEAD(a);
@@ -708,6 +896,9 @@ extern char fw_path[MOD_PARAM_PATHLEN];
 extern char nv_path[MOD_PARAM_PATHLEN];
 
 extern u32 g_assert_type;
+extern const bcmevent_name_t bcmevent_names[];
+extern const int bcmevent_names_size;
+
 
 static inline void MUTEX_LOCK_INIT(dhd_pub_t *dhdp)
 {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index b7f4e63..85d87db 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -27,6 +27,7 @@
 
 #define BRCM_OUI		"\x00\x10\x18"
 #define DOT11_OUI_LEN			3
+#define BCMILCP_BCM_SUBTYPE_EVENT		1
 
 int dhd_msg_level;
 char fw_path[MOD_PARAM_PATHLEN];
diff --git a/drivers/staging/brcm80211/include/proto/bcmeth.h b/drivers/staging/brcm80211/include/proto/bcmeth.h
index e98ee65..0053984 100644
--- a/drivers/staging/brcm80211/include/proto/bcmeth.h
+++ b/drivers/staging/brcm80211/include/proto/bcmeth.h
@@ -17,28 +17,4 @@
 #ifndef _BCMETH_H_
 #define _BCMETH_H_
 
-#define	BCMILCP_SUBTYPE_RATE		1
-#define	BCMILCP_SUBTYPE_LINK		2
-#define	BCMILCP_SUBTYPE_CSA		3
-#define	BCMILCP_SUBTYPE_LARQ		4
-#define BCMILCP_SUBTYPE_VENDOR		5
-#define	BCMILCP_SUBTYPE_FLH		17
-#define BCMILCP_SUBTYPE_VENDOR_LONG	32769
-#define BCMILCP_SUBTYPE_CERT		32770
-#define BCMILCP_SUBTYPE_SES		32771
-#define BCMILCP_BCM_SUBTYPE_RESERVED		0
-#define BCMILCP_BCM_SUBTYPE_EVENT		1
-#define BCMILCP_BCM_SUBTYPE_SES			2
-#define BCMILCP_BCM_SUBTYPE_DPT			4
-#define BCMILCP_BCM_SUBTYPEHDR_MINLENGTH	8
-#define BCMILCP_BCM_SUBTYPEHDR_VERSION		0
-
-typedef  struct bcmeth_hdr {
-	u16 subtype;
-	u16 length;
-	u8 version;
-	u8 oui[3];
-	u16 usr_subtype;
-} __attribute__((packed)) bcmeth_hdr_t;
-
 #endif				/* _BCMETH_H_ */
diff --git a/drivers/staging/brcm80211/include/proto/bcmevent.h b/drivers/staging/brcm80211/include/proto/bcmevent.h
index 1b60789..1f4ab64 100644
--- a/drivers/staging/brcm80211/include/proto/bcmevent.h
+++ b/drivers/staging/brcm80211/include/proto/bcmevent.h
@@ -19,189 +19,4 @@
 
 #include <linux/if_ether.h>
 
-#define BCM_EVENT_MSG_VERSION		1
-#define BCM_MSG_IFNAME_MAX		16
-
-#define WLC_EVENT_MSG_LINK		0x01
-#define WLC_EVENT_MSG_FLUSHTXQ		0x02
-#define WLC_EVENT_MSG_GROUP		0x04
-
-typedef struct {
-	u16 version;
-	u16 flags;
-	u32 event_type;
-	u32 status;
-	u32 reason;
-	u32 auth_type;
-	u32 datalen;
-	u8 addr[ETH_ALEN];
-	char ifname[BCM_MSG_IFNAME_MAX];
-} __attribute__((packed)) wl_event_msg_t;
-
-#ifdef BRCM_FULLMAC
-typedef struct bcm_event {
-	struct ethhdr eth;
-	bcmeth_hdr_t		bcm_hdr;
-	wl_event_msg_t		event;
-} __attribute__((packed)) bcm_event_t;
-#endif
-#define BCM_MSG_LEN	(sizeof(bcm_event_t) - sizeof(bcmeth_hdr_t) - \
-	sizeof(struct ether_header))
-
-#define WLC_E_SET_SSID		0
-#define WLC_E_JOIN		1
-#define WLC_E_START		2
-#define WLC_E_AUTH		3
-#define WLC_E_AUTH_IND		4
-#define WLC_E_DEAUTH		5
-#define WLC_E_DEAUTH_IND	6
-#define WLC_E_ASSOC		7
-#define WLC_E_ASSOC_IND		8
-#define WLC_E_REASSOC		9
-#define WLC_E_REASSOC_IND	10
-#define WLC_E_DISASSOC		11
-#define WLC_E_DISASSOC_IND	12
-#define WLC_E_QUIET_START	13
-#define WLC_E_QUIET_END		14
-#define WLC_E_BEACON_RX		15
-#define WLC_E_LINK		16
-#define WLC_E_MIC_ERROR		17
-#define WLC_E_NDIS_LINK		18
-#define WLC_E_ROAM		19
-#define WLC_E_TXFAIL		20
-#define WLC_E_PMKID_CACHE	21
-#define WLC_E_RETROGRADE_TSF	22
-#define WLC_E_PRUNE		23
-#define WLC_E_AUTOAUTH		24
-#define WLC_E_EAPOL_MSG		25
-#define WLC_E_SCAN_COMPLETE	26
-#define WLC_E_ADDTS_IND		27
-#define WLC_E_DELTS_IND		28
-#define WLC_E_BCNSENT_IND	29
-#define WLC_E_BCNRX_MSG		30
-#define WLC_E_BCNLOST_MSG	31
-#define WLC_E_ROAM_PREP		32
-#define WLC_E_PFN_NET_FOUND	33
-#define WLC_E_PFN_NET_LOST	34
-#define WLC_E_RESET_COMPLETE	35
-#define WLC_E_JOIN_START	36
-#define WLC_E_ROAM_START	37
-#define WLC_E_ASSOC_START	38
-#define WLC_E_IBSS_ASSOC	39
-#define WLC_E_RADIO		40
-#define WLC_E_PSM_WATCHDOG	41
-#define WLC_E_PROBREQ_MSG       44
-#define WLC_E_SCAN_CONFIRM_IND  45
-#define WLC_E_PSK_SUP		46
-#define WLC_E_COUNTRY_CODE_CHANGED 47
-#define	WLC_E_EXCEEDED_MEDIUM_TIME 48
-#define WLC_E_ICV_ERROR		49
-#define WLC_E_UNICAST_DECODE_ERROR 50
-#define WLC_E_MULTICAST_DECODE_ERROR 51
-#define WLC_E_TRACE		52
-#define WLC_E_IF		54
-#define WLC_E_RSSI		56
-#define WLC_E_PFN_SCAN_COMPLETE	57
-#define WLC_E_EXTLOG_MSG	58
-#define WLC_E_ACTION_FRAME      59
-#define WLC_E_ACTION_FRAME_COMPLETE 60
-#define WLC_E_PRE_ASSOC_IND	61
-#define WLC_E_PRE_REASSOC_IND	62
-#define WLC_E_CHANNEL_ADOPTED	63
-#define WLC_E_AP_STARTED	64
-#define WLC_E_DFS_AP_STOP	65
-#define WLC_E_DFS_AP_RESUME	66
-#define WLC_E_RESERVED1		67
-#define WLC_E_RESERVED2		68
-#define WLC_E_ESCAN_RESULT 	69
-#define WLC_E_ACTION_FRAME_OFF_CHAN_COMPLETE 	70
-#define WLC_E_DCS_REQUEST 73
-
-#define WLC_E_FIFO_CREDIT_MAP	74
-
-#define WLC_E_LAST		75
-
-typedef struct {
-	uint event;
-	const char *name;
-} bcmevent_name_t;
-
-extern const bcmevent_name_t bcmevent_names[];
-extern const int bcmevent_names_size;
-
-#define WLC_E_STATUS_SUCCESS		0
-#define WLC_E_STATUS_FAIL		1
-#define WLC_E_STATUS_TIMEOUT		2
-#define WLC_E_STATUS_NO_NETWORKS	3
-#define WLC_E_STATUS_ABORT		4
-#define WLC_E_STATUS_NO_ACK		5
-#define WLC_E_STATUS_UNSOLICITED	6
-#define WLC_E_STATUS_ATTEMPT		7
-#define WLC_E_STATUS_PARTIAL		8
-#define WLC_E_STATUS_NEWSCAN		9
-#define WLC_E_STATUS_NEWASSOC		10
-#define WLC_E_STATUS_11HQUIET		11
-#define WLC_E_STATUS_SUPPRESS		12
-#define WLC_E_STATUS_NOCHANS		13
-#define WLC_E_STATUS_CS_ABORT		15
-#define WLC_E_STATUS_ERROR		16
-
-#define WLC_E_REASON_INITIAL_ASSOC	0
-#define WLC_E_REASON_LOW_RSSI		1
-#define WLC_E_REASON_DEAUTH		2
-#define WLC_E_REASON_DISASSOC		3
-#define WLC_E_REASON_BCNS_LOST		4
-#define WLC_E_REASON_MINTXRATE		9
-#define WLC_E_REASON_TXFAIL		10
-
-#define WLC_E_REASON_FAST_ROAM_FAILED	5
-#define WLC_E_REASON_DIRECTED_ROAM	6
-#define WLC_E_REASON_TSPEC_REJECTED	7
-#define WLC_E_REASON_BETTER_AP		8
-
-#define WLC_E_PRUNE_ENCR_MISMATCH	1
-#define WLC_E_PRUNE_BCAST_BSSID		2
-#define WLC_E_PRUNE_MAC_DENY		3
-#define WLC_E_PRUNE_MAC_NA		4
-#define WLC_E_PRUNE_REG_PASSV		5
-#define WLC_E_PRUNE_SPCT_MGMT		6
-#define WLC_E_PRUNE_RADAR		7
-#define WLC_E_RSN_MISMATCH		8
-#define WLC_E_PRUNE_NO_COMMON_RATES	9
-#define WLC_E_PRUNE_BASIC_RATES		10
-#define WLC_E_PRUNE_CIPHER_NA		12
-#define WLC_E_PRUNE_KNOWN_STA		13
-#define WLC_E_PRUNE_WDS_PEER		15
-#define WLC_E_PRUNE_QBSS_LOAD		16
-#define WLC_E_PRUNE_HOME_AP		17
-
-#define WLC_E_SUP_OTHER			0
-#define WLC_E_SUP_DECRYPT_KEY_DATA	1
-#define WLC_E_SUP_BAD_UCAST_WEP128	2
-#define WLC_E_SUP_BAD_UCAST_WEP40	3
-#define WLC_E_SUP_UNSUP_KEY_LEN		4
-#define WLC_E_SUP_PW_KEY_CIPHER		5
-#define WLC_E_SUP_MSG3_TOO_MANY_IE	6
-#define WLC_E_SUP_MSG3_IE_MISMATCH	7
-#define WLC_E_SUP_NO_INSTALL_FLAG	8
-#define WLC_E_SUP_MSG3_NO_GTK		9
-#define WLC_E_SUP_GRP_KEY_CIPHER	10
-#define WLC_E_SUP_GRP_MSG1_NO_GTK	11
-#define WLC_E_SUP_GTK_DECRYPT_FAIL	12
-#define WLC_E_SUP_SEND_FAIL		13
-#define WLC_E_SUP_DEAUTH		14
-
-#define WLC_E_IF_ADD		1
-#define WLC_E_IF_DEL		2
-#define WLC_E_IF_CHANGE		3
-
-#define WLC_E_IF_ROLE_STA		0
-#define WLC_E_IF_ROLE_AP		1
-#define WLC_E_IF_ROLE_WDS		2
-
-#define WLC_E_LINK_BCN_LOSS	1
-#define WLC_E_LINK_DISASSOC	2
-#define WLC_E_LINK_ASSOC_REC	3
-#define WLC_E_LINK_BSSCFG_DIS	4
-
 #endif				/* _BCMEVENT_H_ */
-- 
1.7.4.1


