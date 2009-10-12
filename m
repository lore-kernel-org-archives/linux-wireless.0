Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47119 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758229AbZJLVUn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 17:20:43 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/9] [compat-2.6] Fix compile bug with kernel 2.6.32
Date: Mon, 12 Oct 2009 23:19:13 +0200
Message-Id: <1255382358-20760-6-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
References: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/patches/12-iw_handler-changes.patch |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/compat/patches/12-iw_handler-changes.patch b/compat/patches/12-iw_handler-changes.patch
index 50c9b1a..7a700b1 100644
--- a/compat/patches/12-iw_handler-changes.patch
+++ b/compat/patches/12-iw_handler-changes.patch
@@ -1,11 +1,14 @@
 --- a/drivers/net/wireless/ipw2x00/ipw2100.c	2009-10-08 11:01:52.000000000 -0400
 +++ b/drivers/net/wireless/ipw2x00/ipw2100.c	2009-10-08 11:01:43.000000000 -0400
-@@ -6057,7 +6057,7 @@
+@@ -6057,7 +6057,11 @@
  
  	dev->ethtool_ops = &ipw2100_ethtool_ops;
  	dev->wireless_handlers = &ipw2100_wx_handler_def;
--	priv->wireless_data.libipw = priv->ieee;
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,31))
+ 	priv->wireless_data.libipw = priv->ieee;
++#else
 +	priv->wireless_data.ieee80211 = (struct ieee80211_device *) priv->ieee;
++#endif
  	dev->wireless_data = &priv->wireless_data;
  	dev->watchdog_timeo = 3 * HZ;
  	dev->irq = 0;
-- 
1.6.2.1

