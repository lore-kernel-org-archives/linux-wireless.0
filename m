Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:23251 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab0FPOiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 10:38:08 -0400
Subject: [PATCH] mac80211: fix warn, enum may be used uninitialized
From: Christoph Fritz <chf.fritz@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kalle.valo@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 16:37:34 +0200
Message-ID: <1276699054.30673.0.camel@lovely>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

regression introduced by b8d92c9c141ee3dc9b3537b1f0ffb4a54ea8d9b2

In function ‘ieee80211_work_rx_queued_mgmt’:
warning: ‘rma’ may be used uninitialized in this function

this re-adds default value WORK_ACT_NONE back to rma

Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
---
 net/mac80211/work.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index be3d4a6..b025dc7 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -715,7 +715,7 @@ static void ieee80211_work_rx_queued_mgmt(struct ieee80211_local *local,
 	struct ieee80211_rx_status *rx_status;
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_work *wk;
-	enum work_action rma;
+	enum work_action rma = WORK_ACT_NONE;
 	u16 fc;
 
 	rx_status = (struct ieee80211_rx_status *) skb->cb;
-- 
1.7.1



