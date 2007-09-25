Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:8076 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbXIYSo4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 14:44:56 -0400
Received: by fk-out-0910.google.com with SMTP id z23so2123530fkz
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2007 11:44:55 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/12] rt2x00: Fix panic on rmmod with rfkill enabled
Date: Tue, 25 Sep 2007 20:57:49 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709252052.34803.IvDoorn@gmail.com>
In-Reply-To: <200709252052.34803.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709252057.49147.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When ieee80211_hw.config indicates that the radio
is enabled and is configuring options that require
the link tuner to be restarted the link tuner will
cause a kernel panic when rfkill has indicated the
radio was in fact disabled.

Signed-off-by: Modestas Vainius <modestas@vainius.eu>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 92b7252..0216096 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -85,6 +85,9 @@ static void rt2x00lib_stop_link_tuner(struct rt2x00_dev *rt2x00dev)
 
 void rt2x00lib_reset_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
+	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
+		return;
+
 	rt2x00lib_stop_link_tuner(rt2x00dev);
 	rt2x00lib_start_link_tuner(rt2x00dev);
 }
-- 
1.5.3.2

