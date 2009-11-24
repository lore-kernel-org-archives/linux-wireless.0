Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:38260 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933481AbZKXRFb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 12:05:31 -0500
Subject: [PATCH v2 1/2] mac80211: supp_rates initialization and rate
 control notification
From: Adam Wozniak <awozniak@irobot.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Derek Smithies <derek@indranet.co.nz>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <4B0B2F67.3030605@irobot.com>
References: <4AF0D54D.4090303@irobot.com>
	 <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>
	 <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>
	 <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>
	 <1258097352.3899.75.camel@johannes.local>  <4AFDDF19.8060202@irobot.com>
	 <1258191039.6167.40.camel@johannes.local>  <4B018B26.2070008@irobot.com>
	 <1258392453.32159.28.camel@johannes.local> <4B0192A6.9050808@irobot.com>
	 <alpine.DEB.2.00.0911170938380.3829@kauri.acheron.indranet.co.nz>
	 <4B01D4A5.7060204@irobot.com>
	 <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz>
	 <4B01E298.3030602@irobot.com>
	 <alpine.DEB.2.00.0911171314470.3829@kauri.acheron.indranet.co.nz>
	 <1258443484.1375.8.camel@johannes.local> <4B02DFE3.9040602@irobot.com>
	 <4B0AEEE3.2050808@irobot.com> <1259018866.7094.189.camel@johannes.local>
	 <4B0B2F67.3030605@irobot.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 09:05:27 -0800
Message-ID: <1259082327.2573.18.camel@awozniak-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, not all code paths set supp_rates, and a rate change did not reinitialize the rate control layer.
This patch fixes those issues.  (Hopefully not whitespace damaged this time)

Signed-off-by: Adam Wozniak <awozniak@irobot.com>
---
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 10d1385..474f66d 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -246,9 +246,13 @@ static void ieee80211_rx_bss_info(struct
ieee80211_sub_if_data *sdata,
 	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
 		return;
 
+	supp_rates = ieee80211_sta_get_rates(local, elems, band);
+
+	/* make sure mandatory rates are always added */
+	supp_rates |= ieee80211_mandatory_rates(local, band);
+
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC && elems->supp_rates &&
 	    memcmp(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0) {
-		supp_rates = ieee80211_sta_get_rates(local, elems, band);
 
 		rcu_read_lock();
 
@@ -257,12 +261,10 @@ static void ieee80211_rx_bss_info(struct
ieee80211_sub_if_data *sdata,
 			u32 prev_rates;
 
 			prev_rates = sta->sta.supp_rates[band];
-			/* make sure mandatory rates are always added */
-			sta->sta.supp_rates[band] = supp_rates |
-				ieee80211_mandatory_rates(local, band);
+			sta->sta.supp_rates[band] = supp_rates;
 
+			if (sta->sta.supp_rates[band] != prev_rates) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
-			if (sta->sta.supp_rates[band] != prev_rates)
 				printk(KERN_DEBUG "%s: updated supp_rates set "
 				    "for %pM based on beacon info (0x%llx | "
 				    "0x%llx -> 0x%llx)\n",
@@ -272,6 +274,8 @@ static void ieee80211_rx_bss_info(struct
ieee80211_sub_if_data *sdata,
 				    (unsigned long long) supp_rates,
 				    (unsigned long long) sta->sta.supp_rates[band]);
 #endif
+				rate_control_rate_init(sta);
+			}
 		} else
 			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
 
@@ -415,6 +419,15 @@ struct sta_info *ieee80211_ibss_add_sta(struct
ieee80211_sub_if_data *sdata,
 	sta->sta.supp_rates[band] = supp_rates |
 			ieee80211_mandatory_rates(local, band);
 
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+	printk(KERN_DEBUG "%s: initialized supp_rates set "
+		"for %pM (0x%llx) (band %d)\n",
+		sdata->dev->name,
+		sta->sta.addr,
+		(unsigned long long) sta->sta.supp_rates[band],
+		band);
+#endif
+
 	rate_control_rate_init(sta);
 
 	if (sta_info_insert(sta))

