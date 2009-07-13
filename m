Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49187 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZGML0C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 07:26:02 -0400
Subject: [PATCH] mac80211_hwsim: fix use after free
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 13:25:58 +0200
Message-Id: <1247484358.4166.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once the "data" pointer is freed, we can't be iterating
to the next item in the list any more so we need to use
list_for_each_entry_safe with a temporary variable.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/mac80211_hwsim.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-07-13 13:21:18.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-07-13 13:21:42.000000000 +0200
@@ -790,7 +790,7 @@ static const struct ieee80211_ops mac802
 static void mac80211_hwsim_free(void)
 {
 	struct list_head tmplist, *i, *tmp;
-	struct mac80211_hwsim_data *data;
+	struct mac80211_hwsim_data *data, *tmpdata;
 
 	INIT_LIST_HEAD(&tmplist);
 
@@ -799,7 +799,7 @@ static void mac80211_hwsim_free(void)
 		list_move(i, &tmplist);
 	spin_unlock_bh(&hwsim_radio_lock);
 
-	list_for_each_entry(data, &tmplist, list) {
+	list_for_each_entry_safe(data, tmpdata, &tmplist, list) {
 		debugfs_remove(data->debugfs_group);
 		debugfs_remove(data->debugfs_ps);
 		debugfs_remove(data->debugfs);


