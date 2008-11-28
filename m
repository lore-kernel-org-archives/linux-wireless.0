Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:18639 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbYK1TuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 14:50:04 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx06.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mASJlFe3032398
	for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2008 21:50:02 +0200
Received: from localhost.localdomain (essapo-nirac25338.europe.nokia.com [10.162.253.38])
	by mgw-int01.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mASJnjSj003187
	for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2008 21:49:50 +0200
From: Kalle Valo <kalle.valo@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC v3 3/4] mac80211: add IEEE80211_HW_NO_DYNAMIC_PS flag
Date: Fri, 28 Nov 2008 21:49:43 +0200
Message-Id: <1227901784-5325-4-git-send-email-kalle.valo@nokia.com> (sfid-20081128_205010_097030_BDDD13FB)
In-Reply-To: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com>
References: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 include/net/mac80211.h |    1 +
 net/mac80211/tx.c      |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6a1d4ea..53a0dc5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -858,6 +858,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_NOISE_DBM				= 1<<8,
 	IEEE80211_HW_SPECTRUM_MGMT			= 1<<9,
 	IEEE80211_HW_AMPDU_AGGREGATION			= 1<<10,
+	IEEE80211_HW_NO_DYNAMIC_PS			= 1<<11,
 };
 
 /**
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 25d4a86..1d7ef18 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1476,7 +1476,8 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		goto fail;
 	}
 
-	if (local->dynamic_ps_timeout > 0) {
+	if (local->hw.flags & IEEE80211_HW_NO_DYNAMIC_PS &&
+	    local->dynamic_ps_timeout > 0) {
 		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 			netif_tx_stop_all_queues(local->mdev);
 			queue_work(local->hw.workqueue,
-- 
1.5.6.5

