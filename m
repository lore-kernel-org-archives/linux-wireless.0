Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45756 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbZE1C4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 22:56:08 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	Jouni.Malinen@atheros.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Shan.Palanisamy@Atheros.com
Subject: [PATCH] mac80211: handle -EALREADY on cfg80211 op assoc req
Date: Wed, 27 May 2009 22:56:05 -0400
Message-Id: <1243479365-19353-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the SME requests to associate to an open AP
ieee80211_sta_set_extra_ie() can be called with zero IE
length. When this happens or when the extra IE has already
been set -EALREADY is passed down and the supplicant will
complain that the operation is already in progress and it will
not let us associate. We correct this by treating -EALREADY
from ieee80211_sta_set_extra_ie() as a success just as we do
for wext.

Cc: Shan.Palanisamy@Atheros.com
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/cfg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 77e9ff5..68fa87b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1255,7 +1255,7 @@ static int ieee80211_assoc(struct wiphy *wiphy, struct net_device *dev,
 		sdata->u.mgd.flags |= IEEE80211_STA_AUTO_SSID_SEL;
 
 	ret = ieee80211_sta_set_extra_ie(sdata, req->ie, req->ie_len);
-	if (ret)
+	if (ret && ret != -EALREADY)
 		return ret;
 
 	if (req->use_mfp) {
-- 
1.6.0.6

