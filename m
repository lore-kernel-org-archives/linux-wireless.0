Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36339 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523AbcALAdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2016 19:33:15 -0500
Received: by mail-pf0-f194.google.com with SMTP id n128so4171444pfn.3
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jan 2016 16:33:15 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/5] staging: wilc1000: remove typedef from struct wilc_cfg_word_t
Date: Tue, 12 Jan 2016 09:32:54 +0900
Message-Id: <1452558775-21532-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20160112_013319_015497_3E731E44)
In-Reply-To: <1452558775-21532-1-git-send-email-chaehyun.lim@gmail.com>
References: <1452558775-21532-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from struct wilc_cfg_word_t and renames it to
wilc_cfg_word.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 2 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 003f2af..94193b3 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -108,7 +108,7 @@ static struct wilc_cfg_hword g_cfg_hword[] = {
 	{WID_NIL, 0}
 };
 
-static wilc_cfg_word_t g_cfg_word[] = {
+static struct wilc_cfg_word g_cfg_word[] = {
 	{WID_FAILED_COUNT, 0},
 	{WID_RETRY_COUNT, 0},
 	{WID_MULTIPLE_RETRY_COUNT, 0},
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index aed7b80..f51091e 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -20,10 +20,10 @@ struct wilc_cfg_hword {
 	u16 val;
 };
 
-typedef struct {
+struct wilc_cfg_word {
 	u32 id;
 	u32 val;
-} wilc_cfg_word_t;
+};
 
 typedef struct {
 	u32 id;
-- 
2.6.4

