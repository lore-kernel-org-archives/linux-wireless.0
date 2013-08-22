Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33846 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab3HVGjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Aug 2013 02:39:31 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: minstrel_ht: don't use control.flags in TX status path
Date: Thu, 22 Aug 2013 08:39:26 +0200
Message-Id: <1377153566-15478-1-git-send-email-johannes@sipsolutions.net> (sfid-20130822_083934_765528_45353E2F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Sujith reports that my commit af61a165187bb94b1dc7628ef815c23d0eacf40b
("mac80211: add control port protocol TX control flag") broke ath9k
(aggregation). The reason is that I made minstrel_ht use the flag in
the TX status path, where it can have been overwritten by the driver.
Since we have no more space in info->flags, revert that part of the
change for now, until we can reshuffle the flags or so.

Reported-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rc80211_minstrel_ht.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 9eff382..c397ff5 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -439,13 +439,12 @@ minstrel_aggr_check(struct ieee80211_sta *pubsta, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	u16 tid;
 
 	if (unlikely(!ieee80211_is_data_qos(hdr->frame_control)))
 		return;
 
-	if (unlikely(info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO))
+	if (unlikely(skb->protocol == cpu_to_be16(ETH_P_PAE)))
 		return;
 
 	tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
-- 
1.8.4.rc2

