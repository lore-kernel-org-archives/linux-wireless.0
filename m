Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FFFC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 03:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 398C520815
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 03:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbeLTDzg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 22:55:36 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:16171 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728228AbeLTDzg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 22:55:36 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9AEEF21421C9A;
        Thu, 20 Dec 2018 11:55:32 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.408.0; Thu, 20 Dec 2018
 11:55:28 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <plaes@plaes.org>,
        <kvalo@codeaurora.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] brcm80211: remove set but not used variables 'phybw40, maxtargetpwr'
Date:   Thu, 20 Dec 2018 11:55:22 +0800
Message-ID: <20181220035522.10640-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:1202:5: warning: variable 'phybw40' set but not used [-Wunused-but-set-variable]
drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:4625:5: warning: variable 'phybw40' set but not used [-Wunused-but-set-variable]
drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:4834:5: warning: variable 'phybw40' set but not used [-Wunused-but-set-variable]

drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:3085:17: warning: variable 'maxtargetpwr' set but not used [-Wunused-but-set-variable]
drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:4215:17: warning: variable 'maxtargetpwr' set but not used [-Wunused-but-set-variable]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 .../net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c  | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
index e78a93a..c6e107f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -1199,8 +1199,6 @@ wlc_lcnphy_rx_iq_est(struct brcms_phy *pi,
 {
 	int wait_count = 0;
 	bool result = true;
-	u8 phybw40;
-	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
 
 	mod_phy_reg(pi, 0x6da, (0x1 << 5), (1) << 5);
 
@@ -3082,7 +3080,7 @@ static void wlc_lcnphy_tx_pwr_ctrl_init(struct brcms_phy_pub *ppi)
 	u8 bbmult;
 	struct phytbl_info tab;
 	s32 a1, b0, b1;
-	s32 tssi, pwr, maxtargetpwr, mintargetpwr;
+	s32 tssi, pwr, mintargetpwr;
 	bool suspend;
 	struct brcms_phy *pi = container_of(ppi, struct brcms_phy, pubpi_ro);
 
@@ -3119,7 +3117,6 @@ static void wlc_lcnphy_tx_pwr_ctrl_init(struct brcms_phy_pub *ppi)
 		b0 = pi->txpa_2g[0];
 		b1 = pi->txpa_2g[1];
 		a1 = pi->txpa_2g[2];
-		maxtargetpwr = wlc_lcnphy_tssi2dbm(10, a1, b0, b1);
 		mintargetpwr = wlc_lcnphy_tssi2dbm(125, a1, b0, b1);
 
 		tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
@@ -4212,7 +4209,7 @@ static void wlc_lcnphy_periodic_cal(struct brcms_phy *pi)
 	s8 index;
 	struct phytbl_info tab;
 	s32 a1, b0, b1;
-	s32 tssi, pwr, maxtargetpwr, mintargetpwr;
+	s32 tssi, pwr, mintargetpwr;
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	pi->phy_lastcal = pi->sh->now;
@@ -4249,7 +4246,6 @@ static void wlc_lcnphy_periodic_cal(struct brcms_phy *pi)
 		b0 = pi->txpa_2g[0];
 		b1 = pi->txpa_2g[1];
 		a1 = pi->txpa_2g[2];
-		maxtargetpwr = wlc_lcnphy_tssi2dbm(10, a1, b0, b1);
 		mintargetpwr = wlc_lcnphy_tssi2dbm(125, a1, b0, b1);
 
 		tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
@@ -4622,13 +4618,10 @@ static void wlc_lcnphy_radio_init(struct brcms_phy *pi)
 static void wlc_lcnphy_tbl_init(struct brcms_phy *pi)
 {
 	uint idx;
-	u8 phybw40;
 	struct phytbl_info tab;
 	const struct phytbl_info *tb;
 	u32 val;
 
-	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
-
 	for (idx = 0; idx < dot11lcnphytbl_info_sz_rev0; idx++)
 		wlc_lcnphy_write_table(pi, &dot11lcnphytbl_info_rev0[idx]);
 
@@ -4831,9 +4824,7 @@ static void wlc_lcnphy_baseband_init(struct brcms_phy *pi)
 
 void wlc_phy_init_lcnphy(struct brcms_phy *pi)
 {
-	u8 phybw40;
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
-	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
 
 	pi_lcn->lcnphy_cal_counter = 0;
 	pi_lcn->lcnphy_cal_temper = pi_lcn->lcnphy_rawtempsense;
-- 
2.7.0


