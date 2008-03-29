Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:34450 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbYC2O7z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Mar 2008 10:59:55 -0400
Received: by fg-out-1718.google.com with SMTP id l27so828502fgb.17
        for <linux-wireless@vger.kernel.org>; Sat, 29 Mar 2008 07:59:54 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Invert scheduled packet_filter check
Date: Sat, 29 Mar 2008 15:59:01 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Bas Hulsken <bhulsken@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803291559.01882.IvDoorn@gmail.com> (sfid-20080329_145959_837281_2E10E7A1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Invert the check for scheduling the packet_filter configuration.
When DRIVER_REQUIRE_SCHEDULED is not set we should immediately
configure the the filter.

This fixes the 'infinite calls to rt2x00mc_configure_filter'
bug reported by Bas Hulsken.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 7063743..5131767 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -423,9 +423,9 @@ void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 	rt2x00dev->packet_filter = *total_flags;
 
 	if (!test_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags))
-		queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->filter_work);
-	else
 		rt2x00dev->ops->lib->config_filter(rt2x00dev, *total_flags);
+	else
+		queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->filter_work);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_configure_filter);
 
-- 
1.5.4.4

