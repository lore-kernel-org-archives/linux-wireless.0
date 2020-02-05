Return-Path: <SRS0=U5kn=3Z=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D24C35249
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Feb 2020 07:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94F692085B
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Feb 2020 07:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgBEHJN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Feb 2020 02:09:13 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:49345 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgBEHJL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Feb 2020 02:09:11 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 015796oQ008617, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTEXMB06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 015796oQ008617
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 5 Feb 2020 15:09:06 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 5 Feb 2020 15:09:05 +0800
Received: from RTEXMB06.realtek.com.tw (172.21.6.99) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 5 Feb 2020 15:09:05 +0800
Received: from RTITCASV01.realtek.com.tw (172.21.6.18) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_0, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.1.1779.2
 via Frontend Transport; Wed, 5 Feb 2020 15:09:05 +0800
Received: from localhost.localdomain (172.21.69.117) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.468.0; Wed, 5 Feb 2020 15:09:05 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <briannorris@chromium.org>
Subject: [PATCH 4/7] rtw88: move rtw_enter_ips() to the last when config
Date:   Wed, 5 Feb 2020 15:08:55 +0800
Message-ID: <20200205070858.15386-5-yhchuang@realtek.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200205070858.15386-1-yhchuang@realtek.com>
References: <20200205070858.15386-1-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.69.117]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

When driver is coming up, mac80211 will set changed as ~0 (0xffffffff),
and driver could enter IDLE state (power off) before switching channel or
other config event. So move rtw_enter_ips() to the last, to make sure the
driver completed the config events before going to IDLE state.

So, moves leave/enter IPS config to be first/last one according to flag
IEEE80211_CONF_IDLE. If there're more configureations we want to add in
the future, they must locate between leave/enter IPS.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 6fc33e11d08c..8742b3f2b5c1 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -75,15 +75,12 @@ static int rtw_ops_config(struct ieee80211_hw *hw, u32 changed)
 
 	rtw_leave_lps_deep(rtwdev);
 
-	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
-		if (hw->conf.flags & IEEE80211_CONF_IDLE) {
-			rtw_enter_ips(rtwdev);
-		} else {
-			ret = rtw_leave_ips(rtwdev);
-			if (ret) {
-				rtw_err(rtwdev, "failed to leave idle state\n");
-				goto out;
-			}
+	if ((changed & IEEE80211_CONF_CHANGE_IDLE) &&
+	    !(hw->conf.flags & IEEE80211_CONF_IDLE)) {
+		ret = rtw_leave_ips(rtwdev);
+		if (ret) {
+			rtw_err(rtwdev, "failed to leave idle state\n");
+			goto out;
 		}
 	}
 
@@ -99,6 +96,10 @@ static int rtw_ops_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL)
 		rtw_set_channel(rtwdev);
 
+	if ((changed & IEEE80211_CONF_CHANGE_IDLE) &&
+	    (hw->conf.flags & IEEE80211_CONF_IDLE))
+		rtw_enter_ips(rtwdev);
+
 out:
 	mutex_unlock(&rtwdev->mutex);
 	return ret;
-- 
2.17.1

