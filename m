Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33046 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbcBAM1A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 07:27:00 -0500
Received: by mail-pf0-f196.google.com with SMTP id x125so7540154pfb.0
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2016 04:27:00 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/11] staging: wilc1000: linux_mon: use __packed instead of __attribute__((packed))
Date: Mon,  1 Feb 2016 21:26:37 +0900
Message-Id: <1454329607-9486-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160201_132705_452557_985710C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the following checkpatch warning:
WARNING: __packed is preferred over __attribute__((packed))

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_mon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index e550027..284dfb0 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -15,14 +15,14 @@
 struct wilc_wfi_radiotap_hdr {
 	struct ieee80211_radiotap_header hdr;
 	u8 rate;
-} __attribute__((packed));
+} __packed;
 
 struct wilc_wfi_radiotap_cb_hdr {
 	struct ieee80211_radiotap_header hdr;
 	u8 rate;
 	u8 dump;
 	u16 tx_flags;
-} __attribute__((packed));
+} __packed;
 
 static struct net_device *wilc_wfi_mon; /* global monitor netdev */
 
-- 
2.7.0

