Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f196.google.com ([209.85.212.196]:36022 "EHLO
	mail-wi0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbbJXWbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2015 18:31:55 -0400
From: Punit Vara <punitvara@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Punit Vara <punitvara@gmail.com>
Subject: [PATCH 1/3] staging: wilc1000: Remove reference preceded by free
Date: Sun, 25 Oct 2015 04:01:23 +0530
Message-Id: <1445725885-25995-2-git-send-email-punitvara@gmail.com> (sfid-20151025_003249_660830_F0F771C2)
In-Reply-To: <1445725885-25995-1-git-send-email-punitvara@gmail.com>
References: <1445725885-25995-1-git-send-email-punitvara@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is to the wilc_wfi_cfgoperations.c file that fixes up
following error reported by coccicheck:

ERROR: reference preceded by free on line 1219

For (params->seq_len) <= 0 memory is already freed when
(params->seq_len) >0 then memory was alloted. So there is no need to use
kfree whenever params->seq_len <=0 remove it and place kfree inside
(params->seq_len) >0 condition.

Signed-off-by: Punit Vara <punitvara@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index bcbf1bd..9b3cf04 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1216,11 +1216,10 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 				priv->wilc_ptk[key_index]->key = kmalloc(params->key_len, GFP_KERNEL);
 
-				kfree(priv->wilc_ptk[key_index]->seq);
-
-				if ((params->seq_len) > 0)
+				if ((params->seq_len) > 0) {
+					kfree(priv->wilc_ptk[key_index]->seq);
 					priv->wilc_ptk[key_index]->seq = kmalloc(params->seq_len, GFP_KERNEL);
-
+				}
 				if (INFO) {
 					for (i = 0; i < params->key_len; i++)
 						PRINT_INFO(CFG80211_DBG, "Adding pairwise key value[%d] = %x\n", i, params->key[i]);
-- 
2.5.3

