Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:48751 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754791Ab0EMBRU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 21:17:20 -0400
Received: from vs3012.wh2.ocn.ne.jp (125.206.180.183)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0667463438
	for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 10:17:18 +0900 (JST)
Subject: [PATCH] compat-wireless: fix 07-change-default-rate-alg.patch
To: lrodriguez@atheros.com
From: Bruno Randolf <br1@einfach.org>
Cc: hauke@hauke-m.de, linux-wireless@vger.kernel.org
Date: Thu, 13 May 2010 10:17:11 +0900
Message-ID: <20100513011711.13007.45318.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i need this change to make it apply again

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 patches/07-change-default-rate-alg.patch |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/patches/07-change-default-rate-alg.patch b/patches/07-change-default-rate-alg.patch
index f0ccbce..f73a4c5 100644
--- a/patches/07-change-default-rate-alg.patch
+++ b/patches/07-change-default-rate-alg.patch
@@ -10,9 +10,9 @@ and define CONFIG_COMPAT_MAC80211_RC_DEFAULT on config.mk.
 Through the compat autoconf we then get it also defined there
 at compilation time.
 
---- a/net/mac80211/rate.c
-+++ b/net/mac80211/rate.c
-@@ -23,7 +23,7 @@ struct rate_control_alg {
+--- a/net/mac80211/rate.c	2010-05-12 16:27:02.245747971 +0900
++++ b/net/mac80211/rate.c	2010-05-12 17:00:45.855748158 +0900
+@@ -23,7 +23,7 @@
  static LIST_HEAD(rate_ctrl_algs);
  static DEFINE_MUTEX(rate_ctrl_mutex);
  
@@ -21,7 +21,7 @@ at compilation time.
  module_param(ieee80211_default_rc_algo, charp, 0644);
  MODULE_PARM_DESC(ieee80211_default_rc_algo,
  		 "Default rate control algorithm for mac80211 to use");
-@@ -119,8 +119,8 @@ ieee80211_rate_control_ops_get(const cha
+@@ -118,8 +118,8 @@
  		ops = ieee80211_try_rate_control_ops_get(ieee80211_default_rc_algo);
  
  	/* try built-in one if specific alg requested but not found */
@@ -29,6 +29,6 @@ at compilation time.
 -		ops = ieee80211_try_rate_control_ops_get(CONFIG_MAC80211_RC_DEFAULT);
 +	if (!ops && strlen(CONFIG_COMPAT_MAC80211_RC_DEFAULT))
 +		ops = ieee80211_try_rate_control_ops_get(CONFIG_COMPAT_MAC80211_RC_DEFAULT);
- 	kparam_unblock_sysfs_write(ieee80211_default_rc_algo);
  
  	return ops;
+ }

