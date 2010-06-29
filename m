Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38772 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab0F2TvZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:51:25 -0400
Received: by mail-ew0-f46.google.com with SMTP id 23so2589ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:51:24 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 21/21] rt2x00: Fix compile warning when debug disabled
Date: Tue, 29 Jun 2010 21:49:50 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com> <201006292149.06304.IvDoorn@gmail.com> <201006292149.27751.IvDoorn@gmail.com>
In-Reply-To: <201006292149.27751.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292149.51654.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

CC [M]  drivers/net/wireless/rt2x00/rt2800lib.o
drivers/net/wireless/rt2x00/rt2800lib.c: In function 'rt2800_ampdu_action':
drivers/net/wireless/rt2x00/rt2800lib.c:2821: warning: unused variable 'rt2x00dev'

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index f813b43..d3cf0cc 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2769,7 +2769,6 @@ static int rt2800_ampdu_action(struct ieee80211_hw *hw,
 			       struct ieee80211_sta *sta,
 			       u16 tid, u16 *ssn)
 {
-	struct rt2x00_dev *rt2x00dev = hw->priv;
 	int ret = 0;
 
 	switch (action) {
@@ -2787,7 +2786,7 @@ static int rt2800_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		break;
 	default:
-		WARNING(rt2x00dev, "Unknown AMPDU action\n");
+		WARNING((struct rt2x00_dev *)hw->priv, "Unknown AMPDU action\n");
 	}
 
 	return ret;
-- 
1.6.6.1

