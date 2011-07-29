Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63916 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab1G2RWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 13:22:44 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so2464952fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jul 2011 10:22:43 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 2/2] mac80211: Always send EAPOL frames at lowest rate
Date: Fri, 29 Jul 2011 19:22:17 +0200
Message-Id: <1311960137-25420-2-git-send-email-helmut.schaa@googlemail.com> (sfid-20110729_192247_438591_192FA4BB)
In-Reply-To: <1311960137-25420-1-git-send-email-helmut.schaa@googlemail.com>
References: <1311960137-25420-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since EAPOL frames are normal data frames they are treated by the rate
control algorithm as such. Thus it can happen that the rate control
algorithm chooses an inappropriate rate (minstrel_ht uses MCS rates for
example) for the 4-way handshake and under low signal conditions the
handshake may time out.

To fix this issue always treat EAPOL frames the same as management
frames and send them with the lowest available rate.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/rate.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 3d5a2cb..c307b7b 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -199,6 +199,13 @@ static void rate_control_release(struct kref *kref)
 	kfree(ctrl_ref);
 }
 
+static bool rc_is_port_control(struct ieee80211_sta *pubsta,
+			       struct ieee80211_tx_rate_control *txrc)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	return sta->sdata->control_port_protocol == txrc->skb->protocol;
+}
+
 static bool rc_no_data_or_no_ack(struct ieee80211_tx_rate_control *txrc)
 {
 	struct sk_buff *skb = txrc->skb;
@@ -241,7 +248,8 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
 	struct ieee80211_supported_band *sband = txrc->sband;
 	int mcast_rate;
 
-	if (!sta || !priv_sta || rc_no_data_or_no_ack(txrc)) {
+	if (!sta || !priv_sta || rc_no_data_or_no_ack(txrc) ||
+	    rc_is_port_control(sta, txrc)) {
 		info->control.rates[0].idx = rate_lowest_index(txrc->sband, sta);
 		info->control.rates[0].count =
 			(info->flags & IEEE80211_TX_CTL_NO_ACK) ?
-- 
1.7.3.4

