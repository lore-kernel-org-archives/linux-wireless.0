Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57920 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbYBYKMg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 05:12:36 -0500
Subject: [PATCH] adm8211: fix cfg80211 band API conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: ptb@inv.it.uc3m.es, John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
In-Reply-To: <1203934027.13162.60.camel@johannes.berg> (sfid-20080225_100720_012562_43D37C6F)
References: <200802242157.m1OLvS429023@inv.it.uc3m.es>
	 (sfid-20080224_220312_353058_4025F8DA)  <1203934027.13162.60.camel@johannes.berg>
	 (sfid-20080225_100720_012562_43D37C6F)
Content-Type: text/plain
Date: Mon, 25 Feb 2008 11:12:18 +0100
Message-Id: <1203934338.13162.63.camel@johannes.berg> (sfid-20080225_101244_397053_FA0AA338)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Insert a missing band assignment.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Please test and if it works reply with Tested-by (like my Signed-off-by)
so John can note that to merge it.

 drivers/net/wireless/adm8211.c |    2 ++
 1 file changed, 2 insertions(+)

--- everything.orig/drivers/net/wireless/adm8211.c	2008-02-25 11:08:45.000000000 +0100
+++ everything/drivers/net/wireless/adm8211.c	2008-02-25 11:09:53.000000000 +0100
@@ -1932,6 +1932,8 @@ static int __devinit adm8211_probe(struc
 
 	priv->channel = 1;
 
+	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
+
 	err = ieee80211_register_hw(dev);
 	if (err) {
 		printk(KERN_ERR "%s (adm8211): Cannot register device\n",


