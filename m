Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39053 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637Ab0EJVYS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 17:24:18 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: make patches apply again
Date: Mon, 10 May 2010 23:24:10 +0200
Message-Id: <1273526650-26282-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1273526650-26282-1-git-send-email-hauke@hauke-m.de>
References: <1273526650-26282-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/07-change-default-rate-alg.patch |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/patches/07-change-default-rate-alg.patch b/patches/07-change-default-rate-alg.patch
index af65207..f0ccbce 100644
--- a/patches/07-change-default-rate-alg.patch
+++ b/patches/07-change-default-rate-alg.patch
@@ -21,7 +21,7 @@ at compilation time.
  module_param(ieee80211_default_rc_algo, charp, 0644);
  MODULE_PARM_DESC(ieee80211_default_rc_algo,
  		 "Default rate control algorithm for mac80211 to use");
-@@ -118,8 +118,8 @@ ieee80211_rate_control_ops_get(const cha
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

