Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:59706 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaDBEAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2014 00:00:15 -0400
Received: by mail-pa0-f43.google.com with SMTP id bj1so10854730pad.16
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2014 21:00:15 -0700 (PDT)
From: Fariya Fatima <fariyaf@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Fariya Fatima <fariyaf@gmail.com>
Subject: [PATCH 2/6] rsi: Fixed signedness bug reported by static code analyzer.
Date: Wed,  2 Apr 2014 09:29:51 +0530
Message-Id: <1396411195-5051-3-git-send-email-fariyaf@gmail.com> (sfid-20140402_060022_181822_EA016B14)
In-Reply-To: <1396411195-5051-1-git-send-email-fariyaf@gmail.com>
References: <1396411195-5051-1-git-send-email-fariyaf@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fariya Fatima <fariyaf@gmail.com>

Signed-off-by: Fariya Fatima <fariyaf@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 2361a68..7369429 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -738,7 +738,7 @@ int rsi_hal_load_key(struct rsi_common *common,
  *
  * Return: 0 on success, corresponding error code on failure.
  */
-static u8 rsi_load_bootup_params(struct rsi_common *common)
+static int rsi_load_bootup_params(struct rsi_common *common)
 {
 	struct sk_buff *skb;
 	struct rsi_boot_params *boot_params;
@@ -1272,6 +1272,7 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
 {
 	s32 msg_len = (le16_to_cpu(*(__le16 *)&msg[0]) & 0x0fff);
 	u16 msg_type = (msg[2]);
+	int ret;
 
 	rsi_dbg(FSM_ZONE, "%s: Msg Len: %d, Msg Type: %4x\n",
 		__func__, msg_len, msg_type);
@@ -1284,8 +1285,9 @@ int rsi_mgmt_pkt_recv(struct rsi_common *common, u8 *msg)
 		if (common->fsm_state == FSM_CARD_NOT_READY) {
 			rsi_set_default_parameters(common);
 
-			if (rsi_load_bootup_params(common))
-				return -ENOMEM;
+			ret = rsi_load_bootup_params(common);
+			if (ret)
+				return ret;
 			else
 				common->fsm_state = FSM_BOOT_PARAMS_SENT;
 		} else {
-- 
1.7.5.4

