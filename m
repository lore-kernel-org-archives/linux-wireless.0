Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56277 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZDZONY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2009 10:13:24 -0400
Received: by ewy24 with SMTP id 24so1732512ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 26 Apr 2009 07:13:23 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/5] rt2x00: Fix the interval for rfkill and link_tuner.
Date: Sun, 26 Apr 2009 16:09:11 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
References: <200904261608.30384.IvDoorn@gmail.com> <200904261608.50411.IvDoorn@gmail.com>
In-Reply-To: <200904261608.50411.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200904261609.11447.IvDoorn@gmail.com> (sfid-20090426_161334_139944_9BBDC870)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alban Browaeys <prahal@yahoo.com>

extra parenthesis made the value an argument and the value of the
define empty. This was triggering those very fast.

Signed-off-by: Alban Browaeys <prahal@yahoo.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00lib.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index aa284e4..747178c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -32,8 +32,8 @@
  * Interval defines
  * Both the link tuner as the rfkill will be called once per second.
  */
-#define LINK_TUNE_INTERVAL	( round_jiffies_relative(HZ) )
-#define RFKILL_POLL_INTERVAL	( 1000 )
+#define LINK_TUNE_INTERVAL	round_jiffies_relative(HZ)
+#define RFKILL_POLL_INTERVAL	1000
 
 /*
  * rt2x00_rate: Per rate device information
-- 
1.6.2.3

