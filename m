Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:55213 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYEWQNr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 12:13:47 -0400
Received: by fg-out-1718.google.com with SMTP id 19so433779fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2008 09:13:47 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/4] rt2x00: Use atomic interface iteration in irq context
Date: Fri, 23 May 2008 18:14:02 +0200
References: <200805231811.38557.IvDoorn@gmail.com> <200805231812.18092.IvDoorn@gmail.com> <200805231812.43582.IvDoorn@gmail.com>
In-Reply-To: <200805231812.43582.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200805231814.02871.IvDoorn@gmail.com> (sfid-20080523_181352_753852_3C95DC9D)
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00lib_beacondone() is called from interrupt context,
this means we cannot use the mac80211 interface iterator
that uses the rtnl lock (since that uses a mutex which can sleep).
Instead we should use the atomic mac80211 interface iterator.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 5645140..669d942 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -481,9 +481,9 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
 	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
 		return;
 
-	ieee80211_iterate_active_interfaces(rt2x00dev->hw,
-					    rt2x00lib_beacondone_iter,
-					    rt2x00dev);
+	ieee80211_iterate_active_interfaces_atomic(rt2x00dev->hw,
+						   rt2x00lib_beacondone_iter,
+						   rt2x00dev);
 
 	queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->intf_work);
 }
-- 
1.5.5.1

