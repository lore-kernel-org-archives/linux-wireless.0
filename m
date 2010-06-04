Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47354 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab0FDSaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 14:30:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: make ARP filtering depend on CONFIG_INET
Date: Fri,  4 Jun 2010 14:28:07 -0400
Message-Id: <1275676087-20039-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <20100604153006.fa15c770.sfr@canb.auug.org.au>
References: <20100604153006.fa15c770.sfr@canb.auug.org.au>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/main.c |    6 ++++++
 net/mac80211/mlme.c |    2 ++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 045ead9..5706156 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -329,6 +329,7 @@ static void ieee80211_recalc_smps_work(struct work_struct *work)
 	mutex_unlock(&local->iflist_mtx);
 }
 
+#ifdef CONFIG_INET
 int ieee80211_set_arp_filter(struct ieee80211_sub_if_data *sdata)
 {
 	struct in_device *idev;
@@ -380,6 +381,7 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 
 	return NOTIFY_DONE;
 }
+#endif
 
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops)
@@ -669,10 +671,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		goto fail_pm_qos;
 	}
 
+#ifdef CONFIG_INET
 	local->ifa_notifier.notifier_call = ieee80211_ifa_changed;
 	result = register_inetaddr_notifier(&local->ifa_notifier);
 	if (result)
 		goto fail_ifa;
+#endif
 
 	return 0;
 
@@ -707,7 +711,9 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 
 	pm_qos_remove_notifier(PM_QOS_NETWORK_LATENCY,
 			       &local->network_latency_notifier);
+#ifdef CONFIG_INET
 	unregister_inetaddr_notifier(&local->ifa_notifier);
+#endif
 
 	rtnl_lock();
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7e72013..3623bb7 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2078,6 +2078,7 @@ static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
 			cfg80211_send_assoc_timeout(wk->sdata->dev,
 						    wk->filter_ta);
 			return WORK_DONE_DESTROY;
+#ifdef CONFIG_INET
 		} else {
 			mutex_unlock(&wk->sdata->u.mgd.mtx);
 
@@ -2088,6 +2089,7 @@ static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
 			rtnl_lock();
 			ieee80211_set_arp_filter(wk->sdata);
 			rtnl_unlock();
+#endif
 		}
 	}
 
-- 
1.6.6.1

