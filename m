Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33949 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756235AbdGLLoX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Jul 2017 07:44:23 -0400
Received: by mail-wr0-f196.google.com with SMTP id k67so5179413wrc.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jul 2017 04:44:23 -0700 (PDT)
Message-ID: <1499859860.2050.5.camel@googlemail.com> (sfid-20170712_134427_793236_A9E16CC2)
Subject: [PATCH] ath9k: fix debugfs file permission
From: Christoph Fritz <chf.fritz@googlemail.com>
Reply-To: chf.fritz@googlemail.com
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date: Wed, 12 Jul 2017 13:44:20 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a trivial debugfs file permission issue. Debugfs
file ack_to has no write function, so S_IWUSR gets purged.

Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index c56e40f..674451a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1405,7 +1405,7 @@ int ath9k_init_debug(struct ath_hw *ah)
 #endif
 
 #ifdef CONFIG_ATH9K_DYNACK
-	debugfs_create_file("ack_to", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
+	debugfs_create_file("ack_to", S_IRUSR, sc->debug.debugfs_phy,
 			    sc, &fops_ackto);
 #endif
 	debugfs_create_file("tpc", S_IRUSR | S_IWUSR,
-- 
2.1.4
