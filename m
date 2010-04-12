Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:3498 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752499Ab0DLHhG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 03:37:06 -0400
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0289977822
	for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 16:37:04 +0900 (JST)
Subject: [PATCH 2/2] mac80211: Initialize IBSS basic rates according to band
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 12 Apr 2010 16:37:03 +0900
Message-ID: <20100412073703.28078.90501.stgit@tt-desk>
In-Reply-To: <20100412073658.28078.32155.stgit@tt-desk>
References: <20100412073658.28078.32155.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we create an IBSS we are can define the basic rates according to the band
in use. Previously only the B mode rates (1 and 2Mbps) were used
unconditionally, which resulted in low thruput when using RTS/CTS.

Also we should save the IBSS basic rates configuration when we join an IBSS.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 net/mac80211/ibss.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 01974c2..05846ab 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -77,6 +77,10 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	u32 bss_change;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+	printk(KERN_DEBUG "JOIN IBSS basic_rates %x\n", basic_rates);
+#endif
+
 	/* Reset own TSF to allow time synchronization work. */
 	drv_reset_tsf(local);
 
@@ -165,6 +169,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	rcu_assign_pointer(ifibss->presp, skb);
 
 	sdata->vif.bss_conf.beacon_int = beacon_int;
+	sdata->vif.bss_conf.basic_rates = basic_rates;
 	bss_change = BSS_CHANGED_BEACON_INT;
 	bss_change |= ieee80211_reset_erp_info(sdata);
 	bss_change |= BSS_CHANGED_BSSID;
@@ -518,7 +523,8 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 		sdata->drop_unencrypted = 0;
 
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
-				  ifibss->channel, 3, /* first two are basic */
+				  ifibss->channel,
+				  ieee80211_mandatory_rates(local, sband->band),
 				  capability, 0);
 }
 

