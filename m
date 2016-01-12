Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34423 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523AbcALAdS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2016 19:33:18 -0500
Received: by mail-pa0-f65.google.com with SMTP id yy13so25138309pab.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jan 2016 16:33:18 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 5/5] staging: wilc1000: remove typedef from struct wilc_cfg_str_t
Date: Tue, 12 Jan 2016 09:32:55 +0900
Message-Id: <1452558775-21532-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20160112_013321_334791_5CD51148)
In-Reply-To: <1452558775-21532-1-git-send-email-chaehyun.lim@gmail.com>
References: <1452558775-21532-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from struct wilc_cfg_str_t and renames it to
wilc_cfg_str.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 2 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 94193b3..068b06d 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -131,7 +131,7 @@ static struct wilc_cfg_word g_cfg_word[] = {
 
 };
 
-static wilc_cfg_str_t g_cfg_str[] = {
+static struct wilc_cfg_str g_cfg_str[] = {
 	{WID_SSID, g_mac.ssid},	/* 33 + 1 bytes */
 	{WID_FIRMWARE_VERSION, g_mac.firmware_version},
 	{WID_OPERATIONAL_RATE_SET, g_mac.supp_rate},
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index f51091e..9b74cc3 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -25,10 +25,10 @@ struct wilc_cfg_word {
 	u32 val;
 };
 
-typedef struct {
+struct wilc_cfg_str {
 	u32 id;
 	u8 *str;
-} wilc_cfg_str_t;
+};
 
 struct wilc;
 int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size);
-- 
2.6.4

