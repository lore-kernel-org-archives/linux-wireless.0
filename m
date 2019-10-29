Return-Path: <SRS0=76X5=YW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C5CCCA9EC4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Oct 2019 13:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0014020856
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Oct 2019 13:16:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VamG53xB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388300AbfJ2NQh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Oct 2019 09:16:37 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43153 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732534AbfJ2NQg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Oct 2019 09:16:36 -0400
Received: by mail-pl1-f196.google.com with SMTP id v5so7594694ply.10;
        Tue, 29 Oct 2019 06:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=BEANdppUHS19syOQxQ2Hfj8cvgSVpvTUi8gyof+Qqo8=;
        b=VamG53xBXpapSScc5HR+I6K8ptJmRyAQimPXJHkC7gB7XU7UC9x0V5eP9ypKgtJ9g5
         76kprNY4fS4mGiM+5DiseUgOOSmP/AO91DADvgVgeu6fpJupwrq1FRDnYZiHI58yBQ34
         2ssE1Rr4Yx/4mTQksP9UHyud+2gikHGI1F2bg/iBgUkkAL3UlkR9hwsax6NxpOV/ttr8
         rM32vbFd7MqsqzbSCvaWc60z+QzX0p31duSwWIqWCKNHVVbQb8obSBluTtkIBKq2ky8n
         SXUQzue93516YOo5f+OkTu3TDfEQa7SYpLk3nTloFzAbYruiZ/VGoP9a5buiWv0f/mYm
         X3Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=BEANdppUHS19syOQxQ2Hfj8cvgSVpvTUi8gyof+Qqo8=;
        b=rrTBrswn33y+YdpDJSW5eSWt40sU1fJ8sSer3lA87mxCKLgQn2it/uW1zOXAbo0QyN
         3Wi4JqQoifq/XCZRUDdcbrh74QOVm+1dRfADHw/KBilTU2zTTNCYX8iFyjY5fMTEONvw
         Vuc4+KA6wyqczsk3vbRhVIEcQBOSLdfxlkJ46LcPoosHxaiiyRvqXzKeyOaVRVi4ubLp
         Rxy4thOEMeIs9QXTL8zE/hgsQ0SkTkC7X1OS+rouUSp/a6MkYJ4Hgde/8zYBoS+P1obB
         ewrMcXzLNG5V3Pht94yaqhfPUofNpmAJPEN6WY7Mb+NHMThossRx77+46NdJBa1QGXPi
         R8tQ==
X-Gm-Message-State: APjAAAXZ4sq8pohyqKuhIdDnfwfXB26yDKGwUV0hFzXqIT2bKcNcfGCa
        cm1axZax970KT0Wd/0cRVnw=
X-Google-Smtp-Source: APXvYqyGdtI9aT7NHPIrtgeELQCTNYPrYunUngeQGfBD572sIpTERqlxBFzSTfT5A+AS5FTcfGGOiQ==
X-Received: by 2002:a17:902:7c81:: with SMTP id y1mr202631pll.308.1572354995952;
        Tue, 29 Oct 2019 06:16:35 -0700 (PDT)
Received: from saurav ([117.232.226.35])
        by smtp.gmail.com with ESMTPSA id d17sm14176388pfd.118.2019.10.29.06.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 06:16:34 -0700 (PDT)
Date:   Tue, 29 Oct 2019 18:46:24 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        Larry.Finger@lwfinger.net, gustavo@embeddedor.com,
        colin.king@canonical.com, saurav.girepunje@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] rtlwifi: rtl8821ae: phy.c: Drop condition with no effect
Message-ID: <20191029131624.GA17391@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

As the "else if" and "else" branch body are identical the condition
has no effect. So drop the "else if" condition.

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 979e434a4e73..cad560aeb7dd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -3553,8 +3553,6 @@ void rtl8821ae_phy_sw_chnl_callback(struct ieee80211_hw *hw)
 			if (rtlhal->hw_type == HARDWARE_TYPE_RTL8821AE) {
 				if (36 <= channel && channel <= 64)
 					data = 0x114E9;
-				else if (100 <= channel && channel <= 140)
-					data = 0x110E9;
 				else
 					data = 0x110E9;
 				rtl8821ae_phy_set_rf_reg(hw, path, RF_APK,
-- 
2.20.1

