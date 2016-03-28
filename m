Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34030 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbcC1E4J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2016 00:56:09 -0400
Received: by mail-pf0-f194.google.com with SMTP id n5so19126192pfn.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Mar 2016 21:56:09 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/5] staging: wilc1000: change data type of wid argument in wilc_wlan_cfg_set
Date: Mon, 28 Mar 2016 13:55:56 +0900
Message-Id: <1459140960-10645-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160328_065613_863669_C0523735)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes data type of wid argument in wilc_wlan_cfg_set from
u32 to u16. It is better to change data type of wid because wid has one of
enum WID_T that is data type of u16. And, there is no need to use u16
type casting when calling wilc_wlan_cfg_set_wid function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 30e1c03..d09aa3b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1197,7 +1197,7 @@ static int wilc_wlan_cfg_commit(struct wilc_vif *vif, int type,
 	return 0;
 }
 
-int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u32 wid, u8 *buffer,
+int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
 		      u32 buffer_size, int commit, u32 drv_handler)
 {
 	u32 offset;
@@ -1212,7 +1212,7 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u32 wid, u8 *buffer,
 
 	offset = wilc->cfg_frame_offset;
 	ret_size = wilc_wlan_cfg_set_wid(wilc->cfg_frame.frame, offset,
-					 (u16)wid, buffer, buffer_size);
+					 wid, buffer, buffer_size);
 	offset += ret_size;
 	wilc->cfg_frame_offset = offset;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index bcd4bfa..ef70642 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -284,7 +284,7 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count);
 void wilc_handle_isr(struct wilc *wilc);
 void wilc_wlan_cleanup(struct net_device *dev);
-int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u32 wid, u8 *buffer,
+int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
 		      u32 buffer_size, int commit, u32 drv_handler);
 int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u32 wid, int commit,
 		      u32 drv_handler);
-- 
2.7.4

