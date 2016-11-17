Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.smtp.broadcom.com ([192.19.211.62]:49980 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754703AbcKQRfh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 12:35:37 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2] cfg80211: get rid of name indirection trick for ieee80211_get_channel()
Date: Thu, 17 Nov 2016 12:48:53 +0000
Message-Id: <1479386933-17834-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161117_183542_772422_AABE932B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The comment on the name indirection suggested an issue but turned out
to be untrue. Digging in older kernel version showed issue with ipw2x00
but that is no longer true so get rid on the name indirection.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c        |  3 +--
 drivers/net/wireless/marvell/mwifiex/cfg80211.c |  2 +-
 include/net/cfg80211.h                          | 17 +++--------------
 net/wireless/util.c                             |  5 ++---
 4 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 0b4c156..01f3803 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2329,8 +2329,7 @@ bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		u32 phymode = __le32_to_cpu(resp->chan_change.phymode);
 		u32 freq = __le32_to_cpu(resp->chan_change.freq);
 
-		ar->tgt_oper_chan =
-			__ieee80211_get_channel(ar->hw->wiphy, freq);
+		ar->tgt_oper_chan = ieee80211_get_channel(ar->hw->wiphy, freq);
 		ath10k_dbg(ar, ATH10K_DBG_HTT,
 			   "htt chan change freq %u phymode %s\n",
 			   freq, ath10k_wmi_phymode_str(phymode));
diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 39ce76a..9efc3d9 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2072,7 +2072,7 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 	ie_len = ie_buf[1] + sizeof(struct ieee_types_header);
 
 	band = mwifiex_band_to_radio_type(priv->curr_bss_params.band);
-	chan = __ieee80211_get_channel(priv->wdev.wiphy,
+	chan = ieee80211_get_channel(priv->wdev.wiphy,
 			ieee80211_channel_to_frequency(bss_info.bss_chan,
 						       band));
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2019310..ef42749 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3955,26 +3955,15 @@ static inline void *wdev_priv(struct wireless_dev *wdev)
  */
 int ieee80211_frequency_to_channel(int freq);
 
-/*
- * Name indirection necessary because the ieee80211 code also has
- * a function named "ieee80211_get_channel", so if you include
- * cfg80211's header file you get cfg80211's version, if you try
- * to include both header files you'll (rightfully!) get a symbol
- * clash.
- */
-struct ieee80211_channel *__ieee80211_get_channel(struct wiphy *wiphy,
-						  int freq);
 /**
  * ieee80211_get_channel - get channel struct from wiphy for specified frequency
+ *
  * @wiphy: the struct wiphy to get the channel for
  * @freq: the center frequency of the channel
+ *
  * Return: The channel struct from @wiphy at @freq.
  */
-static inline struct ieee80211_channel *
-ieee80211_get_channel(struct wiphy *wiphy, int freq)
-{
-	return __ieee80211_get_channel(wiphy, freq);
-}
+struct ieee80211_channel *ieee80211_get_channel(struct wiphy *wiphy, int freq);
 
 /**
  * ieee80211_get_response_rate - get basic rate for a given rate
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 88725f8..f717694 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -114,8 +114,7 @@ int ieee80211_frequency_to_channel(int freq)
 }
 EXPORT_SYMBOL(ieee80211_frequency_to_channel);
 
-struct ieee80211_channel *__ieee80211_get_channel(struct wiphy *wiphy,
-						  int freq)
+struct ieee80211_channel *ieee80211_get_channel(struct wiphy *wiphy, int freq)
 {
 	enum nl80211_band band;
 	struct ieee80211_supported_band *sband;
@@ -135,7 +134,7 @@ struct ieee80211_channel *__ieee80211_get_channel(struct wiphy *wiphy,
 
 	return NULL;
 }
-EXPORT_SYMBOL(__ieee80211_get_channel);
+EXPORT_SYMBOL(ieee80211_get_channel);
 
 static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
 				     enum nl80211_band band)
-- 
1.9.1
