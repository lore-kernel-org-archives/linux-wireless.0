Return-Path: <SRS0=+qZr=YS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B27CDCA9EA0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Oct 2019 09:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9201D21D71
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Oct 2019 09:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393290AbfJYJeA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Oct 2019 05:34:00 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:50496 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730185AbfJYJd7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Oct 2019 05:33:59 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x9P9XqaG026494, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x9P9XqaG026494
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 25 Oct 2019 17:33:52 +0800
Received: from localhost.localdomain (172.21.68.126) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server id
 14.3.468.0; Fri, 25 Oct 2019 17:33:51 +0800
From:   <yhchuang@realtek.com>
To:     <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <briannorris@chromium.org>,
        <g.schlmm@googlemail.com>
Subject: [PATCH 6/6] rtw88: avoid FW info flood
Date:   Fri, 25 Oct 2019 17:33:45 +0800
Message-ID: <20191025093345.22643-7-yhchuang@realtek.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191025093345.22643-1-yhchuang@realtek.com>
References: <20191025093345.22643-1-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.68.126]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

The FW info was printed everytime driver is powered on, such as
leaving IDLE state. It will flood the kernel log.

Move the FW info printing to callback when FW is loaded, so
that will only be printed once when device is probed.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/rtw88/mac.c  | 17 -----------------
 drivers/net/wireless/realtek/rtw88/main.c | 10 ++++++++++
 2 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index c471117b1472..507970387b2a 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -567,21 +567,6 @@ download_firmware_to_mem(struct rtw_dev *rtwdev, const u8 *data,
 	return 0;
 }
 
-static void update_firmware_info(struct rtw_dev *rtwdev,
-				 struct rtw_fw_state *fw)
-{
-	const struct rtw_fw_hdr *fw_hdr =
-				(const struct rtw_fw_hdr *)fw->firmware->data;
-
-	fw->h2c_version = le16_to_cpu(fw_hdr->h2c_fmt_ver);
-	fw->version = le16_to_cpu(fw_hdr->version);
-	fw->sub_version = fw_hdr->subversion;
-	fw->sub_index = fw_hdr->subindex;
-
-	rtw_info(rtwdev, "Firmware version %u.%u.%u, H2C version %u\n",
-		 fw->version, fw->sub_version, fw->sub_index, fw->h2c_version);
-}
-
 static int
 start_download_firmware(struct rtw_dev *rtwdev, const u8 *data, u32 size)
 {
@@ -698,8 +683,6 @@ int rtw_download_firmware(struct rtw_dev *rtwdev, struct rtw_fw_state *fw)
 	if (ret)
 		goto dlfw_fail;
 
-	update_firmware_info(rtwdev, fw);
-
 	/* reset desc and index */
 	rtw_hci_setup(rtwdev);
 
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index bff8a0b129d9..bace9c583abb 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1025,12 +1025,22 @@ static void rtw_load_firmware_cb(const struct firmware *firmware, void *context)
 {
 	struct rtw_dev *rtwdev = context;
 	struct rtw_fw_state *fw = &rtwdev->fw;
+	const struct rtw_fw_hdr *fw_hdr;
 
 	if (!firmware)
 		rtw_err(rtwdev, "failed to request firmware\n");
 
+	fw_hdr = (const struct rtw_fw_hdr *)firmware->data;
+	fw->h2c_version = le16_to_cpu(fw_hdr->h2c_fmt_ver);
+	fw->version = le16_to_cpu(fw_hdr->version);
+	fw->sub_version = fw_hdr->subversion;
+	fw->sub_index = fw_hdr->subindex;
+
 	fw->firmware = firmware;
 	complete_all(&fw->completion);
+
+	rtw_info(rtwdev, "Firmware version %u.%u.%u, H2C version %u\n",
+		 fw->version, fw->sub_version, fw->sub_index, fw->h2c_version);
 }
 
 static int rtw_load_firmware(struct rtw_dev *rtwdev, const char *fw_name)
-- 
2.17.1

