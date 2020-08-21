Return-Path: <SRS0=HZW5=B7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A735C433DF
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Aug 2020 23:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 641E620727
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Aug 2020 23:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="I6A0A8yc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgHUX5j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 21 Aug 2020 19:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgHUX5i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Aug 2020 19:57:38 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1530FC061573
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2020 16:57:38 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id v15so1724061pgh.6
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2020 16:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UJ2x4KM5PrX4y4rhTZdVG0hrG36y7XnXtnRtTx5sPx4=;
        b=I6A0A8ycECfad2dfoGURONy4ytDiTdJXJuIdOf914Y0652hY4VGgTi8BEhLjj3CYYX
         mkgYScJ6UcTBpemYPvyevNk5dHz08UOQp9vth7Z/7dXXBf0fGnMZMG/a+lAudrXaRU35
         NoeNBbpoQFHr1js5vamhBtUz7JeXdW6EhJv+I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UJ2x4KM5PrX4y4rhTZdVG0hrG36y7XnXtnRtTx5sPx4=;
        b=r3Op/xOckNeP2gFqyTMFt9UQjjSJZ9GLlU8vxKw1tpthmfM/ulRlSwzdZGcgHDNymu
         Sve5Qj+Fhi+GjoiZQ1x+MJqMs06I/Qjxbzo9dSOGPn5mXRd3ydbQIQTFrxxly6OYRMAZ
         gNWItBrt18QuOEkSby757NPuZXMzLZEZY7Lr8sZ7MDuKUjBp381xYhymx6ByRl0Gi2gv
         TE5VJxeS3fRV3gCXsGsfMkBNA78Y0qI4XFPMtOLKdro9Q92vvRu15/LE+0/CT/Lp+oJz
         mX7DqS6awv45finaJe1LiaHvtLz8pOsPJV9zl3RbTw4+3v8eyuBLLDdyErvBUccbY5Bn
         jbkw==
X-Gm-Message-State: AOAM533NKrv18SEWafN17hsCLNpjMMvFlpqCTBMuIiMlpdD8TEX+pyi4
        EJlnWsvYvq5NUPoTafxttn1sSXwDQFBSJA==
X-Google-Smtp-Source: ABdhPJyug2/DbQmAvTUPd08qYspydliDSTlQcGK30yEmiv8RPpQUsOvmwDnnNqcd0FOyikZqKcYASw==
X-Received: by 2002:a63:471b:: with SMTP id u27mr3927400pga.139.1598054256966;
        Fri, 21 Aug 2020 16:57:36 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:1:8edc:d4ff:fe53:350d])
        by smtp.gmail.com with ESMTPSA id e125sm3740097pfh.69.2020.08.21.16.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 16:57:36 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     <linux-wireless@vger.kernel.org>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] rtw88: use read_poll_timeout_atomic() for poll loop
Date:   Fri, 21 Aug 2020 16:57:33 -0700
Message-Id: <20200821235733.1785009-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This gives the added bonus of not wasting an extra udelay() if we're
timing out -- we double-check the register state one last time before
returning.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/realtek/rtw88/mac.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index 19b9b7ab016b..59028b121b00 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -114,18 +114,13 @@ static int rtw_mac_pre_system_cfg(struct rtw_dev *rtwdev)
 
 static bool do_pwr_poll_cmd(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 target)
 {
-	u32 cnt;
+	u32 val;
 
 	target &= mask;
 
-	for (cnt = 0; cnt < RTW_PWR_POLLING_CNT; cnt++) {
-		if ((rtw_read8(rtwdev, addr) & mask) == target)
-			return true;
-
-		udelay(50);
-	}
-
-	return false;
+	return read_poll_timeout_atomic(rtw_read8, val, (val & mask) == target,
+					50, 50 * RTW_PWR_POLLING_CNT, false,
+					rtwdev, addr) == 0;
 }
 
 static int rtw_pwr_cmd_polling(struct rtw_dev *rtwdev,
-- 
2.28.0.297.g1956fa8f8d-goog

