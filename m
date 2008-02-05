Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:48892 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755637AbYBEKuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 05:50:04 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 2/2] mac80211: enable IBSS merging
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, flamingice@sourmilk.net, jbenc@suse.cz
Date: Tue, 05 Feb 2008 19:49:49 +0900
Message-ID: <20080205104949.9379.61874.stgit@one> (sfid-20080205_105009_544167_5EF568E1)
In-Reply-To: <20080205104543.9379.47253.stgit@one>
References: <20080205104543.9379.47253.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

enable IBSS cell merging. if an IBSS beacon with the same ESSID and a TSF
higher than the local TSF (mactime) is received, we have to join its BSSID.

* move the relevant code section (previously only containing debug code) down
to the end of the function, so we can reuse the bss structure.

* we have to compare the mactime (TSF at the time of packet receive) rather
than the current TSF.

* in IBSS mode we want to allow beacons to override probe response info so we
can correctly do merges.

* we don't only configure beacons based on scan results, so change that
message.

* to enable all this we have to let all beacons thru in IBSS mode, even if they
have a different BSSID.

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---

 net/mac80211/ieee80211_sta.c |   68 +++++++++++++++++++++++++-----------------
 net/mac80211/rx.c            |    5 ++-
 2 files changed, 45 insertions(+), 28 deletions(-)


diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 08f89fa..7f72f32 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2202,7 +2202,7 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 	struct ieee80211_sta_bss *bss;
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	u64 timestamp;
+	u64 timestamp, mactime;
 	DECLARE_MAC_BUF(mac);
 	DECLARE_MAC_BUF(mac2);
 
@@ -2220,30 +2220,6 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 		return;
 
 	timestamp = le64_to_cpu(mgmt->u.beacon.timestamp);
-
-	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && beacon &&
-	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0) {
-#ifdef CONFIG_MAC80211_IBSS_DEBUG
-		static unsigned long last_tsf_debug = 0;
-		u64 tsf;
-		if (local->ops->get_tsf)
-			tsf = local->ops->get_tsf(local_to_hw(local));
-		else
-			tsf = -1LLU;
-		if (time_after(jiffies, last_tsf_debug + 5 * HZ)) {
-			printk(KERN_DEBUG "RX beacon SA=%s BSSID="
-			       "%s TSF=0x%llx BCN=0x%llx diff=%lld "
-			       "@%lu\n",
-			       print_mac(mac, mgmt->sa), print_mac(mac2, mgmt->bssid),
-			       (unsigned long long)tsf,
-			       (unsigned long long)timestamp,
-			       (unsigned long long)(tsf - timestamp),
-			       jiffies);
-			last_tsf_debug = jiffies;
-		}
-#endif /* CONFIG_MAC80211_IBSS_DEBUG */
-	}
-
 	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
 
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && elems.supp_rates &&
@@ -2329,8 +2305,10 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 
 	bss->band = rx_status->band;
 
-	if (bss->probe_resp && beacon) {
-		/* Do not allow beacon to override data from Probe Response. */
+	if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
+	    bss->probe_resp && beacon) {
+		/* STA mode:
+		 * Do not allow beacon to override data from Probe Response. */
 		ieee80211_rx_bss_put(dev, bss);
 		return;
 	}
@@ -2434,6 +2412,42 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 	bss->noise = rx_status->noise;
 	if (!beacon)
 		bss->probe_resp++;
+
+	/* check if we need to merge IBSS */
+	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && beacon &&
+	    !local->sta_sw_scanning && !local->sta_hw_scanning &&
+	    mgmt->u.beacon.capab_info & WLAN_CAPABILITY_IBSS &&
+	    memcmp(elems.ssid, sdata->u.sta.ssid, sdata->u.sta.ssid_len) == 0) {
+		if (rx_status->flag & RX_FLAG_TSFT)
+			/* in order for correct IBSS merging we need mactime */
+			mactime = rx_status->mactime;
+		else if (local && local->ops && local->ops->get_tsf)
+			/* second best option: get current TSF */
+			mactime = local->ops->get_tsf(local_to_hw(local));
+		else
+			/* can't merge without knowing the TSF */
+			mactime = -1LLU;
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+		printk(KERN_DEBUG "RX beacon SA=%s BSSID="
+		       "%s TSF=0x%llx BCN=0x%llx diff=%lld @%lu\n",
+		       print_mac(mac, mgmt->sa),
+		       print_mac(mac2, mgmt->bssid),
+		       (unsigned long long)mactime,
+		       (unsigned long long)timestamp,
+		       (unsigned long long)(mactime - timestamp),
+		       jiffies);
+#endif /* CONFIG_MAC80211_IBSS_DEBUG */
+		if (mactime <= timestamp) {
+			if (CONFIG_MAC80211_IBSS_DEBUG || net_ratelimit())
+				printk(KERN_DEBUG "%s: beacon TSF higher than "
+				       "local TSF - IBSS merge with BSSID %s\n",
+				       dev->name, print_mac(mac, mgmt->bssid));
+			ieee80211_sta_join_ibss(dev, &sdata->u.sta, bss);
+			ieee80211_ibss_add_sta(dev, NULL,
+					       mgmt->bssid, mgmt->sa);
+		}
+	}
+
 	ieee80211_rx_bss_put(dev, bss);
 }
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index beda1bf..ed7cf37 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1612,7 +1612,10 @@ static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
 	case IEEE80211_IF_TYPE_IBSS:
 		if (!bssid)
 			return 0;
-		if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
+		if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT &&
+		    (rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON)
+			return 1;
+		else if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
 			if (!(rx->flags & IEEE80211_TXRXD_RXIN_SCAN))
 				return 0;
 			rx->flags &= ~IEEE80211_TXRXD_RXRA_MATCH;

