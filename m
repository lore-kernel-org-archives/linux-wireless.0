Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35127 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab2KZQGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 11:06:04 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so3507268wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 08:06:04 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 04/11] wlcore/wl18xx: allow TX BA on all TIDs
Date: Mon, 26 Nov 2012 18:05:43 +0200
Message-Id: <1353945950-3899-5-git-send-email-arik@wizery.com> (sfid-20121126_170614_713736_3FFFBC54)
In-Reply-To: <1353945950-3899-1-git-send-email-arik@wizery.com>
References: <1353945950-3899-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

In 12xx cards a FW limitation prevents us from from starting TX BA
sessions on TIDs 6/7. This restriction does not exist for 18xx cards.
Enable TX BA on all TIDs for them

[Arik - split Tx BA parameter between chip families. Don't change this
setting for 12xx]

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c |    2 +-
 drivers/net/wireless/ti/wl18xx/main.c |    2 +-
 drivers/net/wireless/ti/wlcore/conf.h |    3 ---
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 17ee0fd..032a639 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -293,7 +293,7 @@ static struct wlcore_conf wl12xx_conf = {
 		.rx_ba_win_size = 8,
 		.tx_ba_win_size = 64,
 		.inactivity_timeout = 10000,
-		.tx_ba_tid_bitmap = CONF_TX_BA_ENABLED_TID_BITMAP,
+		.tx_ba_tid_bitmap = 0x3f,
 	},
 	/*
 	 * Memory config for wl127x chips is given in the
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index c616c21..5e81d9c 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -420,7 +420,7 @@ static struct wlcore_conf wl18xx_conf = {
 		.rx_ba_win_size = 32,
 		.tx_ba_win_size = 64,
 		.inactivity_timeout = 10000,
-		.tx_ba_tid_bitmap = CONF_TX_BA_ENABLED_TID_BITMAP,
+		.tx_ba_tid_bitmap = 0xff,
 	},
 	.mem = {
 		.num_stations                 = 1,
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index c9de4d5..e0695e9 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -561,9 +561,6 @@ struct conf_tx_ac_category {
 
 #define CONF_TX_MAX_TID_COUNT 8
 
-/* Allow TX BA on all TIDs but 6,7. These are currently reserved in the FW */
-#define CONF_TX_BA_ENABLED_TID_BITMAP 0x3F
-
 enum {
 	CONF_CHANNEL_TYPE_DCF = 0,   /* DC/LEGACY*/
 	CONF_CHANNEL_TYPE_EDCF = 1,  /* EDCA*/
-- 
1.7.9.5

