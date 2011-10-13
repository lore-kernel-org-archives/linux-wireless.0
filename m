Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65205 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1JMTJE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 15:09:04 -0400
Received: by bkbzt4 with SMTP id zt4so1844155bkb.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Oct 2011 12:09:02 -0700 (PDT)
Subject: [PATCH] mac80211: handle HT PHY BSS membership selector value correctly
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Thu, 13 Oct 2011 21:08:49 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201110132108.50019.chunkeey@googlemail.com> (sfid-20111013_210908_209655_E2C31CD4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

802.11n-2009 extends the supported rates element with a
magic value which can be used to prevent legacy stations
from joining the BSS.

However, this magic value is not a rate like the others
and the magic can simply be ignored/skipped at this late
stage.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
pending... still testing.
---
 include/linux/ieee80211.h |    4 ++
 net/mac80211/mlme.c       |   71 ++++++++++++++++++++++++--------------------
 2 files changed, 42 insertions(+), 33 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 48363c3..7d2c72d 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -770,6 +770,10 @@ struct ieee80211_mgmt {
 	} u;
 } __attribute__ ((packed));
 
+/* Supported Rates flags and value encodings in 802.11n-2009 7.3.2.2 */
+#define BSS_MEMBERSHIP_SELECTOR		BIT(7)
+#define BSS_MEMBERSHIP_SELECTOR_HT_PHY	127
+
 /* mgmt header + 1 byte category code */
 #define IEEE80211_MIN_ACTION_SIZE offsetof(struct ieee80211_mgmt, u.action.u)
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0e5d8da..5619fd5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1463,6 +1463,38 @@ ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 	return RX_MGMT_CFG80211_DISASSOC;
 }
 
+static void ieee80211_get_rates(struct ieee80211_supported_band *sband,
+				u8 *supp_rates, unsigned int supp_rates_len,
+				u32 *rates, u32 *basic_rates,
+				bool *have_higher_than_11mbit)
+{
+	int i, j;
+
+	for (i = 0; i < supp_rates_len; i++) {
+		int rate = (supp_rates[i] & 0x7f) * 5;
+		bool is_basic = !!(supp_rates[i] & BSS_MEMBERSHIP_SELECTOR);
+
+		if (rate > 110)
+			*have_higher_than_11mbit = true;
+
+		/*
+		 * BSS_MEMBERSHIP_SELECTOR_HT_PHY is defined in 802.11n-2009
+		 * 7.3.2.2 as a magic value instead of a rate. Hence, skip it.
+		 */
+		if (is_basic &&
+		    (supp_rates[i] & 0x7f) == BSS_MEMBERSHIP_SELECTOR_HT_PHY)
+			continue;
+
+		for (j = 0; j < sband->n_bitrates; j++) {
+			if (sband->bitrates[j].bitrate == rate) {
+				*rates |= BIT(j);
+				if (is_basic)
+					*basic_rates |= BIT(j);
+				break;
+			}
+		}
+	}
+}
 
 static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 				    struct ieee80211_mgmt *mgmt, size_t len)
@@ -1479,7 +1511,7 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 	struct ieee802_11_elems elems;
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 	u32 changed = 0;
-	int i, j, err;
+	int err;
 	bool have_higher_than_11mbit = false;
 	u16 ap_ht_cap_flags;
 
@@ -1525,39 +1557,12 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 	basic_rates = 0;
 	sband = local->hw.wiphy->bands[wk->chan->band];
 
-	for (i = 0; i < elems.supp_rates_len; i++) {
-		int rate = (elems.supp_rates[i] & 0x7f) * 5;
-		bool is_basic = !!(elems.supp_rates[i] & 0x80);
-
-		if (rate > 110)
-			have_higher_than_11mbit = true;
-
-		for (j = 0; j < sband->n_bitrates; j++) {
-			if (sband->bitrates[j].bitrate == rate) {
-				rates |= BIT(j);
-				if (is_basic)
-					basic_rates |= BIT(j);
-				break;
-			}
-		}
-	}
-
-	for (i = 0; i < elems.ext_supp_rates_len; i++) {
-		int rate = (elems.ext_supp_rates[i] & 0x7f) * 5;
-		bool is_basic = !!(elems.ext_supp_rates[i] & 0x80);
+	ieee80211_get_rates(sband, elems.supp_rates, elems.supp_rates_len,
+			    &rates, &basic_rates, &have_higher_than_11mbit);
 
-		if (rate > 110)
-			have_higher_than_11mbit = true;
-
-		for (j = 0; j < sband->n_bitrates; j++) {
-			if (sband->bitrates[j].bitrate == rate) {
-				rates |= BIT(j);
-				if (is_basic)
-					basic_rates |= BIT(j);
-				break;
-			}
-		}
-	}
+	ieee80211_get_rates(sband, elems.ext_supp_rates,
+			    elems.ext_supp_rates_len, &rates, &basic_rates,
+			    &have_higher_than_11mbit);
 
 	sta->sta.supp_rates[wk->chan->band] = rates;
 	sdata->vif.bss_conf.basic_rates = basic_rates;
-- 
1.7.7

