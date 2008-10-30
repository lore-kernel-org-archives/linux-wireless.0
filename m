Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:56420 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbYJ3PD0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 11:03:26 -0400
Message-Id: <20081030150227.154812323@localhost> (sfid-20081030_160329_698330_3E57E05B)
References: <20081030145920.233178987@localhost>
Date: Thu, 30 Oct 2008 16:59:23 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCHv2 3/5] mac80211_hwsim: Debug info for TX queue parameters
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide detailed information on TX queue parameter changes to make it
easier to debug mac80211 functionality.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Index: wireless-testing/drivers/net/wireless/mac80211_hwsim.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2008-10-30 16:09:28.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2008-10-30 16:11:33.000000000 +0200
@@ -478,6 +478,17 @@
 	return 0;
 }
 
+static int mac80211_hwsim_conf_tx(
+	struct ieee80211_hw *hw, u16 queue,
+	const struct ieee80211_tx_queue_params *params)
+{
+	printk(KERN_DEBUG "%s:%s (queue=%d txop=%d cw_min=%d cw_max=%d "
+	       "aifs=%d)\n",
+	       wiphy_name(hw->wiphy), __func__, queue,
+	       params->txop, params->cw_min, params->cw_max, params->aifs);
+	return 0;
+}
+
 static const struct ieee80211_ops mac80211_hwsim_ops =
 {
 	.tx = mac80211_hwsim_tx,
@@ -491,6 +502,7 @@
 	.bss_info_changed = mac80211_hwsim_bss_info_changed,
 	.sta_notify = mac80211_hwsim_sta_notify,
 	.set_tim = mac80211_hwsim_set_tim,
+	.conf_tx = mac80211_hwsim_conf_tx,
 };
 
 

--

-- 
Jouni Malinen                                            PGP id EFC895FA
