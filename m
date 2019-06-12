Return-Path: <SRS0=e4fn=UL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A1AC31E46
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Jun 2019 06:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AFDB20874
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Jun 2019 06:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731224AbfFLGpc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Jun 2019 02:45:32 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:51293 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727443AbfFLGpc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Jun 2019 02:45:32 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x5C6jSH5004348, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x5C6jSH5004348
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 12 Jun 2019 14:45:28 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.439.0; Wed, 12 Jun 2019 14:45:27 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/11] rtw88: add support for random mac scan
Date:   Wed, 12 Jun 2019 14:45:08 +0800
Message-ID: <1560321917-17751-3-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560321917-17751-1-git-send-email-yhchuang@realtek.com>
References: <1560321917-17751-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.126]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When driver uses random mac address to scan, the unicast probe response
will not be received because the addr1 is not matched. Configure port
address by requested mac address to receive probe response from AP.

To support random mac scan, we need to configure the mac address during
scan period to receive unicast prop_resp. After scan is completed,
configure the mac address back to the original one that the port used.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c | 19 +++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/main.c     |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index abded63..61436bb 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -446,20 +446,39 @@ static void rtw_ops_sw_scan_start(struct ieee80211_hw *hw,
 {
 	struct rtw_dev *rtwdev = hw->priv;
 	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
+	u32 config = 0;
 
 	rtw_leave_lps(rtwdev, rtwvif);
 
+	mutex_lock(&rtwdev->mutex);
+
+	ether_addr_copy(rtwvif->mac_addr, mac_addr);
+	config |= PORT_SET_MAC_ADDR;
+	rtw_vif_port_config(rtwdev, rtwvif, config);
+
 	rtw_flag_set(rtwdev, RTW_FLAG_DIG_DISABLE);
 	rtw_flag_set(rtwdev, RTW_FLAG_SCANNING);
+
+	mutex_unlock(&rtwdev->mutex);
 }
 
 static void rtw_ops_sw_scan_complete(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif)
 {
 	struct rtw_dev *rtwdev = hw->priv;
+	struct rtw_vif *rtwvif = (struct rtw_vif *)vif->drv_priv;
+	u32 config = 0;
+
+	mutex_lock(&rtwdev->mutex);
 
 	rtw_flag_clear(rtwdev, RTW_FLAG_SCANNING);
 	rtw_flag_clear(rtwdev, RTW_FLAG_DIG_DISABLE);
+
+	ether_addr_copy(rtwvif->mac_addr, vif->addr);
+	config |= PORT_SET_MAC_ADDR;
+	rtw_vif_port_config(rtwdev, rtwvif, config);
+
+	mutex_unlock(&rtwdev->mutex);
 }
 
 const struct ieee80211_ops rtw_ops = {
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index d2e8d2e..306d799 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1178,6 +1178,8 @@ int rtw_register_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw)
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
 			    WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
 
+	hw->wiphy->features |= NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
+
 	rtw_set_supported_band(hw, rtwdev->chip);
 	SET_IEEE80211_PERM_ADDR(hw, rtwdev->efuse.addr);
 
-- 
2.7.4

