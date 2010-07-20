Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35504 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017Ab0GTSaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 14:30:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ivdoorn@gmail.com, gwingerde@gmail.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: correct sparse warning in rt2x00debug.c
Date: Tue, 20 Jul 2010 14:23:47 -0400
Message-Id: <1279650227-11089-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   drivers/net/wireless/rt2x00/rt2x00debug.c
drivers/net/wireless/rt2x00/rt2x00debug.c:193:28: warning: incorrect type in assignment (different base types)
drivers/net/wireless/rt2x00/rt2x00debug.c:193:28:    expected restricted __le32 [usertype] chip_rev
drivers/net/wireless/rt2x00/rt2x00debug.c:193:28:    got restricted __le16 [usertype] <noident>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rt2x00/rt2x00dump.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dump.h b/drivers/net/wireless/rt2x00/rt2x00dump.h
index 6df2e0b..5d6e0b8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dump.h
+++ b/drivers/net/wireless/rt2x00/rt2x00dump.h
@@ -116,7 +116,7 @@ struct rt2x00dump_hdr {
 
 	__le16 chip_rt;
 	__le16 chip_rf;
-	__le32 chip_rev;
+	__le16 chip_rev;
 
 	__le16 type;
 	__u8 queue_index;
-- 
1.7.1.1

