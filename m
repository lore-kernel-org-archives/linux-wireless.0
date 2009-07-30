Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:40940 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbZG3Qrf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 12:47:35 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 08/10] rndis_wlan: handle 802.11 indications from device
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Date: Thu, 30 Jul 2009 19:41:58 +0300
Message-ID: <20090730164157.28317.48523.stgit@fate.lan>
In-Reply-To: <20090730164120.28317.53313.stgit@fate.lan>
References: <20090730164120.28317.53313.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add handling for 802.11 specific rndis indications.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |  233 +++++++++++++++++++++++++++++++++++++
 include/linux/usb/rndis_host.h    |   13 +-
 2 files changed, 239 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 6b6452b..7a50cfa 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -201,6 +201,24 @@ enum ndis_80211_priv_filter {
 	NDIS_80211_PRIV_8021X_WEP
 };
 
+enum ndis_80211_status_type {
+	NDIS_80211_STATUSTYPE_AUTHENTICATION,
+	NDIS_80211_STATUSTYPE_MEDIASTREAMMODE,
+	NDIS_80211_STATUSTYPE_PMKID_CANDIDATELIST,
+	NDIS_80211_STATUSTYPE_RADIOSTATE,
+};
+
+enum ndis_80211_media_stream_mode {
+	NDIS_80211_MEDIA_STREAM_OFF,
+	NDIS_80211_MEDIA_STREAM_ON
+};
+
+enum ndis_80211_radio_status {
+	NDIS_80211_RADIO_STATUS_ON,
+	NDIS_80211_RADIO_STATUS_HARDWARE_OFF,
+	NDIS_80211_RADIO_STATUS_SOFTWARE_OFF,
+};
+
 enum ndis_80211_addkey_bits {
 	NDIS_80211_ADDKEY_8021X_AUTH = cpu_to_le32(1 << 28),
 	NDIS_80211_ADDKEY_SET_INIT_RECV_SEQ = cpu_to_le32(1 << 29),
@@ -213,6 +231,35 @@ enum ndis_80211_addwep_bits {
 	NDIS_80211_ADDWEP_TRANSMIT_KEY = cpu_to_le32(1 << 31)
 };
 
+struct ndis_80211_auth_request {
+	__le32 length;
+	u8 bssid[6];
+	u8 padding[2];
+	__le32 flags;
+} __attribute__((packed));
+
+struct ndis_80211_pmkid_candidate {
+	u8 bssid[6];
+	u8 padding[2];
+	__le32 flags;
+} __attribute__((packed));
+
+struct ndis_80211_pmkid_cand_list {
+	__le32 version;
+	__le32 num_candidates;
+	struct ndis_80211_pmkid_candidate candidate_list[0];
+} __attribute__((packed));
+
+struct ndis_80211_status_indication {
+	__le32 status_type;
+	union {
+		enum ndis_80211_media_stream_mode	media_stream_mode;
+		enum ndis_80211_radio_status		radio_status;
+		struct ndis_80211_auth_request		auth_request[0];
+		struct ndis_80211_pmkid_cand_list	cand_list;
+	} u;
+} __attribute__((packed));
+
 struct ndis_80211_ssid {
 	__le32 length;
 	u8 essid[NDIS_802_11_LENGTH_SSID];
@@ -2211,16 +2258,195 @@ static void rndis_wlan_set_multicast_list(struct net_device *dev)
 	queue_work(priv->workqueue, &priv->work);
 }
 
+
+static void rndis_wlan_auth_indication(struct usbnet *usbdev,
+				struct ndis_80211_status_indication *indication,
+				int len)
+{
+	u8 *buf;
+	const char *type;
+	int flags, buflen;
+	bool pairwise_error, group_error;
+	struct ndis_80211_auth_request *auth_req;
+
+	/* must have at least one array entry */
+	if (len < offsetof(struct ndis_80211_status_indication, u) +
+				sizeof(struct ndis_80211_auth_request)) {
+		devinfo(usbdev, "authentication indication: "
+				"too short message (%i)", len);
+		return;
+	}
+
+	buf = (void *)&indication->u.auth_request[0];
+	buflen = len - offsetof(struct ndis_80211_status_indication, u);
+
+	while (buflen >= sizeof(*auth_req)) {
+		auth_req = (void *)buf;
+		type = "unknown";
+		flags = le32_to_cpu(auth_req->flags);
+		pairwise_error = false;
+		group_error = false;
+
+		if (flags & 0x1)
+			type = "reauth request";
+		if (flags & 0x2)
+			type = "key update request";
+		if (flags & 0x6) {
+			pairwise_error = true;
+			type = "pairwise_error";
+		}
+		if (flags & 0xe) {
+			group_error = true;
+			type = "group_error";
+		}
+
+		devinfo(usbdev, "authentication indication: %s (0x%08x)", type,
+				le32_to_cpu(auth_req->flags));
+
+		if (pairwise_error || group_error) {
+			union iwreq_data wrqu;
+			struct iw_michaelmicfailure micfailure;
+
+			memset(&micfailure, 0, sizeof(micfailure));
+			if (pairwise_error)
+				micfailure.flags |= IW_MICFAILURE_PAIRWISE;
+			if (group_error)
+				micfailure.flags |= IW_MICFAILURE_GROUP;
+
+			memcpy(micfailure.src_addr.sa_data, auth_req->bssid,
+				ETH_ALEN);
+
+			memset(&wrqu, 0, sizeof(wrqu));
+			wrqu.data.length = sizeof(micfailure);
+			wireless_send_event(usbdev->net, IWEVMICHAELMICFAILURE,
+						&wrqu, (u8 *)&micfailure);
+		}
+
+		buflen -= le32_to_cpu(auth_req->length);
+		buf += le32_to_cpu(auth_req->length);
+	}
+}
+
+static void rndis_wlan_pmkid_cand_list_indication(struct usbnet *usbdev,
+				struct ndis_80211_status_indication *indication,
+				int len)
+{
+	struct ndis_80211_pmkid_cand_list *cand_list;
+	int list_len, expected_len, i;
+
+	if (len < offsetof(struct ndis_80211_status_indication, u) +
+				sizeof(struct ndis_80211_pmkid_cand_list)) {
+		devinfo(usbdev, "pmkid candidate list indication: "
+				"too short message (%i)", len);
+		return;
+	}
+
+	list_len = le32_to_cpu(indication->u.cand_list.num_candidates) *
+			sizeof(struct ndis_80211_pmkid_candidate);
+	expected_len = sizeof(struct ndis_80211_pmkid_cand_list) + list_len +
+			offsetof(struct ndis_80211_status_indication, u);
+
+	if (len < expected_len) {
+		devinfo(usbdev, "pmkid candidate list indication: "
+				"list larger than buffer (%i < %i)",
+				len, expected_len);
+		return;
+	}
+
+	cand_list = &indication->u.cand_list;
+
+	devinfo(usbdev, "pmkid candidate list indication: "
+			"version %i, candidates %i",
+			le32_to_cpu(cand_list->version),
+			le32_to_cpu(cand_list->num_candidates));
+
+	if (le32_to_cpu(cand_list->version) != 1)
+		return;
+
+	for (i = 0; i < le32_to_cpu(cand_list->num_candidates); i++) {
+		struct iw_pmkid_cand pcand;
+		union iwreq_data wrqu;
+		struct ndis_80211_pmkid_candidate *cand =
+						&cand_list->candidate_list[i];
+
+		devdbg(usbdev, "cand[%i]: flags: 0x%08x, bssid: %pM",
+				i, le32_to_cpu(cand->flags), cand->bssid);
+
+		memset(&pcand, 0, sizeof(pcand));
+		if (le32_to_cpu(cand->flags) & 0x01)
+			pcand.flags |= IW_PMKID_CAND_PREAUTH;
+		pcand.index = i;
+		memcpy(pcand.bssid.sa_data, cand->bssid, ETH_ALEN);
+
+		memset(&wrqu, 0, sizeof(wrqu));
+		wrqu.data.length = sizeof(pcand);
+		wireless_send_event(usbdev->net, IWEVPMKIDCAND, &wrqu,
+								(u8 *)&pcand);
+	}
+}
+
+static void rndis_wlan_media_specific_indication(struct usbnet *usbdev,
+			struct rndis_indicate *msg, int buflen)
+{
+	struct ndis_80211_status_indication *indication;
+	int len, offset;
+
+	offset = offsetof(struct rndis_indicate, status) +
+			le32_to_cpu(msg->offset);
+	len = le32_to_cpu(msg->length);
+
+	if (len < 8) {
+		devinfo(usbdev, "media specific indication, "
+				"ignore too short message (%i < 8)", len);
+		return;
+	}
+
+	if (offset + len > buflen) {
+		devinfo(usbdev, "media specific indication, "
+				"too large to fit to buffer (%i > %i)",
+				offset + len, buflen);
+		return;
+	}
+
+	indication = (void *)((u8 *)msg + offset);
+
+	switch (le32_to_cpu(indication->status_type)) {
+	case NDIS_80211_STATUSTYPE_RADIOSTATE:
+		devinfo(usbdev, "radio state indication: %i",
+			le32_to_cpu(indication->u.radio_status));
+		return;
+
+	case NDIS_80211_STATUSTYPE_MEDIASTREAMMODE:
+		devinfo(usbdev, "media stream mode indication: %i",
+			le32_to_cpu(indication->u.media_stream_mode));
+		return;
+
+	case NDIS_80211_STATUSTYPE_AUTHENTICATION:
+		rndis_wlan_auth_indication(usbdev, indication, len);
+		return;
+
+	case NDIS_80211_STATUSTYPE_PMKID_CANDIDATELIST:
+		rndis_wlan_pmkid_cand_list_indication(usbdev, indication, len);
+		return;
+
+	default:
+		devinfo(usbdev, "media specific indication: "
+				"unknown status type 0x%08x",
+				le32_to_cpu(indication->status_type));
+	}
+}
+
+
 static void rndis_wlan_indication(struct usbnet *usbdev, void *ind, int buflen)
 {
 	struct rndis_wlan_private *priv = get_rndis_wlan_priv(usbdev);
 	struct rndis_indicate *msg = ind;
 
-	/* queue work to avoid recursive calls into rndis_command */
 	switch (msg->status) {
 	case RNDIS_STATUS_MEDIA_CONNECT:
 		devinfo(usbdev, "media connect");
 
+		/* queue work to avoid recursive calls into rndis_command */
 		set_bit(WORK_LINK_UP, &priv->work_pending);
 		queue_work(priv->workqueue, &priv->work);
 		break;
@@ -2228,10 +2454,15 @@ static void rndis_wlan_indication(struct usbnet *usbdev, void *ind, int buflen)
 	case RNDIS_STATUS_MEDIA_DISCONNECT:
 		devinfo(usbdev, "media disconnect");
 
+		/* queue work to avoid recursive calls into rndis_command */
 		set_bit(WORK_LINK_DOWN, &priv->work_pending);
 		queue_work(priv->workqueue, &priv->work);
 		break;
 
+	case RNDIS_STATUS_MEDIA_SPECIFIC_INDICATION:
+		rndis_wlan_media_specific_indication(usbdev, msg, buflen);
+		break;
+
 	default:
 		devinfo(usbdev, "indication: 0x%08x",
 				le32_to_cpu(msg->status));
diff --git a/include/linux/usb/rndis_host.h b/include/linux/usb/rndis_host.h
index 37836b9..1ef1ebc 100644
--- a/include/linux/usb/rndis_host.h
+++ b/include/linux/usb/rndis_host.h
@@ -70,12 +70,13 @@ struct rndis_msg_hdr {
 #define RNDIS_MSG_KEEPALIVE_C	(RNDIS_MSG_KEEPALIVE|RNDIS_MSG_COMPLETION)
 
 /* codes for "status" field of completion messages */
-#define	RNDIS_STATUS_SUCCESS		cpu_to_le32(0x00000000)
-#define	RNDIS_STATUS_FAILURE		cpu_to_le32(0xc0000001)
-#define	RNDIS_STATUS_INVALID_DATA	cpu_to_le32(0xc0010015)
-#define	RNDIS_STATUS_NOT_SUPPORTED	cpu_to_le32(0xc00000bb)
-#define	RNDIS_STATUS_MEDIA_CONNECT	cpu_to_le32(0x4001000b)
-#define	RNDIS_STATUS_MEDIA_DISCONNECT	cpu_to_le32(0x4001000c)
+#define	RNDIS_STATUS_SUCCESS			cpu_to_le32(0x00000000)
+#define	RNDIS_STATUS_FAILURE			cpu_to_le32(0xc0000001)
+#define	RNDIS_STATUS_INVALID_DATA		cpu_to_le32(0xc0010015)
+#define	RNDIS_STATUS_NOT_SUPPORTED		cpu_to_le32(0xc00000bb)
+#define	RNDIS_STATUS_MEDIA_CONNECT		cpu_to_le32(0x4001000b)
+#define	RNDIS_STATUS_MEDIA_DISCONNECT		cpu_to_le32(0x4001000c)
+#define	RNDIS_STATUS_MEDIA_SPECIFIC_INDICATION	cpu_to_le32(0x40010012)
 
 /* codes for OID_GEN_PHYSICAL_MEDIUM */
 #define	RNDIS_PHYSICAL_MEDIUM_UNSPECIFIED	cpu_to_le32(0x00000000)

