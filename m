Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9143C04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 07:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93FA320851
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 07:18:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93FA320851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbeLEHSD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 02:18:03 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:37343 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726820AbeLEHSA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 02:18:00 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CC4C8777999D8;
        Wed,  5 Dec 2018 15:17:57 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.408.0; Wed, 5 Dec 2018 15:17:53 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Priit Laes <plaes@plaes.org>,
        Kees Cook <keescook@chromium.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] b43: remove set but not used variables 'tx_pwr_state,tmp2'
Date:   Wed, 5 Dec 2018 07:26:06 +0000
Message-ID: <1543994766-7057-1-git-send-email-yuehaibing@huawei.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/broadcom/b43/phy_n.c: In function 'b43_nphy_op_recalc_txpower':
drivers/net/wireless/broadcom/b43/phy_n.c:5898:7: warning:
 variable 'tx_pwr_state' set but not used [-Wunused-but-set-variable]

drivers/net/wireless/broadcom/b43/phy_n.c:6047:20: warning:
 variable 'tmp2' set but not used [-Wunused-but-set-variable]

'tx_pwr_state' never used since introduction in commit
8615eb2870f1 ("b43: N-PHY: support setting custom TX power")

'tmp2' not used any more since commit c002831a07dd ("b43: N-PHY: use helper
for checking IPA")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/broadcom/b43/phy_n.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index 7d30036..77d7cd5 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -5895,7 +5895,6 @@ static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
 	struct ieee80211_channel *channel = dev->wl->hw->conf.chandef.chan;
 	struct b43_ppr *ppr = &nphy->tx_pwr_max_ppr;
 	u8 max; /* qdBm */
-	bool tx_pwr_state;
 
 	if (nphy->tx_pwr_last_recalc_freq == channel->center_freq &&
 	    nphy->tx_pwr_last_recalc_limit == phy->desired_txpower)
@@ -5931,7 +5930,6 @@ static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
 	b43_ppr_apply_min(dev, ppr, INT_TO_Q52(8));
 
 	/* Apply */
-	tx_pwr_state = nphy->txpwrctrl;
 	b43_mac_suspend(dev);
 	b43_nphy_tx_power_ctl_setup(dev);
 	if (dev->dev->core_rev == 11 || dev->dev->core_rev == 12) {
@@ -6044,7 +6042,6 @@ static int b43_phy_initn(struct b43_wldev *dev)
 	u8 tx_pwr_state;
 	struct nphy_txgains target;
 	u16 tmp;
-	enum nl80211_band tmp2;
 	bool do_rssi_cal;
 
 	u16 clip[2];
@@ -6138,7 +6135,6 @@ static int b43_phy_initn(struct b43_wldev *dev)
 		b43_phy_write(dev, B43_NPHY_DUP40_BL, 0x9A4);
 	}
 
-	tmp2 = b43_current_band(dev->wl);
 	if (b43_nphy_ipa(dev)) {
 		b43_phy_set(dev, B43_NPHY_PAPD_EN0, 0x1);
 		b43_phy_maskset(dev, B43_NPHY_EPS_TABLE_ADJ0, 0x007F,



