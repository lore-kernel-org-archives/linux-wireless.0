Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35035 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbZEBEet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 00:34:49 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] cfg80211: make nl80211_send_mlme_timeout() static
Date: Sat,  2 May 2009 00:34:48 -0400
Message-Id: <1241238888-30592-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes sparse complaint:

  CHECK   net/wireless/nl80211.c
net/wireless/nl80211.c:3694:6:
	warning: symbol 'nl80211_send_mlme_timeout'
	was not declared. Should it be static?

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/nl80211.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b1fc982..3c53c5c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3696,9 +3696,9 @@ void nl80211_send_disassoc(struct cfg80211_registered_device *rdev,
 				NL80211_CMD_DISASSOCIATE);
 }
 
-void nl80211_send_mlme_timeout(struct cfg80211_registered_device *rdev,
-			       struct net_device *netdev, int cmd,
-			       const u8 *addr)
+static void nl80211_send_mlme_timeout(struct cfg80211_registered_device *rdev,
+				      struct net_device *netdev, int cmd,
+				      const u8 *addr)
 {
 	struct sk_buff *msg;
 	void *hdr;
-- 
1.6.0.6

