Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54679 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab1KKTYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 14:24:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] mac80211: fix warning in ieee80211_probe_client
Date: Fri, 11 Nov 2011 14:24:19 -0500
Message-Id: <1321039459-12214-1-git-send-email-linville@tuxdriver.com> (sfid-20111111_202448_255493_E9BCB1D6)
In-Reply-To: <4EBD7183.3080008@lwfinger.net>
References: <4EBD7183.3080008@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  net/mac80211/cfg.o
net/mac80211/cfg.c: In function ‘ieee80211_probe_client’:
net/mac80211/cfg.c:2567:7: warning: ‘qos’ may be used uninitialized in this function

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
v2 -- use "false" instead of "NULL" for initializing bool -- duh!

 net/mac80211/cfg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c2416fb..a097d60 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2564,7 +2564,7 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 	struct sk_buff *skb;
 	int size = sizeof(*nullfunc);
 	__le16 fc;
-	bool qos;
+	bool qos = false;
 	struct ieee80211_tx_info *info;
 	struct sta_info *sta;
 
-- 
1.7.4.4

