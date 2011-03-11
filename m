Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:58086 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab1CKAWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 19:22:45 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/4] mwifiex: remove unused macros
Date: Thu, 10 Mar 2011 16:25:49 -0800
Message-Id: <1299803149-25996-4-git-send-email-bzhao@marvell.com>
In-Reply-To: <1299803149-25996-1-git-send-email-bzhao@marvell.com>
References: <1299803149-25996-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MWIFIEX_MIN_SSID_LENGTH is never used.
MWIFIEX_MAX_SSID_LENGTH can be replaced by
IEEE80211_MAX_SSID_LEN

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/debugfs.c |    2 +-
 drivers/net/wireless/mwifiex/main.h    |    4 ----
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 6207f6b..eec43b3 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -1949,7 +1949,7 @@ mwifiex_passphrase_write(struct file *file,
 			ret = -EINVAL;
 			break;
 		} else if (!strnicmp(opt, "ssid", strlen(opt))) {
-			if (strlen(end) > MWIFIEX_MAX_SSID_LENGTH) {
+			if (strlen(end) > IEEE80211_MAX_SSID_LEN) {
 				dev_err(priv->adapter->dev, "SSID length "
 						"exceeds max length\n");
 				ret = -EFAULT;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index f85f2ea..79cf048 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -132,10 +132,6 @@ struct mwifiex_drv_mode {
 
 #define MAX_BITMAP_RATES_SIZE			10
 
-#define MWIFIEX_MAX_SSID_LENGTH					32
-
-#define MWIFIEX_MIN_SSID_LENGTH					1
-
 #define MAX_CHANNEL_BAND_BG     14
 
 #define MAX_FREQUENCY_BAND_BG   2484
-- 
1.7.0.2

