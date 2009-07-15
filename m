Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbZGOAO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:14:29 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: [PATCH 14/21] mac80211: make minstrel/pid RC use ieee80211_is_data(fc)
Date: Tue, 14 Jul 2009 20:14:06 -0400
Message-Id: <1247616853-11221-15-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
References: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Felix Fietkau <nbd@openwrt.org>
Cc: Derek Smithies <derek@indranet.co.nz>
Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/rc80211_minstrel.c |    7 +++----
 net/mac80211/rc80211_pid_algo.c |    7 +++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 37771ab..5bdce0c 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -75,12 +75,11 @@ use_low_rate(struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	u16 fc;
+	__le16 fc;
 
-	fc = le16_to_cpu(hdr->frame_control);
+	fc = hdr->frame_control;
 
-	return ((info->flags & IEEE80211_TX_CTL_NO_ACK) ||
-		(fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA);
+	return ((info->flags & IEEE80211_TX_CTL_NO_ACK) || !ieee80211_is_data(fc));
 }
 
 
diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index a0bef76..5496077 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -280,7 +280,7 @@ rate_control_pid_get_rate(void *priv, struct ieee80211_sta *sta,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct rc_pid_sta_info *spinfo = priv_sta;
 	int rateidx;
-	u16 fc;
+	__le16 fc;
 
 	if (txrc->rts)
 		info->control.rates[0].count =
@@ -290,9 +290,8 @@ rate_control_pid_get_rate(void *priv, struct ieee80211_sta *sta,
 			txrc->hw->conf.short_frame_max_tx_count;
 
 	/* Send management frames and NO_ACK data using lowest rate. */
-	fc = le16_to_cpu(hdr->frame_control);
-	if (!sta || !spinfo ||
-	    (fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
+	fc = hdr->frame_control;
+	if (!sta || !spinfo || !ieee80211_is_data(fc) ||
 	    info->flags & IEEE80211_TX_CTL_NO_ACK) {
 		info->control.rates[0].idx = rate_lowest_index(sband, sta);
 		if (info->flags & IEEE80211_TX_CTL_NO_ACK)
-- 
1.6.0.6

