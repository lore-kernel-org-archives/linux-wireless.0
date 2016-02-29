Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34356 "EHLO
	mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbcB2BIY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2016 20:08:24 -0500
Received: by mail-qk0-f194.google.com with SMTP id u128so4851341qkh.1
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2016 17:08:24 -0800 (PST)
Received: from hash ([2001:470:1d:6db:230:48ff:fe9d:9c89])
        by smtp.gmail.com with ESMTPSA id e11sm9977607qkb.39.2016.02.28.17.08.22
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Feb 2016 17:08:22 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/3] ath9k: fix a misleading indentation
Date: Sun, 28 Feb 2016 20:07:56 -0500
Message-Id: <1456708077-19652-2-git-send-email-me@bobcopeland.com> (sfid-20160229_020830_107044_6B74C25C)
In-Reply-To: <1456708077-19652-1-git-send-email-me@bobcopeland.com>
References: <1456708077-19652-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These lines belong inside the if-statement above, not in the
main body of the switch.

Found by smatch.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 201425e7f9cb..3e011f84211f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1332,11 +1332,11 @@ skip_ws_det:
 				chan->channel,
 				aniState->mrcCCK ? "on" : "off",
 				is_on ? "on" : "off");
-		if (is_on)
-			ah->stats.ast_ani_ccklow++;
-		else
-			ah->stats.ast_ani_cckhigh++;
-		aniState->mrcCCK = is_on;
+			if (is_on)
+				ah->stats.ast_ani_ccklow++;
+			else
+				ah->stats.ast_ani_cckhigh++;
+			aniState->mrcCCK = is_on;
 		}
 	break;
 	}
-- 
2.6.1

