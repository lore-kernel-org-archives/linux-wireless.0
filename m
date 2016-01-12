Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36766 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523AbcALAdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2016 19:33:09 -0500
Received: by mail-pa0-f67.google.com with SMTP id a20so20042498pag.3
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jan 2016 16:33:09 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/5] staging: wilc1000: remove typedef from struct wilc_cfg_byte_t
Date: Tue, 12 Jan 2016 09:32:52 +0900
Message-Id: <1452558775-21532-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160112_013313_391887_CA7C4523)
In-Reply-To: <1452558775-21532-1-git-send-email-chaehyun.lim@gmail.com>
References: <1452558775-21532-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from struct wilc_cfg_byte_t and renames it to
wilc_cfg_byte.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 2 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index b72c77b..54b394c 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -44,7 +44,7 @@ typedef struct {
 
 static wilc_mac_cfg_t g_mac;
 
-static wilc_cfg_byte_t g_cfg_byte[] = {
+static struct wilc_cfg_byte g_cfg_byte[] = {
 	{WID_BSS_TYPE, 0},
 	{WID_CURRENT_TX_RATE, 0},
 	{WID_CURRENT_CHANNEL, 0},
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index 5f74eb8..d978615 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -10,10 +10,10 @@
 #ifndef WILC_WLAN_CFG_H
 #define WILC_WLAN_CFG_H
 
-typedef struct {
+struct wilc_cfg_byte {
 	u16 id;
 	u16 val;
-} wilc_cfg_byte_t;
+};
 
 typedef struct {
 	u16 id;
-- 
2.6.4

