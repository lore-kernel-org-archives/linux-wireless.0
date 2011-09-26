Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50001 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab1IZMXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 08:23:12 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [RFC v3] mac80211: Send nullfunc frames at lower rate
Date: Mon, 26 Sep 2011 17:53:24 +0530
Message-ID: <1317039804-8521-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110926_142316_017545_25DFCEEC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recently mac80211 was changed to use nullfunc instead of probe
request for connection monitoring for tx ack status reporting
hardwares. These nullfunc data frames are being sent at higer
rates and also as aggregated ones. This could probably delays
the nullfunc ack so the connection is more frequently getting
disconnected as max retries are reached. In order to improve
the connectivity send the nullfunc at lower rate.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
v2: update commit log
v3: rename rc_no_data_or_no_ack & Ccd stable
 net/mac80211/rate.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index f61244c..240a24d 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -199,7 +199,7 @@ static void rate_control_release(struct kref *kref)
 	kfree(ctrl_ref);
 }
 
-static bool rc_no_data_or_no_ack(struct ieee80211_tx_rate_control *txrc)
+static bool rc_no_non_nulldata_or_no_ack(struct ieee80211_tx_rate_control *txrc)
 {
 	struct sk_buff *skb = txrc->skb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -208,7 +208,8 @@ static bool rc_no_data_or_no_ack(struct ieee80211_tx_rate_control *txrc)
 
 	fc = hdr->frame_control;
 
-	return (info->flags & IEEE80211_TX_CTL_NO_ACK) || !ieee80211_is_data(fc);
+	return (info->flags & IEEE80211_TX_CTL_NO_ACK) ||
+		!ieee80211_is_data(fc) || ieee80211_is_nullfunc(fc);
 }
 
 static void rc_send_low_broadcast(s8 *idx, u32 basic_rates,
@@ -262,7 +263,7 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
 	struct ieee80211_supported_band *sband = txrc->sband;
 	int mcast_rate;
 
-	if (!sta || !priv_sta || rc_no_data_or_no_ack(txrc)) {
+	if (!sta || !priv_sta || rc_no_non_nulldata_or_no_ack(txrc)) {
 		if ((sband->band != IEEE80211_BAND_2GHZ) ||
 		    !(info->flags & IEEE80211_TX_CTL_NO_CCK_RATE))
 			info->control.rates[0].idx =
-- 
1.7.6.4

