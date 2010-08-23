Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43999 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab0HWR50 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 13:57:26 -0400
Received: by mail-wy0-f174.google.com with SMTP id 32so7066669wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Aug 2010 10:57:25 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/8] rt2x00: Fix rt2800 retry calculation
Date: Mon, 23 Aug 2010 19:55:01 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201008231953.40629.IvDoorn@gmail.com> <201008231954.22661.IvDoorn@gmail.com> <201008231954.42087.IvDoorn@gmail.com>
In-Reply-To: <201008231954.42087.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008231955.02401.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The retry count for a frame is calculated by the realized MCS rate
subtracting of the requested MCS rate. However during TX done reporting
we accidently override the requested MCS rate with the realized MCS
rate. This causes the retry count to be reset to 0 always, and feeding
invalid rate information into minstrel_ht.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6a0cb2d..d3a5837 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -650,7 +650,6 @@ void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
 		txdesc.flags = 0;
 		rt2x00_desc_read(txwi, 0, &word);
 		mcs = rt2x00_get_field32(word, TXWI_W0_MCS);
-		mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
 		real_mcs = rt2x00_get_field32(reg, TX_STA_FIFO_MCS);
 
 		/*
-- 
1.7.2.1

