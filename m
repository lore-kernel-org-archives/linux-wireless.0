Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43806 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaKIQuf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2014 11:50:35 -0500
Received: by mail-wi0-f174.google.com with SMTP id d1so8338512wiv.1
        for <linux-wireless@vger.kernel.org>; Sun, 09 Nov 2014 08:50:34 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 07/16] mac80211: add BSS coex IE to TDLS setup frames
Date: Sun,  9 Nov 2014 18:50:13 +0200
Message-Id: <1415551822-20121-7-git-send-email-arik@wizery.com> (sfid-20141109_175041_600694_C7ADF79D)
In-Reply-To: <1415551822-20121-1-git-send-email-arik@wizery.com>
References: <1415551822-20121-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the BSS coex IE in case we support HT40 channels, as mandated by
section 8.5.13 in IEEE802.11 2012.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/linux/ieee80211.h |  3 +++
 net/mac80211/tdls.c       | 15 +++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 4e2bb91..adac1be 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2037,6 +2037,9 @@ enum ieee80211_tdls_actioncode {
 /* TDLS specific payload type in the LLC/SNAP header */
 #define WLAN_TDLS_SNAP_RFTYPE	0x2
 
+/* BSS Coex IE information field bits */
+#define WLAN_BSS_COEX_INFORMATION_REQUEST	BIT(0)
+
 /**
  * enum - mesh synchronization method identifier
  *
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 8fb314b..30a4c10 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -117,6 +117,16 @@ ieee80211_tdls_add_supp_channels(struct ieee80211_sub_if_data *sdata,
 	*pos = 2 * subband_cnt;
 }
 
+static void ieee80211_tdls_add_bss_coex_ie(struct sk_buff *skb)
+{
+	u8 *pos = (void *)skb_put(skb, 3);
+
+	*pos++ = WLAN_EID_BSS_COEX_2040;
+	*pos++ = 1; /* len */
+
+	*pos++ = WLAN_BSS_COEX_INFORMATION_REQUEST;
+}
+
 static u16 ieee80211_get_tdls_sta_capab(struct ieee80211_sub_if_data *sdata,
 					u16 status_code)
 {
@@ -341,6 +351,10 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 
 	rcu_read_unlock();
 
+	if (ht_cap.ht_supported &&
+	    (ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
+		ieee80211_tdls_add_bss_coex_ie(skb);
+
 	/* add any remaining IEs */
 	if (extra_ies_len) {
 		noffset = extra_ies_len;
@@ -597,6 +611,7 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 			       2 + max(sizeof(struct ieee80211_ht_cap),
 				       sizeof(struct ieee80211_ht_operation)) +
 			       50 + /* supported channels */
+			       3 + /* 40/20 BSS coex */
 			       extra_ies_len +
 			       sizeof(struct ieee80211_tdls_lnkie));
 	if (!skb)
-- 
1.9.1

