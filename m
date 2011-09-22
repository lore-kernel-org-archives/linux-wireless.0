Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13291 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1IVO6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 10:58:07 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [RFC 2/2] mac80211: Send the management frame at requested rate
Date: Thu, 22 Sep 2011 20:28:36 +0530
Message-ID: <1316703516-24216-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110922_165811_977479_ECF2EE05)
In-Reply-To: <1316703516-24216-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1316703516-24216-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever the scan request or tx_mgmt is requesting not to
use CCK rate for managemet frames through
NL80211_ATTR_TX_NO_CCK_RATE attribute, then mac80211 should
select appropriate least non-CCK rate. This could help to
send P2P probes and P2P action frames at non 11b rates
without diabling 11b rates globally.

Cc: Jouni Malinen <jouni@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 include/net/mac80211.h |    4 ++++
 net/mac80211/cfg.c     |    3 +++
 net/mac80211/rate.c    |   30 +++++++++++++++++++++++++++++-
 net/mac80211/tx.c      |    5 +++++
 4 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c0f63fd..63a3634 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -363,6 +363,9 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_INTFL_TKIP_MIC_FAILURE: Marks this packet to be used for TKIP
  *	testing. It will be sent out with incorrect Michael MIC key to allow
  *	TKIP countermeasures to be tested.
+ * @IEEE80211_TX_CTL_NO_CCK_RATE: This frame will be sent at non CCK rate.
+ *	This flag is actually used for management frame especially for P2P frames
+ *	not being sent at CCK rate at 2GHz band.
  *
  * Note: If you have to add new flags to the enumeration, then don't
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -393,6 +396,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_STBC			= BIT(23) | BIT(24),
 	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(25),
 	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(26),
+	IEEE80211_TX_CTL_NO_CCK_RATE		= BIT(27),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9cba010..56c3504 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1897,6 +1897,9 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 		flags |= IEEE80211_TX_CTL_TX_OFFCHAN;
 	}
 
+	if (no_cck)
+		flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
+
 	if (is_offchan && !offchan)
 		return -EBUSY;
 
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 3d5a2cb..6711954 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -233,6 +233,28 @@ static void rc_send_low_broadcast(s8 *idx, u32 basic_rates,
 	/* could not find a basic rate; use original selection */
 }
 
+static inline s8
+rate_lowest_non_cck_index(struct ieee80211_supported_band *sband,
+			  struct ieee80211_sta *sta)
+{
+	int i;
+
+	for (i = 0; i < sband->n_bitrates; i++) {
+		struct ieee80211_rate *srate = &sband->bitrates[i];
+		if ((srate->bitrate == 10) || (srate->bitrate == 20) ||
+		    (srate->bitrate == 55) || (srate->bitrate == 110))
+			continue;
+
+		if ((i != sband->n_bitrates) &&
+		    rate_supported(sta, sband->band, i))
+			return i;
+	}
+
+	/* No matching rate found */
+	return 0;
+}
+
+
 bool rate_control_send_low(struct ieee80211_sta *sta,
 			   void *priv_sta,
 			   struct ieee80211_tx_rate_control *txrc)
@@ -242,7 +264,13 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
 	int mcast_rate;
 
 	if (!sta || !priv_sta || rc_no_data_or_no_ack(txrc)) {
-		info->control.rates[0].idx = rate_lowest_index(txrc->sband, sta);
+		if ((sband->band != IEEE80211_BAND_2GHZ) ||
+		    !(info->flags & IEEE80211_TX_CTL_NO_CCK_RATE))
+			info->control.rates[0].idx =
+				rate_lowest_index(txrc->sband, sta);
+		else
+			info->control.rates[0].idx =
+				rate_lowest_non_cck_index(txrc->sband, sta);
 		info->control.rates[0].count =
 			(info->flags & IEEE80211_TX_CTL_NO_ACK) ?
 			1 : txrc->hw->max_rate_tries;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7cd6c28..4f2d5aa 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -639,6 +639,11 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 		txrc.rts = rts = true;
 	}
 
+	if (ieee80211_is_probe_req(hdr->frame_control) &&
+	    tx->sdata->local->scan_req &&
+	    tx->sdata->local->scan_req->no_cck)
+		info->flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
+
 	/*
 	 * Use short preamble if the BSS can handle it, but not for
 	 * management frames unless we know the receiver can handle
-- 
1.7.6.3

