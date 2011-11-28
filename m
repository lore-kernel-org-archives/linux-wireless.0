Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:40694 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1K1R4Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 12:56:24 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	Marek Lindner <lindner_marek@yahoo.de>,
	Felix Fietkau <nbd@openwrt.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 4/4] mac80211: handle protection mode, RIFS and ADDBA for HT IBSS
Date: Mon, 28 Nov 2011 18:55:16 +0100
Message-Id: <1322502917-28205-5-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111128_185629_108712_6AF49AA5)
In-Reply-To: <1322502917-28205-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1322502917-28205-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Follow 802.11n-2009 9.13.3.1 for protection mode and ADDBA
* Send ADDBA only to HT STAs - implement 11.5.1.1 partially

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/agg-tx.c |   21 +++++++++++++++++++++
 net/mac80211/ibss.c   |   18 ++++++++++++++++++
 net/mac80211/util.c   |    3 +++
 3 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 41b9bfd..c85c369 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -390,6 +390,27 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 		return -EINVAL;
 	}
 
+	/*
+	 * 11.5.1.1: If the initiating STA is an HT STA, is a member of an
+	 * IBSS, and has no other existing Block Ack agreement with the
+	 * recipient STA, then the initiating STA shall transmit a Probe
+	 * Request frame to the recipient STA and shall not transmit an
+	 * ADDBA Request frame unless it receives a Probe Response frame
+	 * from the recipient within dot11ADDBAFailureTimeout.
+	 *
+	 * The probe request mechanism for ADDBA is currently not implemented,
+	 * but we only build up Block Ack session with HT STAs. This information
+	 * is set when we receive a bss info from a probe response or a beacon.
+	 */
+	if (sta->sdata->vif.type == NL80211_IFTYPE_ADHOC &&
+	    !sta->sta.ht_cap.ht_supported) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "BA request denied - IBSS STA %pM"
+		       "does not advertise HT support\n", pubsta->addr);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+		return -EINVAL;
+	}
+
 	spin_lock_bh(&sta->lock);
 
 	/* we have tried too many times, receiver does not want A-MPDU */
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 1e4fd0f..ea424de 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -954,6 +954,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_ibss_params *params)
 {
 	struct sk_buff *skb;
+	u32 changed = 0;
 
 	skb = dev_alloc_skb(sdata->local->hw.extra_tx_headroom +
 			    sizeof(struct ieee80211_hdr_3addr) +
@@ -1016,6 +1017,23 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	ieee80211_recalc_idle(sdata->local);
 	mutex_unlock(&sdata->local->mtx);
 
+	/*
+	 * 9.13.3.1: In an IBSS, the HT Protection field is reserved, but
+	 * an HT STA shall protect HT transmissions as though the HT
+	 * Protection field were set to non-HT mixed mode.
+	 *
+	 * In an IBSS, the RIFS Mode field of the HT Operation element is
+	 * also reserved, but an HT STA shall operate as though this field
+	 * were set to 1.
+	 */
+
+	sdata->vif.bss_conf.ht_operation_mode |=
+		  IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED
+		| IEEE80211_HT_PARAM_RIFS_MODE;
+
+	changed |= BSS_CHANGED_HT;
+	ieee80211_bss_info_change_notify(sdata, changed);
+
 	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 
 	return 0;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3b9b492..c26e968 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1585,6 +1585,9 @@ u8 *ieee80211_ie_build_ht_info(u8 *pos,
 	}
 	if (ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
 		ht_info->ht_param |= IEEE80211_HT_PARAM_CHAN_WIDTH_ANY;
+
+	/* Note: According to 9.13.3.1, HT Protection field and RIFS Mode
+	 * are reserved in IBSS mode, therefore keep them at 0 */
 	ht_info->operation_mode = 0x0000;
 	ht_info->stbc_param = 0x0000;
 
-- 
1.7.7.3

