Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 080FDC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA9A3222A4
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 08:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731177AbfBNI7l (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:59:41 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:39600 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730476AbfBNI7k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 03:59:40 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1E8xLib005871, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1E8xLib005871
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Thu, 14 Feb 2019 16:59:21 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.408.0; Thu, 14 Feb 2019 16:59:20 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>, <johannes@sipsolutions.net>
CC:     <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <tehuang@realtek.com>,
        <briannorris@chromium.org>, <sgruszka@redhat.com>
Subject: [PATCH v2 12/24] rtw88: add module param to switch lps supportability
Date:   Thu, 14 Feb 2019 16:58:51 +0800
Message-ID: <1550134743-17443-13-git-send-email-yhchuang@realtek.com>
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

The module parameter is added to turn on/off lps support. And the
default value is "N". It is because that lps is not compatible with
bt-coexistence, WOW/PNO and the calibration routines for now.

After trade lps support off against these functionalities, it is
reasonable to set the parameter default to "N".

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 5b2be74..233871e 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -13,11 +13,14 @@
 #include "efuse.h"
 #include "debug.h"
 
+static bool rtw_fw_support_lps;
 unsigned int rtw_debug_mask;
 EXPORT_SYMBOL(rtw_debug_mask);
 
+module_param_named(support_lps, rtw_fw_support_lps, bool, 0644);
 module_param_named(debug_mask, rtw_debug_mask, uint, 0644);
 
+MODULE_PARM_DESC(support_lps, "Set Y to enable LPS support");
 MODULE_PARM_DESC(debug_mask, "Debugging mask");
 
 static struct ieee80211_channel rtw_channeltable_2g[] = {
@@ -165,7 +168,8 @@ static void rtw_watch_dog_work(struct work_struct *work)
 	 * more than two stations associated to the AP, then we can not enter
 	 * lps, because fw does not handle the overlapped beacon interval
 	 */
-	if (data.rtwvif && !data.active && data.assoc_cnt == 1)
+	if (rtw_fw_support_lps &&
+	    data.rtwvif && !data.active && data.assoc_cnt == 1)
 		rtw_enter_lps(rtwdev, data.rtwvif);
 
 	if (rtw_flag_check(rtwdev, RTW_FLAG_SCANNING))
-- 
2.7.4

