Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:58038 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946167AbXD3QKe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2007 12:10:34 -0400
Date: Mon, 30 Apr 2007 18:11:08 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] mac80211: destroy workqueue in error path
Message-ID: <20070430181108.3ce0edb1@griffin.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Created workqueue is not destroyed when ieee80211_register_hw fails.

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---
 net/mac80211/ieee80211.c |    1 +
 1 files changed, 1 insertion(+)

--- mac80211.orig/net/mac80211/ieee80211.c
+++ mac80211/net/mac80211/ieee80211.c
@@ -4902,6 +4902,7 @@ fail_dev:
 	sta_info_stop(local);
 fail_sta_info:
 	debugfs_hw_del(local);
+	destroy_workqueue(local->hw.workqueue);
 fail_workqueue:
 	wiphy_unregister(local->hw.wiphy);
 	return result;


-- 
Jiri Benc
SUSE Labs
