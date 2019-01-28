Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0778FC282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 10:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7BF52148E
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 10:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfA1Ky5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 05:54:57 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:35340 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbfA1Ky5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 05:54:57 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1go4Z5-0007bD-DX; Mon, 28 Jan 2019 11:54:55 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>
Subject: [PATCH v7 02/11] mac80211: move the bss update from elements to an helper
Date:   Mon, 28 Jan 2019 11:54:37 +0100
Message-Id: <20190128105446.17256-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190128105446.17256-1-johannes@sipsolutions.net>
References: <20190128105446.17256-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

This will allow iterating over multiple BSSs inside
cfg80211_bss, in case of multiple BSSID.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/scan.c | 150 +++++++++++++++++++++++---------------------
 1 file changed, 80 insertions(+), 70 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index b58f75da9c84..20211cbc63f4 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -58,6 +58,85 @@ static bool is_uapsd_supported(struct ieee802_11_elems *elems)
 	return qos_info & IEEE80211_WMM_IE_AP_QOSINFO_UAPSD;
 }
 
+static void
+ieee80211_update_bss_from_elems(struct ieee80211_local *local,
+				struct ieee80211_bss *bss,
+				struct ieee802_11_elems *elems,
+				struct ieee80211_rx_status *rx_status,
+				bool beacon)
+{
+	int clen, srlen;
+
+	if (beacon)
+		bss->device_ts_beacon = rx_status->device_timestamp;
+	else
+		bss->device_ts_presp = rx_status->device_timestamp;
+
+	if (elems->parse_error) {
+		if (beacon)
+			bss->corrupt_data |= IEEE80211_BSS_CORRUPT_BEACON;
+		else
+			bss->corrupt_data |= IEEE80211_BSS_CORRUPT_PROBE_RESP;
+	} else {
+		if (beacon)
+			bss->corrupt_data &= ~IEEE80211_BSS_CORRUPT_BEACON;
+		else
+			bss->corrupt_data &= ~IEEE80211_BSS_CORRUPT_PROBE_RESP;
+	}
+
+	/* save the ERP value so that it is available at association time */
+	if (elems->erp_info && (!elems->parse_error ||
+				!(bss->valid_data & IEEE80211_BSS_VALID_ERP))) {
+		bss->erp_value = elems->erp_info[0];
+		bss->has_erp_value = true;
+		if (!elems->parse_error)
+			bss->valid_data |= IEEE80211_BSS_VALID_ERP;
+	}
+
+	/* replace old supported rates if we get new values */
+	if (!elems->parse_error ||
+	    !(bss->valid_data & IEEE80211_BSS_VALID_RATES)) {
+		srlen = 0;
+		if (elems->supp_rates) {
+			clen = IEEE80211_MAX_SUPP_RATES;
+			if (clen > elems->supp_rates_len)
+				clen = elems->supp_rates_len;
+			memcpy(bss->supp_rates, elems->supp_rates, clen);
+			srlen += clen;
+		}
+		if (elems->ext_supp_rates) {
+			clen = IEEE80211_MAX_SUPP_RATES - srlen;
+			if (clen > elems->ext_supp_rates_len)
+				clen = elems->ext_supp_rates_len;
+			memcpy(bss->supp_rates + srlen, elems->ext_supp_rates,
+			       clen);
+			srlen += clen;
+		}
+		if (srlen) {
+			bss->supp_rates_len = srlen;
+			if (!elems->parse_error)
+				bss->valid_data |= IEEE80211_BSS_VALID_RATES;
+		}
+	}
+
+	if (!elems->parse_error ||
+	    !(bss->valid_data & IEEE80211_BSS_VALID_WMM)) {
+		bss->wmm_used = elems->wmm_param || elems->wmm_info;
+		bss->uapsd_supported = is_uapsd_supported(elems);
+		if (!elems->parse_error)
+			bss->valid_data |= IEEE80211_BSS_VALID_WMM;
+	}
+
+	if (beacon) {
+		struct ieee80211_supported_band *sband =
+			local->hw.wiphy->bands[rx_status->band];
+		if (!(rx_status->encoding == RX_ENC_HT) &&
+		    !(rx_status->encoding == RX_ENC_VHT))
+			bss->beacon_rate =
+				&sband->bitrates[rx_status->rate_idx];
+	}
+}
+
 struct ieee80211_bss *
 ieee80211_bss_info_update(struct ieee80211_local *local,
 			  struct ieee80211_rx_status *rx_status,
@@ -67,7 +146,6 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	bool beacon = ieee80211_is_beacon(mgmt->frame_control);
 	struct cfg80211_bss *cbss;
 	struct ieee80211_bss *bss;
-	int clen, srlen;
 	struct cfg80211_inform_bss bss_meta = {
 		.boottime_ns = rx_status->boottime_ns,
 	};
@@ -132,75 +210,7 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 		rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
 	bss = (void *)cbss->priv;
-
-	if (beacon)
-		bss->device_ts_beacon = rx_status->device_timestamp;
-	else
-		bss->device_ts_presp = rx_status->device_timestamp;
-
-	if (elems.parse_error) {
-		if (beacon)
-			bss->corrupt_data |= IEEE80211_BSS_CORRUPT_BEACON;
-		else
-			bss->corrupt_data |= IEEE80211_BSS_CORRUPT_PROBE_RESP;
-	} else {
-		if (beacon)
-			bss->corrupt_data &= ~IEEE80211_BSS_CORRUPT_BEACON;
-		else
-			bss->corrupt_data &= ~IEEE80211_BSS_CORRUPT_PROBE_RESP;
-	}
-
-	/* save the ERP value so that it is available at association time */
-	if (elems.erp_info && (!elems.parse_error ||
-			       !(bss->valid_data & IEEE80211_BSS_VALID_ERP))) {
-		bss->erp_value = elems.erp_info[0];
-		bss->has_erp_value = true;
-		if (!elems.parse_error)
-			bss->valid_data |= IEEE80211_BSS_VALID_ERP;
-	}
-
-	/* replace old supported rates if we get new values */
-	if (!elems.parse_error ||
-	    !(bss->valid_data & IEEE80211_BSS_VALID_RATES)) {
-		srlen = 0;
-		if (elems.supp_rates) {
-			clen = IEEE80211_MAX_SUPP_RATES;
-			if (clen > elems.supp_rates_len)
-				clen = elems.supp_rates_len;
-			memcpy(bss->supp_rates, elems.supp_rates, clen);
-			srlen += clen;
-		}
-		if (elems.ext_supp_rates) {
-			clen = IEEE80211_MAX_SUPP_RATES - srlen;
-			if (clen > elems.ext_supp_rates_len)
-				clen = elems.ext_supp_rates_len;
-			memcpy(bss->supp_rates + srlen, elems.ext_supp_rates,
-			       clen);
-			srlen += clen;
-		}
-		if (srlen) {
-			bss->supp_rates_len = srlen;
-			if (!elems.parse_error)
-				bss->valid_data |= IEEE80211_BSS_VALID_RATES;
-		}
-	}
-
-	if (!elems.parse_error ||
-	    !(bss->valid_data & IEEE80211_BSS_VALID_WMM)) {
-		bss->wmm_used = elems.wmm_param || elems.wmm_info;
-		bss->uapsd_supported = is_uapsd_supported(&elems);
-		if (!elems.parse_error)
-			bss->valid_data |= IEEE80211_BSS_VALID_WMM;
-	}
-
-	if (beacon) {
-		struct ieee80211_supported_band *sband =
-			local->hw.wiphy->bands[rx_status->band];
-		if (!(rx_status->encoding == RX_ENC_HT) &&
-		    !(rx_status->encoding == RX_ENC_VHT))
-			bss->beacon_rate =
-				&sband->bitrates[rx_status->rate_idx];
-	}
+	ieee80211_update_bss_from_elems(local, bss, &elems, rx_status, beacon);
 
 	return bss;
 }
-- 
2.17.2

