Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:60365 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966497AbeEYM3Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 08:29:24 -0400
Subject: [PATCH] mac80211: Move up init of TXQs
From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org
Cc: Niklas Cassel <niklas.cassel@linaro.org>
Date: Fri, 25 May 2018 14:29:21 +0200
Message-ID: <152725136177.14483.16708750819293583562.stgit@alrua-kau> (sfid-20180525_142943_783332_DD5B80F9)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On init, ieee80211_if_add() dumps the interface. Since that now includes a
dump of the TXQ state, we need to initialise that before the dump happens.
So move up the TXQ initialisation to to before the call to
ieee80211_if_add().

Fixes: 52539ca89f36 ("cfg80211: Expose TXQ stats and parameters to userspace")
Reported-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 net/mac80211/main.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4d2e797e3f16..722f3d9fb416 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1098,6 +1098,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	ieee80211_led_init(local);
 
+	result = ieee80211_txq_setup_flows(local);
+	if (result)
+		goto fail_flows;
+
 	rtnl_lock();
 
 	result = ieee80211_init_rate_ctrl_alg(local,
@@ -1120,10 +1124,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	rtnl_unlock();
 
-	result = ieee80211_txq_setup_flows(local);
-	if (result)
-		goto fail_flows;
-
 #ifdef CONFIG_INET
 	local->ifa_notifier.notifier_call = ieee80211_ifa_changed;
 	result = register_inetaddr_notifier(&local->ifa_notifier);
@@ -1149,8 +1149,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 #if defined(CONFIG_INET) || defined(CONFIG_IPV6)
  fail_ifa:
 #endif
-	ieee80211_txq_teardown_flows(local);
- fail_flows:
 	rtnl_lock();
 	rate_control_deinitialize(local);
 	ieee80211_remove_interfaces(local);
@@ -1158,6 +1156,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	rtnl_unlock();
 	ieee80211_led_exit(local);
 	ieee80211_wep_free(local);
+	ieee80211_txq_teardown_flows(local);
+ fail_flows:
 	destroy_workqueue(local->workqueue);
  fail_workqueue:
 	wiphy_unregister(local->hw.wiphy);
