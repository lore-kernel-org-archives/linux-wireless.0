Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34934 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbcC1E4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2016 00:56:12 -0400
Received: by mail-pf0-f193.google.com with SMTP id u190so19204933pfb.2
        for <linux-wireless@vger.kernel.org>; Sun, 27 Mar 2016 21:56:12 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/5] staging: wilc1000: change data type of wid argument in wilc_wlan_cfg_get
Date: Mon, 28 Mar 2016 13:55:57 +0900
Message-Id: <1459140960-10645-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160328_065615_382941_F8BE9BF7)
In-Reply-To: <1459140960-10645-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459140960-10645-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes data type of wid argument in wilc_wlan_cfg_get from
u32 to u16. It is better to change data type of wid because wid has one
of enum WID_T that is data type of u16. And, there is no need to use u16
type casting when calling wilc_wlan_cfg_get_wid function.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 5 ++---
 drivers/staging/wilc1000/wilc_wlan.h | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index d09aa3b..db79ae2 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1239,7 +1239,7 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
 	return ret_size;
 }
 
-int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u32 wid, int commit,
+int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u16 wid, int commit,
 		      u32 drv_handler)
 {
 	u32 offset;
@@ -1253,8 +1253,7 @@ int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u32 wid, int commit,
 		wilc->cfg_frame_offset = 0;
 
 	offset = wilc->cfg_frame_offset;
-	ret_size = wilc_wlan_cfg_get_wid(wilc->cfg_frame.frame, offset,
-					 (u16)wid);
+	ret_size = wilc_wlan_cfg_get_wid(wilc->cfg_frame.frame, offset, wid);
 	offset += ret_size;
 	wilc->cfg_frame_offset = offset;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index ef70642..38edeeb 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -286,7 +286,7 @@ void wilc_handle_isr(struct wilc *wilc);
 void wilc_wlan_cleanup(struct net_device *dev);
 int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
 		      u32 buffer_size, int commit, u32 drv_handler);
-int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u32 wid, int commit,
+int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u16 wid, int commit,
 		      u32 drv_handler);
 int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size);
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
-- 
2.7.4

