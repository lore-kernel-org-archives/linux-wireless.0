Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:55730 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbXGYUs3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 16:48:29 -0400
Received: by ug-out-1314.google.com with SMTP id j3so420021ugf
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 13:48:28 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/11] rt2x00: Check permissions on debugfs write
Date: Wed, 25 Jul 2007 22:49:56 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707252249.56238.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 0eb031ef356c30c766966b4321808934c2667625 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Fri, 20 Jul 2007 16:36:42 +0200
Subject: [PATCH 01/11] rt2x00: Check permissions on debugfs write

When writing to the registers through debugfs
the capabilities should be checked for CAP_NET_ADMIN.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c
index cb61870..e99d783 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00debug.c
@@ -152,6 +152,9 @@ static ssize_t rt2x00debug_file_write(void *device, const char __user *buf,
 	int size;
 	char *line;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	line = kzalloc(length, GFP_KERNEL);
 	if (!line)
 		return -ENOMEM;
-- 
1.5.2.2

