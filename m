Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1247 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab1JRMD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 08:03:28 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/15] brcm80211: fmac: annotated little endian struct
 with _le
Date: Tue, 18 Oct 2011 14:03:01 +0200
Message-ID: <1318939391-19495-6-git-send-email-arend@broadcom.com> (sfid-20111018_140332_350048_C29BB730)
In-Reply-To: <1318939391-19495-1-git-send-email-arend@broadcom.com>
References: <1318939391-19495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Made code more readable.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   10 +++++-----
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   12 ++++++------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    8 ++++----
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 4645766..cf7cc9a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -87,7 +87,7 @@
 #define TOE_TX_CSUM_OL		0x00000001
 #define TOE_RX_CSUM_OL		0x00000002
 
-#define	BRCMF_BSS_INFO_VERSION	108 /* current ver of brcmf_bss_info struct */
+#define	BRCMF_BSS_INFO_VERSION	108 /* curr ver of brcmf_bss_info_le struct */
 
 /* size of brcmf_scan_params not including variable length array */
 #define BRCMF_SCAN_PARAMS_FIXED_SIZE 64
@@ -365,7 +365,7 @@ struct brcmf_pkt_filter_enable_le {
  * Applications MUST CHECK ie_offset field and length field to access IEs and
  * next bss_info structure in a vector (in struct brcmf_scan_results)
  */
-struct brcmf_bss_info {
+struct brcmf_bss_info_le {
 	__le32 version;		/* version field */
 	__le32 length;		/* byte length of data in this record,
 				 * starting at version and including IEs
@@ -466,14 +466,14 @@ struct brcmf_scan_results {
 	u32 buflen;
 	u32 version;
 	u32 count;
-	struct brcmf_bss_info bss_info[1];
+	struct brcmf_bss_info_le bss_info_le[1];
 };
 
 struct brcmf_scan_results_le {
 	__le32 buflen;
 	__le32 version;
 	__le32 count;
-	struct brcmf_bss_info bss_info[1];
+	struct brcmf_bss_info_le bss_info_le[1];
 };
 
 /* used for association with a specific BSSID and chanspec list */
@@ -495,7 +495,7 @@ struct brcmf_join_params {
 
 /* size of brcmf_scan_results not including variable length array */
 #define BRCMF_SCAN_RESULTS_FIXED_SIZE \
-	(sizeof(struct brcmf_scan_results) - sizeof(struct brcmf_bss_info))
+	(sizeof(struct brcmf_scan_results) - sizeof(struct brcmf_bss_info_le))
 
 /* incremental scan results struct */
 struct brcmf_iscan_results {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 5eddabe..7f89bad 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1997,7 +1997,7 @@ done:
 }
 
 static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_priv *cfg_priv,
-				   struct brcmf_bss_info *bi)
+				   struct brcmf_bss_info_le *bi)
 {
 	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
 	struct ieee80211_channel *notify_channel;
@@ -2060,7 +2060,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_priv *cfg_priv,
 static s32 brcmf_inform_bss(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	struct brcmf_scan_results *bss_list;
-	struct brcmf_bss_info *bi = NULL;	/* must be initialized */
+	struct brcmf_bss_info_le *bi = NULL;	/* must be initialized */
 	s32 err = 0;
 	int i;
 
@@ -2085,7 +2085,7 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_priv *cfg_priv,
 {
 	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
 	struct ieee80211_channel *notify_channel;
-	struct brcmf_bss_info *bi = NULL;
+	struct brcmf_bss_info_le *bi = NULL;
 	struct ieee80211_supported_band *band;
 	u8 *buf = NULL;
 	s32 err = 0;
@@ -2114,7 +2114,7 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_priv *cfg_priv,
 		goto CleanUp;
 	}
 
-	bi = (struct brcmf_bss_info *)(buf + 4);
+	bi = (struct brcmf_bss_info_le *)(buf + 4);
 
 	channel = bi->ctl_ch ? bi->ctl_ch :
 				CHSPEC_CHANNEL(le16_to_cpu(bi->chanspec));
@@ -2188,7 +2188,7 @@ static struct brcmf_tlv *brcmf_parse_tlvs(void *buf, int buflen, uint key)
 
 static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct brcmf_bss_info *bi;
+	struct brcmf_bss_info_le *bi;
 	struct brcmf_ssid *ssid;
 	struct brcmf_tlv *tim;
 	u16 beacon_interval;
@@ -2211,7 +2211,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
 		goto update_bss_info_out;
 	}
 
-	bi = (struct brcmf_bss_info *)(cfg_priv->extra_buf + 4);
+	bi = (struct brcmf_bss_info_le *)(cfg_priv->extra_buf + 4);
 	err = brcmf_inform_single_bss(cfg_priv, bi);
 	if (err)
 		goto update_bss_info_out;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 62dc461..bec30e3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -352,13 +352,13 @@ brcmf_cfg80211_connect_info *cfg_to_conn(struct brcmf_cfg80211_priv *cfg)
 	return &cfg->conn_info;
 }
 
-static inline struct brcmf_bss_info *next_bss(struct brcmf_scan_results *list,
-					   struct brcmf_bss_info *bss)
+static inline struct brcmf_bss_info_le *
+next_bss(struct brcmf_scan_results *list, struct brcmf_bss_info_le *bss)
 {
 	return bss = bss ?
-		(struct brcmf_bss_info *)((unsigned long)bss +
+		(struct brcmf_bss_info_le *)((unsigned long)bss +
 				       le32_to_cpu(bss->length)) :
-		list->bss_info;
+		list->bss_info_le;
 }
 
 extern struct brcmf_cfg80211_dev *brcmf_cfg80211_attach(struct net_device *ndev,
-- 
1.7.4.1


