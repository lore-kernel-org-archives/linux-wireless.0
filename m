Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:56111 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbYCaPFJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 11:05:09 -0400
Message-ID: <47F0FD9F.6020709@work.ksp.sk> (sfid-20080331_160524_598389_F98B96E1)
Date: Mon, 31 Mar 2008 17:05:03 +0200
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>
Subject: [PATCH 1/2] mac80211: correct use_short_preamble handling
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ERP IE bit for preamble mode is 0 for short and 1 for long, not the other
way around. This fixes the value reported to the driver via
bss_conf->use_short_preamble field.

Signed-off-by: Vladimir Koutny <vlado@ksp.sk>

---
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index f9cf2f1..6fb179a 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -360,7 +360,7 @@ static u32 ieee80211_handle_erp_ie(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_bss_conf *bss_conf = &sdata->bss_conf;
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	bool use_protection = (erp_value & WLAN_ERP_USE_PROTECTION) != 0;
-	bool preamble_mode = (erp_value & WLAN_ERP_BARKER_PREAMBLE) != 0;
+	bool use_short_preamble = (erp_value & WLAN_ERP_BARKER_PREAMBLE) == 0;
 	DECLARE_MAC_BUF(mac);
 	u32 changed = 0;

@@ -376,16 +376,15 @@ static u32 ieee80211_handle_erp_ie(struct ieee80211_sub_if_data *sdata,
 		changed |= BSS_CHANGED_ERP_CTS_PROT;
 	}

-	if (preamble_mode != bss_conf->use_short_preamble) {
+	if (use_short_preamble != bss_conf->use_short_preamble) {
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "%s: switched to %s barker preamble"
 			       " (BSSID=%s)\n",
 			       sdata->dev->name,
-			       (preamble_mode == WLAN_ERP_PREAMBLE_SHORT) ?
-					"short" : "long",
+			       use_short_preamble ? "short" : "long",
 			       print_mac(mac, ifsta->bssid));
 		}
-		bss_conf->use_short_preamble = preamble_mode;
+		bss_conf->use_short_preamble = use_short_preamble;
 		changed |= BSS_CHANGED_ERP_PREAMBLE;
 	}

