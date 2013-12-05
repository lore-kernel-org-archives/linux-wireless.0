Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:62898 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab3LEJCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 04:02:30 -0500
Received: by mail-ea0-f171.google.com with SMTP id h10so11290983eak.30
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 01:02:29 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, j@w1.fi,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 2/3] nl80211/cfg80211: bitrate_mask, rename mcs to ht_mcs
Date: Thu,  5 Dec 2013 10:02:15 +0100
Message-Id: <1386234137-3531-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131205_100244_898663_9B965351)
In-Reply-To: <1386234137-3531-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1386234137-3531-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename NL80211_TXRATE_MCS into NL80211_TXRATE_HT.
Rename mcs to ht_mcs in cfg80211_bitrate_mask structure.
This is cleanup before we will introduce NL80211_TXRATE_VHT.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c   |    6 +++---
 drivers/net/wireless/mwifiex/cfg80211.c |    6 +++---
 include/net/cfg80211.h                  |    2 +-
 include/uapi/linux/nl80211.h            |    6 ++++--
 net/mac80211/cfg.c                      |    4 ++--
 net/wireless/nl80211.c                  |   18 +++++++++---------
 6 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 546d5da..4f16d79 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2754,9 +2754,9 @@ static int ath6kl_set_bitrate_mask64(struct wmi *wmi, u8 if_idx,
 				mask->control[band].legacy << 4;
 
 		/* copy mcs rate mask */
-		mcsrate = mask->control[band].mcs[1];
+		mcsrate = mask->control[band].ht_mcs[1];
 		mcsrate <<= 8;
-		mcsrate |= mask->control[band].mcs[0];
+		mcsrate |= mask->control[band].ht_mcs[0];
 		ratemask[band] |= mcsrate << 12;
 		ratemask[band] |= mcsrate << 28;
 	}
@@ -2806,7 +2806,7 @@ static int ath6kl_set_bitrate_mask32(struct wmi *wmi, u8 if_idx,
 				mask->control[band].legacy << 4;
 
 		/* copy mcs rate mask */
-		mcsrate = mask->control[band].mcs[0];
+		mcsrate = mask->control[band].ht_mcs[0];
 		ratemask[band] |= mcsrate << 12;
 		ratemask[band] |= mcsrate << 20;
 	}
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index fbad00a..27033ab 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1170,10 +1170,10 @@ static int mwifiex_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
 	else
 		bitmap_rates[1] = mask->control[band].legacy;
 
-	/* Fill MCS rates */
-	bitmap_rates[2] = mask->control[band].mcs[0];
+	/* Fill HT MCS rates */
+	bitmap_rates[2] = mask->control[band].ht_mcs[0];
 	if (priv->adapter->hw_dev_mcs_support == HT_STREAM_2X2)
-		bitmap_rates[2] |= mask->control[band].mcs[1] << 8;
+		bitmap_rates[2] |= mask->control[band].ht_mcs[1] << 8;
 
 	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_TX_RATE_CFG,
 				     HostCmd_ACT_GEN_SET, 0, bitmap_rates);
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f07840e..626087b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1763,7 +1763,7 @@ enum wiphy_params_flags {
 struct cfg80211_bitrate_mask {
 	struct {
 		u32 legacy;
-		u8 mcs[IEEE80211_HT_MCS_MASK_LEN];
+		u8 ht_mcs[IEEE80211_HT_MCS_MASK_LEN];
 	} control[IEEE80211_NUM_BANDS];
 };
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f752e98..59d65e3 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3058,7 +3058,7 @@ enum nl80211_key_attributes {
  *	in an array of rates as defined in IEEE 802.11 7.3.2.2 (u8 values with
  *	1 = 500 kbps) but without the IE length restriction (at most
  *	%NL80211_MAX_SUPP_RATES in a single array).
- * @NL80211_TXRATE_MCS: HT (MCS) rates allowed for TX rate selection
+ * @NL80211_TXRATE_HT: HT (MCS) rates allowed for TX rate selection
  *	in an array of MCS numbers.
  * @__NL80211_TXRATE_AFTER_LAST: internal
  * @NL80211_TXRATE_MAX: highest TX rate attribute
@@ -3066,13 +3066,15 @@ enum nl80211_key_attributes {
 enum nl80211_tx_rate_attributes {
 	__NL80211_TXRATE_INVALID,
 	NL80211_TXRATE_LEGACY,
-	NL80211_TXRATE_MCS,
+	NL80211_TXRATE_HT,
 
 	/* keep last */
 	__NL80211_TXRATE_AFTER_LAST,
 	NL80211_TXRATE_MAX = __NL80211_TXRATE_AFTER_LAST - 1
 };
 
+#define NL80211_TXRATE_MCS NL80211_TXRATE_HT
+
 /**
  * enum nl80211_band - Frequency band
  * @NL80211_BAND_2GHZ: 2.4 GHz ISM band
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5232b01..57d25a0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2565,8 +2565,8 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 		int j;
 
 		sdata->rc_rateidx_mask[i] = mask->control[i].legacy;
-		memcpy(sdata->rc_rateidx_mcs_mask[i], mask->control[i].mcs,
-		       sizeof(mask->control[i].mcs));
+		memcpy(sdata->rc_rateidx_mcs_mask[i], mask->control[i].ht_mcs,
+		       sizeof(mask->control[i].ht_mcs));
 
 		sdata->rc_has_mcs_mask[i] = false;
 		if (!sband)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 072b60d..cc43374 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7296,8 +7296,8 @@ static bool ht_rateset_to_mask(struct ieee80211_supported_band *sband,
 static const struct nla_policy nl80211_txattr_policy[NL80211_TXRATE_MAX + 1] = {
 	[NL80211_TXRATE_LEGACY] = { .type = NLA_BINARY,
 				    .len = NL80211_MAX_SUPP_RATES },
-	[NL80211_TXRATE_MCS] = { .type = NLA_BINARY,
-				 .len = NL80211_MAX_SUPP_HT_RATES },
+	[NL80211_TXRATE_HT] = { .type = NLA_BINARY,
+				.len = NL80211_MAX_SUPP_HT_RATES },
 };
 
 static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
@@ -7323,9 +7323,9 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 			continue;
 
 		mask.control[i].legacy = (1 << sband->n_bitrates) - 1;
-		memcpy(mask.control[i].mcs,
+		memcpy(mask.control[i].ht_mcs,
 		       sband->ht_cap.mcs.rx_mask,
-		       sizeof(mask.control[i].mcs));
+		       sizeof(mask.control[i].ht_mcs));
 	}
 
 	/* Back to default settings */
@@ -7356,12 +7356,12 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 			    nla_len(tb[NL80211_TXRATE_LEGACY]))
 				return -EINVAL;
 		}
-		if (tb[NL80211_TXRATE_MCS]) {
+		if (tb[NL80211_TXRATE_HT]) {
 			if (!ht_rateset_to_mask(
 					sband,
-					nla_data(tb[NL80211_TXRATE_MCS]),
-					nla_len(tb[NL80211_TXRATE_MCS]),
-					mask.control[band].mcs))
+					nla_data(tb[NL80211_TXRATE_HT]),
+					nla_len(tb[NL80211_TXRATE_HT]),
+					mask.control[band].ht_mcs))
 				return -EINVAL;
 		}
 
@@ -7372,7 +7372,7 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 				return -EINVAL;
 
 			for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
-				if (mask.control[band].mcs[i])
+				if (mask.control[band].ht_mcs[i])
 					break;
 
 			/* legacy and mcs rates may not be both empty */
-- 
1.7.9.5

