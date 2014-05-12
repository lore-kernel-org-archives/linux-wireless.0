Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:31551 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbaELIrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 04:47:42 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Kim <dekim@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 01/14] brcmfmac: Give priority to 5GHz band in selecting target BSS
Date: Mon, 12 May 2014 10:47:26 +0200
Message-ID: <1399884459-5048-2-git-send-email-arend@broadcom.com> (sfid-20140512_104805_518350_5E88B559)
In-Reply-To: <1399884459-5048-1-git-send-email-arend@broadcom.com>
References: <1399884459-5048-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Kim <dekim@broadcom.com>

When a BSS provides both 2.4GHz and 5GHz bands, in many cases it
makes sense to choose 5GHz. Typically a 5GHz channel is less crowded
and has less interference and therefore its performance will be
better than a crowded 2.4 GHz channel. This patch configures
'join_pref' to induce firmware to preferably select 5GHz BSS.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Daniel Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   18 +++++++++++++++
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |   24 ++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 6a8983a..ed3e32c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -32,6 +32,9 @@
 #define BRCMF_DEFAULT_SCAN_UNASSOC_TIME	40
 #define BRCMF_DEFAULT_PACKET_FILTER	"100 0 0 0 0x01 0x00"
 
+/* boost value for RSSI_DELTA in preferred join selection */
+#define BRCMF_JOIN_PREF_RSSI_BOOST	8
+
 
 bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 		      struct sk_buff *pkt, int prec)
@@ -246,6 +249,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 {
 	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
 	u8 buf[BRCMF_DCMD_SMLEN];
+	struct brcmf_join_pref_params join_pref_params[2];
 	char *ptr;
 	s32 err;
 
@@ -298,6 +302,20 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 		goto done;
 	}
 
+	/* Setup join_pref to select target by RSSI(with boost on 5GHz) */
+	join_pref_params[0].type = BRCMF_JOIN_PREF_RSSI_DELTA;
+	join_pref_params[0].len = 2;
+	join_pref_params[0].rssi_gain = BRCMF_JOIN_PREF_RSSI_BOOST;
+	join_pref_params[0].band = WLC_BAND_5G;
+	join_pref_params[1].type = BRCMF_JOIN_PREF_RSSI;
+	join_pref_params[1].len = 2;
+	join_pref_params[1].rssi_gain = 0;
+	join_pref_params[1].band = 0;
+	err = brcmf_fil_iovar_data_set(ifp, "join_pref", join_pref_params,
+				       sizeof(join_pref_params));
+	if (err)
+		brcmf_err("Set join_pref error (%d)\n", err);
+
 	/* Setup event_msgs, enable E_IF */
 	err = brcmf_fil_iovar_data_get(ifp, "event_msgs", eventmask,
 				       BRCMF_EVENTING_MASK_LEN);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
index 614e488..2bc68a2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
@@ -53,6 +53,14 @@
 #define BRCMF_OBSS_COEX_OFF		0
 #define BRCMF_OBSS_COEX_ON		1
 
+/* join preference types for join_pref iovar */
+enum brcmf_join_pref_types {
+	BRCMF_JOIN_PREF_RSSI = 1,
+	BRCMF_JOIN_PREF_WPA,
+	BRCMF_JOIN_PREF_BAND,
+	BRCMF_JOIN_PREF_RSSI_DELTA,
+};
+
 enum brcmf_fil_p2p_if_types {
 	BRCMF_FIL_P2P_IF_CLIENT,
 	BRCMF_FIL_P2P_IF_GO,
@@ -282,6 +290,22 @@ struct brcmf_assoc_params_le {
 	__le16 chanspec_list[1];
 };
 
+/**
+ * struct join_pref params - parameters for preferred join selection.
+ *
+ * @type: preference type (see enum brcmf_join_pref_types).
+ * @len: length of bytes following (currently always 2).
+ * @rssi_gain: signal gain for selection (only when @type is RSSI_DELTA).
+ * @band: band to which selection preference applies.
+ *	This is used if @type is BAND or RSSI_DELTA.
+ */
+struct brcmf_join_pref_params {
+	u8 type;
+	u8 len;
+	u8 rssi_gain;
+	u8 band;
+};
+
 /* used for join with or without a specific bssid and channel list */
 struct brcmf_join_params {
 	struct brcmf_ssid_le ssid_le;
-- 
1.7.9.5

