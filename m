Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.183]:37642 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbYGRSl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 14:41:29 -0400
Received: by ik-out-1112.google.com with SMTP id c28so232715ika.5
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2008 11:41:25 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 6/6] rt2x00: Fix GCC warning because aifs is now unsigned
Date: Fri, 18 Jul 2008 20:45:24 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807182043.08990.IvDoorn@gmail.com> <200807182044.45140.IvDoorn@gmail.com> <200807182045.04530.IvDoorn@gmail.com>
In-Reply-To: <200807182045.04530.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807182045.24303.IvDoorn@gmail.com> (sfid-20080718_204131_622021_F7D810A6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The aifs type has recently been changed to unsigned,
this triggered the following gcc warning:

  CC [M]  drivers/net/wireless/rt2x00/rt2x00mac.o
  drivers/net/wireless/rt2x00/rt2x00mac.c: In function 'rt2x00mac_conf_tx':
  drivers/net/wireless/rt2x00/rt2x00mac.c:557: warning: comparison is always true due to limited range of data type

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 77af1df..f1dcbaa 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -554,10 +554,7 @@ int rt2x00mac_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 	else
 		queue->cw_max = 10; /* cw_min: 2^10 = 1024. */
 
-	if (params->aifs >= 0)
-		queue->aifs = params->aifs;
-	else
-		queue->aifs = 2;
+	queue->aifs = params->aifs;
 
 	INFO(rt2x00dev,
 	     "Configured TX queue %d - CWmin: %d, CWmax: %d, Aifs: %d.\n",
-- 
1.5.6.1

