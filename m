Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39216 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757213Ab1KKSpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 13:45:12 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: fix warning in ieee80211_probe_client
Date: Fri, 11 Nov 2011 13:32:28 -0500
Message-Id: <1321036348-32272-1-git-send-email-linville@tuxdriver.com> (sfid-20111111_194528_165423_47C2083E)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  net/mac80211/cfg.o
net/mac80211/cfg.c: In function ‘ieee80211_probe_client’:
net/mac80211/cfg.c:2567:7: warning: ‘qos’ may be used uninitialized in this function

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/cfg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c2416fb..1d82d2b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2564,7 +2564,7 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 	struct sk_buff *skb;
 	int size = sizeof(*nullfunc);
 	__le16 fc;
-	bool qos;
+	bool qos = NULL;
 	struct ieee80211_tx_info *info;
 	struct sta_info *sta;
 
-- 
1.7.4.4

