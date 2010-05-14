Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53917 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757120Ab0ENSUa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 14:20:30 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] Revert "compat-wireless: fix 07-change-default-rate-alg.patch"
Date: Fri, 14 May 2010 20:20:15 +0200
Message-Id: <1273861216-12195-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit fc4ed11ef1265b43e14bb3aa5bb4c6bd788ba65a.

In the linux-next tree there is this line
kparam_unblock_sysfs_write(ieee80211_default_rc_algo);
it was introduced 2 days ago. In wireless-text this does not exist for now.

This patch was added because it was not clear that compat-wireless is build on
linux-next.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/07-change-default-rate-alg.patch |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/patches/07-change-default-rate-alg.patch b/patches/07-change-default-rate-alg.patch
index f73a4c5..f0ccbce 100644
--- a/patches/07-change-default-rate-alg.patch
+++ b/patches/07-change-default-rate-alg.patch
@@ -10,9 +10,9 @@ and define CONFIG_COMPAT_MAC80211_RC_DEFAULT on config.mk.
 Through the compat autoconf we then get it also defined there
 at compilation time.
 
---- a/net/mac80211/rate.c	2010-05-12 16:27:02.245747971 +0900
-+++ b/net/mac80211/rate.c	2010-05-12 17:00:45.855748158 +0900
-@@ -23,7 +23,7 @@
+--- a/net/mac80211/rate.c
++++ b/net/mac80211/rate.c
+@@ -23,7 +23,7 @@ struct rate_control_alg {
  static LIST_HEAD(rate_ctrl_algs);
  static DEFINE_MUTEX(rate_ctrl_mutex);
  
@@ -21,7 +21,7 @@ at compilation time.
  module_param(ieee80211_default_rc_algo, charp, 0644);
  MODULE_PARM_DESC(ieee80211_default_rc_algo,
  		 "Default rate control algorithm for mac80211 to use");
-@@ -118,8 +118,8 @@
+@@ -119,8 +119,8 @@ ieee80211_rate_control_ops_get(const cha
  		ops = ieee80211_try_rate_control_ops_get(ieee80211_default_rc_algo);
  
  	/* try built-in one if specific alg requested but not found */
@@ -29,6 +29,6 @@ at compilation time.
 -		ops = ieee80211_try_rate_control_ops_get(CONFIG_MAC80211_RC_DEFAULT);
 +	if (!ops && strlen(CONFIG_COMPAT_MAC80211_RC_DEFAULT))
 +		ops = ieee80211_try_rate_control_ops_get(CONFIG_COMPAT_MAC80211_RC_DEFAULT);
+ 	kparam_unblock_sysfs_write(ieee80211_default_rc_algo);
  
  	return ops;
- }
-- 
1.7.0.4

