Return-Path: <SRS0=GVYC=2A=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE28C2D0BF
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Dec 2019 21:04:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4956C24680
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Dec 2019 21:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576011876;
	bh=CaIEzmNLIk68AeBJAIRs1D9WJLu/79Hwl/RZzyzBKEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Ny6UqGUcEKDZOSCyQQPX7tTI0h6b/NjMTuyoDlysEj2yd11/X00J/0iB6JrXAleTU
	 J2mm7NH95NGOw9eJdpmmqspGw43MZ1+wQBJZcgCOv2aBhXszoKzTJi9wkBvyrI+C0N
	 98gQoXzx49uQtfrEYyZQo43uQdhjYsSF0P4aeBco=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfLJVEf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 Dec 2019 16:04:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727325AbfLJVEe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Dec 2019 16:04:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B8352468B;
        Tue, 10 Dec 2019 21:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576011874;
        bh=CaIEzmNLIk68AeBJAIRs1D9WJLu/79Hwl/RZzyzBKEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSimjJhueOSDemAzTMA5jPDTWW8G1e/CPpk+Hd7AynYNsJcryFiuTd4enUuysg00H
         O8oQ/jyX9ZJvjZaMnPV8Ma0Ht6UKLSyGdSjyux5O0yC3bML1a58VLzU3c6f/la5uz4
         ZaIMgftwOSKtbKPRfFv12EcvIcPdSm2ikgkcO+s4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 026/350] rtlwifi: prevent memory leak in rtl_usb_probe
Date:   Tue, 10 Dec 2019 15:58:38 -0500
Message-Id: <20191210210402.8367-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210402.8367-1-sashal@kernel.org>
References: <20191210210402.8367-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 3f93616951138a598d930dcaec40f2bfd9ce43bb ]

In rtl_usb_probe if allocation for usb_data fails the allocated hw
should be released. In addition the allocated rtlpriv->usb_data should
be released on error handling path.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 4b59f3b46b281..348b0072cdd69 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1021,8 +1021,10 @@ int rtl_usb_probe(struct usb_interface *intf,
 	rtlpriv->hw = hw;
 	rtlpriv->usb_data = kcalloc(RTL_USB_MAX_RX_COUNT, sizeof(u32),
 				    GFP_KERNEL);
-	if (!rtlpriv->usb_data)
+	if (!rtlpriv->usb_data) {
+		ieee80211_free_hw(hw);
 		return -ENOMEM;
+	}
 
 	/* this spin lock must be initialized early */
 	spin_lock_init(&rtlpriv->locks.usb_lock);
@@ -1083,6 +1085,7 @@ error_out2:
 	_rtl_usb_io_handler_release(hw);
 	usb_put_dev(udev);
 	complete(&rtlpriv->firmware_loading_complete);
+	kfree(rtlpriv->usb_data);
 	return -ENODEV;
 }
 EXPORT_SYMBOL(rtl_usb_probe);
-- 
2.20.1

