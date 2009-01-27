Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:58108 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbZA0XeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 18:34:07 -0500
Received: by ewy14 with SMTP id 14so2476754ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 15:34:04 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 1/3] rt2x00: Move intf_work to mac82011 workqueue
Date: Wed, 28 Jan 2009 00:32:13 +0100
Cc: rt2400-devel@lists.sourceforge.net,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901280032.13646.IvDoorn@gmail.com> (sfid-20090128_003411_875602_7541D068)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_iterate_active_interfaces() no longer acquires the
RTNL lock which means the intf_work handler can be safely
used from the mac80211 workqueue again.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index e1b4054..e681d23 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -215,7 +215,7 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
 						   rt2x00lib_beacondone_iter,
 						   rt2x00dev);
 
-	schedule_work(&rt2x00dev->intf_work);
+	queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->intf_work);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_beacondone);
 
-- 
1.5.6.1

