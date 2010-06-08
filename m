Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:25128 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab0FHMfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jun 2010 08:35:04 -0400
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [RFC 3/3] mac80211: Store basic rates for bss when joining ibss network
Date: Tue,  8 Jun 2010 15:34:19 +0300
Message-Id: <1276000459-1121-4-git-send-email-ext-teemu.3.paasikivi@nokia.com>
In-Reply-To: <1276000459-1121-3-git-send-email-ext-teemu.3.paasikivi@nokia.com>
References: <1276000459-1121-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
 <1276000459-1121-2-git-send-email-ext-teemu.3.paasikivi@nokia.com>
 <1276000459-1121-3-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When joinig a ibss network, basic rates for bss were not stored. When
network was self created, leaving and (re)joining same network has
caused basic rates to be left unset. With this patch stored values are
used.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 net/mac80211/ibss.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index d984ab2..72407f0 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -77,6 +77,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_bss *bss;
 	u32 bss_change;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
+	struct ieee80211_bss *ibss;
 
 	/* Reset own TSF to allow time synchronization work. */
 	drv_reset_tsf(local);
@@ -191,6 +192,19 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	bss = cfg80211_inform_bss_frame(local->hw.wiphy, local->hw.conf.channel,
 					mgmt, skb->len, 0, GFP_KERNEL);
+
+	ibss = (struct ieee80211_bss *)(bss->priv);
+
+	for (i = 0; i < sband->n_bitrates; i++) {
+		u8 basic = 0x00;
+		if (basic_rates & BIT(i))
+			basic = 0x80;
+
+		ibss->supp_rates[i] = supp_rates[i] | basic;
+	}
+
+	ibss->supp_rates_len = i;
+
 	cfg80211_put_bss(bss);
 	cfg80211_ibss_joined(sdata->dev, ifibss->bssid, GFP_KERNEL);
 }
-- 
1.5.6.3

