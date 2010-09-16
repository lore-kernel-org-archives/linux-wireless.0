Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:38676 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750726Ab0IPIeQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 04:34:16 -0400
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0977836053
	for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 17:34:14 +0900 (JST)
Subject: [PATCH] mac80211: Add WME information element for IBSS
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 16 Sep 2010 17:34:31 +0900
Message-ID: <20100916083431.14175.90366.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable WME QoS in IBSS mode by adding a WME information element to beacons and
probe respones and by checking for it and marking stations as WME capable if it
is present.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 net/mac80211/ibss.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 1a3aae5..95fe43f 100644
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
@@ -294,9 +307,12 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			rcu_read_unlock();
 		} else {
 			rcu_read_unlock();
-			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
-					       supp_rates, GFP_KERNEL);
+
+			sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
+					mgmt->sa, supp_rates, GFP_KERNEL);
 		}
+		if (sta && elems->wmm_info)
+			set_sta_flags(sta, WLAN_STA_WME);
 	}
 
 	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, elems,

