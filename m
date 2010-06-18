Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41007 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab0FRHjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 03:39:02 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] cfg80211: move cfg80211_exit to .exit.text
Date: Fri, 18 Jun 2010 09:38:54 +0200
Message-Id: <1276846735-12105-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211_exit is only used as module_exit function, so it can go to
.exit.text saving a few bytes when CONFIG_CFG80211=y.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 net/wireless/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 37d0e0a..47fcfd0 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -894,7 +894,7 @@ out_fail_pernet:
 }
 subsys_initcall(cfg80211_init);
 
-static void cfg80211_exit(void)
+static void __exit cfg80211_exit(void)
 {
 	debugfs_remove(ieee80211_debugfs_dir);
 	nl80211_exit();
-- 
1.7.1

