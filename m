Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B34EC282CC
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 12:11:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A2272190C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 12:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfBGMLr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 07:11:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46865 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbfBGMLq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 07:11:46 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1griWs-0007FZ-1p; Thu, 07 Feb 2019 12:11:42 +0000
From:   Colin King <colin.king@canonical.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rsi:  fix indentation issue with a code block
Date:   Thu,  7 Feb 2019 12:11:41 +0000
Message-Id: <20190207121141.28336-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a block of code that is indented at the wrong level. Fix this
with extra tabbing.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index aded1ae4fad5..747d96e14bcd 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -810,15 +810,15 @@ static void rsi_mac80211_bss_info_changed(struct ieee80211_hw *hw,
 		adapter->ps_info.dtim_interval_duration = bss->dtim_period;
 		adapter->ps_info.listen_interval = conf->listen_interval;
 
-	/* If U-APSD is updated, send ps parameters to firmware */
-	if (bss->assoc) {
-		if (common->uapsd_bitmap) {
-			rsi_dbg(INFO_ZONE, "Configuring UAPSD\n");
-			rsi_conf_uapsd(adapter, vif);
+		/* If U-APSD is updated, send ps parameters to firmware */
+		if (bss->assoc) {
+			if (common->uapsd_bitmap) {
+				rsi_dbg(INFO_ZONE, "Configuring UAPSD\n");
+				rsi_conf_uapsd(adapter, vif);
+			}
+		} else {
+			common->uapsd_bitmap = 0;
 		}
-	} else {
-		common->uapsd_bitmap = 0;
-	}
 	}
 
 	if (changed & BSS_CHANGED_CQM) {
-- 
2.20.1

