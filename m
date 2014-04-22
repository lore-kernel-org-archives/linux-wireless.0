Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:44351 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbaDVAK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 20:10:28 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so3953541eek.22
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2014 17:10:27 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Pavel Machek <pavel@ucw.cz>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
	David Gnedt <david.gnedt@davizone.at>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 3/4] wl1251: fix mixed up args for join
Date: Tue, 22 Apr 2014 03:09:54 +0300
Message-Id: <1398125395-5579-4-git-send-email-notasas@gmail.com> (sfid-20140422_021038_155370_54AADAB4)
In-Reply-To: <1398125395-5579-1-git-send-email-notasas@gmail.com>
References: <1398125395-5579-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The join arguments are mixed up, passing beacon_interval instead of
channel and channel instead of beacon_interval. Fix them.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/ti/wl1251/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index f557eb5..4e782f1 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -1226,8 +1226,8 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 		if (ret < 0)
 			goto out_sleep;
 
-		ret = wl1251_join(wl, wl->bss_type, wl->beacon_int,
-				  wl->channel, wl->dtim_period);
+		ret = wl1251_join(wl, wl->bss_type, wl->channel,
+				  wl->beacon_int, wl->dtim_period);
 
 		if (ret < 0)
 			goto out_sleep;
-- 
1.7.9.5

