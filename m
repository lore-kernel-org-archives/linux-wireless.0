Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42538 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbbBZMZY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 07:25:24 -0500
Received: by lbiw7 with SMTP id w7so10397208lbi.9
        for <linux-wireless@vger.kernel.org>; Thu, 26 Feb 2015 04:25:22 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: refactor p2p noa code
Date: Thu, 26 Feb 2015 13:23:17 +0100
Message-Id: <1424953398-18809-1-git-send-email-michal.kazior@tieto.com> (sfid-20150226_132528_384955_4E22260C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some files are getting bloated and it makes sense
to split some of the code into separate files. Do
so with the P2P NoA code and prepare it for reuse.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/Makefile |   3 +-
 drivers/net/wireless/ath/ath10k/p2p.c    | 124 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/p2p.h    |  26 +++++++
 drivers/net/wireless/ath/ath10k/wmi.c    |  91 +----------------------
 4 files changed, 156 insertions(+), 88 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/p2p.c
 create mode 100644 drivers/net/wireless/ath/ath10k/p2p.h

diff --git a/drivers/net/wireless/ath/ath10k/Makefile b/drivers/net/wireless/ath/ath10k/Makefile
index f4dbb3e..92a1e09 100644
--- a/drivers/net/wireless/ath/ath10k/Makefile
+++ b/drivers/net/wireless/ath/ath10k/Makefile
@@ -10,7 +10,8 @@ ath10k_core-y += mac.o \
 		 wmi.o \
 		 wmi-tlv.o \
 		 bmi.o \
-		 hw.o
+		 hw.o \
+		 p2p.o
 
 ath10k_core-$(CONFIG_ATH10K_DEBUGFS) += spectral.o
 ath10k_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
diff --git a/drivers/net/wireless/ath/ath10k/p2p.c b/drivers/net/wireless/ath/ath10k/p2p.c
new file mode 100644
index 0000000..79d7485
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/p2p.c
@@ -0,0 +1,124 @@
+/*
+ * Copyright (c) 2015 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "core.h"
+#include "wmi.h"
+#include "p2p.h"
+
+static void ath10k_p2p_noa_ie_fill(u8 *data, size_t len,
+				   const struct wmi_p2p_noa_info *noa)
+{
+	struct ieee80211_p2p_noa_attr *noa_attr;
+	u8  ctwindow_oppps = noa->ctwindow_oppps;
+	u8 ctwindow = ctwindow_oppps >> WMI_P2P_OPPPS_CTWINDOW_OFFSET;
+	bool oppps = !!(ctwindow_oppps & WMI_P2P_OPPPS_ENABLE_BIT);
+	__le16 *noa_attr_len;
+	u16 attr_len;
+	u8 noa_descriptors = noa->num_descriptors;
+	int i;
+
+	/* P2P IE */
+	data[0] = WLAN_EID_VENDOR_SPECIFIC;
+	data[1] = len - 2;
+	data[2] = (WLAN_OUI_WFA >> 16) & 0xff;
+	data[3] = (WLAN_OUI_WFA >> 8) & 0xff;
+	data[4] = (WLAN_OUI_WFA >> 0) & 0xff;
+	data[5] = WLAN_OUI_TYPE_WFA_P2P;
+
+	/* NOA ATTR */
+	data[6] = IEEE80211_P2P_ATTR_ABSENCE_NOTICE;
+	noa_attr_len = (__le16 *)&data[7]; /* 2 bytes */
+	noa_attr = (struct ieee80211_p2p_noa_attr *)&data[9];
+
+	noa_attr->index = noa->index;
+	noa_attr->oppps_ctwindow = ctwindow;
+	if (oppps)
+		noa_attr->oppps_ctwindow |= IEEE80211_P2P_OPPPS_ENABLE_BIT;
+
+	for (i = 0; i < noa_descriptors; i++) {
+		noa_attr->desc[i].count =
+			__le32_to_cpu(noa->descriptors[i].type_count);
+		noa_attr->desc[i].duration = noa->descriptors[i].duration;
+		noa_attr->desc[i].interval = noa->descriptors[i].interval;
+		noa_attr->desc[i].start_time = noa->descriptors[i].start_time;
+	}
+
+	attr_len = 2; /* index + oppps_ctwindow */
+	attr_len += noa_descriptors * sizeof(struct ieee80211_p2p_noa_desc);
+	*noa_attr_len = __cpu_to_le16(attr_len);
+}
+
+static size_t ath10k_p2p_noa_ie_len_compute(const struct wmi_p2p_noa_info *noa)
+{
+	size_t len = 0;
+
+	if (!noa->num_descriptors &&
+	    !(noa->ctwindow_oppps & WMI_P2P_OPPPS_ENABLE_BIT))
+		return 0;
+
+	len += 1 + 1 + 4; /* EID + len + OUI */
+	len += 1 + 2; /* noa attr + attr len */
+	len += 1 + 1; /* index + oppps_ctwindow */
+	len += noa->num_descriptors * sizeof(struct ieee80211_p2p_noa_desc);
+
+	return len;
+}
+
+static void ath10k_p2p_noa_ie_assign(struct ath10k_vif *arvif, void *ie,
+				     size_t len)
+{
+	struct ath10k *ar = arvif->ar;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	kfree(arvif->u.ap.noa_data);
+
+	arvif->u.ap.noa_data = ie;
+	arvif->u.ap.noa_len = len;
+}
+
+static void __ath10k_p2p_noa_update(struct ath10k_vif *arvif,
+				    const struct wmi_p2p_noa_info *noa)
+{
+	struct ath10k *ar = arvif->ar;
+	void *ie;
+	size_t len;
+
+	lockdep_assert_held(&ar->data_lock);
+
+	ath10k_p2p_noa_ie_assign(arvif, NULL, 0);
+
+	len = ath10k_p2p_noa_ie_len_compute(noa);
+	if (!len)
+		return;
+
+	ie = kmalloc(len, GFP_ATOMIC);
+	if (!ie)
+		return;
+
+	ath10k_p2p_noa_ie_fill(ie, len, noa);
+	ath10k_p2p_noa_ie_assign(arvif, ie, len);
+}
+
+void ath10k_p2p_noa_update(struct ath10k_vif *arvif,
+			   const struct wmi_p2p_noa_info *noa)
+{
+	struct ath10k *ar = arvif->ar;
+
+	spin_lock_bh(&ar->data_lock);
+	__ath10k_p2p_noa_update(arvif, noa);
+	spin_unlock_bh(&ar->data_lock);
+}
diff --git a/drivers/net/wireless/ath/ath10k/p2p.h b/drivers/net/wireless/ath/ath10k/p2p.h
new file mode 100644
index 0000000..171d30d6
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/p2p.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (c) 2015 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef _P2P_H
+#define _P2P_H
+
+struct ath10k_vif;
+struct wmi_p2p_noa_info;
+
+void ath10k_p2p_noa_update(struct ath10k_vif *arvif,
+			   const struct wmi_p2p_noa_info *noa);
+
+#endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c7ea77e..4dd76e0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -26,6 +26,7 @@
 #include "mac.h"
 #include "testmode.h"
 #include "wmi-ops.h"
+#include "p2p.h"
 
 /* MAIN WMI cmd track */
 static struct wmi_cmd_map wmi_cmd_map = {
@@ -2276,109 +2277,25 @@ static void ath10k_wmi_update_tim(struct ath10k *ar,
 		   tim->bitmap_ctrl, pvm_len);
 }
 
-static void ath10k_p2p_fill_noa_ie(u8 *data, u32 len,
-				   const struct wmi_p2p_noa_info *noa)
-{
-	struct ieee80211_p2p_noa_attr *noa_attr;
-	u8  ctwindow_oppps = noa->ctwindow_oppps;
-	u8 ctwindow = ctwindow_oppps >> WMI_P2P_OPPPS_CTWINDOW_OFFSET;
-	bool oppps = !!(ctwindow_oppps & WMI_P2P_OPPPS_ENABLE_BIT);
-	__le16 *noa_attr_len;
-	u16 attr_len;
-	u8 noa_descriptors = noa->num_descriptors;
-	int i;
-
-	/* P2P IE */
-	data[0] = WLAN_EID_VENDOR_SPECIFIC;
-	data[1] = len - 2;
-	data[2] = (WLAN_OUI_WFA >> 16) & 0xff;
-	data[3] = (WLAN_OUI_WFA >> 8) & 0xff;
-	data[4] = (WLAN_OUI_WFA >> 0) & 0xff;
-	data[5] = WLAN_OUI_TYPE_WFA_P2P;
-
-	/* NOA ATTR */
-	data[6] = IEEE80211_P2P_ATTR_ABSENCE_NOTICE;
-	noa_attr_len = (__le16 *)&data[7]; /* 2 bytes */
-	noa_attr = (struct ieee80211_p2p_noa_attr *)&data[9];
-
-	noa_attr->index = noa->index;
-	noa_attr->oppps_ctwindow = ctwindow;
-	if (oppps)
-		noa_attr->oppps_ctwindow |= IEEE80211_P2P_OPPPS_ENABLE_BIT;
-
-	for (i = 0; i < noa_descriptors; i++) {
-		noa_attr->desc[i].count =
-			__le32_to_cpu(noa->descriptors[i].type_count);
-		noa_attr->desc[i].duration = noa->descriptors[i].duration;
-		noa_attr->desc[i].interval = noa->descriptors[i].interval;
-		noa_attr->desc[i].start_time = noa->descriptors[i].start_time;
-	}
-
-	attr_len = 2; /* index + oppps_ctwindow */
-	attr_len += noa_descriptors * sizeof(struct ieee80211_p2p_noa_desc);
-	*noa_attr_len = __cpu_to_le16(attr_len);
-}
-
-static u32 ath10k_p2p_calc_noa_ie_len(const struct wmi_p2p_noa_info *noa)
-{
-	u32 len = 0;
-	u8 noa_descriptors = noa->num_descriptors;
-	u8 opp_ps_info = noa->ctwindow_oppps;
-	bool opps_enabled = !!(opp_ps_info & WMI_P2P_OPPPS_ENABLE_BIT);
-
-	if (!noa_descriptors && !opps_enabled)
-		return len;
-
-	len += 1 + 1 + 4; /* EID + len + OUI */
-	len += 1 + 2; /* noa attr  + attr len */
-	len += 1 + 1; /* index + oppps_ctwindow */
-	len += noa_descriptors * sizeof(struct ieee80211_p2p_noa_desc);
-
-	return len;
-}
-
 static void ath10k_wmi_update_noa(struct ath10k *ar, struct ath10k_vif *arvif,
 				  struct sk_buff *bcn,
 				  const struct wmi_p2p_noa_info *noa)
 {
-	u8 *new_data, *old_data = arvif->u.ap.noa_data;
-	u32 new_len;
-
 	if (arvif->vdev_subtype != WMI_VDEV_SUBTYPE_P2P_GO)
 		return;
 
 	ath10k_dbg(ar, ATH10K_DBG_MGMT, "noa changed: %d\n", noa->changed);
-	if (noa->changed & WMI_P2P_NOA_CHANGED_BIT) {
-		new_len = ath10k_p2p_calc_noa_ie_len(noa);
-		if (!new_len)
-			goto cleanup;
 
-		new_data = kmalloc(new_len, GFP_ATOMIC);
-		if (!new_data)
-			goto cleanup;
-
-		ath10k_p2p_fill_noa_ie(new_data, new_len, noa);
-
-		spin_lock_bh(&ar->data_lock);
-		arvif->u.ap.noa_data = new_data;
-		arvif->u.ap.noa_len = new_len;
-		spin_unlock_bh(&ar->data_lock);
-		kfree(old_data);
-	}
+	if (noa->changed & WMI_P2P_NOA_CHANGED_BIT)
+		ath10k_p2p_noa_update(arvif, noa);
 
 	if (arvif->u.ap.noa_data)
 		if (!pskb_expand_head(bcn, 0, arvif->u.ap.noa_len, GFP_ATOMIC))
 			memcpy(skb_put(bcn, arvif->u.ap.noa_len),
 			       arvif->u.ap.noa_data,
 			       arvif->u.ap.noa_len);
-	return;
 
-cleanup:
-	spin_lock_bh(&ar->data_lock);
-	arvif->u.ap.noa_data = NULL;
-	arvif->u.ap.noa_len = 0;
-	spin_unlock_bh(&ar->data_lock);
-	kfree(old_data);
+	return;
 }
 
 static int ath10k_wmi_op_pull_swba_ev(struct ath10k *ar, struct sk_buff *skb,
-- 
1.8.5.3

