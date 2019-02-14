Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E072C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 09:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5526F222A4
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 09:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730699AbfBNJAA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 04:00:00 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:39563 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728448AbfBNI7c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 03:59:32 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1E8xEsa005830, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1E8xEsa005830
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 14 Feb 2019 16:59:14 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 14 Feb 2019 16:59:13 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>, <johannes@sipsolutions.net>
CC:     <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>
Subject: [PATCH v2 03/24] rtw88: can not support vif beacon filter actually
Date:   Thu, 14 Feb 2019 16:58:42 +0800
Message-ID: <1550134743-17443-4-git-send-email-yhchuang@realtek.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
References: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.126]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Hardwares suuported by rtw88 are not able to support vif beacon filter.
Reporting this confuses mac80211's connection monitor mechanism.
Leave the beacon check for mac80211, and it will decide to trigger
keep-alive when beacons missed.

Otherwise the connection monitor can only rely on the data packets, and
the corresponding timer is set to 30 seconds, which is too long.
If we let mac80211 count the beacon, the connection can be detected in
seven TUs.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 39529af..66b2b02 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -121,7 +121,6 @@ static int rtw_ops_add_interface(struct ieee80211_hw *hw,
 	u32 config = 0;
 	u8 port = 0;
 
-	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
 	rtwvif->port = port;
 	rtwvif->vif = vif;
 	rtwvif->stats.tx_unicast = 0;
-- 
2.7.4

