Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55100 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab1JNWOz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 18:14:55 -0400
Received: by bkbzt19 with SMTP id zt19so484438bkb.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2011 15:14:53 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Jouni Malinen <j@w1.fi>
Subject: [PATCH v2] mac80211: handle HT PHY BSS membership selector value correctly
Date: Sat, 15 Oct 2011 00:14:49 +0200
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
References: <201110132108.50019.chunkeey@googlemail.com> <201110140942.37085.chunkeey@googlemail.com> <201110141012.21010.chunkeey@googlemail.com>
In-Reply-To: <201110141012.21010.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201110150014.50136.chunkeey@googlemail.com> (sfid-20111015_001459_536948_4D165E7B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

802.11n-2009 extends the supported rates element with a
magic value which can be used to prevent legacy stations
from joining the BSS.

However, this magic value is not a rate like the others
and the magic can simply be ignored/skipped at this late
stage.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>---
---
v2:
	Jouni's comment... Although I'm still not sure what is
	the difference between the membership and basic
	rate flag at this point.
---
 include/linux/ieee80211.h |    3 ++
 net/mac80211/mlme.c       |   75 +++++++++++++++++++++++++--------------------
 2 files changed, 45 insertions(+), 33 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 48363c3..9789aed 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -770,6 +770,9 @@ struct ieee80211_mgmt {
 	} u;
 } __attribute__ ((packed));
 
+/* Supported Rates value encodings in 802.11n-2009 7.3.2.2 */
+#define BSS_MEMBERSHIP_SELECTOR_HT_PHY	127
+
 /* mgmt header + 1 byte category code */
 #define IEEE80211_MIN_ACTION_SIZE offsetof(struct ieee80211_mgmt, u.action.u)
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0e5d8da..c0e54c5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1463,6 +1463,42 @@ ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
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
+		bool is_basic = !!(supp_rates[i] & 0x80);
+
+		if (rate > 110)
+			*have_higher_than_11mbit = true;
+
+		/*
+		 * BSS_MEMBERSHIP_SELECTOR_HT_PHY is defined in 802.11n-2009
+		 * 7.3.2.2 as a magic value instead of a rate. Hence, skip it.
+		 *
+		 * Note: Even through the membership selector and the basic
+		 *	 rate flag share the same bit, they are not exactly
+		 *	 the same.
+		 */
+		if (!!(supp_rates[i] & 0x80) &&
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
@@ -1479,7 +1515,7 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 	struct ieee802_11_elems elems;
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 	u32 changed = 0;
-	int i, j, err;
+	int err;
 	bool have_higher_than_11mbit = false;
 	u16 ap_ht_cap_flags;
 
@@ -1525,39 +1561,12 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
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
1.7.6.3
