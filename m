Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:39768 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab3JOSrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 14:47:16 -0400
Subject: [PATCH 6/7] ath10k: fix ath10k_bss_assoc() to not sleep in atomic
 context
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 15 Oct 2013 21:47:14 +0300
Message-ID: <20131015184714.14123.32890.stgit@localhost6.localdomain6> (sfid-20131015_204718_821341_9E1A9BA5)
In-Reply-To: <20131015184548.14123.56949.stgit@localhost6.localdomain6>
References: <20131015184548.14123.56949.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k_bss_assoc() was calling ath10k_peer_assoc(), which can sleep, under
atomic rcu_read_lock() and causing scheduing while atomic errors. Workaround
that by delaying the call to ath10k_wmi_peer_assoc().

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   56 ++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 4273eef..0b1cc51 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1137,26 +1137,25 @@ static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
 	WARN_ON(phymode == MODE_UNKNOWN);
 }
 
-static int ath10k_peer_assoc(struct ath10k *ar,
-			     struct ath10k_vif *arvif,
-			     struct ieee80211_sta *sta,
-			     struct ieee80211_bss_conf *bss_conf)
+static int ath10k_peer_assoc_prepare(struct ath10k *ar,
+				     struct ath10k_vif *arvif,
+				     struct ieee80211_sta *sta,
+				     struct ieee80211_bss_conf *bss_conf,
+				     struct wmi_peer_assoc_complete_arg *arg)
 {
-	struct wmi_peer_assoc_complete_arg arg;
-
 	lockdep_assert_held(&ar->conf_mutex);
 
-	memset(&arg, 0, sizeof(struct wmi_peer_assoc_complete_arg));
+	memset(arg, 0, sizeof(*arg));
 
-	ath10k_peer_assoc_h_basic(ar, arvif, sta, bss_conf, &arg);
-	ath10k_peer_assoc_h_crypto(ar, arvif, &arg);
-	ath10k_peer_assoc_h_rates(ar, sta, &arg);
-	ath10k_peer_assoc_h_ht(ar, sta, &arg);
-	ath10k_peer_assoc_h_vht(ar, sta, &arg);
-	ath10k_peer_assoc_h_qos(ar, arvif, sta, bss_conf, &arg);
-	ath10k_peer_assoc_h_phymode(ar, arvif, sta, &arg);
+	ath10k_peer_assoc_h_basic(ar, arvif, sta, bss_conf, arg);
+	ath10k_peer_assoc_h_crypto(ar, arvif, arg);
+	ath10k_peer_assoc_h_rates(ar, sta, arg);
+	ath10k_peer_assoc_h_ht(ar, sta, arg);
+	ath10k_peer_assoc_h_vht(ar, sta, arg);
+	ath10k_peer_assoc_h_qos(ar, arvif, sta, bss_conf, arg);
+	ath10k_peer_assoc_h_phymode(ar, arvif, sta, arg);
 
-	return ath10k_wmi_peer_assoc(ar, &arg);
+	return 0;
 }
 
 /* can be called only in mac80211 callbacks due to `key_count` usage */
@@ -1166,6 +1165,7 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 {
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct wmi_peer_assoc_complete_arg peer_arg;
 	struct ieee80211_sta *ap_sta;
 	int ret;
 
@@ -1181,15 +1181,24 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 		return;
 	}
 
-	ret = ath10k_peer_assoc(ar, arvif, ap_sta, bss_conf);
+	ret = ath10k_peer_assoc_prepare(ar, arvif, ap_sta,
+					bss_conf, &peer_arg);
 	if (ret) {
-		ath10k_warn("Peer assoc failed for %pM\n", bss_conf->bssid);
+		ath10k_warn("Peer assoc prepare failed for %pM\n: %d",
+			    bss_conf->bssid, ret);
 		rcu_read_unlock();
 		return;
 	}
 
 	rcu_read_unlock();
 
+	ret = ath10k_wmi_peer_assoc(ar, &peer_arg);
+	if (ret) {
+		ath10k_warn("Peer assoc failed for %pM\n: %d",
+			    bss_conf->bssid, ret);
+		return;
+	}
+
 	ath10k_dbg(ATH10K_DBG_MAC,
 		   "mac vdev %d up (associated) bssid %pM aid %d\n",
 		   arvif->vdev_id, bss_conf->bssid, bss_conf->aid);
@@ -1243,13 +1252,22 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
 				struct ieee80211_sta *sta)
 {
+	struct wmi_peer_assoc_complete_arg peer_arg;
 	int ret = 0;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	ret = ath10k_peer_assoc(ar, arvif, sta, NULL);
+	ret = ath10k_peer_assoc_prepare(ar, arvif, sta, NULL, &peer_arg);
+	if (ret) {
+		ath10k_warn("WMI peer assoc prepare failed for %pM\n",
+			    sta->addr);
+		return ret;
+	}
+
+	ret = ath10k_wmi_peer_assoc(ar, &peer_arg);
 	if (ret) {
-		ath10k_warn("WMI peer assoc failed for %pM\n", sta->addr);
+		ath10k_warn("Peer assoc failed for STA %pM\n: %d",
+			    sta->addr, ret);
 		return ret;
 	}
 

