Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A936417D8D
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784138658; cv=none; b=WfpJOJDVsC4C3fgK9SFJh/BeG4uxUjLhfj0t6kHVDbN6OmVymJGAgNlYAXnUPtU3fDUXi4fiI8xiAPmJjiKpAUu3ebRqLzyawBv1KjhXS2aNgzSYr37UuQ4QWhlUHm+3+UWXzijdejenuPS8HCsmzMzn+DfY1UxERpUPSr91rXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784138658; c=relaxed/simple;
	bh=+EZlFZyFl/daIsmTZpoC/+oy5tZJD7hYQNjLKu8X3b0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FX4HeIG2Spf6j1a+Rih8Wp9MI4GlfjKMnypPBpikEQ3SobBZ8nz78nS5NXqpVuu0ehJCyTnTStU7xT09PcCn0effEhvDKqWR4pII5P/nmRz0m1noV/M2fW6qkMsD5W89dcFr9RmGjQGb36Mcd6ukAKjzcJgdNvyVcACFGGI7iGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xn60CPGn; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xn60CPGn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784138642; x=1815674642;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+EZlFZyFl/daIsmTZpoC/+oy5tZJD7hYQNjLKu8X3b0=;
  b=Xn60CPGn2jR7JSnRvPtHZsa1kFotESVOf6pWFRJQQJCBgNtgkR6HV8HV
   4pInrs3hfTEibGd4S4TWyf7yNMxFT9z9OwCh3i2hel/dQNwwRdcC8Q51D
   zxjOKFmn+icAaaS1K7iMKvLb4p2Y3pYKzq8yej0wjvwi5y05ZtfKx0gZ2
   WMg0dLplMh5Qpn3gJ5FH6tP0cK6e81ygkIcHbD6WN6dePEaQ2/CbfRvwl
   GMd9BUCBg5G9X3zpONhLm1m5FMaUeY8HCn1NxLbUdBcA3iGJjtWy9KVeo
   gUe68y945TxiGaUt9E/yQkItQgUKGIGfoOHrMYpbIsbpSOLUHhre5gE75
   A==;
X-CSE-ConnectionGUID: HCFP7W4nQPSART1f/uwCUQ==
X-CSE-MsgGUID: fmU+P4iySiSDsyN0k9MZtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="84642333"
X-IronPort-AV: E=Sophos;i="6.25,165,1779174000"; 
   d="scan'208";a="84642333"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:03:56 -0700
X-CSE-ConnectionGUID: fqIEDI0CSDGgzEeOjmKS+w==
X-CSE-MsgGUID: br2GcIeeQ/ybty8mZG2IeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,165,1779174000"; 
   d="scan'208";a="279524125"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:03:54 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: always send regulatory connectivity element
Date: Wed, 15 Jul 2026 21:03:33 +0300
Message-Id: <20260715210322.02a4f3fced21.I94bbd08ac38001e11d5143a8b3f54dcea8ae8e15@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The spec says to include it if the STA is "capable of operating
as STA 6G", which is a bit unclear because this is defined at a
STA level and not at the MLD level or so, but WFA requires this
to be included. Either way, the element is completely advisory
and intended mostly for debugging (and perhaps a bit steering),
so just include it in association request all the time if 6 GHz
is supported.

To determine what exactly to include, check all the channels
that aren't disabled. That way, it ends up being a lowest
common denominator, which is most useful for steering etc.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/ieee80211_i.h |  4 ++--
 net/mac80211/mlme.c        | 13 ++++++-------
 net/mac80211/util.c        | 24 +++++++++++++++++++++---
 3 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d585820245dd..11f449e8ff00 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2771,8 +2771,8 @@ int ieee80211_put_eht_cap(struct sk_buff *skb,
 int ieee80211_put_uhr_cap(struct sk_buff *skb,
 			  struct ieee80211_sub_if_data *sdata,
 			  const struct ieee80211_supported_band *sband);
-int ieee80211_put_reg_conn(struct sk_buff *skb,
-			   enum ieee80211_channel_flags flags);
+void ieee80211_put_reg_conn(struct ieee80211_sub_if_data *sdata,
+			    struct sk_buff *skb);
 
 /* channel management */
 bool ieee80211_chandef_ht_oper(const struct ieee80211_ht_operation *ht_oper,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9e92337bb6f9..1afdb610dff2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2307,13 +2307,14 @@ ieee80211_add_link_elems(struct ieee80211_sub_if_data *sdata,
 	offset = ieee80211_add_before_reg_conn(skb, extra_elems,
 					       extra_elems_len, offset);
 
-	if (sband->band == NL80211_BAND_6GHZ) {
+	/* only add this on the assoc link, not in per-STA profiles */
+	if (link) {
 		/*
 		 * as per Section E.2.7 of IEEE 802.11 REVme D7.0, non-AP STA
 		 * capable of operating on the 6 GHz band shall transmit
 		 * regulatory connectivity element.
 		 */
-		ieee80211_put_reg_conn(skb, chan->flags);
+		ieee80211_put_reg_conn(sdata, skb);
 	}
 
 	/*
@@ -2564,11 +2565,8 @@ ieee80211_link_common_elems_size(struct ieee80211_sub_if_data *sdata,
 		sizeof(struct ieee80211_he_mcs_nss_supp) +
 		IEEE80211_HE_PPE_THRES_MAX_LEN;
 
-	if (sband->band == NL80211_BAND_6GHZ) {
+	if (sband->band == NL80211_BAND_6GHZ)
 		size += 2 + 1 + sizeof(struct ieee80211_he_6ghz_capa);
-		/* reg connection */
-		size += 4;
-	}
 
 	size += 2 + 1 + sizeof(struct ieee80211_eht_cap_elem) +
 		sizeof(struct ieee80211_eht_mcs_nss_supp) +
@@ -2615,7 +2613,8 @@ static int ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	       2 + assoc_data->ssid_len + /* SSID */
 	       assoc_data->ie_len + /* extra IEs */
 	       (assoc_data->fils_kek_len ? 16 /* AES-SIV */ : 0) +
-	       9; /* WMM */
+	       9 /* WMM */ +
+	       4 /* regulatory connectivity, if 6 GHz is supported */;
 
 	for (link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS; link_id++) {
 		struct cfg80211_bss *cbss = assoc_data->link[link_id].bss;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index f6d4ae4127c8..34f500deb2c8 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2703,12 +2703,31 @@ int ieee80211_put_he_cap(struct sk_buff *skb,
 	return 0;
 }
 
-int ieee80211_put_reg_conn(struct sk_buff *skb,
-			   enum ieee80211_channel_flags flags)
+void ieee80211_put_reg_conn(struct ieee80211_sub_if_data *sdata,
+			    struct sk_buff *skb)
 {
+	struct ieee80211_local *local = sdata->local;
 	u8 reg_conn = IEEE80211_REG_CONN_LPI_VALID |
 		      IEEE80211_REG_CONN_LPI_VALUE |
 		      IEEE80211_REG_CONN_SP_VALID;
+	struct ieee80211_supported_band *sband;
+	bool available_channels = false;
+	u32 flags = 0;
+	int i;
+
+	sband = local->hw.wiphy->bands[NL80211_BAND_6GHZ];
+	if (!sband)
+		return;
+
+	for (i = 0; i < sband->n_channels; i++) {
+		if (sband->channels[i].flags & IEEE80211_CHAN_DISABLED)
+			continue;
+		flags |= sband->channels[i].flags;
+		available_channels = true;
+	}
+
+	if (!available_channels)
+		return;
 
 	if (!(flags & IEEE80211_CHAN_NO_6GHZ_AFC_CLIENT))
 		reg_conn |= IEEE80211_REG_CONN_SP_VALUE;
@@ -2717,7 +2736,6 @@ int ieee80211_put_reg_conn(struct sk_buff *skb,
 	skb_put_u8(skb, 1 + sizeof(reg_conn));
 	skb_put_u8(skb, WLAN_EID_EXT_NON_AP_STA_REG_CON);
 	skb_put_u8(skb, reg_conn);
-	return 0;
 }
 
 int ieee80211_put_he_6ghz_cap(struct sk_buff *skb,
-- 
2.34.1

