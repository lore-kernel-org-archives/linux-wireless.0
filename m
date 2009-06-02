Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56455 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZFBWiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 18:38:20 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] mac80211: extend sta kdoc - explain when they are added
Date: Tue,  2 Jun 2009 18:38:14 -0400
Message-Id: <1243982294-6175-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/sta_info.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index d5611d8..a360bce 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -44,6 +44,15 @@
  * When the insertion fails (sta_info_insert()) returns non-zero), the
  * structure will have been freed by sta_info_insert()!
  *
+ * sta entries are added by mac80211 when you establish a link with a
+ * peer. This means different things for the different type of interfaces
+ * we support. For a regular station this mean we add the AP sta when we
+ * receive an assocation response from the AP. For IBSS this occurs when
+ * we receive a probe response or a beacon from target IBSS network. For
+ * WDS we add the sta for the peer imediately upon device open. When using
+ * AP mode we add stations for each respective station upon request from
+ * userspace through nl80211.
+ *
  * Because there are debugfs entries for each station, and adding those
  * must be able to sleep, it is also possible to "pin" a station entry,
  * that means it can be removed from the hash table but not be freed.
-- 
1.5.6.4

