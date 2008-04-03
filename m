Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:18672 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093AbYDCWBR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 18:01:17 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1524999nfb.21
        for <linux-wireless@vger.kernel.org>; Thu, 03 Apr 2008 15:01:15 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH] rt2x00: Use lib->config_filter() during scheduled packet filter config
Date: Fri, 4 Apr 2008 00:01:43 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804040001.43596.IvDoorn@gmail.com> (sfid-20080403_230119_963572_B69A653E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now rt2x00lib handles the initial configure_filter() command, we can
directly call lib->config_filter() in scheduled context since the
called function will no longer check if anything has changed (which is
now handled in rt2x00lib as well).

This fixes a endless loop with USB drivers where the config_filter
command was scheduled time and time again without sending any command
to the device.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 50ea7bd..0361524 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -404,18 +404,8 @@ static void rt2x00lib_packetfilter_scheduled(struct work_struct *work)
 {
 	struct rt2x00_dev *rt2x00dev =
 	    container_of(work, struct rt2x00_dev, filter_work);
-	unsigned int filter = rt2x00dev->packet_filter;
 
-	/*
-	 * Since we had stored the filter inside rt2x00dev->packet_filter,
-	 * we should now clear that field. Otherwise the driver will
-	 * assume nothing has changed (*total_flags will be compared
-	 * to rt2x00dev->packet_filter to determine if any action is required).
-	 */
-	rt2x00dev->packet_filter = 0;
-
-	rt2x00dev->ops->hw->configure_filter(rt2x00dev->hw,
-					     filter, &filter, 0, NULL);
+	rt2x00dev->ops->lib->config_filter(rt2x00dev, rt2x00dev->packet_filter);
 }
 
 static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
-- 
1.5.4.5

