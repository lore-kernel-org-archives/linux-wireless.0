Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0048.outbound.protection.outlook.com ([104.47.42.48]:45504
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751937AbdJaBFD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 21:05:03 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, vulyanov@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V2 1/9] qtnfmac: use per-band HT/VHT info from wireless device
Date: Mon, 30 Oct 2017 18:04:47 -0700
Message-Id: <20171031010455.27772-2-igor.mitsyanko.os@quantenna.com> (sfid-20171031_020518_164172_3BB91706)
In-Reply-To: <20171031010455.27772-1-igor.mitsyanko.os@quantenna.com>
References: <20171031010455.27772-1-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

HT/VHT capabilities must be reported per each band supported by a radio,
not for all bands on a radio. Furthermore, driver better not assume
any capabilities and just use whetever is reported by device itself.

To support this, convert "get channels" command into "get band info"
command. Difference is that it may also carry HT/VHT capabilities along
with channels information.

While at it, also add "num_bitrates" field to "get band info" command,
for future use.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 30 +--------
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 77 +++++++++++++++++++----
 drivers/net/wireless/quantenna/qtnfmac/commands.h |  4 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c     |  3 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 29 +++++----
 5 files changed, 84 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index e70f5bd..2f60331 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -823,8 +823,7 @@ static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy_in,
 			if (!wiphy->bands[band])
 				continue;
 
-			ret = qtnf_cmd_get_mac_chan_info(mac,
-							 wiphy->bands[band]);
+			ret = qtnf_cmd_band_info_get(mac, wiphy->bands[band]);
 			if (ret)
 				pr_err("failed to get chan info for mac %u band %u\n",
 				       mac_idx, band);
@@ -832,33 +831,6 @@ static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy_in,
 	}
 }
 
-void qtnf_band_setup_htvht_caps(struct qtnf_mac_info *macinfo,
-				struct ieee80211_supported_band *band)
-{
-	struct ieee80211_sta_ht_cap *ht_cap;
-	struct ieee80211_sta_vht_cap *vht_cap;
-
-	ht_cap = &band->ht_cap;
-	ht_cap->ht_supported = true;
-	memcpy(&ht_cap->cap, &macinfo->ht_cap.cap_info,
-	       sizeof(u16));
-	ht_cap->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
-	ht_cap->ampdu_density = IEEE80211_HT_MPDU_DENSITY_NONE;
-	memcpy(&ht_cap->mcs, &macinfo->ht_cap.mcs,
-	       sizeof(ht_cap->mcs));
-
-	if (macinfo->phymode_cap & QLINK_PHYMODE_AC) {
-		vht_cap = &band->vht_cap;
-		vht_cap->vht_supported = true;
-		memcpy(&vht_cap->cap,
-		       &macinfo->vht_cap.vht_cap_info, sizeof(u32));
-		/* Update MCS support for VHT */
-		memcpy(&vht_cap->vht_mcs,
-		       &macinfo->vht_cap.supp_mcs,
-		       sizeof(struct ieee80211_vht_mcs_info));
-	}
-}
-
 struct wiphy *qtnf_wiphy_allocate(struct qtnf_bus *bus)
 {
 	struct wiphy *wiphy;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index b81f81b..a7422c5 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1115,19 +1115,50 @@ qtnf_cmd_resp_proc_mac_info(struct qtnf_wmac *mac,
 	       sizeof(mac_info->vht_cap));
 }
 
+static void qtnf_cmd_resp_band_fill_htcap(const u8 *info,
+					  struct ieee80211_sta_ht_cap *bcap)
+{
+	const struct ieee80211_ht_cap *ht_cap =
+		(const struct ieee80211_ht_cap *)info;
+
+	bcap->ht_supported = true;
+	bcap->cap = le16_to_cpu(ht_cap->cap_info);
+	bcap->ampdu_factor =
+		ht_cap->ampdu_params_info & IEEE80211_HT_AMPDU_PARM_FACTOR;
+	bcap->ampdu_density =
+		(ht_cap->ampdu_params_info & IEEE80211_HT_AMPDU_PARM_DENSITY) >>
+		IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT;
+	memcpy(&bcap->mcs, &ht_cap->mcs, sizeof(bcap->mcs));
+}
+
+static void qtnf_cmd_resp_band_fill_vhtcap(const u8 *info,
+					   struct ieee80211_sta_vht_cap *bcap)
+{
+	const struct ieee80211_vht_cap *vht_cap =
+		(const struct ieee80211_vht_cap *)info;
+
+	bcap->vht_supported = true;
+	bcap->cap = le32_to_cpu(vht_cap->vht_cap_info);
+	memcpy(&bcap->vht_mcs, &vht_cap->supp_mcs, sizeof(bcap->vht_mcs));
+}
+
 static int
-qtnf_cmd_resp_fill_channels_info(struct ieee80211_supported_band *band,
-				 struct qlink_resp_get_chan_info *resp,
-				 size_t payload_len)
+qtnf_cmd_resp_fill_band_info(struct ieee80211_supported_band *band,
+			     struct qlink_resp_band_info_get *resp,
+			     size_t payload_len)
 {
 	u16 tlv_type;
 	size_t tlv_len;
+	size_t tlv_dlen;
 	const struct qlink_tlv_hdr *tlv;
 	const struct qlink_tlv_channel *qchan;
 	struct ieee80211_channel *chan;
 	unsigned int chidx = 0;
 	u32 qflags;
 
+	memset(&band->ht_cap, 0, sizeof(band->ht_cap));
+	memset(&band->vht_cap, 0, sizeof(band->vht_cap));
+
 	if (band->channels) {
 		if (band->n_channels == resp->num_chans) {
 			memset(band->channels, 0,
@@ -1155,7 +1186,8 @@ qtnf_cmd_resp_fill_channels_info(struct ieee80211_supported_band *band,
 
 	while (payload_len >= sizeof(*tlv)) {
 		tlv_type = le16_to_cpu(tlv->type);
-		tlv_len = le16_to_cpu(tlv->len) + sizeof(*tlv);
+		tlv_dlen = le16_to_cpu(tlv->len);
+		tlv_len = tlv_dlen + sizeof(*tlv);
 
 		if (tlv_len > payload_len) {
 			pr_warn("malformed TLV 0x%.2X; LEN: %zu\n",
@@ -1241,13 +1273,32 @@ qtnf_cmd_resp_fill_channels_info(struct ieee80211_supported_band *band,
 				 chan->hw_value, chan->flags, chan->max_power,
 				 chan->max_reg_power);
 			break;
+		case WLAN_EID_HT_CAPABILITY:
+			if (unlikely(tlv_dlen !=
+				     sizeof(struct ieee80211_ht_cap))) {
+				pr_err("bad HTCAP TLV len %zu\n", tlv_dlen);
+				goto error_ret;
+			}
+
+			qtnf_cmd_resp_band_fill_htcap(tlv->val, &band->ht_cap);
+			break;
+		case WLAN_EID_VHT_CAPABILITY:
+			if (unlikely(tlv_dlen !=
+				     sizeof(struct ieee80211_vht_cap))) {
+				pr_err("bad VHTCAP TLV len %zu\n", tlv_dlen);
+				goto error_ret;
+			}
+
+			qtnf_cmd_resp_band_fill_vhtcap(tlv->val,
+						       &band->vht_cap);
+			break;
 		default:
 			pr_warn("unknown TLV type: %#x\n", tlv_type);
 			break;
 		}
 
 		payload_len -= tlv_len;
-		tlv = (struct qlink_tlv_hdr *)((u8 *)tlv + tlv_len);
+		tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_dlen);
 	}
 
 	if (payload_len) {
@@ -1469,13 +1520,13 @@ int qtnf_cmd_get_hw_info(struct qtnf_bus *bus)
 	return ret;
 }
 
-int qtnf_cmd_get_mac_chan_info(struct qtnf_wmac *mac,
-			       struct ieee80211_supported_band *band)
+int qtnf_cmd_band_info_get(struct qtnf_wmac *mac,
+			   struct ieee80211_supported_band *band)
 {
 	struct sk_buff *cmd_skb, *resp_skb = NULL;
 	size_t info_len;
-	struct qlink_cmd_chans_info_get *cmd;
-	struct qlink_resp_get_chan_info *resp;
+	struct qlink_cmd_band_info_get *cmd;
+	struct qlink_resp_band_info_get *resp;
 	u16 res_code = QLINK_CMD_RESULT_OK;
 	int ret = 0;
 	u8 qband;
@@ -1495,12 +1546,12 @@ int qtnf_cmd_get_mac_chan_info(struct qtnf_wmac *mac,
 	}
 
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, 0,
-					    QLINK_CMD_CHANS_INFO_GET,
+					    QLINK_CMD_BAND_INFO_GET,
 					    sizeof(*cmd));
 	if (!cmd_skb)
 		return -ENOMEM;
 
-	cmd = (struct qlink_cmd_chans_info_get *)cmd_skb->data;
+	cmd = (struct qlink_cmd_band_info_get *)cmd_skb->data;
 	cmd->band = qband;
 
 	qtnf_bus_lock(mac->bus);
@@ -1517,7 +1568,7 @@ int qtnf_cmd_get_mac_chan_info(struct qtnf_wmac *mac,
 		goto out;
 	}
 
-	resp = (struct qlink_resp_get_chan_info *)resp_skb->data;
+	resp = (struct qlink_resp_band_info_get *)resp_skb->data;
 	if (resp->band != qband) {
 		pr_err("MAC%u: reply band %u != cmd band %u\n", mac->macid,
 		       resp->band, qband);
@@ -1525,7 +1576,7 @@ int qtnf_cmd_get_mac_chan_info(struct qtnf_wmac *mac,
 		goto out;
 	}
 
-	ret = qtnf_cmd_resp_fill_channels_info(band, resp, info_len);
+	ret = qtnf_cmd_resp_fill_band_info(band, resp, info_len);
 
 out:
 	qtnf_bus_unlock(mac->bus);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/net/wireless/quantenna/qtnfmac/commands.h
index e87c4a4..d6fe3cc 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -30,8 +30,8 @@ int qtnf_cmd_send_add_intf(struct qtnf_vif *vif, enum nl80211_iftype iftype,
 int qtnf_cmd_send_change_intf_type(struct qtnf_vif *vif,
 				   enum nl80211_iftype iftype, u8 *mac_addr);
 int qtnf_cmd_send_del_intf(struct qtnf_vif *vif);
-int qtnf_cmd_get_mac_chan_info(struct qtnf_wmac *mac,
-			       struct ieee80211_supported_band *band);
+int qtnf_cmd_band_info_get(struct qtnf_wmac *mac,
+			   struct ieee80211_supported_band *band);
 int qtnf_cmd_send_regulatory_config(struct qtnf_wmac *mac, const char *alpha2);
 int qtnf_cmd_send_config_ap(struct qtnf_vif *vif,
 			    const struct cfg80211_ap_settings *s);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index 6a6e5ff..2d2c1ea 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -171,7 +171,7 @@ static int qtnf_mac_init_single_band(struct wiphy *wiphy,
 
 	wiphy->bands[band]->band = band;
 
-	ret = qtnf_cmd_get_mac_chan_info(mac, wiphy->bands[band]);
+	ret = qtnf_cmd_band_info_get(mac, wiphy->bands[band]);
 	if (ret) {
 		pr_err("MAC%u: band %u: failed to get chans info: %d\n",
 		       mac->macid, band, ret);
@@ -179,7 +179,6 @@ static int qtnf_mac_init_single_band(struct wiphy *wiphy,
 	}
 
 	qtnf_band_init_rates(wiphy->bands[band]);
-	qtnf_band_setup_htvht_caps(&mac->macinfo, wiphy->bands[band]);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 0f58278..dfef7fa 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -168,11 +168,12 @@ struct qlink_auth_encr {
  * Commands are QLINK messages of type @QLINK_MSG_TYPE_CMD, sent by driver to
  * wireless network device for processing. Device is expected to send back a
  * reply message of type &QLINK_MSG_TYPE_CMDRSP, containing at least command
- * execution status (one of &enum qlink_cmd_result) at least. Reply message
+ * execution status (one of &enum qlink_cmd_result). Reply message
  * may also contain data payload specific to the command type.
  *
- * @QLINK_CMD_CHANS_INFO_GET: for the specified MAC and specified band, get
- *	number of operational channels and information on each of the channel.
+ * @QLINK_CMD_BAND_INFO_GET: for the specified MAC and specified band, get
+ *	the band's description including number of operational channels and
+ *	info on each channel, HT/VHT capabilities, supported rates etc.
  *	This command is generic to a specified MAC, interface index must be set
  *	to QLINK_VIFID_RSVD in command header.
  * @QLINK_CMD_REG_NOTIFY: notify device about regulatory domain change. This
@@ -194,7 +195,7 @@ enum qlink_cmd_type {
 	QLINK_CMD_CHANGE_INTF		= 0x0017,
 	QLINK_CMD_UPDOWN_INTF		= 0x0018,
 	QLINK_CMD_REG_NOTIFY		= 0x0019,
-	QLINK_CMD_CHANS_INFO_GET	= 0x001A,
+	QLINK_CMD_BAND_INFO_GET		= 0x001A,
 	QLINK_CMD_CHAN_SWITCH		= 0x001B,
 	QLINK_CMD_CHAN_GET		= 0x001C,
 	QLINK_CMD_CONFIG_AP		= 0x0020,
@@ -477,11 +478,11 @@ enum qlink_band {
 };
 
 /**
- * struct qlink_cmd_chans_info_get - data for QLINK_CMD_CHANS_INFO_GET command
+ * struct qlink_cmd_band_info_get - data for QLINK_CMD_BAND_INFO_GET command
  *
- * @band: a PHY band for which channels info is needed, one of @enum qlink_band
+ * @band: a PHY band for which information is queried, one of @enum qlink_band
  */
-struct qlink_cmd_chans_info_get {
+struct qlink_cmd_band_info_get {
 	struct qlink_cmd chdr;
 	u8 band;
 } __packed;
@@ -730,17 +731,19 @@ struct qlink_resp_get_sta_info {
 } __packed;
 
 /**
- * struct qlink_resp_get_chan_info - response for QLINK_CMD_CHANS_INFO_GET cmd
+ * struct qlink_resp_band_info_get - response for QLINK_CMD_BAND_INFO_GET cmd
  *
- * @band: frequency band to which channels belong to, one of @enum qlink_band.
- * @num_chans: total number of channels info data contained in reply data.
- * @info: variable-length channels info.
+ * @band: frequency band that the response describes, one of @enum qlink_band.
+ * @num_chans: total number of channels info TLVs contained in reply.
+ * @num_bitrates: total number of bitrate TLVs contained in reply.
+ * @info: variable-length info portion.
  */
-struct qlink_resp_get_chan_info {
+struct qlink_resp_band_info_get {
 	struct qlink_resp rhdr;
 	u8 band;
 	u8 num_chans;
-	u8 rsvd[2];
+	u8 num_bitrates;
+	u8 rsvd[1];
 	u8 info[0];
 } __packed;
 
-- 
2.9.5
