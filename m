Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41437 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbZFBUbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 16:31:09 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] cfg80211: make ieee80211_get_mesh_hdrlen() static
Date: Tue,  2 Jun 2009 16:31:10 -0400
Message-Id: <1243974670-15760-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes spares warning:
net/wireless/util.c:261:5: warning:
symbol 'ieee80211_get_mesh_hdrlen' was not declared. Should it be static?

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index d072bff..2043ee9 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -259,7 +259,7 @@ unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
 }
 EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
 
-int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
+static int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
 {
 	int ae = meshhdr->flags & MESH_FLAGS_AE;
 	/* 7.1.3.5a.2 */
-- 
1.6.0.6

