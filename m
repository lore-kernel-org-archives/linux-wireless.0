Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60465 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758261AbZLGTBW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 14:01:22 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	johannes@sipsolutions.net
Subject: [PATCH] mac80211: make debugfs mcs set entry reflect 16 bits
Date: Mon,  7 Dec 2009 14:01:28 -0500
Message-Id: <1260212488-5736-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MCS set is 16 bits so when debugging ensure the full 16 bits
are represented. Current reading would make you think its only
8 bits.

Cc: johannes@sipsolutions.net
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/debugfs_sta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 3f41608..ae6a919 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -168,7 +168,7 @@ static ssize_t sta_ht_capa_read(struct file *file, char __user *userbuf,
 	p += scnprintf(p, sizeof(buf) + buf - p, "ht %ssupported\n",
 			htc->ht_supported ? "" : "not ");
 	if (htc->ht_supported) {
-		p += scnprintf(p, sizeof(buf)+buf-p, "cap: %#.2x\n", htc->cap);
+		p += scnprintf(p, sizeof(buf)+buf-p, "cap: %#.4x\n", htc->cap);
 		p += scnprintf(p, sizeof(buf)+buf-p, "ampdu factor/density: %d/%d\n",
 				htc->ampdu_factor, htc->ampdu_density);
 		p += scnprintf(p, sizeof(buf)+buf-p, "MCS mask:");
-- 
1.6.3.3

