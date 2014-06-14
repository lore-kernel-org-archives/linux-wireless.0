Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63189 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbaFNNwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2014 09:52:50 -0400
Received: by mail-pa0-f46.google.com with SMTP id eu11so3013064pac.5
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2014 06:52:50 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id iz2sm8991708pbb.95.2014.06.14.06.52.48
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sat, 14 Jun 2014 06:52:49 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/16] rsi: Lower level debug messages and changed handling of confirm received for rsi_program_bb_rf().
Date: Sat, 14 Jun 2014 19:22:40 +0530
Message-Id: <1402753960-14074-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140614_155253_225795_16B44D13)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lower level debug messages for some frames and changed confirm
received for rsi_program_bb_rf() to a valid case.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index f5182cd..92f584e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1153,7 +1153,7 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 				common->fsm_state = FSM_EEPROM_READ_MAC_ADDR;
 			}
 		} else {
-			rsi_dbg(ERR_ZONE,
+			rsi_dbg(INFO_ZONE,
 				"%s: Received bootup params cfm in %d state\n",
 				 __func__, common->fsm_state);
 			return 0;
@@ -1216,7 +1216,7 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 					__func__);
 			}
 		} else {
-			rsi_dbg(ERR_ZONE,
+			rsi_dbg(INFO_ZONE,
 				"%s: Received radio caps cfm in %d state\n",
 				 __func__, common->fsm_state);
 			return 0;
@@ -1234,7 +1234,10 @@ static int rsi_handle_ta_confirm_type(struct rsi_common *common,
 				return rsi_mac80211_attach(common);
 			}
 		} else {
-			goto out;
+			rsi_dbg(INFO_ZONE,
+				"%s: Received bbb_rf cfm in %d state\n",
+				 __func__, common->fsm_state);
+			return 0;
 		}
 		break;
 
-- 
1.7.1

