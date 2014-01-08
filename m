Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:58147 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaAHHqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 02:46:17 -0500
Received: by mail-ea0-f176.google.com with SMTP id h14so623635eaj.7
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jan 2014 23:46:16 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v3] nl80211: add Guard Interval support for set_bitrate_mask
Date: Wed,  8 Jan 2014 08:46:02 +0100
Message-Id: <1389167162-3681-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140108_084620_623630_13849C9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow to force SGI, LGI.
Mainly for test purpose.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
*V3 - check GI value

 include/net/cfg80211.h       |    1 +
 include/uapi/linux/nl80211.h |    8 ++++++++
 net/wireless/nl80211.c       |    7 +++++++
 3 files changed, 16 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 80a1021..514c612 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1768,6 +1768,7 @@ struct cfg80211_bitrate_mask {
 		u32 legacy;
 		u8 ht_mcs[IEEE80211_HT_MCS_MASK_LEN];
 		u16 vht_mcs[NL80211_VHT_NSS_MAX];
+		enum nl80211_txrate_gi gi;
 	} control[IEEE80211_NUM_BANDS];
 };
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e130790..a7a8aa2 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3114,6 +3114,7 @@ enum nl80211_key_attributes {
  *	in an array of MCS numbers.
  * @NL80211_TXRATE_VHT: VHT rates allowed for TX rate selection,
  *	see &struct nl80211_txrate_vht
+ * @NL80211_TXRATE_GI: configure GI, see &enum nl80211_txrate_gi
  * @__NL80211_TXRATE_AFTER_LAST: internal
  * @NL80211_TXRATE_MAX: highest TX rate attribute
  */
@@ -3122,6 +3123,7 @@ enum nl80211_tx_rate_attributes {
 	NL80211_TXRATE_LEGACY,
 	NL80211_TXRATE_HT,
 	NL80211_TXRATE_VHT,
+	NL80211_TXRATE_GI,
 
 	/* keep last */
 	__NL80211_TXRATE_AFTER_LAST,
@@ -3139,6 +3141,12 @@ struct nl80211_txrate_vht {
 	__u16 mcs[NL80211_VHT_NSS_MAX];
 };
 
+enum nl80211_txrate_gi {
+	NL80211_TXRATE_DEFAULT_GI,
+	NL80211_TXRATE_FORCE_SGI,
+	NL80211_TXRATE_FORCE_LGI,
+};
+
 /**
  * enum nl80211_band - Frequency band
  * @NL80211_BAND_2GHZ: 2.4 GHz ISM band
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 04681a4..358deee 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7394,6 +7394,7 @@ static const struct nla_policy nl80211_txattr_policy[NL80211_TXRATE_MAX + 1] = {
 	[NL80211_TXRATE_HT] = { .type = NLA_BINARY,
 				.len = NL80211_MAX_SUPP_HT_RATES },
 	[NL80211_TXRATE_VHT] = { .len = sizeof(struct nl80211_txrate_vht)},
+	[NL80211_TXRATE_GI] = { .type = NLA_U8 },
 };
 
 static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
@@ -7474,6 +7475,12 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 					mask.control[band].vht_mcs))
 				return -EINVAL;
 		}
+		if (tb[NL80211_TXRATE_GI]) {
+			mask.control[band].gi =
+				nla_get_u8(tb[NL80211_TXRATE_GI]);
+			if (mask.control[band].gi > NL80211_TXRATE_FORCE_LGI)
+				return -EINVAL;
+		}
 
 		if (mask.control[band].legacy == 0) {
 			/* don't allow empty legacy rates if HT or VHT
-- 
1.7.9.5

