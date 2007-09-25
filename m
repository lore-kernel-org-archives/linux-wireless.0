Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:8076 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbXIYSou (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 14:44:50 -0400
Received: by fk-out-0910.google.com with SMTP id z23so2123530fkz
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2007 11:44:49 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 8/12] rt2x00: make rt2x00lib_stop_link_tuner() reentrant with link_tuner work
Date: Tue, 25 Sep 2007 20:56:36 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709252052.34803.IvDoorn@gmail.com>
In-Reply-To: <200709252052.34803.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709252056.36472.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Calling cancel_delayed_work_sync() unconditionally won't hurt
and it will avoid race conditions when another CPU is already
executing link_tuner work.

Signed-off-by: Modestas Vainius <modestas@vainius.eu>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index f8f7e6e..e8c91fb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -80,8 +80,7 @@ static void rt2x00lib_start_link_tuner(struct rt2x00_dev *rt2x00dev)
 
 static void rt2x00lib_stop_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
-	if (delayed_work_pending(&rt2x00dev->link.work))
-		cancel_rearming_delayed_work(&rt2x00dev->link.work);
+	cancel_delayed_work_sync(&rt2x00dev->link.work);
 }
 
 void rt2x00lib_reset_link_tuner(struct rt2x00_dev *rt2x00dev)
-- 
1.5.3.2

