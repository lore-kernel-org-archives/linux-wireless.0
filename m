Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:52531 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab0BNDNZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 22:13:25 -0500
Subject: [PATCH] mwl8k: disable softirqs when accessing sta_notify_list
From: Pavel Roskin <proski@gnu.org>
To: Lennert Buytenhek <buytenh@marvell.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Sat, 13 Feb 2010 22:13:06 -0500
Message-Id: <1266117186.13902.21.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use spin_[un]lock_bh in mwl8k_sta_notify().  The sta_notify handler is
required to be atomic, yet it can be called in process context, so make
sure one call won't preempt another.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
I found it by accident (sparse reported it, but presumably for a wrong
reason) and I have no hardware to test the patch on, but I believe it's
correct.

 drivers/net/wireless/mwl8k.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 0cfdb9d..6497c84 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3784,9 +3784,9 @@ mwl8k_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		s->cmd = cmd;
 		s->sta = *sta;
 
-		spin_lock(&priv->sta_notify_list_lock);
+		spin_lock_bh(&priv->sta_notify_list_lock);
 		list_add_tail(&s->list, &priv->sta_notify_list);
-		spin_unlock(&priv->sta_notify_list_lock);
+		spin_unlock_bh(&priv->sta_notify_list_lock);
 
 		ieee80211_queue_work(hw, &priv->sta_notify_worker);
 	}
-- 
Regards,
Pavel Roskin
