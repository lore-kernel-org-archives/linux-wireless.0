Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:8076 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbXIYSow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 14:44:52 -0400
Received: by fk-out-0910.google.com with SMTP id z23so2123530fkz
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2007 11:44:52 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 9/12] rt2x00: Stop link tuning when radio is down
Date: Tue, 25 Sep 2007 20:57:04 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709252052.34803.IvDoorn@gmail.com>
In-Reply-To: <200709252052.34803.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709252057.04999.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As pointed out by Modestas Vainius the link tuner
could continue working while the radio is already
down. This because at the start of disable_radio
the ENABLED_RADIO flag is cleared and causes the
toggle_rx to skip the stop_link_tuner() call.
This will add a check to the start of the link tuner
which will automatically stop the link tuner when the
radio is disabled.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index e8c91fb..92b7252 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -237,6 +237,13 @@ static void rt2x00lib_link_tuner(struct work_struct *work)
 	    container_of(work, struct rt2x00_dev, link.work.work);
 
 	/*
+	 * When the radio is shutting down we should
+	 * immediately cease all link tuning.
+	 */
+	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
+		return;
+
+	/*
 	 * Update statistics.
 	 */
 	rt2x00dev->ops->lib->link_stats(rt2x00dev);
-- 
1.5.3.2

