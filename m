Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44255 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbeGPODp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jul 2018 10:03:45 -0400
Received: by mail-pg1-f194.google.com with SMTP id r1-v6so7515951pgp.11
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jul 2018 06:36:16 -0700 (PDT)
From: Siva Rebbagondla <siva8118@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Amol Hanwate <amol.hanwate@redpinesignals.com>
Subject: [PATCH 3/6] rsi: add firmware support for AP+BT dual mode
Date: Mon, 16 Jul 2018 19:09:34 +0530
Message-Id: <1531748377-29215-4-git-send-email-siva8118@gmail.com> (sfid-20180716_153619_285530_53B48064)
In-Reply-To: <1531748377-29215-1-git-send-email-siva8118@gmail.com>
References: <1531748377-29215-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

Currently, AP mode will work on only WLAN alone firmware. To give support
for AP and BT dual mode, adding firmware entry in 'struct ta_metadata'.
The firmware entry is based on what coex_mode is used in driver and coex
mode '4' for all AP+BT related functionalities. Hence, added the same.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 150c3e6..27e6baf 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -26,6 +26,9 @@ static struct ta_metadata metadata_flash_content[] = {
 	{"flash_content", 0x00010000},
 	{"rsi/rs9113_wlan_qspi.rps", 0x00010000},
 	{"rsi/rs9113_wlan_bt_dual_mode.rps", 0x00010000},
+	{"flash_content", 0x00010000},
+	{"rsi/rs9113_ap_bt_dual_mode.rps", 0x00010000},
+
 };
 
 int rsi_send_pkt_to_bus(struct rsi_common *common, struct sk_buff *skb)
-- 
2.5.5
