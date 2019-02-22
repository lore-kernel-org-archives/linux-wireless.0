Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 941EAC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F4A620700
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfBVOVi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:21:38 -0500
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:46067 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727015AbfBVOVg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 09:21:36 -0500
X-IronPort-AV: E=Sophos;i="5.58,400,1544482800"; 
   d="scan'208";a="2017381"
Received: from ironmsg02-ams.qualcomm.com ([10.251.56.3])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 22 Feb 2019 15:21:30 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9174"; a="7285587"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg02-ams.qualcomm.com with ESMTP; 22 Feb 2019 15:21:30 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 14/21] wil6210: use OEM MAC address from OTP
Date:   Fri, 22 Feb 2019 16:21:12 +0200
Message-Id: <1550845279-16103-15-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
References: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

In addition to existing MAC address field in OTP, new field added for
OEM MAC address.
wil6210 gives precedence to the new OEM MAC address and will use it if
its valid.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/main.c    | 21 +++++++++++++++------
 drivers/net/wireless/ath/wil6210/wil6210.h |  1 +
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 6a6bfb3..b69d9a2 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1413,13 +1413,22 @@ static int wil_get_otp_info(struct wil6210_priv *wil)
 	u8 mac[8];
 	int mac_addr;
 
-	if (wil->hw_version >= HW_VER_TALYN_MB)
-		mac_addr = RGF_OTP_MAC_TALYN_MB;
-	else
-		mac_addr = RGF_OTP_MAC;
+	/* OEM MAC has precedence */
+	mac_addr = RGF_OTP_OEM_MAC;
+	wil_memcpy_fromio_32(mac, wil->csr + HOSTADDR(mac_addr), sizeof(mac));
+
+	if (is_valid_ether_addr(mac)) {
+		wil_info(wil, "using OEM MAC %pM\n", mac);
+	} else {
+		if (wil->hw_version >= HW_VER_TALYN_MB)
+			mac_addr = RGF_OTP_MAC_TALYN_MB;
+		else
+			mac_addr = RGF_OTP_MAC;
+
+		wil_memcpy_fromio_32(mac, wil->csr + HOSTADDR(mac_addr),
+				     sizeof(mac));
+	}
 
-	wil_memcpy_fromio_32(mac, wil->csr + HOSTADDR(mac_addr),
-			     sizeof(mac));
 	if (!is_valid_ether_addr(mac)) {
 		wil_err(wil, "Invalid MAC %pM\n", mac);
 		return -EINVAL;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index de72466..9d7e02e 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -367,6 +367,7 @@ struct RGF_ICR {
 	#define REVISION_ID_SPARROW_D0	(0x3)
 
 #define RGF_OTP_MAC_TALYN_MB		(0x8a0304)
+#define RGF_OTP_OEM_MAC			(0x8a0334)
 #define RGF_OTP_MAC			(0x8a0620)
 
 /* Talyn-MB */
-- 
1.9.1

