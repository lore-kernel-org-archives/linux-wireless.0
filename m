Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51558 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2LTLkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 06:40:07 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: restrict assoc request VHT capabilities
Date: Thu, 20 Dec 2012 12:40:26 +0100
Message-Id: <1356003626-23425-1-git-send-email-johannes@sipsolutions.net> (sfid-20121220_124010_941702_1EA3B5DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In interoperability testing some APs showed bad behaviour
if some of the VHT capabilities of the station are better
than their own. Restrict the assoc request parameters
 - beamformee capabable,
 - RX STBC and
 - RX MCS set
to the subset that the AP can support.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/mlme.c        | 51 +++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 71fd4b1..d4114e9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -405,6 +405,8 @@ struct ieee80211_mgd_assoc_data {
 
 	u8 ap_ht_param;
 
+	struct ieee80211_vht_cap ap_vht_cap;
+
 	size_t ie_len;
 	u8 ie[];
 };
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c98fdf0..57d97ab 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -341,11 +341,13 @@ static void ieee80211_add_ht_ie(struct ieee80211_sub_if_data *sdata,
 
 static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb,
-				 struct ieee80211_supported_band *sband)
+				 struct ieee80211_supported_band *sband,
+				 struct ieee80211_vht_cap *ap_vht_cap)
 {
 	u8 *pos;
 	u32 cap;
 	struct ieee80211_sta_vht_cap vht_cap;
+	int i;
 
 	BUILD_BUG_ON(sizeof(vht_cap) != sizeof(sband->vht_cap));
 
@@ -364,6 +366,42 @@ static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 		cap &= ~IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ;
 	}
 
+	/*
+	 * Some APs apparently get confused if our capabilities are better
+	 * than theirs, so restrict what we advertise in the assoc request.
+	 */
+	if (!(ap_vht_cap->vht_cap_info &
+			cpu_to_le32(IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE)))
+		cap &= ~IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
+
+	if (!(ap_vht_cap->vht_cap_info &
+			cpu_to_le32(IEEE80211_VHT_CAP_TXSTBC)))
+		cap &= ~(IEEE80211_VHT_CAP_RXSTBC_1 |
+			 IEEE80211_VHT_CAP_RXSTBC_3 |
+			 IEEE80211_VHT_CAP_RXSTBC_4);
+
+	for (i = 0; i < 8; i++) {
+		int shift = i * 2;
+		u16 mask = IEEE80211_VHT_MCS_NOT_SUPPORTED << shift;
+		u16 ap_mcs, our_mcs;
+
+		ap_mcs = (le16_to_cpu(ap_vht_cap->supp_mcs.tx_mcs_map) &
+								mask) >> shift;
+		our_mcs = (le16_to_cpu(vht_cap.vht_mcs.rx_mcs_map) &
+								mask) >> shift;
+
+		switch (ap_mcs) {
+		default:
+			if (our_mcs <= ap_mcs)
+				break;
+			/* fall through */
+		case IEEE80211_VHT_MCS_NOT_SUPPORTED:
+			vht_cap.vht_mcs.rx_mcs_map &= cpu_to_le16(~mask);
+			vht_cap.vht_mcs.rx_mcs_map |=
+				cpu_to_le16(ap_mcs << shift);
+		}
+	}
+
 	/* reserve and fill IE */
 	pos = skb_put(skb, sizeof(struct ieee80211_vht_cap) + 2);
 	ieee80211_ie_build_vht_cap(pos, &vht_cap, cap);
@@ -562,7 +600,8 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 				    sband, chan, sdata->smps_mode);
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
-		ieee80211_add_vht_ie(sdata, skb, sband);
+		ieee80211_add_vht_ie(sdata, skb, sband,
+				     &assoc_data->ap_vht_cap);
 
 	/* if present, add any custom non-vendor IEs that go after HT */
 	if (assoc_data->ie_len && assoc_data->ie) {
@@ -3779,7 +3818,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_bss *bss = (void *)req->bss->priv;
 	struct ieee80211_mgd_assoc_data *assoc_data;
 	struct ieee80211_supported_band *sband;
-	const u8 *ssidie, *ht_ie;
+	const u8 *ssidie, *ht_ie, *vht_ie;
 	int i, err;
 
 	assoc_data = kzalloc(sizeof(*assoc_data) + req->ie_len, GFP_KERNEL);
@@ -3898,6 +3937,12 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			((struct ieee80211_ht_operation *)(ht_ie + 2))->ht_param;
 	else
 		ifmgd->flags |= IEEE80211_STA_DISABLE_HT;
+	vht_ie = ieee80211_bss_get_ie(req->bss, WLAN_EID_VHT_CAPABILITY);
+	if (vht_ie && vht_ie[1] >= sizeof(struct ieee80211_vht_cap))
+		memcpy(&assoc_data->ap_vht_cap, vht_ie + 2,
+		       sizeof(struct ieee80211_vht_cap));
+	else
+		ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
 	rcu_read_unlock();
 
 	if (bss->wmm_used && bss->uapsd_supported &&
-- 
1.8.0

