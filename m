Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41010 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab0FRHjd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 03:39:33 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] wireless: move regulatory_init to .init.text
Date: Fri, 18 Jun 2010 09:38:55 +0200
Message-Id: <1276846735-12105-2-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1276846735-12105-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1276846735-12105-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

regulatory_init is only called by cfg80211_init which is in .init.text,
too.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 net/wireless/reg.c |    4 ++--
 net/wireless/reg.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8f0d97d..994c7c5 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2630,7 +2630,7 @@ out:
 	mutex_unlock(&reg_mutex);
 }
 
-int regulatory_init(void)
+int __init regulatory_init(void)
 {
 	int err = 0;
 
@@ -2676,7 +2676,7 @@ int regulatory_init(void)
 	return 0;
 }
 
-void regulatory_exit(void)
+void /* __init_or_exit */ regulatory_exit(void)
 {
 	struct regulatory_request *reg_request, *tmp;
 	struct reg_beacon *reg_beacon, *btmp;
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index b26224a..c4695d0 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -10,7 +10,7 @@ int regulatory_hint_user(const char *alpha2);
 
 void reg_device_remove(struct wiphy *wiphy);
 
-int regulatory_init(void);
+int __init regulatory_init(void);
 void regulatory_exit(void);
 
 int set_regdom(const struct ieee80211_regdomain *rd);
-- 
1.7.1

