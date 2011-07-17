Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:56314 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab1GQJOD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 05:14:03 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh03-2.mail.saunalahti.fi (Postfix) with SMTP id 4CC40EBBA1
	for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 12:14:00 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh01.mail.saunalahti.fi (Postfix) with ESMTP id 2DAC8402E
	for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 12:13:57 +0300 (EEST)
Subject: [PATCH] ieee80211: add few wmm tspec values
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Sun, 17 Jul 2011 12:13:56 +0300
Message-ID: <20110717091356.3427.38487.stgit@localhost6.localdomain6> (sfid-20110717_111433_219264_02D12B78)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are needed by ath6kl for parsing tspec status from an IE.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 include/linux/ieee80211.h |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index a26108e..54c8789 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1453,6 +1453,43 @@ enum ieee80211_sa_query_action {
 
 #define WLAN_PMKID_LEN			16
 
+/*
+ * WMM/802.11e Tspec Element
+ */
+#define IEEE80211_WMM_IE_TSPEC_TID_MASK		0x0F
+#define IEEE80211_WMM_IE_TSPEC_TID_SHIFT	1
+
+enum ieee80211_tspec_status_code {
+	IEEE80211_TSPEC_STATUS_ADMISS_ACCEPTED = 0,
+	IEEE80211_TSPEC_STATUS_ADDTS_INVAL_PARAMS = 0x1,
+};
+
+struct ieee80211_tspec_ie {
+	u8 element_id;
+	u8 len;
+	u8 oui[3];
+	u8 oui_type;
+	u8 oui_subtype;
+	u8 version;
+	__le16 tsinfo;
+	u8 tsinfo_resvd;
+	__le16 nominal_msdu;
+	__le16 max_msdu;
+	__le32 min_service_int;
+	__le32 max_service_int;
+	__le32 inactivity_int;
+	__le32 suspension_int;
+	__le32 service_start_time;
+	__le32 min_data_rate;
+	__le32 mean_data_rate;
+	__le32 peak_data_rate;
+	__le32 max_burst_size;
+	__le32 delay_bound;
+	__le32 min_phy_rate;
+	__le16 sba;
+	__le16 medium_time;
+} __packed;
+
 /**
  * ieee80211_get_qos_ctl - get pointer to qos control bytes
  * @hdr: the frame

