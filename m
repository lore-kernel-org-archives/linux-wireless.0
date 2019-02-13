Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E916C282CE
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 14:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E0A62075D
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 14:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550066806;
	bh=Qspvit2uW6KFUNIXNiQB8n4IK+v1A3RzNnsQVOOFWSo=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=XVsWR4erAOlLJOiBiwSLQwHqkbiDQRub/LrOjzZELkY7qGrOwC/0z2xTwwcFvQqrN
	 UoPff2bI/Kd9FG/D7vsNNV73uIRan3QMeJ7EbZa/46Azweo0jqBYPQUrSgqVXNIgGg
	 sWkOZElt3FXm8zi3d56NX/qEm5PrzAo2zPab4k08=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391560AbfBMOGo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 09:06:44 -0500
Received: from mail.stusta.mhn.de ([141.84.69.5]:55134 "EHLO
        mail.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729622AbfBMOGo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 09:06:44 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2019 09:06:42 EST
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.stusta.mhn.de (Postfix) with ESMTPSA id 4401Np2PW5z3K;
        Wed, 13 Feb 2019 14:59:38 +0100 (CET)
From:   Adrian Bunk <bunk@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH net] mwifiex: Fix NL80211_TX_POWER_LIMITED
Date:   Wed, 13 Feb 2019 15:59:38 +0200
Message-Id: <20190213135938.13664-1-bunk@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

NL80211_TX_POWER_LIMITED was treated as NL80211_TX_POWER_AUTOMATIC,
which is the opposite of what should happen and can cause nasty
regulatory problems.

if/else converted to a switch without default to make gcc warn
on unhandled enum values.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

I tried to follow the conventions used inside this driver for
variable types, dbm_min is u16 like dbm.
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c  | 13 +++++++++++--
 drivers/net/wireless/marvell/mwifiex/ioctl.h     |  1 +
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 11 +++++++----
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 1467af22e394..9ef0fc108641 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -376,11 +376,20 @@ mwifiex_cfg80211_set_tx_power(struct wiphy *wiphy,
 	struct mwifiex_power_cfg power_cfg;
 	int dbm = MBM_TO_DBM(mbm);
 
-	if (type == NL80211_TX_POWER_FIXED) {
+	switch (type) {
+	case NL80211_TX_POWER_FIXED:
 		power_cfg.is_power_auto = 0;
+		power_cfg.is_power_fixed = 1;
 		power_cfg.power_level = dbm;
-	} else {
+		break;
+	case NL80211_TX_POWER_LIMITED:
+		power_cfg.is_power_auto = 0;
+		power_cfg.is_power_fixed = 0;
+		power_cfg.power_level = dbm;
+		break;
+	case NL80211_TX_POWER_AUTOMATIC:
 		power_cfg.is_power_auto = 1;
+		break;
 	}
 
 	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
diff --git a/drivers/net/wireless/marvell/mwifiex/ioctl.h b/drivers/net/wireless/marvell/mwifiex/ioctl.h
index 48e154e1865d..0dd592ea6e83 100644
--- a/drivers/net/wireless/marvell/mwifiex/ioctl.h
+++ b/drivers/net/wireless/marvell/mwifiex/ioctl.h
@@ -267,6 +267,7 @@ struct mwifiex_ds_encrypt_key {
 
 struct mwifiex_power_cfg {
 	u32 is_power_auto;
+	u32 is_power_fixed;
 	u32 power_level;
 };
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index b454b5f85503..ebc0e41e5d3b 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -688,6 +688,9 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 	txp_cfg = (struct host_cmd_ds_txpwr_cfg *) buf;
 	txp_cfg->action = cpu_to_le16(HostCmd_ACT_GEN_SET);
 	if (!power_cfg->is_power_auto) {
+		u16 dbm_min = power_cfg->is_power_fixed ?
+			      dbm : priv->min_tx_power_level;
+
 		txp_cfg->mode = cpu_to_le32(1);
 		pg_tlv = (struct mwifiex_types_power_group *)
 			 (buf + sizeof(struct host_cmd_ds_txpwr_cfg));
@@ -702,7 +705,7 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 		pg->last_rate_code = 0x03;
 		pg->modulation_class = MOD_CLASS_HR_DSSS;
 		pg->power_step = 0;
-		pg->power_min = (s8) dbm;
+		pg->power_min = (s8) dbm_min;
 		pg->power_max = (s8) dbm;
 		pg++;
 		/* Power group for modulation class OFDM */
@@ -710,7 +713,7 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 		pg->last_rate_code = 0x07;
 		pg->modulation_class = MOD_CLASS_OFDM;
 		pg->power_step = 0;
-		pg->power_min = (s8) dbm;
+		pg->power_min = (s8) dbm_min;
 		pg->power_max = (s8) dbm;
 		pg++;
 		/* Power group for modulation class HTBW20 */
@@ -718,7 +721,7 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 		pg->last_rate_code = 0x20;
 		pg->modulation_class = MOD_CLASS_HT;
 		pg->power_step = 0;
-		pg->power_min = (s8) dbm;
+		pg->power_min = (s8) dbm_min;
 		pg->power_max = (s8) dbm;
 		pg->ht_bandwidth = HT_BW_20;
 		pg++;
@@ -727,7 +730,7 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 		pg->last_rate_code = 0x20;
 		pg->modulation_class = MOD_CLASS_HT;
 		pg->power_step = 0;
-		pg->power_min = (s8) dbm;
+		pg->power_min = (s8) dbm_min;
 		pg->power_max = (s8) dbm;
 		pg->ht_bandwidth = HT_BW_40;
 	}
-- 
2.11.0

