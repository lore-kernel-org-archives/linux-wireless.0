Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-2.exch022.serverdata.net ([206.225.164.185]:28651
	"EHLO HUB022-nj-2.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144Ab2JJLdG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 07:33:06 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: VHT peer STA caps
Date: Wed, 10 Oct 2012 11:33:04 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCFB359@mbx022-e1-nj-10.exch022.domain.local> (sfid-20121010_133311_747377_EAAE65C6)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mahesh Palivela <maheshp@posedge.com>

To save AP's VHT capabilities in STA mode

Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
---
 include/net/mac80211.h     |    3 +++
 net/mac80211/Makefile      |    1 +
 net/mac80211/ieee80211_i.h |    7 +++++++
 net/mac80211/mlme.c        |    5 +++++
 net/mac80211/util.c        |   12 ++++++++++++
 net/mac80211/vht.c         |   36 ++++++++++++++++++++++++++++++++++++
 6 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f12df5b..89d5bba 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1122,6 +1122,8 @@ enum ieee80211_sta_state {
  * @aid: AID we assigned to the station if we're an AP
  * @supp_rates: Bitmap of supported rates (per band)
  * @ht_cap: HT capabilities of this STA; restricted to our own TX capabilities
+ * @vht_cap: VHT capabilities of this STA; Not restricting any capabilities
+ * 	of remote STA. Taking as is.
  * @wme: indicates whether the STA supports WME. Only valid during AP-mode.
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *), size is determined in hw information.
@@ -1134,6 +1136,7 @@ struct ieee80211_sta {
 	u8 addr[ETH_ALEN];
 	u16 aid;
 	struct ieee80211_sta_ht_cap ht_cap;
+	struct ieee80211_sta_vht_cap vht_cap;
 	bool wme;
 	u8 uapsd_queues;
 	u8 max_sp;
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index a7dd110..4911202 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -8,6 +8,7 @@ mac80211-y := \
 	wpa.o \
 	scan.o offchannel.o \
 	ht.o agg-tx.o agg-rx.o \
+	vht.o \
 	ibss.o \
 	iface.o \
 	rate.o \
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1fd7dfc..546da35 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1188,6 +1188,8 @@ struct ieee802_11_elems {
 	u8 *wmm_param;
 	struct ieee80211_ht_cap *ht_cap_elem;
 	struct ieee80211_ht_operation *ht_operation;
+	struct ieee80211_vht_cap *vht_cap_elem;
+	struct ieee80211_vht_operation *vht_operation;
 	struct ieee80211_meshconf_ie *mesh_config;
 	u8 *mesh_id;
 	u8 *peering;
@@ -1416,6 +1418,11 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid);
 
 u8 ieee80211_mcs_to_chains(const struct ieee80211_mcs_info *mcs);
 
+/* VHT */
+void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
+					 struct ieee80211_supported_band *sband,
+					 struct ieee80211_vht_cap *vht_cap_ie,
+					 struct ieee80211_sta_vht_cap *vht_cap);
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_mgmt *mgmt,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8cefc18..02f4ed5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2156,6 +2156,11 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	sta->supports_40mhz =
 		sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 
+	if (elems.vht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
+		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
+						    elems.vht_cap_elem,
+						    &sta->sta.vht_cap);
+
 	rate_control_rate_init(sta);
 
 	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3b35356..af6c54d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -741,6 +741,18 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			else
 				elem_parse_failed = true;
 			break;
+		case WLAN_EID_VHT_CAPABILITY:
+			if (elen >= sizeof(struct ieee80211_vht_cap))
+				elems->vht_cap_elem = (void *)pos;
+			else
+				elem_parse_failed = true;
+			break;
+		case WLAN_EID_VHT_OPERATION:
+			if (elen >= sizeof(struct ieee80211_vht_operation))
+				elems->vht_operation = (void *)pos;
+			else
+				elem_parse_failed = true;
+			break;
 		case WLAN_EID_MESH_ID:
 			elems->mesh_id = pos;
 			elems->mesh_id_len = elen;
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
new file mode 100644
index 0000000..18f584e
--- /dev/null
+++ b/net/mac80211/vht.c
@@ -0,0 +1,36 @@
+/*
+ * VHT handling
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/ieee80211.h>
+#include <linux/export.h>
+#include <net/mac80211.h>
+#include "ieee80211_i.h"
+
+
+void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
+					 struct ieee80211_supported_band *sband,
+					 struct ieee80211_vht_cap *vht_cap_ie,
+					 struct ieee80211_sta_vht_cap *vht_cap)
+{
+	if (WARN_ON_ONCE(!vht_cap))
+		return;
+
+	memset(vht_cap, 0, sizeof(*vht_cap));
+
+	if (!vht_cap_ie || !sband->vht_cap.vht_supported)
+		return;
+
+	vht_cap->vht_supported = true;
+
+	vht_cap->cap = le16_to_cpu(vht_cap_ie->vht_cap_info);
+
+	/* Copy peer MCS info, the driver might need them. */
+	memcpy((u8 *)&vht_cap->vht_mcs,
+	       (u8 *)&vht_cap_ie->supp_mcs,
+	       sizeof(struct ieee80211_vht_mcs_info));
+}