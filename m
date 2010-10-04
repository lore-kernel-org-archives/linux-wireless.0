Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:16625 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751244Ab0JDCRc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Oct 2010 22:17:32 -0400
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0835528650
	for <linux-wireless@vger.kernel.org>; Mon,  4 Oct 2010 11:17:31 +0900 (JST)
Subject: [PATCH v3] mac80211: Add WME information element for IBSS
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 04 Oct 2010 11:17:30 +0900
Message-ID: <20101004021730.3870.14677.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable WME QoS in IBSS mode by adding a WME information element to beacons and
probe respones and by checking for it and marking stations as WME capable if it
is present.

Signed-off-by: Bruno Randolf <br1@einfach.org>

---
v3: use GFP_ATOMIC and re-organize nesting of "if" statements. allthough in
practice we would probaby always have the rates element i think it's more
correct to code it like this.
---
 net/mac80211/ibss.c |   65 ++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 43 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 1a3aae5..ff60c02 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -173,6 +173,19 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		memcpy(skb_put(skb, ifibss->ie_len),
 		       ifibss->ie, ifibss->ie_len);
 
+	if (local->hw.queues >= 4) {
+		pos = skb_put(skb, 9);
+		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
+		*pos++ = 7; /* len */
+		*pos++ = 0x00; /* Microsoft OUI 00:50:F2 */
+		*pos++ = 0x50;
+		*pos++ = 0xf2;
+		*pos++ = 2; /* WME */
+		*pos++ = 0; /* WME info */
+		*pos++ = 1; /* WME ver */
+		*pos++ = 0; /* U-APSD no in use */
+	}
+
 	rcu_assign_pointer(ifibss->presp, skb);
 
 	sdata->vif.bss_conf.beacon_int = beacon_int;
@@ -266,37 +279,45 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
 		return;
 
-	if (sdata->vif.type == NL80211_IFTYPE_ADHOC && elems->supp_rates &&
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
 	    memcmp(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0) {
-		supp_rates = ieee80211_sta_get_rates(local, elems, band);
 
 		rcu_read_lock();
-
 		sta = sta_info_get(sdata, mgmt->sa);
-		if (sta) {
-			u32 prev_rates;
 
-			prev_rates = sta->sta.supp_rates[band];
-			/* make sure mandatory rates are always added */
-			sta->sta.supp_rates[band] = supp_rates |
-				ieee80211_mandatory_rates(local, band);
+		if (elems->supp_rates) {
+			supp_rates = ieee80211_sta_get_rates(local, elems,
+							     band);
+			if (sta) {
+				u32 prev_rates;
 
-			if (sta->sta.supp_rates[band] != prev_rates) {
+				prev_rates = sta->sta.supp_rates[band];
+				/* make sure mandatory rates are always added */
+				sta->sta.supp_rates[band] = supp_rates |
+					ieee80211_mandatory_rates(local, band);
+
+				if (sta->sta.supp_rates[band] != prev_rates) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
-				printk(KERN_DEBUG "%s: updated supp_rates set "
-				    "for %pM based on beacon/probe_response "
-				    "(0x%x -> 0x%x)\n",
-				    sdata->name, sta->sta.addr,
-				    prev_rates, sta->sta.supp_rates[band]);
+					printk(KERN_DEBUG
+						"%s: updated supp_rates set "
+						"for %pM based on beacon"
+						"/probe_resp (0x%x -> 0x%x)\n",
+						sdata->name, sta->sta.addr,
+						prev_rates,
+						sta->sta.supp_rates[band]);
 #endif
-				rate_control_rate_init(sta);
-			}
-			rcu_read_unlock();
-		} else {
-			rcu_read_unlock();
-			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
-					       supp_rates, GFP_KERNEL);
+					rate_control_rate_init(sta);
+				}
+			} else
+				sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
+						mgmt->sa, supp_rates,
+						GFP_ATOMIC);
 		}
+
+		if (sta && elems->wmm_info)
+			set_sta_flags(sta, WLAN_STA_WME);
+
+		rcu_read_unlock();
 	}
 
 	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, elems,

