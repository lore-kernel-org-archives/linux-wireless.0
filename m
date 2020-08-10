Return-Path: <SRS0=Pq/w=BU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5035C433E0
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Aug 2020 19:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C092F22B47
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Aug 2020 19:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597088002;
	bh=kbuDP+M988482p05npem60kQat8V2wwECI9KCrdipsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Od5FRvk3/POlBp2XLmttS9DdXx4vMufkuWjJ9PKVbXCZIkfj/tA5+qLHYOB0z9PXa
	 9Fc8T2AUv5qROCLo8usnzWmze0F5O9Ho8jLTVISIouaSLYiTLd6Bk7nEFMAO0ovWcg
	 /XR5TWFB9QQSQSP0iS09kmfwq5MctSOal7Ia1FJs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgHJTJX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Aug 2020 15:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728450AbgHJTJW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Aug 2020 15:09:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB94B20885;
        Mon, 10 Aug 2020 19:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086561;
        bh=kbuDP+M988482p05npem60kQat8V2wwECI9KCrdipsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdL2u9HTyI7Wj7FnOt8JHS9nu+WRm2UGykaxf20TSXurVwivfRdsxTbme0Y13CTR0
         WzkqX9Si3LG7x7k8LMByN68ORPgm3V9LllobXUuR4vvvYTWkC/ZhHHhgzBGSbD0ts0
         i3WXxmRggozCwOtzy5GSpSaef7mu/2smAOfJtceA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aaron Ma <aaron.ma@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 16/64] rtw88: 8822ce: add support for device ID 0xc82f
Date:   Mon, 10 Aug 2020 15:08:11 -0400
Message-Id: <20200810190859.3793319-16-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810190859.3793319-1-sashal@kernel.org>
References: <20200810190859.3793319-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Aaron Ma <aaron.ma@canonical.com>

[ Upstream commit 7d428b1c9ffc9ddcdd64c6955836bbb17a233ef3 ]

New device ID 0xc82f found on Lenovo ThinkCenter.
Tested it with c822 driver, works good.

PCI id:
03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd.
Device [10ec:c82f]
        Subsystem: Lenovo Device [17aa:c02f]

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200612082745.204400-1-aaron.ma@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8822ce.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822ce.c b/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
index 7b6bd990651e1..026ac49ce6e3c 100644
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
2.25.1

