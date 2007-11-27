Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.189]:38808 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbXK0TmA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 14:42:00 -0500
Received: by mu-out-0910.google.com with SMTP id i10so1396181mue
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 11:41:58 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/11] rt2x00: Remove redundant code in rfkill setup
Date: Tue, 27 Nov 2007 21:51:39 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200711272146.53518.IvDoorn@gmail.com>
In-Reply-To: <200711272146.53518.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711272151.39293.IvDoorn@gmail.com> (sfid-20071127_194249_299022_9C4E0DE8)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>

In rt2x00rfkill.c, routine input_allocate_device() is called even though
input_allocate_polled_device(), which was just called, includes a call to
that routine. This patch, which has not been tested, removes the redundant code.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index bbbf51d..7439637 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -136,12 +136,6 @@ int rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->poll_dev->poll = rt2x00rfkill_poll;
 	rt2x00dev->poll_dev->poll_interval = RFKILL_POLL_INTERVAL;
 
-	rt2x00dev->poll_dev->input = input_allocate_device();
-	if (!rt2x00dev->poll_dev->input) {
-		ERROR(rt2x00dev, "Failed to allocate input device.\n");
-		goto exit_free_polldev;
-	}
-
 	rt2x00dev->poll_dev->input->name = rt2x00dev->ops->name;
 	rt2x00dev->poll_dev->input->phys = wiphy_name(rt2x00dev->hw->wiphy);
 	rt2x00dev->poll_dev->input->id.bustype = BUS_HOST;
-- 
1.5.3.6

