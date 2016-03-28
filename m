Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:33601 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbcC1E4P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2016 00:56:15 -0400
Received: by mail-pa0-f68.google.com with SMTP id q6so13798323pav.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Mar 2016 21:56:15 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/5] staging: wilc1000: change data type of wid argument in wilc_wlan_cfg_get_val
Date: Mon, 28 Mar 2016 13:55:58 +0900
Message-Id: <1459140960-10645-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160328_065618_555135_7D479D56)
In-Reply-To: <1459140960-10645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459140960-10645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes data type of wid argument in wilc_wlan_cfg_get_val
from u32 to u16. It is better to change data type of wid because wid has
one of enum WID_T that is data type of u16. And, there is no need to use
u16 type casting when calling wilc_wlan_cfg_get_wid_value function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index db79ae2..7da3b4a 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1276,9 +1276,9 @@ int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u16 wid, int commit,
 	return ret_size;
 }
 
-int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size)
+int wilc_wlan_cfg_get_val(u16 wid, u8 *buffer, u32 buffer_size)
 {
-	return wilc_wlan_cfg_get_wid_value((u16)wid, buffer, buffer_size);
+	return wilc_wlan_cfg_get_wid_value(wid, buffer, buffer_size);
 }
 
 int wilc_send_config_pkt(struct wilc_vif *vif, u8 mode, struct wid *wids,
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 38edeeb..30e5312 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -288,7 +288,7 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
 		      u32 buffer_size, int commit, u32 drv_handler);
 int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u16 wid, int commit,
 		      u32 drv_handler);
-int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size);
+int wilc_wlan_cfg_get_val(u16 wid, u8 *buffer, u32 buffer_size);
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			       u32 buffer_size, wilc_tx_complete_func_t func);
 void wilc_chip_sleep_manually(struct wilc *wilc);
-- 
2.7.4

