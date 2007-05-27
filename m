Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:29573 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbXE0Ocf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 May 2007 10:32:35 -0400
Received: by py-out-1112.google.com with SMTP id a73so2348719pye
        for <linux-wireless@vger.kernel.org>; Sun, 27 May 2007 07:32:35 -0700 (PDT)
Date: Sun, 27 May 2007 23:25:00 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	James Ketrenos <jketreno@linux.intel.com>
Subject: [PATCH] ieee80211: fix incomplete error message
Message-ID: <20070527142459.GA13087@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix error message:
Unable to network device. --> Unable to allocate network device.

Cc: John W. Linville <linville@tuxdriver.com>
Cc: James Ketrenos <jketreno@linux.intel.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 net/ieee80211/ieee80211_module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6-mm/net/ieee80211/ieee80211_module.c
===================================================================
--- 2.6-mm.orig/net/ieee80211/ieee80211_module.c
+++ 2.6-mm/net/ieee80211/ieee80211_module.c
@@ -140,7 +140,7 @@ struct net_device *alloc_ieee80211(int s
 
 	dev = alloc_etherdev(sizeof(struct ieee80211_device) + sizeof_priv);
 	if (!dev) {
-		IEEE80211_ERROR("Unable to network device.\n");
+		IEEE80211_ERROR("Unable to allocate network device.\n");
 		goto failed;
 	}
 	ieee = netdev_priv(dev);
