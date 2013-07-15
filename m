Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59172 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756210Ab3GOMfK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 08:35:10 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, krzysiek@podlesie.net
Subject: [PATCH 3.11] mac80211/minstrel: fix NULL pointer dereference issue
Date: Mon, 15 Jul 2013 14:35:06 +0200
Message-Id: <1373891706-1071-1-git-send-email-nbd@openwrt.org> (sfid-20130715_143514_916258_8E3B7A08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When priv_sta == NULL, mi->prev_sample is dereferenced too early. Move
the assignment further down, after the rate_control_send_low call.

Reported-by: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: stable@vger.kernel.org # 3.10
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index ac7ef54..e6512e2 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -290,7 +290,7 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 	struct minstrel_rate *msr, *mr;
 	unsigned int ndx;
 	bool mrr_capable;
-	bool prev_sample = mi->prev_sample;
+	bool prev_sample;
 	int delta;
 	int sampling_ratio;
 
@@ -314,6 +314,7 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 			(mi->sample_count + mi->sample_deferred / 2);
 
 	/* delta < 0: no sampling required */
+	prev_sample = mi->prev_sample;
 	mi->prev_sample = false;
 	if (delta < 0 || (!mrr_capable && prev_sample))
 		return;
-- 
1.8.0.2

