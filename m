Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:44117 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbXHSSa2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:30:28 -0400
Received: by nf-out-0910.google.com with SMTP id g13so508819nfb
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:30:27 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/30] rt2x00: Clear all fields on start_link_tune()
Date: Sun, 19 Aug 2007 20:22:11 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192022.11665.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 643e88e4fca8b22d60f718226bede9f033b3e869 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 12:55:02 +0200
Subject: [PATCH 04/30] rt2x00: Clear all fields on start_link_tune()

All variables inside the link structure need to be
cleared when calling start_link_tune().

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00dev.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00dev.c b/drivers/net/wireless/rt2x00dev.c
index 1597d2d..b7191cc 100644
--- a/drivers/net/wireless/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00dev.c
@@ -73,6 +73,10 @@ static void rt2x00_start_link_tune(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->link.avg_rssi = 0;
 	rt2x00dev->link.vgc_level = 0;
 	rt2x00dev->link.false_cca = 0;
+	rt2x00dev->link.rx_success = 0;
+	rt2x00dev->link.rx_failed = 0;
+	rt2x00dev->link.tx_success = 0;
+	rt2x00dev->link.tx_failed = 0;
 
 	/*
 	 * Reset the link tuner.
-- 
1.5.3.rc5

