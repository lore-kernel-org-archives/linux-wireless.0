Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:40897 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754332AbeDJPB6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 11:01:58 -0400
Received: by mail-pf0-f196.google.com with SMTP id y66so8520705pfi.7
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2018 08:01:58 -0700 (PDT)
From: Siva Rebbagondla <siva8118@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Mishra <sushant.mishra@redpinesignals.com>
Subject: [v2 6/7] rsi: enable power save by default for coex
Date: Tue, 10 Apr 2018 20:34:16 +0530
Message-Id: <1523372657-6067-7-git-send-email-siva8118@gmail.com> (sfid-20180410_170204_351483_24C8ABD1)
In-Reply-To: <1523372657-6067-1-git-send-email-siva8118@gmail.com>
References: <1523372657-6067-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Power save is by default enabled for WLAN and BT coex mode.

Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 2a77743..bb497bd 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -2008,6 +2008,9 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	wiphy->iface_combinations = rsi_iface_combinations;
 	wiphy->n_iface_combinations = ARRAY_SIZE(rsi_iface_combinations);
 
+	if (common->coex_mode > 1)
+		wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;
+
 	status = ieee80211_register_hw(hw);
 	if (status)
 		return status;
-- 
2.7.4
