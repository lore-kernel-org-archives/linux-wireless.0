Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:23287 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161505AbXDWS6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 14:58:18 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 05/13] mac80211: remove statistics callback for master device
Date: Mon, 23 Apr 2007 14:48:13 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070423184813.7029.95204.stgit@magic.sourmilk.net>
In-Reply-To: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

Statistics were never updated properly for the master device, so don't
bother reporting them.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 7743ca0..8a3c749 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -4694,7 +4694,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	sta_info_init(local);
 
 	mdev->hard_start_xmit = ieee80211_master_start_xmit;
-	mdev->get_stats = ieee80211_get_stats;
 	mdev->open = ieee80211_master_open;
 	mdev->stop = ieee80211_master_stop;
 	mdev->type = ARPHRD_IEEE80211;

