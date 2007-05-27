Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:31772 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbXE0OeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 May 2007 10:34:07 -0400
Received: by py-out-1112.google.com with SMTP id a73so2349178pye
        for <linux-wireless@vger.kernel.org>; Sun, 27 May 2007 07:34:06 -0700 (PDT)
Date: Sun, 27 May 2007 23:26:31 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Joe Jezak <josejx@gentoo.org>, Daniel Drake <dsd@gentoo.org>
Subject: [PATCH] softmac: alloc_ieee80211() NULL check
Message-ID: <20070527142631.GA13105@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds missing NULL check and trims a line longer than 80 columns.

Cc: John W. Linville <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Joe Jezak <josejx@gentoo.org>
Cc: Daniel Drake <dsd@gentoo.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 net/ieee80211/softmac/ieee80211softmac_module.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: 2.6-mm/net/ieee80211/softmac/ieee80211softmac_module.c
===================================================================
--- 2.6-mm.orig/net/ieee80211/softmac/ieee80211softmac_module.c
+++ 2.6-mm/net/ieee80211/softmac/ieee80211softmac_module.c
@@ -33,7 +33,10 @@ struct net_device *alloc_ieee80211softma
 	struct ieee80211softmac_device *softmac;
 	struct net_device *dev;
 
-	dev = alloc_ieee80211(sizeof(struct ieee80211softmac_device) + sizeof_priv);
+	dev = alloc_ieee80211(sizeof(*softmac) + sizeof_priv);
+	if (!dev)
+		return NULL;
+
 	softmac = ieee80211_priv(dev);
 	softmac->dev = dev;
 	softmac->ieee = netdev_priv(dev);
