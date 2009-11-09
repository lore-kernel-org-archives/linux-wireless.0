Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:61771 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201AbZKIV4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 16:56:10 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Gertjan van Wingerde <gwingerde@wingerd.gvw.nl>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 6/9] rt2x00: Fix typo in rf programming of rt2800lib.
Date: Mon,  9 Nov 2009 22:55:51 +0100
Message-Id: <1257803751-5265-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@wingerd.gvw.nl>

Fix a type in rt2800_config_channel_rt3x. The second write to RF register 2 should be to RF register 3.
This is confirmed by the legacy Ralink code.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 24b3af4..2c91c44 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -774,7 +774,7 @@ static void rt2800_config_channel_rt3x(struct rt2x00_dev *rt2x00dev,
 	u8 rfcsr;
 
 	rt2800_rfcsr_write(rt2x00dev, 2, rf->rf1);
-	rt2800_rfcsr_write(rt2x00dev, 2, rf->rf3);
+	rt2800_rfcsr_write(rt2x00dev, 3, rf->rf3);
 
 	rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR6_R, rf->rf2);
-- 
1.6.5.2

