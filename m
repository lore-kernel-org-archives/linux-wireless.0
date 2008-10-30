Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:56466 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbYJ3PDx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 11:03:53 -0400
Message-Id: <20081030150254.961883544@localhost> (sfid-20081030_160357_800211_D0111952)
References: <20081030145920.233178987@localhost>
Date: Thu, 30 Oct 2008 16:59:25 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCHv2 5/5] mac80211_hwsim: Make sure beacon_timer gets deleted
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was possible to trigger a kernel panic because beacon_timer may not
have been deleted in all cases when the kernel module was removed while
hostapd was still running.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Index: wireless-testing/drivers/net/wireless/mac80211_hwsim.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2008-10-30 16:11:33.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2008-10-30 16:26:49.000000000 +0200
@@ -290,6 +290,7 @@
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 	data->started = 0;
+	del_timer(&data->beacon_timer);
 	printk(KERN_DEBUG "%s:%s\n", wiphy_name(hw->wiphy), __func__);
 }
 

--

-- 
Jouni Malinen                                            PGP id EFC895FA
