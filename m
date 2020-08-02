Return-Path: <SRS0=QD1N=BM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0677EC433E0
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Aug 2020 00:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C94C5207BB
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Aug 2020 00:47:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VHAaaqHG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgHBArl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 1 Aug 2020 20:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbgHBArl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Aug 2020 20:47:41 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C2DC06174A
        for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2020 17:47:40 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f18so31076150wrs.0
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2020 17:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FJua73DrnL7fvmD4/CUOM6UXPiA/MBZ9wdxcSkASnJY=;
        b=VHAaaqHGkxP2tnX0k032jNDAuuRZpyw3tFuYOFOd+Mlzmav2xMr82IUfIf2D5Fh0oy
         IrIXhuAyl5eec9cT9TYivQFaZqzxt4sGnBcOXtUjt8tuYgYVKWFNcQ45rR4eDzOljWws
         0c+LxlA5ZnP5M5fptUKyVBVmvk3vRqgs2UdrfhwoTz5JuB6tqrAh9YHy+kid3A5p4K3y
         8GSVo9Ys7BcWhaM6/h6/0Z9glQ9gFlM0KAlbjbeIvmBQ3Mn0yNN2ND0zQCuSnq27e3c9
         MJmhWT3LCkE+W4p05Lx6DC6xf8uqtC9scDVQwc+Jr0FfDYraN8vHHkFPMXmmYm/528NH
         DHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FJua73DrnL7fvmD4/CUOM6UXPiA/MBZ9wdxcSkASnJY=;
        b=ug0Zo0WX1M2n1NEDCIsGjh63oOi6nqUe48OeufMWVLoifRBENxgwuUnkrBALpzLEwu
         kD2wn5Dgad7A78dj3/zeMy1PvVXPCBMRzMfYCsg1XnPAtAdc76KPi25yFQVXXnIlrn6N
         fInl61ZCD+iIk0udYExowHNRjTrUkNpTVOyBb0p64H9hCZouQLFA0APCsHjk21jCgimX
         WF3M6smEEgY2ZIYlEl9Sj2rVjKNeI+KSB1X8M1S291KN6F+25TR7w94aVnCDZzRAaVRR
         PHF3YApSaHMJw2ZRKSxZr47IiFXxZXaK44fMdmU1IN36aCJARx+ABfZ7mgn80F5h/AmZ
         Nd3g==
X-Gm-Message-State: AOAM530N8gTzk6Xxwlyw0VNPK2u35hBHuc3Ekhm7XiEtYrzXSHoyTmz0
        qUuFA2pjWeyR/VJ3I9bHy4ucNg==
X-Google-Smtp-Source: ABdhPJwF4Xt/8oMDKxNEc+DUw9SlAEsGOIsp4gidP9IbdIot+7/gF1ULTt5cObPPH5wLF2SU5/TdXw==
X-Received: by 2002:adf:e9cd:: with SMTP id l13mr10016565wrn.340.1596329259495;
        Sat, 01 Aug 2020 17:47:39 -0700 (PDT)
Received: from localhost.localdomain ([176.61.57.127])
        by smtp.gmail.com with ESMTPSA id z67sm821057wmg.28.2020.08.01.17.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 17:47:38 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@codeaurora.org
Cc:     wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        bryan.odonoghue@linaro.org
Subject: [PATCH] wcn36xx: Fix reported 802.11n rx_highest rate wcn3660/wcn3680
Date:   Sun,  2 Aug 2020 01:48:24 +0100
Message-Id: <20200802004824.1307124-1-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Qualcomm's document "80-WL007-1 Rev. J" states that the highest rx rate for
the WCN3660 and WCN3680 on MCS 7 is 150 Mbps not the 72 Mbps stated here.

This patch fixes the data-rate declared in the 5GHz table.

Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680
hardware")

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index da2db0420d02..f389cd4676e3 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -163,7 +163,7 @@ static struct ieee80211_supported_band wcn_band_5ghz = {
 		.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
 		.mcs = {
 			.rx_mask = { 0xff, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
-			.rx_highest = cpu_to_le16(72),
+			.rx_highest = cpu_to_le16(150),
 			.tx_params = IEEE80211_HT_MCS_TX_DEFINED,
 		}
 	}
-- 
2.27.0

