Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:50383 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbYEHLeN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 07:34:13 -0400
From: Helmut Schaa <hschaa@suse.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH/RFC v2] mac80211: fix association with some APs
Date: Thu, 8 May 2008 13:34:07 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
References: <200805081030.57966.hschaa@suse.de>
In-Reply-To: <200805081030.57966.hschaa@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805081334.07599.hschaa@suse.de> (sfid-20080508_133313_994069_1A7288B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some APs refuse association if the supported rates contained in the
association request do not match its own supported rates. This patch
introduces a new function which builds the intersection between the AP's
supported rates and the client's supported rates to work around such
problems. The same approach is already used in ipw2200 for example.

Signed-off-by: Helmut Schaa <hschaa@suse.de>

---
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cb01995..91d96d9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -650,6 +650,26 @@ static void ieee80211_authenticate(struct net_device *dev,
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
 }
 
+static int ieee80211_compatible_rates(struct ieee80211_sta_bss *bss,
+				      struct ieee80211_supported_band *sband,
+				      u64 *rates)
+{
+	int i, j, count;
+	*rates = 0;
+	count = 0;
+	for (i = 0; i < bss->supp_rates_len; i++) {
+		int rate = (bss->supp_rates[i] & 0x7F) * 5;
+
+		for (j = 0; j < sband->n_bitrates; j++)
+			if (sband->bitrates[j].bitrate == rate) {
+				*rates |= BIT(j);
+				count++;
+				break;
+			}
+	}
+
+	return count;
+}
 
 static void ieee80211_send_assoc(struct net_device *dev,
 				 struct ieee80211_if_sta *ifsta)
@@ -658,11 +678,12 @@ static void ieee80211_send_assoc(struct net_device *dev,
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos, *ies;
-	int i, len;
+	int i, len, count, rates_len, supp_rates_len;
 	u16 capab;
 	struct ieee80211_sta_bss *bss;
 	int wmm = 0;
 	struct ieee80211_supported_band *sband;
+	u64 rates = 0;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
 			    sizeof(*mgmt) + 200 + ifsta->extra_ie_len +
@@ -724,24 +745,39 @@ static void ieee80211_send_assoc(struct net_device *dev,
 	*pos++ = ifsta->ssid_len;
 	memcpy(pos, ifsta->ssid, ifsta->ssid_len);
 
+	/* all supported rates should be added here but some APs
+	 * (e.g. D-Link DAP 1353 in b-only mode) don't like that
+	 * Therefore only add rates the AP supports */
+	rates_len = ieee80211_compatible_rates(bss, sband, &rates);
+	supp_rates_len = rates_len;
+	if (supp_rates_len > 8)
+		supp_rates_len = 8;
+
 	len = sband->n_bitrates;
-	if (len > 8)
-		len = 8;
-	pos = skb_put(skb, len + 2);
+	pos = skb_put(skb, supp_rates_len + 2);
 	*pos++ = WLAN_EID_SUPP_RATES;
-	*pos++ = len;
-	for (i = 0; i < len; i++) {
-		int rate = sband->bitrates[i].bitrate;
-		*pos++ = (u8) (rate / 5);
-	}
+	*pos++ = supp_rates_len;
 
-	if (sband->n_bitrates > len) {
-		pos = skb_put(skb, sband->n_bitrates - len + 2);
-		*pos++ = WLAN_EID_EXT_SUPP_RATES;
-		*pos++ = sband->n_bitrates - len;
-		for (i = len; i < sband->n_bitrates; i++) {
+	count = 0;
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if (BIT(i) & rates) {
 			int rate = sband->bitrates[i].bitrate;
 			*pos++ = (u8) (rate / 5);
+			if (++count == 8)
+				break;
+		}
+	}
+
+	if (count == 8) {
+		pos = skb_put(skb, rates_len - count + 2);
+		*pos++ = WLAN_EID_EXT_SUPP_RATES;
+		*pos++ = rates_len - count;
+
+		for (i++; i < sband->n_bitrates; i++) {
+			if (BIT(i) & rates) {
+				int rate = sband->bitrates[i].bitrate;
+				*pos++ = (u8) (rate / 5);
+			}
 		}
 	}
 
