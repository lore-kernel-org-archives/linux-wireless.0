Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:32891 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523AbcALAdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2016 19:33:12 -0500
Received: by mail-pf0-f193.google.com with SMTP id e65so4187192pfe.0
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jan 2016 16:33:12 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/5] staging: wilc1000: remove typedef from struct wilc_cfg_hword_t
Date: Tue, 12 Jan 2016 09:32:53 +0900
Message-Id: <1452558775-21532-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160112_013316_616565_80A3059C)
In-Reply-To: <1452558775-21532-1-git-send-email-chaehyun.lim@gmail.com>
References: <1452558775-21532-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from struct wilc_cfg_hword_t and renames it
to wilc_cfg_hword.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 2 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 54b394c..003f2af 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -87,7 +87,7 @@ static struct wilc_cfg_byte g_cfg_byte[] = {
 	{WID_NIL, 0}
 };
 
-static wilc_cfg_hword_t g_cfg_hword[] = {
+static struct wilc_cfg_hword g_cfg_hword[] = {
 	{WID_LINK_LOSS_THRESHOLD, 0},
 	{WID_RTS_THRESHOLD, 0},
 	{WID_FRAG_THRESHOLD, 0},
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index d978615..aed7b80 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -15,10 +15,10 @@ struct wilc_cfg_byte {
 	u16 val;
 };
 
-typedef struct {
+struct wilc_cfg_hword {
 	u16 id;
 	u16 val;
-} wilc_cfg_hword_t;
+};
 
 typedef struct {
 	u32 id;
-- 
2.6.4

