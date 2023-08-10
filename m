Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481BFC001E0
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Aug 2023 14:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235680AbjHJOwm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Aug 2023 10:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbjHJOwl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Aug 2023 10:52:41 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE5E2694
        for <linux-wireless@vger.kernel.org>; Thu, 10 Aug 2023 07:52:40 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RM8xD70CLzTmd4;
        Thu, 10 Aug 2023 22:50:40 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 10 Aug
 2023 22:52:37 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <toke@toke.dk>, <kvalo@kernel.org>,
        <christophe.jaillet@wanadoo.fr>, <yuehaibing@huawei.com>
CC:     <linux-wireless@vger.kernel.org>
Subject: [PATCH] wifi: ath9k: Remove unused declarations
Date:   Thu, 10 Aug 2023 22:52:22 +0800
Message-ID: <20230810145222.34364-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Commit b57ba3b2f7b0 ("ath9k: move ath9k_reload_chainmask_settings to common")
removed the implementation ath9k_reload_chainmask_settings() but not the declaration.
Also commit 978f78bf7137 ("ath9k_hw: Move bt_stomp to hw from common.") left behind
ath9k_cmn_btcoex_bt_stomp() declaration.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  | 1 -
 drivers/net/wireless/ath/ath9k/common.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 2cc23605c9fc..668fc07b3073 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -1129,7 +1129,6 @@ void ath_restart_work(struct ath_softc *sc);
 int ath9k_init_device(u16 devid, struct ath_softc *sc,
 		    const struct ath_bus_ops *bus_ops);
 void ath9k_deinit_device(struct ath_softc *sc);
-void ath9k_reload_chainmask_settings(struct ath_softc *sc);
 u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate);
 void ath_start_rfkill_poll(struct ath_softc *sc);
 void ath9k_rfkill_poll_state(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index f0ab6f9955e4..12204cf86fcf 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -85,8 +85,6 @@ struct ath9k_channel *ath9k_cmn_get_channel(struct ieee80211_hw *hw,
 					    struct ath_hw *ah,
 					    struct cfg80211_chan_def *chandef);
 int ath9k_cmn_count_streams(unsigned int chainmask, int max);
-void ath9k_cmn_btcoex_bt_stomp(struct ath_common *common,
-				  enum ath_stomp_type stomp_type);
 void ath9k_cmn_update_txpow(struct ath_hw *ah, u16 cur_txpow,
 			    u16 new_txpow, u16 *txpower);
 void ath9k_cmn_init_crypto(struct ath_hw *ah);
-- 
2.34.1

