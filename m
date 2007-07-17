Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbXGQMD0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2007 08:03:26 -0400
Subject: [PATCH] fix bug introduced in my IE stack space saving patch
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 14:02:14 +0200
Message-Id: <1184673734.3773.67.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I really wonder how I managed to use the IE patch all along. But I had
it in my tree all the time.

--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-07-17 14:02:00.230964463 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-07-17 14:02:01.910964463 +0200
@@ -110,6 +110,8 @@ struct ieee802_11_elems {
 	u8 wpa_len;
 	u8 rsn_len;
 	u8 erp_info_len;
+	u8 ht_cap_param_len;
+	u8 ht_extra_param_len;
 	u8 ext_supp_rates_len;
 	u8 wmm_info_len;
 	u8 wmm_param_len;


