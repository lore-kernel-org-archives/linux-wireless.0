Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36920 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751719AbdHCOzz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 10:55:55 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, ath9k-devel@qca.qualcomm.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] ath9k: make ath_ps_ops structures as const
Date: Thu,  3 Aug 2017 20:25:31 +0530
Message-Id: <1501772131-13038-1-git-send-email-bhumirks@gmail.com> (sfid-20170803_165627_850912_4F6AD55A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath_ps_ops structures are only stored as a reference in the ps_ops
field of a ath_common structure. This field is of type const, so make
the structures as const.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 2 +-
 drivers/net/wireless/ath/ath9k/init.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index defacc6..da2164b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -71,7 +71,7 @@ static void ath9k_htc_op_ps_restore(struct ath_common *common)
 	ath9k_htc_ps_restore((struct ath9k_htc_priv *) common->priv);
 }
 
-static struct ath_ps_ops ath9k_htc_ps_ops = {
+static const struct ath_ps_ops ath9k_htc_ps_ops = {
 	.wakeup = ath9k_htc_op_ps_wakeup,
 	.restore = ath9k_htc_op_ps_restore,
 };
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index fd9a618..bb79360 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -104,7 +104,7 @@ static void ath9k_op_ps_restore(struct ath_common *common)
 	ath9k_ps_restore((struct ath_softc *) common->priv);
 }
 
-static struct ath_ps_ops ath9k_ps_ops = {
+static const struct ath_ps_ops ath9k_ps_ops = {
 	.wakeup = ath9k_op_ps_wakeup,
 	.restore = ath9k_op_ps_restore,
 };
-- 
1.9.1
