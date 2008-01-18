Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:26152 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757023AbYARMwr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 07:52:47 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH] mac80211: enable IBSS merging
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Fri, 18 Jan 2008 21:52:52 +0900
Message-ID: <20080118125252.6455.41047.stgit@one> (sfid-20080118_125251_383020_9A9C2A8A)
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

 net/mac80211/ieee80211_sta.c |   75 ++++++++++++++++++++++++++----------------
 net/mac80211/rx.c            |    5 ++-
 2 files changed, 51 insertions(+), 29 deletions(-)


diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index e7da1cd..f6b76a3 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -80,6 +80,9 @@ static void ieee80211_rx_bss_put(struct net_device *dev,
 				 struct ieee80211_sta_bss *bss);
 static int ieee80211_sta_find_ibss(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta);
+static int ieee80211_sta_join_ibss(struct net_device *dev,
+				   struct ieee80211_if_sta *ifsta,
+				   struct ieee80211_sta_bss *bss);
 static int ieee80211_sta_wep_configured(struct net_device *dev);
 static int ieee80211_sta_start_scan(struct net_device *dev,
 				    u8 *ssid, size_t ssid_len);
@@ -1825,7 +1828,7 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 	struct ieee80211_sta_bss *bss;
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	u64 timestamp;
+	u64 timestamp, mactime;
 	DECLARE_MAC_BUF(mac);
 	DECLARE_MAC_BUF(mac2);
 
@@ -1843,30 +1846,6 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
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
@@ -1951,7 +1930,8 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 #endif
 	}
 
-	if (bss->probe_resp && beacon) {
+	if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
+	    bss->probe_resp && beacon) {
 		/* Do not allow beacon to override data from Probe Response. */
 		ieee80211_rx_bss_put(dev, bss);
 		return;
@@ -2070,6 +2050,45 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 	bss->noise = rx_status->noise;
 	if (!beacon)
 		bss->probe_resp++;
+
+	/* check if we need to merge IBSS */
+	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && beacon &&
+	    !local->sta_sw_scanning && !local->sta_hw_scanning &&
+	    mgmt->u.beacon.capab_info & WLAN_CAPABILITY_IBSS &&
+	    memcmp(elems.ssid, sdata->u.sta.ssid, sdata->u.sta.ssid_len) == 0) {
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+		static unsigned long last_tsf_debug;
+#endif
+		if (rx_status->flag & RX_FLAG_TSFT)
+			mactime = rx_status->mactime;
+		else {
+			mactime = -1LLU;
+			printk(KERN_WARNING "%s: IBSS mode needs mactime for "
+				"beacons\n", dev->name);
+		}
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+		if (time_after(jiffies, last_tsf_debug + 5 * HZ)) {
+			printk(KERN_DEBUG "RX beacon SA=%s BSSID="
+			       "%s TSF=0x%llx BCN=0x%llx diff=%lld @%lu\n",
+			       print_mac(mac, mgmt->sa),
+			       print_mac(mac2, mgmt->bssid),
+			       (unsigned long long)mactime,
+			       (unsigned long long)timestamp,
+			       (unsigned long long)(mactime - timestamp),
+			       jiffies);
+			last_tsf_debug = jiffies;
+		}
+#endif /* CONFIG_MAC80211_IBSS_DEBUG */
+		if (mactime <= timestamp) {
+			printk(KERN_DEBUG "%s: beacon TSF higher than local TSF"
+				" -> IBSS merge with BSSID %s\n",
+				dev->name, print_mac(mac, mgmt->bssid));
+			ieee80211_sta_join_ibss(dev, &sdata->u.sta, bss);
+			ieee80211_ibss_add_sta(dev, NULL,
+				mgmt->bssid, mgmt->sa);
+		}
+	}
+
 	ieee80211_rx_bss_put(dev, bss);
 }
 
@@ -2724,7 +2743,7 @@ static int ieee80211_sta_join_ibss(struct net_device *dev,
 		return -1;
 	}
 
-	/* Set beacon template based on scan results */
+	/* Set beacon template */
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
 	do {
 		if (!skb)
@@ -2810,7 +2829,7 @@ static int ieee80211_sta_join_ibss(struct net_device *dev,
 		    local->ops->beacon_update(local_to_hw(local),
 					     skb, &control) == 0) {
 			printk(KERN_DEBUG "%s: Configured IBSS beacon "
-			       "template based on scan results\n", dev->name);
+			       "template\n", dev->name);
 			skb = NULL;
 		}
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6cc1e7e..5617e17 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1609,7 +1609,10 @@ static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
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

