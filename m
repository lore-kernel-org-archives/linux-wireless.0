Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:25702 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab0GFUYN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 16:24:13 -0400
Subject: [PATCH] compat-wireless: update 07-change-default-rate-alg.patch
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 06 Jul 2010 16:24:08 -0400
Message-ID: <20100706202408.10219.7113.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---
 patches/07-change-default-rate-alg.patch |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/patches/07-change-default-rate-alg.patch b/patches/07-change-default-rate-alg.patch
index f0ccbce..858e1bc 100644
--- a/patches/07-change-default-rate-alg.patch
+++ b/patches/07-change-default-rate-alg.patch
@@ -29,6 +29,6 @@ at compilation time.
 -		ops = ieee80211_try_rate_control_ops_get(CONFIG_MAC80211_RC_DEFAULT);
 +	if (!ops && strlen(CONFIG_COMPAT_MAC80211_RC_DEFAULT))
 +		ops = ieee80211_try_rate_control_ops_get(CONFIG_COMPAT_MAC80211_RC_DEFAULT);
- 	kparam_unblock_sysfs_write(ieee80211_default_rc_algo);
  
  	return ops;
+ }
