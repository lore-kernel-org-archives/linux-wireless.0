Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:26933 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab0HCFWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Aug 2010 01:22:48 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix compilation warning when CONFIG_INET is not set
Date: Tue,  3 Aug 2010 08:22:25 +0300
Message-Id: <1280812945-27132-1-git-send-email-juuso.oikarinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The warning is:
  net/mac80211/main.c:688: warning: label ‘fail_ifa’ defined but not used

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/mac80211/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7cc4f91..798a91b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -685,10 +685,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	return 0;
 
+#ifdef CONFIG_INET
  fail_ifa:
 	pm_qos_remove_notifier(PM_QOS_NETWORK_LATENCY,
 			       &local->network_latency_notifier);
 	rtnl_lock();
+#endif
  fail_pm_qos:
 	ieee80211_led_exit(local);
 	ieee80211_remove_interfaces(local);
-- 
1.6.3.3

