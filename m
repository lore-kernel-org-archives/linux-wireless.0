Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7815 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbbJYJAA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 05:00:00 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/10] mac80211: TDLS: add proper HT-oper IE
Date: Sun, 25 Oct 2015 10:59:34 +0200
Message-Id: <1445763582-11421-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_100009_055362_E42E7A6B)
In-Reply-To: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

When 11n peers performs a TDLS connection on a legacy BSS, the HT
operation IE must be specified according to IEEE802.11-2012 section
9.23.3.2. Otherwise HT-protection is compromised and the medium becomes
noisy for both the TDLS and the BSS links.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
RESEND - already to the ML in August
---
---
 net/mac80211/ibss.c        |  2 +-
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/mesh.c        |  3 ++-
 net/mac80211/tdls.c        | 13 ++++++++++---
 net/mac80211/util.c        |  5 ++++-
 5 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 2001555..3b5874e 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -188,7 +188,7 @@ ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
 		 * keep them at 0
 		 */
 		pos = ieee80211_ie_build_ht_oper(pos, &sband->ht_cap,
-						 chandef, 0);
+						 chandef, 0, false);
 
 		/* add VHT capability and information IEs */
 		if (chandef->width != NL80211_CHAN_WIDTH_20 &&
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 68680ad..5c76ba7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1962,7 +1962,7 @@ u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			      u16 cap);
 u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       const struct cfg80211_chan_def *chandef,
-			       u16 prot_mode);
+			       u16 prot_mode, bool rifs_mode);
 u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 			       u32 cap);
 u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 626e8de..fa28500 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -466,7 +466,8 @@ int mesh_add_ht_oper_ie(struct ieee80211_sub_if_data *sdata,
 
 	pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_operation));
 	ieee80211_ie_build_ht_oper(pos, ht_cap, &sdata->vif.bss_conf.chandef,
-				   sdata->vif.bss_conf.ht_operation_mode);
+				   sdata->vif.bss_conf.ht_operation_mode,
+				   false);
 
 	return 0;
 }
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index ecc5e2a..c9eeb3f 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -591,12 +591,19 @@ ieee80211_tdls_add_setup_cfm_ies(struct ieee80211_sub_if_data *sdata,
 		offset = noffset;
 	}
 
-	/* if HT support is only added in TDLS, we need an HT-operation IE */
+	/*
+	 * if HT support is only added in TDLS, we need an HT-operation IE.
+	 * add the IE as required by IEEE802.11-2012 9.23.3.2.
+	 */
 	if (!ap_sta->sta.ht_cap.ht_supported && sta->sta.ht_cap.ht_supported) {
+		u16 prot = IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED |
+			   IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT |
+			   IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT;
+
 		pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_operation));
-		/* send an empty HT operation IE */
 		ieee80211_ie_build_ht_oper(pos, &sta->sta.ht_cap,
-					   &sdata->vif.bss_conf.chandef, 0);
+					   &sdata->vif.bss_conf.chandef, prot,
+					   true);
 	}
 
 	ieee80211_tdls_add_link_ie(sdata, skb, peer, initiator);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 13b07ed..7150ae2 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2274,7 +2274,7 @@ u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 
 u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       const struct cfg80211_chan_def *chandef,
-			       u16 prot_mode)
+			       u16 prot_mode, bool rifs_mode)
 {
 	struct ieee80211_ht_operation *ht_oper;
 	/* Build HT Information */
@@ -2302,6 +2302,9 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 	    chandef->width != NL80211_CHAN_WIDTH_20)
 		ht_oper->ht_param |= IEEE80211_HT_PARAM_CHAN_WIDTH_ANY;
 
+	if (rifs_mode)
+		ht_oper->ht_param |= IEEE80211_HT_PARAM_RIFS_MODE;
+
 	ht_oper->operation_mode = cpu_to_le16(prot_mode);
 	ht_oper->stbc_param = 0x0000;
 
-- 
2.1.4

