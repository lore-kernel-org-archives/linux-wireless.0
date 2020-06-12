Return-Path: <SRS0=YkEg=7Z=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F38F0C433DF
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Jun 2020 08:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D882D207D8
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Jun 2020 08:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgFLI2F (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Jun 2020 04:28:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55173 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbgFLI2F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Jun 2020 04:28:05 -0400
Received: from [111.196.61.134] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <aaron.ma@canonical.com>)
        id 1jjf2Y-0001kT-7U; Fri, 12 Jun 2020 08:27:55 +0000
From:   Aaron Ma <aaron.ma@canonical.com>
To:     aaron.ma@canonical.com, yhchuang@realtek.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rtw88: 8822ce: add support for device ID 0xc82f
Date:   Fri, 12 Jun 2020 16:27:45 +0800
Message-Id: <20200612082745.204400-1-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

New device ID 0xc82f found on Lenovo ThinkCenter.
Tested it with c822 driver, works good.

PCI id:
03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd.
Device [10ec:c82f]
        Subsystem: Lenovo Device [17aa:c02f]

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822ce.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822ce.c b/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
index 7b6bd990651e..026ac49ce6e3 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
@@ -11,6 +11,10 @@ static const struct pci_device_id rtw_8822ce_id_table[] = {
 		PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0xC822),
 		.driver_data = (kernel_ulong_t)&rtw8822c_hw_spec
 	},
+	{
+		PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0xC82F),
+		.driver_data = (kernel_ulong_t)&rtw8822c_hw_spec
+	},
 	{}
 };
 MODULE_DEVICE_TABLE(pci, rtw_8822ce_id_table);
-- 
2.27.0

