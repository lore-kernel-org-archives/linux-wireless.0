Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38125 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab1F2Pdd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 11:33:33 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2011 08:32:56 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <rodrigue@qca.qualcomm.com>, <senthilb@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC] ath9k: Add a module param to enable paprd
Date: Wed, 29 Jun 2011 21:03:26 +0530
Message-ID: <1309361606-5949-1-git-send-email-mshajakhan@atheros.com> (sfid-20110629_173339_544125_EE38234D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

PAPRD is currently disabled and this is purely an RFC patch (or) for
testing alone, we don't like this to be in our driver

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath.h        |    1 +
 drivers/net/wireless/ath/ath9k/hw.c   |    3 ++-
 drivers/net/wireless/ath/ath9k/init.c |    5 +++++
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 17c4b56..1157231 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -162,6 +162,7 @@ struct ath_common {
 
 	bool btcoex_enabled;
 	bool disable_ani;
+	bool paprd_enabled;
 };
 
 struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 07827b5..c938ab6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -361,6 +361,7 @@ static bool ath9k_hw_chip_test(struct ath_hw *ah)
 
 static void ath9k_hw_init_config(struct ath_hw *ah)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	int i;
 
 	ah->config.dma_beacon_response_time = 2;
@@ -380,7 +381,7 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	}
 
 	/* PAPRD needs some more work to be enabled */
-	ah->config.paprd_disable = 1;
+	ah->config.paprd_disable = !common->paprd_enabled;
 
 	ah->config.rx_intr_mitigation = true;
 	ah->config.pcieSerDesWrite = true;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 50103b2..1271a3c 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -42,6 +42,10 @@ static int ath9k_btcoex_enable;
 module_param_named(btcoex_enable, ath9k_btcoex_enable, int, 0444);
 MODULE_PARM_DESC(btcoex_enable, "Enable wifi-BT coexistence");
 
+static int ath9k_paprd_enable;
+module_param_named(paprd_enable, ath9k_paprd_enable, int, 0444);
+MODULE_PARM_DESC(paprd_enable, "Enable PAPRD feature");
+
 bool is_ath9k_unloaded;
 /* We use the hw_value as an index into our private channel structure */
 
@@ -586,6 +590,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	common->priv = sc;
 	common->debug_mask = ath9k_debug;
 	common->btcoex_enabled = ath9k_btcoex_enable == 1;
+	common->paprd_enabled = ath9k_paprd_enable;
 	common->disable_ani = false;
 	spin_lock_init(&common->cc_lock);
 
-- 
1.7.0.4

