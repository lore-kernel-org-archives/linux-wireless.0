Return-Path: <SRS0=/cM4=X3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BE8ECE595
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Oct 2019 02:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03A7620B7C
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Oct 2019 02:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbfJBCbn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Oct 2019 22:31:43 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:46016 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729789AbfJBCbn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Oct 2019 22:31:43 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x922VcHv031861, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x922VcHv031861
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 2 Oct 2019 10:31:38 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.468.0; Wed, 2 Oct 2019 10:31:37 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <briannorris@chromium.org>
Subject: [PATCH v2 09/12] rtw88: not to enter LPS by coex strategy
Date:   Wed, 2 Oct 2019 10:31:25 +0800
Message-ID: <20191002023128.12090-10-yhchuang@realtek.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191002023128.12090-1-yhchuang@realtek.com>
References: <20191002023128.12090-1-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.126]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Sometimes LPS is not compatible with COEX's strategy, and
COEX will not allow driver to enter it.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---

v1 -> v2
  - rebase on top of wireless-drivers-next

 drivers/net/wireless/realtek/rtw88/ps.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/ps.c b/drivers/net/wireless/realtek/rtw88/ps.c
index 4b5774687d21..1661cc2e5fe3 100644
--- a/drivers/net/wireless/realtek/rtw88/ps.c
+++ b/drivers/net/wireless/realtek/rtw88/ps.c
@@ -191,6 +191,9 @@ void rtw_enter_lps(struct rtw_dev *rtwdev, u8 port_id)
 {
 	lockdep_assert_held(&rtwdev->mutex);
 
+	if (rtwdev->coex.stat.wl_force_lps_ctrl)
+		return;
+
 	__rtw_enter_lps(rtwdev, port_id);
 	__rtw_enter_lps_deep(rtwdev);
 }
-- 
2.17.1

