Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4619 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758223Ab1F2Xth (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:37 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 043/119] staging: brcm80211: rename event handling
 definition
Date: Wed, 29 Jun 2011 16:47:07 -0700
Message-ID: <1309391303-22741-44-git-send-email-frankyl@broadcom.com> (sfid-20110630_015254_488247_A60610B7)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Renaming fullmac to have more consistent naming throughout the
driver. This commit renames identifiers related to firmware event
handling.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |  326 +++++++++++-----------
 drivers/staging/brcm80211/brcmfmac/dhd_common.c  |  242 ++++++++--------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |   56 ++--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |  111 ++++----
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |   10 +-
 5 files changed, 371 insertions(+), 374 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 55cbd8a..1145e5b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -136,11 +136,11 @@ struct dhd_info;
 #define DOT11_BSSTYPE_ANY			2
 #define DOT11_MAX_DEFAULT_KEYS	4
 
-#define WLC_EVENT_MSG_LINK		0x01
-#define WLC_EVENT_MSG_FLUSHTXQ		0x02
-#define WLC_EVENT_MSG_GROUP		0x04
+#define BRCMF_EVENT_MSG_LINK		0x01
+#define BRCMF_EVENT_MSG_FLUSHTXQ	0x02
+#define BRCMF_EVENT_MSG_GROUP		0x04
 
-typedef struct {
+typedef struct brcmf_event_msg {
 	u16 version;
 	u16 flags;
 	u32 event_type;
@@ -150,173 +150,169 @@ typedef struct {
 	u32 datalen;
 	u8 addr[ETH_ALEN];
 	char ifname[IFNAMSIZ];
-} __attribute__((packed)) wl_event_msg_t;
+} __packed brcmf_event_msg_t;
 
-typedef  struct bcmeth_hdr {
+struct brcm_ethhdr {
 	u16 subtype;
 	u16 length;
 	u8 version;
 	u8 oui[3];
 	u16 usr_subtype;
-} __attribute__((packed)) bcmeth_hdr_t;
+} __packed;
 
-#ifdef BRCM_FULLMAC
-typedef struct bcm_event {
+typedef struct brcmf_event {
 	struct ethhdr eth;
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
-#define WLC_E_ESCAN_RESULT	69
-#define WLC_E_ACTION_FRAME_OFF_CHAN_COMPLETE	70
-#define WLC_E_DCS_REQUEST 73
-
-#define WLC_E_FIFO_CREDIT_MAP	74
-
-#define WLC_E_LAST		75
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
+	struct brcm_ethhdr hdr;
+	struct brcmf_event_msg msg;
+} __packed brcmf_event_t;
+
+#define BRCMF_E_SET_SSID			0
+#define BRCMF_E_JOIN				1
+#define BRCMF_E_START				2
+#define BRCMF_E_AUTH				3
+#define BRCMF_E_AUTH_IND			4
+#define BRCMF_E_DEAUTH				5
+#define BRCMF_E_DEAUTH_IND			6
+#define BRCMF_E_ASSOC				7
+#define BRCMF_E_ASSOC_IND			8
+#define BRCMF_E_REASSOC				9
+#define BRCMF_E_REASSOC_IND			10
+#define BRCMF_E_DISASSOC			11
+#define BRCMF_E_DISASSOC_IND			12
+#define BRCMF_E_QUIET_START			13
+#define BRCMF_E_QUIET_END			14
+#define BRCMF_E_BEACON_RX			15
+#define BRCMF_E_LINK				16
+#define BRCMF_E_MIC_ERROR			17
+#define BRCMF_E_NDIS_LINK			18
+#define BRCMF_E_ROAM				19
+#define BRCMF_E_TXFAIL				20
+#define BRCMF_E_PMKID_CACHE			21
+#define BRCMF_E_RETROGRADE_TSF			22
+#define BRCMF_E_PRUNE				23
+#define BRCMF_E_AUTOAUTH			24
+#define BRCMF_E_EAPOL_MSG			25
+#define BRCMF_E_SCAN_COMPLETE			26
+#define BRCMF_E_ADDTS_IND			27
+#define BRCMF_E_DELTS_IND			28
+#define BRCMF_E_BCNSENT_IND			29
+#define BRCMF_E_BCNRX_MSG			30
+#define BRCMF_E_BCNLOST_MSG			31
+#define BRCMF_E_ROAM_PREP			32
+#define BRCMF_E_PFN_NET_FOUND			33
+#define BRCMF_E_PFN_NET_LOST			34
+#define BRCMF_E_RESET_COMPLETE			35
+#define BRCMF_E_JOIN_START			36
+#define BRCMF_E_ROAM_START			37
+#define BRCMF_E_ASSOC_START			38
+#define BRCMF_E_IBSS_ASSOC			39
+#define BRCMF_E_RADIO				40
+#define BRCMF_E_PSM_WATCHDOG			41
+#define BRCMF_E_PROBREQ_MSG			44
+#define BRCMF_E_SCAN_CONFIRM_IND		45
+#define BRCMF_E_PSK_SUP				46
+#define BRCMF_E_COUNTRY_CODE_CHANGED		47
+#define	BRCMF_E_EXCEEDED_MEDIUM_TIME		48
+#define BRCMF_E_ICV_ERROR			49
+#define BRCMF_E_UNICAST_DECODE_ERROR		50
+#define BRCMF_E_MULTICAST_DECODE_ERROR		51
+#define BRCMF_E_TRACE				52
+#define BRCMF_E_IF				54
+#define BRCMF_E_RSSI				56
+#define BRCMF_E_PFN_SCAN_COMPLETE		57
+#define BRCMF_E_EXTLOG_MSG			58
+#define BRCMF_E_ACTION_FRAME			59
+#define BRCMF_E_ACTION_FRAME_COMPLETE		60
+#define BRCMF_E_PRE_ASSOC_IND			61
+#define BRCMF_E_PRE_REASSOC_IND			62
+#define BRCMF_E_CHANNEL_ADOPTED			63
+#define BRCMF_E_AP_STARTED			64
+#define BRCMF_E_DFS_AP_STOP			65
+#define BRCMF_E_DFS_AP_RESUME			66
+#define BRCMF_E_RESERVED1			67
+#define BRCMF_E_RESERVED2			68
+#define BRCMF_E_ESCAN_RESULT			69
+#define BRCMF_E_ACTION_FRAME_OFF_CHAN_COMPLETE	70
+#define BRCMF_E_DCS_REQUEST			73
+
+#define BRCMF_E_FIFO_CREDIT_MAP			74
+
+#define BRCMF_E_LAST				75
+
+#define BRCMF_E_STATUS_SUCCESS			0
+#define BRCMF_E_STATUS_FAIL			1
+#define BRCMF_E_STATUS_TIMEOUT			2
+#define BRCMF_E_STATUS_NO_NETWORKS		3
+#define BRCMF_E_STATUS_ABORT			4
+#define BRCMF_E_STATUS_NO_ACK			5
+#define BRCMF_E_STATUS_UNSOLICITED		6
+#define BRCMF_E_STATUS_ATTEMPT			7
+#define BRCMF_E_STATUS_PARTIAL			8
+#define BRCMF_E_STATUS_NEWSCAN			9
+#define BRCMF_E_STATUS_NEWASSOC			10
+#define BRCMF_E_STATUS_11HQUIET			11
+#define BRCMF_E_STATUS_SUPPRESS			12
+#define BRCMF_E_STATUS_NOCHANS			13
+#define BRCMF_E_STATUS_CS_ABORT			15
+#define BRCMF_E_STATUS_ERROR			16
+
+#define BRCMF_E_REASON_INITIAL_ASSOC		0
+#define BRCMF_E_REASON_LOW_RSSI			1
+#define BRCMF_E_REASON_DEAUTH			2
+#define BRCMF_E_REASON_DISASSOC			3
+#define BRCMF_E_REASON_BCNS_LOST		4
+#define BRCMF_E_REASON_MINTXRATE		9
+#define BRCMF_E_REASON_TXFAIL			10
+
+#define BRCMF_E_REASON_FAST_ROAM_FAILED		5
+#define BRCMF_E_REASON_DIRECTED_ROAM		6
+#define BRCMF_E_REASON_TSPEC_REJECTED		7
+#define BRCMF_E_REASON_BETTER_AP		8
+
+#define BRCMF_E_PRUNE_ENCR_MISMATCH		1
+#define BRCMF_E_PRUNE_BCAST_BSSID		2
+#define BRCMF_E_PRUNE_MAC_DENY			3
+#define BRCMF_E_PRUNE_MAC_NA			4
+#define BRCMF_E_PRUNE_REG_PASSV			5
+#define BRCMF_E_PRUNE_SPCT_MGMT			6
+#define BRCMF_E_PRUNE_RADAR			7
+#define BRCMF_E_RSN_MISMATCH			8
+#define BRCMF_E_PRUNE_NO_COMMON_RATES		9
+#define BRCMF_E_PRUNE_BASIC_RATES		10
+#define BRCMF_E_PRUNE_CIPHER_NA			12
+#define BRCMF_E_PRUNE_KNOWN_STA			13
+#define BRCMF_E_PRUNE_WDS_PEER			15
+#define BRCMF_E_PRUNE_QBSS_LOAD			16
+#define BRCMF_E_PRUNE_HOME_AP			17
+
+#define BRCMF_E_SUP_OTHER			0
+#define BRCMF_E_SUP_DECRYPT_KEY_DATA		1
+#define BRCMF_E_SUP_BAD_UCAST_WEP128		2
+#define BRCMF_E_SUP_BAD_UCAST_WEP40		3
+#define BRCMF_E_SUP_UNSUP_KEY_LEN		4
+#define BRCMF_E_SUP_PW_KEY_CIPHER		5
+#define BRCMF_E_SUP_MSG3_TOO_MANY_IE		6
+#define BRCMF_E_SUP_MSG3_IE_MISMATCH		7
+#define BRCMF_E_SUP_NO_INSTALL_FLAG		8
+#define BRCMF_E_SUP_MSG3_NO_GTK			9
+#define BRCMF_E_SUP_GRP_KEY_CIPHER		10
+#define BRCMF_E_SUP_GRP_MSG1_NO_GTK		11
+#define BRCMF_E_SUP_GTK_DECRYPT_FAIL		12
+#define BRCMF_E_SUP_SEND_FAIL			13
+#define BRCMF_E_SUP_DEAUTH			14
+
+#define BRCMF_E_IF_ADD				1
+#define BRCMF_E_IF_DEL				2
+#define BRCMF_E_IF_CHANGE			3
+
+#define BRCMF_E_IF_ROLE_STA			0
+#define BRCMF_E_IF_ROLE_AP			1
+#define BRCMF_E_IF_ROLE_WDS			2
+
+#define BRCMF_E_LINK_BCN_LOSS			1
+#define BRCMF_E_LINK_DISASSOC			2
+#define BRCMF_E_LINK_ASSOC_REC			3
+#define BRCMF_E_LINK_BSSCFG_DIS			4
 
 enum cust_gpio_modes {
 	WLAN_RESET_ON,
@@ -950,7 +946,7 @@ extern int dhd_timeout_expired(dhd_timeout_t *tmo);
 extern int dhd_ifname2idx(struct dhd_info *dhd, char *name);
 extern u8 *dhd_bssidx2bssid(dhd_pub_t *dhd, int idx);
 extern int brcmf_c_host_event(struct dhd_info *dhd, int *idx, void *pktdata,
-			 wl_event_msg_t *, void **data_ptr);
+			 brcmf_event_msg_t *, void **data_ptr);
 
 extern void brcmf_c_init(void);
 
@@ -969,7 +965,7 @@ extern void dhd_vif_sendup(struct dhd_info *dhd, int ifidx, unsigned char * cp,
 extern int dhd_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pkt);
 
 /* Send event to host */
-extern void dhd_sendup_event(dhd_pub_t *dhdp, wl_event_msg_t *event,
+extern void dhd_sendup_event(dhd_pub_t *dhdp, brcmf_event_msg_t *event,
 			     void *data);
 extern int dhd_bus_devreset(dhd_pub_t *dhdp, u8 flag);
 extern uint dhd_bus_status(dhd_pub_t *dhdp);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 4318bed..b06d7e0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -517,7 +517,7 @@ int brcmf_c_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 }
 
 #ifdef SHOW_EVENTS
-static void brcmf_c_show_host_event(wl_event_msg_t *event, void *event_data)
+static void brcmf_c_show_host_event(brcmf_event_msg_t *event, void *event_data)
 {
 	uint i, status, reason;
 	bool group = false, flush_txq = false, link = false;
@@ -529,62 +529,62 @@ static void brcmf_c_show_host_event(wl_event_msg_t *event, void *event_data)
 		char *event_name;
 	} event_names[] = {
 		{
-		WLC_E_SET_SSID, "SET_SSID"}, {
-		WLC_E_JOIN, "JOIN"}, {
-		WLC_E_START, "START"}, {
-		WLC_E_AUTH, "AUTH"}, {
-		WLC_E_AUTH_IND, "AUTH_IND"}, {
-		WLC_E_DEAUTH, "DEAUTH"}, {
-		WLC_E_DEAUTH_IND, "DEAUTH_IND"}, {
-		WLC_E_ASSOC, "ASSOC"}, {
-		WLC_E_ASSOC_IND, "ASSOC_IND"}, {
-		WLC_E_REASSOC, "REASSOC"}, {
-		WLC_E_REASSOC_IND, "REASSOC_IND"}, {
-		WLC_E_DISASSOC, "DISASSOC"}, {
-		WLC_E_DISASSOC_IND, "DISASSOC_IND"}, {
-		WLC_E_QUIET_START, "START_QUIET"}, {
-		WLC_E_QUIET_END, "END_QUIET"}, {
-		WLC_E_BEACON_RX, "BEACON_RX"}, {
-		WLC_E_LINK, "LINK"}, {
-		WLC_E_MIC_ERROR, "MIC_ERROR"}, {
-		WLC_E_NDIS_LINK, "NDIS_LINK"}, {
-		WLC_E_ROAM, "ROAM"}, {
-		WLC_E_TXFAIL, "TXFAIL"}, {
-		WLC_E_PMKID_CACHE, "PMKID_CACHE"}, {
-		WLC_E_RETROGRADE_TSF, "RETROGRADE_TSF"}, {
-		WLC_E_PRUNE, "PRUNE"}, {
-		WLC_E_AUTOAUTH, "AUTOAUTH"}, {
-		WLC_E_EAPOL_MSG, "EAPOL_MSG"}, {
-		WLC_E_SCAN_COMPLETE, "SCAN_COMPLETE"}, {
-		WLC_E_ADDTS_IND, "ADDTS_IND"}, {
-		WLC_E_DELTS_IND, "DELTS_IND"}, {
-		WLC_E_BCNSENT_IND, "BCNSENT_IND"}, {
-		WLC_E_BCNRX_MSG, "BCNRX_MSG"}, {
-		WLC_E_BCNLOST_MSG, "BCNLOST_MSG"}, {
-		WLC_E_ROAM_PREP, "ROAM_PREP"}, {
-		WLC_E_PFN_NET_FOUND, "PNO_NET_FOUND"}, {
-		WLC_E_PFN_NET_LOST, "PNO_NET_LOST"}, {
-		WLC_E_RESET_COMPLETE, "RESET_COMPLETE"}, {
-		WLC_E_JOIN_START, "JOIN_START"}, {
-		WLC_E_ROAM_START, "ROAM_START"}, {
-		WLC_E_ASSOC_START, "ASSOC_START"}, {
-		WLC_E_IBSS_ASSOC, "IBSS_ASSOC"}, {
-		WLC_E_RADIO, "RADIO"}, {
-		WLC_E_PSM_WATCHDOG, "PSM_WATCHDOG"}, {
-		WLC_E_PROBREQ_MSG, "PROBREQ_MSG"}, {
-		WLC_E_SCAN_CONFIRM_IND, "SCAN_CONFIRM_IND"}, {
-		WLC_E_PSK_SUP, "PSK_SUP"}, {
-		WLC_E_COUNTRY_CODE_CHANGED, "COUNTRY_CODE_CHANGED"}, {
-		WLC_E_EXCEEDED_MEDIUM_TIME, "EXCEEDED_MEDIUM_TIME"}, {
-		WLC_E_ICV_ERROR, "ICV_ERROR"}, {
-		WLC_E_UNICAST_DECODE_ERROR, "UNICAST_DECODE_ERROR"}, {
-		WLC_E_MULTICAST_DECODE_ERROR, "MULTICAST_DECODE_ERROR"}, {
-		WLC_E_TRACE, "TRACE"}, {
-		WLC_E_ACTION_FRAME, "ACTION FRAME"}, {
-		WLC_E_ACTION_FRAME_COMPLETE, "ACTION FRAME TX COMPLETE"}, {
-		WLC_E_IF, "IF"}, {
-		WLC_E_RSSI, "RSSI"}, {
-		WLC_E_PFN_SCAN_COMPLETE, "SCAN_COMPLETE"}
+		BRCMF_E_SET_SSID, "SET_SSID"}, {
+		BRCMF_E_JOIN, "JOIN"}, {
+		BRCMF_E_START, "START"}, {
+		BRCMF_E_AUTH, "AUTH"}, {
+		BRCMF_E_AUTH_IND, "AUTH_IND"}, {
+		BRCMF_E_DEAUTH, "DEAUTH"}, {
+		BRCMF_E_DEAUTH_IND, "DEAUTH_IND"}, {
+		BRCMF_E_ASSOC, "ASSOC"}, {
+		BRCMF_E_ASSOC_IND, "ASSOC_IND"}, {
+		BRCMF_E_REASSOC, "REASSOC"}, {
+		BRCMF_E_REASSOC_IND, "REASSOC_IND"}, {
+		BRCMF_E_DISASSOC, "DISASSOC"}, {
+		BRCMF_E_DISASSOC_IND, "DISASSOC_IND"}, {
+		BRCMF_E_QUIET_START, "START_QUIET"}, {
+		BRCMF_E_QUIET_END, "END_QUIET"}, {
+		BRCMF_E_BEACON_RX, "BEACON_RX"}, {
+		BRCMF_E_LINK, "LINK"}, {
+		BRCMF_E_MIC_ERROR, "MIC_ERROR"}, {
+		BRCMF_E_NDIS_LINK, "NDIS_LINK"}, {
+		BRCMF_E_ROAM, "ROAM"}, {
+		BRCMF_E_TXFAIL, "TXFAIL"}, {
+		BRCMF_E_PMKID_CACHE, "PMKID_CACHE"}, {
+		BRCMF_E_RETROGRADE_TSF, "RETROGRADE_TSF"}, {
+		BRCMF_E_PRUNE, "PRUNE"}, {
+		BRCMF_E_AUTOAUTH, "AUTOAUTH"}, {
+		BRCMF_E_EAPOL_MSG, "EAPOL_MSG"}, {
+		BRCMF_E_SCAN_COMPLETE, "SCAN_COMPLETE"}, {
+		BRCMF_E_ADDTS_IND, "ADDTS_IND"}, {
+		BRCMF_E_DELTS_IND, "DELTS_IND"}, {
+		BRCMF_E_BCNSENT_IND, "BCNSENT_IND"}, {
+		BRCMF_E_BCNRX_MSG, "BCNRX_MSG"}, {
+		BRCMF_E_BCNLOST_MSG, "BCNLOST_MSG"}, {
+		BRCMF_E_ROAM_PREP, "ROAM_PREP"}, {
+		BRCMF_E_PFN_NET_FOUND, "PNO_NET_FOUND"}, {
+		BRCMF_E_PFN_NET_LOST, "PNO_NET_LOST"}, {
+		BRCMF_E_RESET_COMPLETE, "RESET_COMPLETE"}, {
+		BRCMF_E_JOIN_START, "JOIN_START"}, {
+		BRCMF_E_ROAM_START, "ROAM_START"}, {
+		BRCMF_E_ASSOC_START, "ASSOC_START"}, {
+		BRCMF_E_IBSS_ASSOC, "IBSS_ASSOC"}, {
+		BRCMF_E_RADIO, "RADIO"}, {
+		BRCMF_E_PSM_WATCHDOG, "PSM_WATCHDOG"}, {
+		BRCMF_E_PROBREQ_MSG, "PROBREQ_MSG"}, {
+		BRCMF_E_SCAN_CONFIRM_IND, "SCAN_CONFIRM_IND"}, {
+		BRCMF_E_PSK_SUP, "PSK_SUP"}, {
+		BRCMF_E_COUNTRY_CODE_CHANGED, "COUNTRY_CODE_CHANGED"}, {
+		BRCMF_E_EXCEEDED_MEDIUM_TIME, "EXCEEDED_MEDIUM_TIME"}, {
+		BRCMF_E_ICV_ERROR, "ICV_ERROR"}, {
+		BRCMF_E_UNICAST_DECODE_ERROR, "UNICAST_DECODE_ERROR"}, {
+		BRCMF_E_MULTICAST_DECODE_ERROR, "MULTICAST_DECODE_ERROR"}, {
+		BRCMF_E_TRACE, "TRACE"}, {
+		BRCMF_E_ACTION_FRAME, "ACTION FRAME"}, {
+		BRCMF_E_ACTION_FRAME_COMPLETE, "ACTION FRAME TX COMPLETE"}, {
+		BRCMF_E_IF, "IF"}, {
+		BRCMF_E_RSSI, "RSSI"}, {
+		BRCMF_E_PFN_SCAN_COMPLETE, "SCAN_COMPLETE"}
 	};
 	uint event_type, flags, auth_type, datalen;
 	event_type = be32_to_cpu(event->event_type);
@@ -606,34 +606,34 @@ static void brcmf_c_show_host_event(wl_event_msg_t *event, void *event_data)
 	DHD_EVENT(("flags 0x%04x, status %d, reason %d, auth_type %d MAC %s\n",
 				flags, status, reason, auth_type, eabuf));
 
-	if (flags & WLC_EVENT_MSG_LINK)
+	if (flags & BRCMF_EVENT_MSG_LINK)
 		link = true;
-	if (flags & WLC_EVENT_MSG_GROUP)
+	if (flags & BRCMF_EVENT_MSG_GROUP)
 		group = true;
-	if (flags & WLC_EVENT_MSG_FLUSHTXQ)
+	if (flags & BRCMF_EVENT_MSG_FLUSHTXQ)
 		flush_txq = true;
 
 	switch (event_type) {
-	case WLC_E_START:
-	case WLC_E_DEAUTH:
-	case WLC_E_DISASSOC:
+	case BRCMF_E_START:
+	case BRCMF_E_DEAUTH:
+	case BRCMF_E_DISASSOC:
 		DHD_EVENT(("MACEVENT: %s, MAC %s\n", event_name, eabuf));
 		break;
 
-	case WLC_E_ASSOC_IND:
-	case WLC_E_REASSOC_IND:
+	case BRCMF_E_ASSOC_IND:
+	case BRCMF_E_REASSOC_IND:
 		DHD_EVENT(("MACEVENT: %s, MAC %s\n", event_name, eabuf));
 		break;
 
-	case WLC_E_ASSOC:
-	case WLC_E_REASSOC:
-		if (status == WLC_E_STATUS_SUCCESS) {
+	case BRCMF_E_ASSOC:
+	case BRCMF_E_REASSOC:
+		if (status == BRCMF_E_STATUS_SUCCESS) {
 			DHD_EVENT(("MACEVENT: %s, MAC %s, SUCCESS\n",
 				   event_name, eabuf));
-		} else if (status == WLC_E_STATUS_TIMEOUT) {
+		} else if (status == BRCMF_E_STATUS_TIMEOUT) {
 			DHD_EVENT(("MACEVENT: %s, MAC %s, TIMEOUT\n",
 				   event_name, eabuf));
-		} else if (status == WLC_E_STATUS_FAIL) {
+		} else if (status == BRCMF_E_STATUS_FAIL) {
 			DHD_EVENT(("MACEVENT: %s, MAC %s, FAILURE, reason %d\n",
 				   event_name, eabuf, (int)reason));
 		} else {
@@ -642,14 +642,14 @@ static void brcmf_c_show_host_event(wl_event_msg_t *event, void *event_data)
 		}
 		break;
 
-	case WLC_E_DEAUTH_IND:
-	case WLC_E_DISASSOC_IND:
+	case BRCMF_E_DEAUTH_IND:
+	case BRCMF_E_DISASSOC_IND:
 		DHD_EVENT(("MACEVENT: %s, MAC %s, reason %d\n", event_name,
 			   eabuf, (int)reason));
 		break;
 
-	case WLC_E_AUTH:
-	case WLC_E_AUTH_IND:
+	case BRCMF_E_AUTH:
+	case BRCMF_E_AUTH_IND:
 		if (auth_type == WLAN_AUTH_OPEN)
 			auth_str = "Open System";
 		else if (auth_type == WLAN_AUTH_SHARED_KEY)
@@ -658,16 +658,16 @@ static void brcmf_c_show_host_event(wl_event_msg_t *event, void *event_data)
 			sprintf(err_msg, "AUTH unknown: %d", (int)auth_type);
 			auth_str = err_msg;
 		}
-		if (event_type == WLC_E_AUTH_IND) {
+		if (event_type == BRCMF_E_AUTH_IND) {
 			DHD_EVENT(("MACEVENT: %s, MAC %s, %s\n", event_name,
 				   eabuf, auth_str));
-		} else if (status == WLC_E_STATUS_SUCCESS) {
+		} else if (status == BRCMF_E_STATUS_SUCCESS) {
 			DHD_EVENT(("MACEVENT: %s, MAC %s, %s, SUCCESS\n",
 				   event_name, eabuf, auth_str));
-		} else if (status == WLC_E_STATUS_TIMEOUT) {
+		} else if (status == BRCMF_E_STATUS_TIMEOUT) {
 			DHD_EVENT(("MACEVENT: %s, MAC %s, %s, TIMEOUT\n",
 				   event_name, eabuf, auth_str));
-		} else if (status == WLC_E_STATUS_FAIL) {
+		} else if (status == BRCMF_E_STATUS_FAIL) {
 			DHD_EVENT(("MACEVENT: %s, MAC %s, %s, FAILURE, "
 				"reason %d\n",
 				event_name, eabuf, auth_str, (int)reason));
@@ -675,15 +675,15 @@ static void brcmf_c_show_host_event(wl_event_msg_t *event, void *event_data)
 
 		break;
 
-	case WLC_E_JOIN:
-	case WLC_E_ROAM:
-	case WLC_E_SET_SSID:
-		if (status == WLC_E_STATUS_SUCCESS) {
+	case BRCMF_E_JOIN:
+	case BRCMF_E_ROAM:
+	case BRCMF_E_SET_SSID:
+		if (status == BRCMF_E_STATUS_SUCCESS) {
 			DHD_EVENT(("MACEVENT: %s, MAC %s\n", event_name,
 				   eabuf));
-		} else if (status == WLC_E_STATUS_FAIL) {
+		} else if (status == BRCMF_E_STATUS_FAIL) {
 			DHD_EVENT(("MACEVENT: %s, failed\n", event_name));
-		} else if (status == WLC_E_STATUS_NO_NETWORKS) {
+		} else if (status == BRCMF_E_STATUS_NO_NETWORKS) {
 			DHD_EVENT(("MACEVENT: %s, no networks found\n",
 				   event_name));
 		} else {
@@ -692,10 +692,10 @@ static void brcmf_c_show_host_event(wl_event_msg_t *event, void *event_data)
 		}
 		break;
 
-	case WLC_E_BEACON_RX:
-		if (status == WLC_E_STATUS_SUCCESS) {
+	case BRCMF_E_BEACON_RX:
+		if (status == BRCMF_E_STATUS_SUCCESS) {
 			DHD_EVENT(("MACEVENT: %s, SUCCESS\n", event_name));
-		} else if (status == WLC_E_STATUS_FAIL) {
+		} else if (status == BRCMF_E_STATUS_FAIL) {
 			DHD_EVENT(("MACEVENT: %s, FAIL\n", event_name));
 		} else {
 			DHD_EVENT(("MACEVENT: %s, status %d\n", event_name,
@@ -703,44 +703,44 @@ static void brcmf_c_show_host_event(wl_event_msg_t *event, void *event_data)
 		}
 		break;
 
-	case WLC_E_LINK:
+	case BRCMF_E_LINK:
 		DHD_EVENT(("MACEVENT: %s %s\n", event_name,
 			   link ? "UP" : "DOWN"));
 		break;
 
-	case WLC_E_MIC_ERROR:
+	case BRCMF_E_MIC_ERROR:
 		DHD_EVENT(("MACEVENT: %s, MAC %s, Group %d, Flush %d\n",
 			   event_name, eabuf, group, flush_txq));
 		break;
 
-	case WLC_E_ICV_ERROR:
-	case WLC_E_UNICAST_DECODE_ERROR:
-	case WLC_E_MULTICAST_DECODE_ERROR:
+	case BRCMF_E_ICV_ERROR:
+	case BRCMF_E_UNICAST_DECODE_ERROR:
+	case BRCMF_E_MULTICAST_DECODE_ERROR:
 		DHD_EVENT(("MACEVENT: %s, MAC %s\n", event_name, eabuf));
 		break;
 
-	case WLC_E_TXFAIL:
+	case BRCMF_E_TXFAIL:
 		DHD_EVENT(("MACEVENT: %s, RA %s\n", event_name, eabuf));
 		break;
 
-	case WLC_E_SCAN_COMPLETE:
-	case WLC_E_PMKID_CACHE:
+	case BRCMF_E_SCAN_COMPLETE:
+	case BRCMF_E_PMKID_CACHE:
 		DHD_EVENT(("MACEVENT: %s\n", event_name));
 		break;
 
-	case WLC_E_PFN_NET_FOUND:
-	case WLC_E_PFN_NET_LOST:
-	case WLC_E_PFN_SCAN_COMPLETE:
+	case BRCMF_E_PFN_NET_FOUND:
+	case BRCMF_E_PFN_NET_LOST:
+	case BRCMF_E_PFN_SCAN_COMPLETE:
 		DHD_EVENT(("PNOEVENT: %s\n", event_name));
 		break;
 
-	case WLC_E_PSK_SUP:
-	case WLC_E_PRUNE:
+	case BRCMF_E_PSK_SUP:
+	case BRCMF_E_PRUNE:
 		DHD_EVENT(("MACEVENT: %s, status %d, reason %d\n",
 			   event_name, (int)status, (int)reason));
 		break;
 
-	case WLC_E_TRACE:
+	case BRCMF_E_TRACE:
 		{
 			static u32 seqnum_prev;
 			struct msgtrace_hdr hdr;
@@ -799,7 +799,7 @@ static void brcmf_c_show_host_event(wl_event_msg_t *event, void *event_data)
 		}
 		break;
 
-	case WLC_E_RSSI:
+	case BRCMF_E_RSSI:
 		DHD_EVENT(("MACEVENT: %s %d\n", event_name,
 			   be32_to_cpu(*((int *)event_data))));
 		break;
@@ -824,22 +824,22 @@ static void brcmf_c_show_host_event(wl_event_msg_t *event, void *event_data)
 
 int
 brcmf_c_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
-	      wl_event_msg_t *event, void **data_ptr)
+	      brcmf_event_msg_t *event, void **data_ptr)
 {
 	/* check whether packet is a BRCM event pkt */
-	bcm_event_t *pvt_data = (bcm_event_t *) pktdata;
+	brcmf_event_t *pvt_data = (brcmf_event_t *) pktdata;
 	char *event_data;
 	u32 type, status;
 	u16 flags;
 	int evlen;
 
-	if (memcmp(BRCM_OUI, &pvt_data->bcm_hdr.oui[0], DOT11_OUI_LEN)) {
+	if (memcmp(BRCM_OUI, &pvt_data->hdr.oui[0], DOT11_OUI_LEN)) {
 		DHD_ERROR(("%s: mismatched OUI, bailing\n", __func__));
 		return -EBADE;
 	}
 
 	/* BRCM event pkt may be unaligned - use xxx_ua to load user_subtype. */
-	if (get_unaligned_be16(&pvt_data->bcm_hdr.usr_subtype) !=
+	if (get_unaligned_be16(&pvt_data->hdr.usr_subtype) !=
 	    BCMILCP_BCM_SUBTYPE_EVENT) {
 		DHD_ERROR(("%s: mismatched subtype, bailing\n", __func__));
 		return -EBADE;
@@ -849,22 +849,22 @@ brcmf_c_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 	event_data = *data_ptr;
 
 	/* memcpy since BRCM event pkt may be unaligned. */
-	memcpy(event, &pvt_data->event, sizeof(wl_event_msg_t));
+	memcpy(event, &pvt_data->msg, sizeof(brcmf_event_msg_t));
 
 	type = get_unaligned_be32(&event->event_type);
 	flags = get_unaligned_be16(&event->flags);
 	status = get_unaligned_be32(&event->status);
-	evlen = get_unaligned_be32(&event->datalen) + sizeof(bcm_event_t);
+	evlen = get_unaligned_be32(&event->datalen) + sizeof(brcmf_event_t);
 
 	switch (type) {
-	case WLC_E_IF:
+	case BRCMF_E_IF:
 		{
 			dhd_if_event_t *ifevent = (dhd_if_event_t *) event_data;
 			DHD_TRACE(("%s: if event\n", __func__));
 
 			if (ifevent->ifidx > 0 &&
 				 ifevent->ifidx < DHD_MAX_IFS) {
-				if (ifevent->action == WLC_E_IF_ADD)
+				if (ifevent->action == BRCMF_E_IF_ADD)
 					dhd_add_if(dhd, ifevent->ifidx,
 						   NULL, event->ifname,
 						   pvt_data->eth.h_dest,
@@ -885,16 +885,16 @@ brcmf_c_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 		break;
 
 #ifdef P2P
-	case WLC_E_NDIS_LINK:
+	case BRCMF_E_NDIS_LINK:
 		break;
 #endif
 		/* fall through */
 		/* These are what external supplicant/authenticator wants */
-	case WLC_E_LINK:
-	case WLC_E_ASSOC_IND:
-	case WLC_E_REASSOC_IND:
-	case WLC_E_DISASSOC_IND:
-	case WLC_E_MIC_ERROR:
+	case BRCMF_E_LINK:
+	case BRCMF_E_ASSOC_IND:
+	case BRCMF_E_REASSOC_IND:
+	case BRCMF_E_DISASSOC_IND:
+	case BRCMF_E_MIC_ERROR:
 	default:
 		/* Fall through: this should get _everything_  */
 
@@ -904,16 +904,16 @@ brcmf_c_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 		DHD_TRACE(("%s: MAC event %d, flags %x, status %x\n",
 			   __func__, type, flags, status));
 
-		/* put it back to WLC_E_NDIS_LINK */
-		if (type == WLC_E_NDIS_LINK) {
+		/* put it back to BRCMF_E_NDIS_LINK */
+		if (type == BRCMF_E_NDIS_LINK) {
 			u32 temp;
 
 			temp = get_unaligned_be32(&event->event_type);
 			DHD_TRACE(("Converted to WLC_E_LINK type %d\n", temp));
 
-			temp = be32_to_cpu(WLC_E_NDIS_LINK);
-			memcpy((void *)(&pvt_data->event.event_type), &temp,
-			       sizeof(pvt_data->event.event_type));
+			temp = be32_to_cpu(BRCMF_E_NDIS_LINK);
+			memcpy((void *)(&pvt_data->msg.event_type), &temp,
+			       sizeof(pvt_data->msg.event_type));
 		}
 		break;
 	}
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 0ab95b3..c6cae48 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -376,7 +376,7 @@ static int dhd_toe_set(dhd_info_t *dhd, int idx, u32 toe_ol);
 #endif				/* TOE */
 
 static int dhd_wl_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
-			     wl_event_msg_t *event_ptr, void **data_ptr);
+			     brcmf_event_msg_t *event_ptr, void **data_ptr);
 
 static void dhd_set_packet_filter(int value, dhd_pub_t *dhd)
 {
@@ -791,10 +791,10 @@ static void dhd_op_if(dhd_if_t *ifp)
 	DHD_TRACE(("%s: idx %d, state %d\n", __func__, ifp->idx, ifp->state));
 
 	switch (ifp->state) {
-	case WLC_E_IF_ADD:
+	case BRCMF_E_IF_ADD:
 		/*
 		 * Delete the existing interface before overwriting it
-		 * in case we missed the WLC_E_IF_DEL event.
+		 * in case we missed the BRCMF_E_IF_DEL event.
 		 */
 		if (ifp->net != NULL) {
 			DHD_ERROR(("%s: ERROR: netdev:%s already exists, "
@@ -839,7 +839,7 @@ static void dhd_op_if(dhd_if_t *ifp)
 			}
 		}
 		break;
-	case WLC_E_IF_DEL:
+	case BRCMF_E_IF_DEL:
 		if (ifp->net != NULL) {
 			DHD_TRACE(("\n%s: got 'WLC_E_IF_DEL' state\n",
 				   __func__));
@@ -1100,7 +1100,7 @@ void dhd_rx_frame(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf,
 	struct sk_buff *pnext, *save_pktbuf;
 	int i;
 	dhd_if_t *ifp;
-	wl_event_msg_t event;
+	brcmf_event_msg_t event;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -1773,7 +1773,7 @@ dhd_add_if(dhd_info_t *dhd, int ifidx, void *handle, char *name,
 		memcpy(&ifp->mac_addr, mac_addr, ETH_ALEN);
 
 	if (handle == NULL) {
-		ifp->state = WLC_E_IF_ADD;
+		ifp->state = BRCMF_E_IF_ADD;
 		ifp->idx = ifidx;
 		ASSERT(dhd->sysioc_tsk);
 		up(&dhd->sysioc_sem);
@@ -1796,7 +1796,7 @@ void dhd_del_if(dhd_info_t *dhd, int ifidx)
 		return;
 	}
 
-	ifp->state = WLC_E_IF_DEL;
+	ifp->state = BRCMF_E_IF_DEL;
 	ifp->idx = ifidx;
 	ASSERT(dhd->sysioc_tsk);
 	up(&dhd->sysioc_sem);
@@ -2027,26 +2027,26 @@ int dhd_bus_start(dhd_pub_t *dhdp)
 	dhdcdc_query_ioctl(dhdp, 0, BRCMF_C_GET_VAR, iovbuf, sizeof(iovbuf));
 	memcpy(dhdp->eventmask, iovbuf, WL_EVENTING_MASK_LEN);
 
-	setbit(dhdp->eventmask, WLC_E_SET_SSID);
-	setbit(dhdp->eventmask, WLC_E_PRUNE);
-	setbit(dhdp->eventmask, WLC_E_AUTH);
-	setbit(dhdp->eventmask, WLC_E_REASSOC);
-	setbit(dhdp->eventmask, WLC_E_REASSOC_IND);
-	setbit(dhdp->eventmask, WLC_E_DEAUTH_IND);
-	setbit(dhdp->eventmask, WLC_E_DISASSOC_IND);
-	setbit(dhdp->eventmask, WLC_E_DISASSOC);
-	setbit(dhdp->eventmask, WLC_E_JOIN);
-	setbit(dhdp->eventmask, WLC_E_ASSOC_IND);
-	setbit(dhdp->eventmask, WLC_E_PSK_SUP);
-	setbit(dhdp->eventmask, WLC_E_LINK);
-	setbit(dhdp->eventmask, WLC_E_NDIS_LINK);
-	setbit(dhdp->eventmask, WLC_E_MIC_ERROR);
-	setbit(dhdp->eventmask, WLC_E_PMKID_CACHE);
-	setbit(dhdp->eventmask, WLC_E_TXFAIL);
-	setbit(dhdp->eventmask, WLC_E_JOIN_START);
-	setbit(dhdp->eventmask, WLC_E_SCAN_COMPLETE);
+	setbit(dhdp->eventmask, BRCMF_E_SET_SSID);
+	setbit(dhdp->eventmask, BRCMF_E_PRUNE);
+	setbit(dhdp->eventmask, BRCMF_E_AUTH);
+	setbit(dhdp->eventmask, BRCMF_E_REASSOC);
+	setbit(dhdp->eventmask, BRCMF_E_REASSOC_IND);
+	setbit(dhdp->eventmask, BRCMF_E_DEAUTH_IND);
+	setbit(dhdp->eventmask, BRCMF_E_DISASSOC_IND);
+	setbit(dhdp->eventmask, BRCMF_E_DISASSOC);
+	setbit(dhdp->eventmask, BRCMF_E_JOIN);
+	setbit(dhdp->eventmask, BRCMF_E_ASSOC_IND);
+	setbit(dhdp->eventmask, BRCMF_E_PSK_SUP);
+	setbit(dhdp->eventmask, BRCMF_E_LINK);
+	setbit(dhdp->eventmask, BRCMF_E_NDIS_LINK);
+	setbit(dhdp->eventmask, BRCMF_E_MIC_ERROR);
+	setbit(dhdp->eventmask, BRCMF_E_PMKID_CACHE);
+	setbit(dhdp->eventmask, BRCMF_E_TXFAIL);
+	setbit(dhdp->eventmask, BRCMF_E_JOIN_START);
+	setbit(dhdp->eventmask, BRCMF_E_SCAN_COMPLETE);
 #ifdef PNO_SUPPORT
-	setbit(dhdp->eventmask, WLC_E_PFN_NET_FOUND);
+	setbit(dhdp->eventmask, BRCMF_E_PFN_NET_FOUND);
 #endif				/* PNO_SUPPORT */
 
 /* enable dongle roaming event */
@@ -2501,7 +2501,7 @@ void dhd_os_sdunlock(dhd_pub_t *pub)
 
 static int
 dhd_wl_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
-		  wl_event_msg_t *event, void **data)
+		  brcmf_event_msg_t *event, void **data)
 {
 	int bcmerror = 0;
 
@@ -2520,7 +2520,7 @@ dhd_wl_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
 }
 
 /* send up locally generated event */
-void dhd_sendup_event(dhd_pub_t *dhdp, wl_event_msg_t *event, void *data)
+void dhd_sendup_event(dhd_pub_t *dhdp, brcmf_event_msg_t *event, void *data)
 {
 	switch (be32_to_cpu(event->event_type)) {
 	default:
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index ee751a0..b30ae73 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -123,24 +123,24 @@ static void wl_init_eq_lock(struct wl_priv *wl);
 static void wl_init_eloop_handler(struct wl_event_loop *el);
 static struct wl_event_q *wl_deq_event(struct wl_priv *wl);
 static s32 wl_enq_event(struct wl_priv *wl, u32 type,
-			  const wl_event_msg_t *msg, void *data);
+			  const brcmf_event_msg_t *msg, void *data);
 static void wl_put_event(struct wl_event_q *e);
 static void wl_wakeup_event(struct wl_priv *wl);
 static s32 wl_notify_connect_status(struct wl_priv *wl,
 				      struct net_device *ndev,
-				      const wl_event_msg_t *e, void *data);
+				      const brcmf_event_msg_t *e, void *data);
 static s32 wl_notify_roaming_status(struct wl_priv *wl,
 				      struct net_device *ndev,
-				      const wl_event_msg_t *e, void *data);
+				      const brcmf_event_msg_t *e, void *data);
 static s32 wl_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
-				   const wl_event_msg_t *e, void *data);
+				   const brcmf_event_msg_t *e, void *data);
 static s32 wl_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
-				 const wl_event_msg_t *e, void *data,
+				 const brcmf_event_msg_t *e, void *data,
 				bool completed);
 static s32 wl_bss_roaming_done(struct wl_priv *wl, struct net_device *ndev,
-				 const wl_event_msg_t *e, void *data);
+				 const brcmf_event_msg_t *e, void *data);
 static s32 wl_notify_mic_status(struct wl_priv *wl, struct net_device *ndev,
-				  const wl_event_msg_t *e, void *data);
+				  const brcmf_event_msg_t *e, void *data);
 
 /*
 ** register/deregister sdio function
@@ -171,7 +171,7 @@ static s32 wl_set_retry(struct net_device *dev, u32 retry, bool l);
 /*
 ** wl profile utilities
 */
-static s32 wl_update_prof(struct wl_priv *wl, const wl_event_msg_t *e,
+static s32 wl_update_prof(struct wl_priv *wl, const brcmf_event_msg_t *e,
 			    void *data, s32 item);
 static void *wl_read_prof(struct wl_priv *wl, s32 item);
 static void wl_init_prof(struct wl_profile *prof);
@@ -237,9 +237,9 @@ static bool wl_is_ibssmode(struct wl_priv *wl);
 /*
 ** dongle up/down , default configuration utilities
 */
-static bool wl_is_linkdown(struct wl_priv *wl, const wl_event_msg_t *e);
-static bool wl_is_linkup(struct wl_priv *wl, const wl_event_msg_t *e);
-static bool wl_is_nonetwork(struct wl_priv *wl, const wl_event_msg_t *e);
+static bool wl_is_linkdown(struct wl_priv *wl, const brcmf_event_msg_t *e);
+static bool wl_is_linkup(struct wl_priv *wl, const brcmf_event_msg_t *e);
+static bool wl_is_nonetwork(struct wl_priv *wl, const brcmf_event_msg_t *e);
 static void wl_link_down(struct wl_priv *wl);
 static s32 wl_dongle_mode(struct net_device *ndev, s32 iftype);
 static s32 __wl_cfg80211_up(struct wl_priv *wl);
@@ -2569,12 +2569,12 @@ CleanUp:
 	return err;
 }
 
-static bool wl_is_linkup(struct wl_priv *wl, const wl_event_msg_t *e)
+static bool wl_is_linkup(struct wl_priv *wl, const brcmf_event_msg_t *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
 	u32 status = be32_to_cpu(e->status);
 
-	if (event == WLC_E_SET_SSID && status == WLC_E_STATUS_SUCCESS) {
+	if (event == BRCMF_E_SET_SSID && status == BRCMF_E_STATUS_SUCCESS) {
 		WL_CONN("Processing set ssid\n");
 		wl->link_up = true;
 		return true;
@@ -2583,31 +2583,31 @@ static bool wl_is_linkup(struct wl_priv *wl, const wl_event_msg_t *e)
 	return false;
 }
 
-static bool wl_is_linkdown(struct wl_priv *wl, const wl_event_msg_t *e)
+static bool wl_is_linkdown(struct wl_priv *wl, const brcmf_event_msg_t *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
 	u16 flags = be16_to_cpu(e->flags);
 
-	if (event == WLC_E_LINK && (!(flags & WLC_EVENT_MSG_LINK))) {
+	if (event == BRCMF_E_LINK && (!(flags & BRCMF_EVENT_MSG_LINK))) {
 		WL_CONN("Processing link down\n");
 		return true;
 	}
 	return false;
 }
 
-static bool wl_is_nonetwork(struct wl_priv *wl, const wl_event_msg_t *e)
+static bool wl_is_nonetwork(struct wl_priv *wl, const brcmf_event_msg_t *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
 	u32 status = be32_to_cpu(e->status);
 
-	if (event == WLC_E_LINK && status == WLC_E_STATUS_NO_NETWORKS) {
+	if (event == BRCMF_E_LINK && status == BRCMF_E_STATUS_NO_NETWORKS) {
 		WL_CONN("Processing Link %s & no network found\n",
-				be16_to_cpu(e->flags) & WLC_EVENT_MSG_LINK ?
+				be16_to_cpu(e->flags) & BRCMF_EVENT_MSG_LINK ?
 				"up" : "down");
 		return true;
 	}
 
-	if (event == WLC_E_SET_SSID && status != WLC_E_STATUS_SUCCESS) {
+	if (event == BRCMF_E_SET_SSID && status != BRCMF_E_STATUS_SUCCESS) {
 		WL_CONN("Processing connecting & no network found\n");
 		return true;
 	}
@@ -2617,7 +2617,7 @@ static bool wl_is_nonetwork(struct wl_priv *wl, const wl_event_msg_t *e)
 
 static s32
 wl_notify_connect_status(struct wl_priv *wl, struct net_device *ndev,
-			 const wl_event_msg_t *e, void *data)
+			 const brcmf_event_msg_t *e, void *data)
 {
 	s32 err = 0;
 
@@ -2661,13 +2661,13 @@ wl_notify_connect_status(struct wl_priv *wl, struct net_device *ndev,
 
 static s32
 wl_notify_roaming_status(struct wl_priv *wl, struct net_device *ndev,
-			 const wl_event_msg_t *e, void *data)
+			 const brcmf_event_msg_t *e, void *data)
 {
 	s32 err = 0;
 	u32 event = be32_to_cpu(e->event_type);
 	u32 status = be32_to_cpu(e->status);
 
-	if (event == WLC_E_ROAM && status == WLC_E_STATUS_SUCCESS) {
+	if (event == BRCMF_E_ROAM && status == BRCMF_E_STATUS_SUCCESS) {
 		if (test_bit(WL_STATUS_CONNECTED, &wl->status))
 			wl_bss_roaming_done(wl, ndev, e, data);
 		else
@@ -2873,7 +2873,7 @@ update_bss_info_out:
 
 static s32
 wl_bss_roaming_done(struct wl_priv *wl, struct net_device *ndev,
-		    const wl_event_msg_t *e, void *data)
+		    const brcmf_event_msg_t *e, void *data)
 {
 	struct wl_connect_info *conn_info = wl_to_conn(wl);
 	s32 err = 0;
@@ -2897,7 +2897,7 @@ wl_bss_roaming_done(struct wl_priv *wl, struct net_device *ndev,
 
 static s32
 wl_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
-		    const wl_event_msg_t *e, void *data, bool completed)
+		    const brcmf_event_msg_t *e, void *data, bool completed)
 {
 	struct wl_connect_info *conn_info = wl_to_conn(wl);
 	s32 err = 0;
@@ -2929,13 +2929,13 @@ wl_bss_connect_done(struct wl_priv *wl, struct net_device *ndev,
 
 static s32
 wl_notify_mic_status(struct wl_priv *wl, struct net_device *ndev,
-		     const wl_event_msg_t *e, void *data)
+		     const brcmf_event_msg_t *e, void *data)
 {
 	u16 flags = be16_to_cpu(e->flags);
 	enum nl80211_key_type key_type;
 
 	rtnl_lock();
-	if (flags & WLC_EVENT_MSG_GROUP)
+	if (flags & BRCMF_EVENT_MSG_GROUP)
 		key_type = NL80211_KEYTYPE_GROUP;
 	else
 		key_type = NL80211_KEYTYPE_PAIRWISE;
@@ -2949,7 +2949,7 @@ wl_notify_mic_status(struct wl_priv *wl, struct net_device *ndev,
 
 static s32
 wl_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
-		      const wl_event_msg_t *e, void *data)
+		      const brcmf_event_msg_t *e, void *data)
 {
 	struct channel_info channel_inform;
 	struct wl_scan_results *bss_list;
@@ -3037,11 +3037,11 @@ static void wl_init_prof(struct wl_profile *prof)
 static void wl_init_eloop_handler(struct wl_event_loop *el)
 {
 	memset(el, 0, sizeof(*el));
-	el->handler[WLC_E_SCAN_COMPLETE] = wl_notify_scan_status;
-	el->handler[WLC_E_LINK] = wl_notify_connect_status;
-	el->handler[WLC_E_ROAM] = wl_notify_roaming_status;
-	el->handler[WLC_E_MIC_ERROR] = wl_notify_mic_status;
-	el->handler[WLC_E_SET_SSID] = wl_notify_connect_status;
+	el->handler[BRCMF_E_SCAN_COMPLETE] = wl_notify_scan_status;
+	el->handler[BRCMF_E_LINK] = wl_notify_connect_status;
+	el->handler[BRCMF_E_ROAM] = wl_notify_roaming_status;
+	el->handler[BRCMF_E_MIC_ERROR] = wl_notify_mic_status;
+	el->handler[BRCMF_E_SET_SSID] = wl_notify_connect_status;
 }
 
 static s32 wl_init_priv_mem(struct wl_priv *wl)
@@ -3530,7 +3530,8 @@ static s32 wl_event_handler(void *data)
 }
 
 void
-wl_cfg80211_event(struct net_device *ndev, const wl_event_msg_t * e, void *data)
+wl_cfg80211_event(struct net_device *ndev,
+		  const brcmf_event_msg_t *e, void *data)
 {
 	u32 event_type = be32_to_cpu(e->event_type);
 	struct wl_priv *wl = ndev_to_wl(ndev);
@@ -3581,7 +3582,7 @@ static struct wl_event_q *wl_deq_event(struct wl_priv *wl)
 */
 
 static s32
-wl_enq_event(struct wl_priv *wl, u32 event, const wl_event_msg_t *msg,
+wl_enq_event(struct wl_priv *wl, u32 event, const brcmf_event_msg_t *msg,
 	     void *data)
 {
 	struct wl_event_q *e;
@@ -3594,7 +3595,7 @@ wl_enq_event(struct wl_priv *wl, u32 event, const wl_event_msg_t *msg,
 	}
 
 	e->etype = event;
-	memcpy(&e->emsg, msg, sizeof(wl_event_msg_t));
+	memcpy(&e->emsg, msg, sizeof(brcmf_event_msg_t));
 	if (data) {
 	}
 	wl_lock_eq(wl);
@@ -3882,25 +3883,25 @@ static s32 wl_dongle_eventmsg(struct net_device *ndev)
 	}
 	memcpy(eventmask, iovbuf, WL_EVENTING_MASK_LEN);
 
-	setbit(eventmask, WLC_E_SET_SSID);
-	setbit(eventmask, WLC_E_ROAM);
-	setbit(eventmask, WLC_E_PRUNE);
-	setbit(eventmask, WLC_E_AUTH);
-	setbit(eventmask, WLC_E_REASSOC);
-	setbit(eventmask, WLC_E_REASSOC_IND);
-	setbit(eventmask, WLC_E_DEAUTH_IND);
-	setbit(eventmask, WLC_E_DISASSOC_IND);
-	setbit(eventmask, WLC_E_DISASSOC);
-	setbit(eventmask, WLC_E_JOIN);
-	setbit(eventmask, WLC_E_ASSOC_IND);
-	setbit(eventmask, WLC_E_PSK_SUP);
-	setbit(eventmask, WLC_E_LINK);
-	setbit(eventmask, WLC_E_NDIS_LINK);
-	setbit(eventmask, WLC_E_MIC_ERROR);
-	setbit(eventmask, WLC_E_PMKID_CACHE);
-	setbit(eventmask, WLC_E_TXFAIL);
-	setbit(eventmask, WLC_E_JOIN_START);
-	setbit(eventmask, WLC_E_SCAN_COMPLETE);
+	setbit(eventmask, BRCMF_E_SET_SSID);
+	setbit(eventmask, BRCMF_E_ROAM);
+	setbit(eventmask, BRCMF_E_PRUNE);
+	setbit(eventmask, BRCMF_E_AUTH);
+	setbit(eventmask, BRCMF_E_REASSOC);
+	setbit(eventmask, BRCMF_E_REASSOC_IND);
+	setbit(eventmask, BRCMF_E_DEAUTH_IND);
+	setbit(eventmask, BRCMF_E_DISASSOC_IND);
+	setbit(eventmask, BRCMF_E_DISASSOC);
+	setbit(eventmask, BRCMF_E_JOIN);
+	setbit(eventmask, BRCMF_E_ASSOC_IND);
+	setbit(eventmask, BRCMF_E_PSK_SUP);
+	setbit(eventmask, BRCMF_E_LINK);
+	setbit(eventmask, BRCMF_E_NDIS_LINK);
+	setbit(eventmask, BRCMF_E_MIC_ERROR);
+	setbit(eventmask, BRCMF_E_PMKID_CACHE);
+	setbit(eventmask, BRCMF_E_TXFAIL);
+	setbit(eventmask, BRCMF_E_JOIN_START);
+	setbit(eventmask, BRCMF_E_SCAN_COMPLETE);
 
 	brcmu_mkiovar("event_msgs", eventmask, WL_EVENTING_MASK_LEN, iovbuf,
 		    sizeof(iovbuf));
@@ -4200,7 +4201,7 @@ static void *wl_read_prof(struct wl_priv *wl, s32 item)
 }
 
 static s32
-wl_update_prof(struct wl_priv *wl, const wl_event_msg_t *e, void *data,
+wl_update_prof(struct wl_priv *wl, const brcmf_event_msg_t *e, void *data,
 	       s32 item)
 {
 	s32 err = 0;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 3b0c8ae..77d0559 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -188,9 +188,9 @@ struct wl_conf {
 
 /* cfg80211 main event loop */
 struct wl_event_loop {
-	s32(*handler[WLC_E_LAST]) (struct wl_priv *wl,
+	s32(*handler[BRCMF_E_LAST]) (struct wl_priv *wl,
 				     struct net_device *ndev,
-				     const wl_event_msg_t *e, void *data);
+				     const brcmf_event_msg_t *e, void *data);
 };
 
 /* representing interface of cfg80211 plane */
@@ -226,7 +226,7 @@ struct wl_ie {
 struct wl_event_q {
 	struct list_head eq_list;
 	u32 etype;
-	wl_event_msg_t emsg;
+	brcmf_event_msg_t emsg;
 	s8 edata[1];
 };
 
@@ -387,8 +387,8 @@ static inline struct wl_bss_info *next_bss(struct wl_scan_results *list,
 extern s32 wl_cfg80211_attach(struct net_device *ndev, void *data);
 extern void wl_cfg80211_detach(void);
 /* event handler from dongle */
-extern void wl_cfg80211_event(struct net_device *ndev, const wl_event_msg_t *e,
-			      void *data);
+extern void wl_cfg80211_event(struct net_device *ndev,
+			      const brcmf_event_msg_t *e, void *data);
 extern void wl_cfg80211_sdio_func(void *func);	/* set sdio function info */
 extern struct sdio_func *wl_cfg80211_get_sdio_func(void);	/* set sdio function info */
 extern s32 wl_cfg80211_up(void);	/* dongle up */
-- 
1.7.1


