Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48138 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab0HQTrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 15:47:24 -0400
Received: by ewy23 with SMTP id 23so3304201ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Aug 2010 12:47:23 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 3/4] wl1251: fix beacon filter table structure
Date: Tue, 17 Aug 2010 22:46:54 +0300
Message-Id: <1282074415-6168-4-git-send-email-notasas@gmail.com>
In-Reply-To: <1282074415-6168-1-git-send-email-notasas@gmail.com>
References: <1282074415-6168-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The beacon filter table configuration ACX structure had certain elements
reversed, fix it to match TI driver.

Based on wl1271 patch 1937e742639c03a6fe77239c3003ce9602302117 by
Juuso Oikarinen.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl12xx/wl1251_acx.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.h b/drivers/net/wireless/wl12xx/wl1251_acx.h
index 9864124..a8845b8 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.h
@@ -459,8 +459,8 @@ struct acx_beacon_filter_ie_table {
 	struct acx_header header;
 
 	u8 num_ie;
-	u8 table[BEACON_FILTER_TABLE_MAX_SIZE];
 	u8 pad[3];
+	u8 table[BEACON_FILTER_TABLE_MAX_SIZE];
 } __packed;
 
 #define SYNCH_FAIL_DEFAULT_THRESHOLD    10     /* number of beacons */
-- 
1.5.6.3

