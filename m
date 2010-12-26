Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63361 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab0LZT5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 14:57:07 -0500
Received: by bwz15 with SMTP id 15so9183393bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Dec 2010 11:57:05 -0800 (PST)
Message-Id: <E1PWwiD-0003TF-Qt@debian64.daheim>
Subject: [PATCH 2/3] carl9170: reduce channel change delay
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Felix <ic.felix@gmail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 26 Dec 2010 18:22:16 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By removing two "safety" msleeps (and an echo nop), the
channel change delay is effectively halved. Previously,
the delay could be as long as 260 ms and the device
could not go off-channel without risking to miss the
next DTIM beacon [interval ~307 ms].

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Hi Felix,

It seems that removing the msleeps doesn't have ANY negative effect
on the operation. Furthermore ath9k doesn't need the 20ms+ msleeps
in the phy codepaths either. So, I wonder if this is just some old
"safety" buffers which survived otus and ar9170usb development
phases, or is there some merit to them?

Regards,
	Chr
---
 drivers/net/wireless/ath/carl9170/phy.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index 122e75e..b6b0de6 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -1029,8 +1029,6 @@ static int carl9170_init_rf_bank4_pwr(struct ar9170 *ar, bool band5ghz,
 	if (err)
 		return err;
 
-	msleep(20);
-
 	return 0;
 }
 
@@ -1660,12 +1658,6 @@ int carl9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 			return err;
 
 		cmd = CARL9170_CMD_RF_INIT;
-
-		msleep(100);
-
-		err = carl9170_echo_test(ar, 0xaabbccdd);
-		if (err)
-			return err;
 	} else {
 		cmd = CARL9170_CMD_FREQUENCY;
 	}
-- 
1.7.2.3

