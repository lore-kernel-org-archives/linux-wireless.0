Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:56324 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981AbYICDbZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:25 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 23/39] mac80211: change MIMO_PS to SM_PS
Date: Wed,  3 Sep 2008 11:26:43 +0800
Message-Id: <1220412419-15404-24-git-send-email-yi.zhu@intel.com> (sfid-20080903_055043_784408_739B6FCA)
In-Reply-To: <1220412419-15404-23-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-14-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-15-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-16-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-17-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-18-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-19-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-20-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-21-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-22-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-23-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch follows 11n spec naming more rigorously replacing MIMO_PS
with SM_PS (Spatial Multiplexing Power Save).

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 include/linux/ieee80211.h |   12 ++++++------
 net/mac80211/main.c       |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index be45645..333d3ae 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -708,7 +708,7 @@ struct ieee80211_ht_addt_info {
 
 /* 802.11n HT capabilities masks */
 #define IEEE80211_HT_CAP_SUP_WIDTH		0x0002
-#define IEEE80211_HT_CAP_MIMO_PS		0x000C
+#define IEEE80211_HT_CAP_SM_PS			0x000C
 #define IEEE80211_HT_CAP_GRN_FLD		0x0010
 #define IEEE80211_HT_CAP_SGI_20			0x0020
 #define IEEE80211_HT_CAP_SGI_40			0x0040
@@ -737,11 +737,11 @@ struct ieee80211_ht_addt_info {
 #define IEEE80211_HT_IE_NON_GF_STA_PRSNT	0x0004
 #define IEEE80211_HT_IE_NON_HT_STA_PRSNT	0x0010
 
-/* MIMO Power Save Modes */
-#define WLAN_HT_CAP_MIMO_PS_STATIC	0
-#define WLAN_HT_CAP_MIMO_PS_DYNAMIC	1
-#define WLAN_HT_CAP_MIMO_PS_INVALID	2
-#define WLAN_HT_CAP_MIMO_PS_DISABLED	3
+/* Spatial Multiplexing Power Save Modes */
+#define WLAN_HT_CAP_SM_PS_STATIC	0
+#define WLAN_HT_CAP_SM_PS_DYNAMIC	1
+#define WLAN_HT_CAP_SM_PS_INVALID	2
+#define WLAN_HT_CAP_SM_PS_DISABLED	3
 
 /* Authentication algorithms */
 #define WLAN_AUTH_OPEN 0
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 638b75f..804a875 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1140,8 +1140,8 @@ u32 ieee80211_handle_ht(struct ieee80211_local *local, int enable_ht,
 	ht_conf.ht_supported = 1;
 
 	ht_conf.cap = req_ht_cap->cap & sband->ht_info.cap;
-	ht_conf.cap &= ~(IEEE80211_HT_CAP_MIMO_PS);
-	ht_conf.cap |= sband->ht_info.cap & IEEE80211_HT_CAP_MIMO_PS;
+	ht_conf.cap &= ~(IEEE80211_HT_CAP_SM_PS);
+	ht_conf.cap |= sband->ht_info.cap & IEEE80211_HT_CAP_SM_PS;
 	ht_bss_conf.primary_channel = req_bss_cap->primary_channel;
 	ht_bss_conf.bss_cap = req_bss_cap->bss_cap;
 	ht_bss_conf.bss_op_mode = req_bss_cap->bss_op_mode;
-- 
1.5.3.6

