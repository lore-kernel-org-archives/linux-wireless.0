Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44940 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab1JYXsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 19:48:45 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC] wifi:  Allow forcing lower mcs (/n) rates.
Date: Tue, 25 Oct 2011 16:48:39 -0700
Message-Id: <1319586519-11190-1-git-send-email-greearb@candelatech.com> (sfid-20111026_014849_098472_74130E00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Allow user to set the HT information and mask.  This
can be used to remove rates from consideration, ie to
force use of lower rates.

Probably still need some work, as I think all of the rates
are advertised, and probably they should be masked out as
well.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 2397bfb... 270fab3... M	include/linux/nl80211.h
:100644 100644 8d6e90e... 4a71d18... M	include/net/cfg80211.h
:100644 100644 d514f5c... fefd4c4... M	net/mac80211/cfg.c
:100644 100644 aebc697... e5b54ea... M	net/mac80211/ieee80211_i.h
:100644 100644 58e5e1b... c4a25a2... M	net/mac80211/mlme.c
:100644 100644 37f35fe... f4f4397... M	net/wireless/nl80211.c
 include/linux/nl80211.h    |    3 +++
 include/net/cfg80211.h     |    4 ++++
 net/mac80211/cfg.c         |   28 ++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/mlme.c        |   23 ++++++++++++++++++++++-
 net/wireless/nl80211.c     |   14 ++++++++++++++
 6 files changed, 74 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2397bfb..270fab3 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1000,6 +1000,8 @@ enum nl80211_commands {
  *      function as /a/b/g stations.
  * @NL80211_ATTR_DISABLE_HT40:  Disable HT-40 even if AP and hardware
  *      support it.
+ * @NL80211_ATTR_HT_CAPABILITY_MASK: Specify which bits of the HT_CAPs
+ *      to pay attention to.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1230,6 +1232,7 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_DISABLE_11N,
 	NL80211_ATTR_DISABLE_HT40,
+	NL80211_ATTR_HT_CAPABILITY_MASK,
 
 	/* add attributes here, update the policy in nl80211.c */
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8d6e90e..4a71d18 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -261,11 +261,15 @@ struct ieee80211_supported_band {
  * @use_4addr: use 4-address frames
  * @disable_11n:  Don't use 11n features (HT, etc)
  * @disable_ht40:  Don't use HT40, even if hardware & AP support it.
+ * @ht_capa:  HT Capabilities for this interface.
+ * @ht_capa_mask:  Bits of ht_capa that are to be used.
  */
 struct vif_params {
 	int use_4addr;
 	int disable_11n;
 	int disable_ht40;
+	struct ieee80211_ht_cap *ht_capa;
+	struct ieee80211_ht_cap *ht_capa_mask;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d514f5c..fefd4c4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -104,6 +104,34 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 		}
 	}
 
+	if (params->ht_capa) {
+		u8 *caps = (u8*)(params->ht_capa);
+		u8 *mask = (u8*)(params->ht_capa_mask);
+		u8 *scaps = (u8*)(&sdata->ht_capa);
+		u8 *smask = (u8*)(&sdata->ht_capa_mask);
+		int i;
+
+		BUILD_BUG_ON(sizeof(*(params->ht_capa)) != sizeof(sdata->ht_capa));
+
+		for (i = 0; i<sizeof(sdata->ht_capa); i++) {
+			if (mask[i]) {
+				int q;
+				smask[i] |= mask[i];
+				for (q = 0; q<8; q++) {
+					if (mask[i] & (1<<q)) {
+						if (caps[i] & (1<<q))
+							scaps[i] |= (1<<q);
+						else
+							scaps[i] &= ~(1<<q);
+					}
+				}
+			}
+		}
+	}
+	else if (params->ht_capa_mask) {
+		memcpy(&sdata->ht_capa_mask, params->ht_capa_mask, sizeof(sdata->ht_capa_mask));
+	}
+
 	return 0;
 }
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index aebc697..e5b54ea 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -567,6 +567,9 @@ struct ieee80211_sub_if_data {
 	bool cfg_disable_11n; /* configured to disable 11n? */
 	bool cfg_disable_ht40; /* configured to not use HT-40 */
 
+	struct ieee80211_ht_cap ht_capa; /* configured ht-cap over-rides */
+	struct ieee80211_ht_cap ht_capa_mask; /* What parts of ht_capa are valid */
+	
 	/* Fragment table for host-based reassembly */
 	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
 	unsigned int fragment_next;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 58e5e1b..c4a25a2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1553,10 +1553,31 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 	else
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
-	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
+	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_11N)) {
+		u8 *scaps = (u8*)(&sdata->ht_capa.mcs.rx_mask);
+		u8 *smask = (u8*)(&sdata->ht_capa_mask.mcs.rx_mask);
+		int i;
+
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
 
+		/* check for HT over-rides, mcs rates only at this time,
+		 * and can only disable them, not force new ones to be
+		 * made available.
+		 */
+		for (i = 0; i<IEEE80211_HT_MCS_MASK_LEN; i++) {
+			int q;
+			for (q = 0; q<8; q++) {
+				if (smask[i] & (1<<q)) {
+					if (!(scaps[i] & (1<<q))) {
+						/* can only disable rates, not force new ones */
+						sta->sta.ht_cap.mcs.rx_mask[i] &= ~(1<<q);
+					}
+				}
+			}
+		}
+	}
+
 	ap_ht_cap_flags = sta->sta.ht_cap.cap;
 
 	rate_control_rate_init(sta);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 37f35fe..f4f4397 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1584,7 +1584,21 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 	else {
 		params.disable_ht40 = -1;
 	}
+
+	if (info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK]) {
+		params.ht_capa_mask =
+			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK]);
+		change = true;
+	}
 	
+	if (info->attrs[NL80211_ATTR_HT_CAPABILITY]) {
+		if (!params.ht_capa_mask)
+			return -EINVAL;
+		params.ht_capa =
+			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
+		change = true;
+	}
+
 	if (change)
 		err = cfg80211_change_iface(rdev, dev, ntype, flags, &params);
 	else
-- 
1.7.3.4

