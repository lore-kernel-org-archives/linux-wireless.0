Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63520 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab0JBJfb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:31 -0400
Received: by mail-wy0-f174.google.com with SMTP id 28so3658520wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:31 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/20] rt2x00: add field definitions for the TBTT_SYNC_CFG register
Date: Sat, 2 Oct 2010 11:31:05 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com> <201010021130.20755.IvDoorn@gmail.com> <201010021130.43811.IvDoorn@gmail.com>
In-Reply-To: <201010021130.43811.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021131.06386.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index f02ea12..4930d29 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -710,8 +710,14 @@
 
 /*
  * TBTT_SYNC_CFG:
+ * BCN_AIFSN: Beacon AIFSN after TBTT interrupt in slots
+ * BCN_CWMIN: Beacon CWMin after TBTT interrupt in slots
  */
 #define TBTT_SYNC_CFG			0x1118
+#define TBTT_SYNC_CFG_TBTT_ADJUST	FIELD32(0x000000ff)
+#define TBTT_SYNC_CFG_BCN_EXP_WIN	FIELD32(0x0000ff00)
+#define TBTT_SYNC_CFG_BCN_AIFSN		FIELD32(0x000f0000)
+#define TBTT_SYNC_CFG_BCN_CWMIN		FIELD32(0x00f00000)
 
 /*
  * TSF_TIMER_DW0: Local lsb TSF timer, read-only
-- 
1.7.2.3

