Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D114A43F6
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 13:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860728; cv=none; b=UBsAIUcDuXaycFDSsriSkGkHw6vvwzVFzc3/osz2lM/6eYU/7czlXwNzkiRpamNQl6nKDdqVgJQ1/H5fVYCWV/BzMy68aW/z32jvhWX/zvv2bhuVU2+EMbLTDnuGG39MnKEDTblHN07EAsG6acHhuN3KKnJoEwZy776guGMXGCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860728; c=relaxed/simple;
	bh=RFGq7Vn8Cp0EaHYq5P78kio3dwY9PkCYI0c5fIfB/IY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jkfrJTvazWRFzVpUvW1ZubykmYUB8/aJHdG7MGE3eTT7jfO2wy13gjum+pazHdQbxtJnSPZ2dDQCnVdXpY95X4WrivSb7cw8NAeidAHoD3LIjXEMTzmrqipxAeImsC0HsWCi4K1JS8itEaT0uYyh78ft+O04EPlXfX57Awfh/jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eYIk+lS/; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eYIk+lS/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790860726; x=1822396726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RFGq7Vn8Cp0EaHYq5P78kio3dwY9PkCYI0c5fIfB/IY=;
  b=eYIk+lS/A+MANcVa8XpopMyvPrY8Gi12SBFjwgHOMZvEwgDAalu/OYGf
   bV1flTavKUqd1/By/2t8sLe8XmwExe5ShoE/6IqVhRcj+Wus+0bRItlsE
   tjXvVTcCItX7svoAHjxd1uL8fYv8FrEIDIXrjJAmDLX4GcDBOEZx4Wm9a
   Qr3iNJN8XVkH050asQPAglok7qQBlYXOl6WDiv11QlZW8jJ/8GQhc5AZG
   pGBsttT/0y4xgWROiv7io/r/+NLU32ONsqXKCdIyxPNyppKtlBzkttJh3
   +QHAiGOjup2IsYWvCfntGPwIoW2XHI7BDJIn+a0+/K37hW99F3MQmJSl4
   g==;
X-CSE-ConnectionGUID: L6q7jyP4RH20YXJhOaGgcA==
X-CSE-MsgGUID: +zOkN4gXT6mc8liFRtOXDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="95423635"
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="95423635"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:45 -0700
X-CSE-ConnectionGUID: PNegYXtVS1afZAEMRFGQlw==
X-CSE-MsgGUID: rNj9+ST5QyuFmA5KUo2bIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,134,1787036400"; 
   d="scan'208";a="305485551"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 06:18:45 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 10/15] wifi: iwlwifi: mld: report the guard interval for UHR
Date: Thu,  1 Oct 2026 16:20:23 +0300
Message-Id: <20261001161715.9f728be36075.Ic46d2234d03fdf3b098a8b25f607bd3559e6a2db@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
References: <20261001132028.3352787-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

We didn't report the guard interval for UHR to mac80211,
fix that by refactoring the EHT function and using it.
The LTF is reported only in radiotap (differently), so
the code for UHR doesn't need it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/rx.c | 70 ++++++++++++---------
 1 file changed, 41 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index c0203e74fff6..9ba68564bf98 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -1243,48 +1243,30 @@ static void iwl_mld_decode_eht_phy_data(struct iwl_mld_rx_phy_data *phy_data,
 		iwl_mld_decode_eht_non_tb(phy_data, rx_status, eht);
 }
 
-static void iwl_mld_rx_eht(struct iwl_mld *mld, struct sk_buff *skb,
-			   struct iwl_mld_rx_phy_data *phy_data)
+static u8 iwl_mld_decode_eht_uhr_gi_ltf(u32 rate_n_flags, u8 *gi)
 {
-	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
-	struct ieee80211_radiotap_eht *eht;
-	size_t eht_len = sizeof(*eht);
-	u32 rate_n_flags = phy_data->rate_n_flags;
 	u32 he_type = rate_n_flags & RATE_MCS_HE_TYPE_MSK;
-	/* EHT and HE have the same values for LTF */
-	u8 ltf = IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_UNKNOWN;
 
-	/* u32 for 1 user_info */
-	if (phy_data->with_data)
-		eht_len += sizeof(u32);
-
-	eht = iwl_mld_radiotap_put_tlv(skb, IEEE80211_RADIOTAP_EHT, eht_len);
+	*gi = NL80211_RATE_INFO_EHT_GI_0_8;
 
 	switch (u32_get_bits(rate_n_flags, RATE_MCS_HE_GI_LTF_MSK)) {
 	case 0:
 		if (he_type == RATE_MCS_HE_TYPE_TRIG) {
-			rx_status->eht.gi = NL80211_RATE_INFO_EHT_GI_1_6;
-			ltf = IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_1X;
-		} else {
-			rx_status->eht.gi = NL80211_RATE_INFO_EHT_GI_0_8;
-			ltf = IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_2X;
+			*gi = NL80211_RATE_INFO_EHT_GI_1_6;
+			return IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_1X;
 		}
-		break;
+		return IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_2X;
 	case 1:
-		rx_status->eht.gi = NL80211_RATE_INFO_EHT_GI_1_6;
-		ltf = IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_2X;
-		break;
+		*gi = NL80211_RATE_INFO_EHT_GI_1_6;
+		return IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_2X;
 	case 2:
-		ltf = IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_4X;
 		if (he_type == RATE_MCS_HE_TYPE_TRIG)
-			rx_status->eht.gi = NL80211_RATE_INFO_EHT_GI_3_2;
-		else
-			rx_status->eht.gi = NL80211_RATE_INFO_EHT_GI_0_8;
-		break;
+			*gi = NL80211_RATE_INFO_EHT_GI_3_2;
+		return IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_4X;
 	case 3:
 		if (he_type != RATE_MCS_HE_TYPE_TRIG) {
-			ltf = IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_4X;
-			rx_status->eht.gi = NL80211_RATE_INFO_EHT_GI_3_2;
+			*gi = NL80211_RATE_INFO_EHT_GI_3_2;
+			return IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_4X;
 		}
 		break;
 	default:
@@ -1292,7 +1274,29 @@ static void iwl_mld_rx_eht(struct iwl_mld *mld, struct sk_buff *skb,
 		break;
 	}
 
+	return IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_UNKNOWN;
+}
+
+static void iwl_mld_rx_eht(struct iwl_mld *mld, struct sk_buff *skb,
+			   struct iwl_mld_rx_phy_data *phy_data)
+{
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
+	struct ieee80211_radiotap_eht *eht;
+	size_t eht_len = sizeof(*eht);
+	u32 rate_n_flags = phy_data->rate_n_flags;
+	u8 gi, ltf;
+
+	/* u32 for 1 user_info */
+	if (phy_data->with_data)
+		eht_len += sizeof(u32);
+
+	eht = iwl_mld_radiotap_put_tlv(skb, IEEE80211_RADIOTAP_EHT, eht_len);
+
+	ltf = iwl_mld_decode_eht_uhr_gi_ltf(rate_n_flags, &gi);
+
 	if (ltf != IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_UNKNOWN) {
+		rx_status->eht.gi = gi;
+
 		eht->known |= cpu_to_le32(IEEE80211_RADIOTAP_EHT_KNOWN_GI);
 		eht->data[0] |= le32_encode_bits(ltf,
 						 IEEE80211_RADIOTAP_EHT_DATA0_LTF) |
@@ -1875,6 +1879,14 @@ static void iwl_mld_decode_uhr_phy_data(struct iwl_mld_rx_phy_data *phy_data,
 static void iwl_mld_rx_uhr(struct iwl_mld *mld, struct sk_buff *skb,
 			   struct iwl_mld_rx_phy_data *phy_data)
 {
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
+	u8 gi, ltf;
+
+	/* the LTF size is reported from the PHY data, only the GI is needed */
+	ltf = iwl_mld_decode_eht_uhr_gi_ltf(phy_data->rate_n_flags, &gi);
+	if (ltf != IEEE80211_RADIOTAP_HE_DATA5_LTF_SIZE_UNKNOWN)
+		rx_status->uhr.gi = gi;
+
 	if (likely(!phy_data->ntfy))
 		return;
 
-- 
2.34.1

