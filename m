Return-Path: <SRS0=opxm=CS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0958C433E2
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Sep 2020 17:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F11221919
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Sep 2020 17:08:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eelOjz49"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbgIIRIQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Sep 2020 13:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730383AbgIIPgw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Sep 2020 11:36:52 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F84DC0613ED
        for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2020 08:36:51 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z9so2839957wmk.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2020 08:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AjQwO8wviPzTyqnqo9pD+Eau9aX3yRTC3bFkrO7cETg=;
        b=eelOjz49ycNtuy76Di5/qOZNhOmSPzkl6XdJwnLN+FwtTVRLmbrS/i5zY8wAcoqpB7
         hTxl+lJ2Hv/bs5sTcaNvQtov9SyI74XJ5juD1KnHPT/2bK45OjF3+DhmL9G0jXjKS7tO
         k30YyB2pI6e4LUDrtVar5l6937e9GPozftNeRlebJm91im6xsjsMENlb0riTaDzBbCCY
         faxoLoVk3ucTuGoX/2lxySoJg+rsXvDuIzV7qa7VnmINErq0uAh3iG/EUwFCiUOu51/M
         Nd0uUnrMm+cGonpoRH2NLXfnLx78yJ1bVVw0mlV76S3Sze7LkBDbb9ic/tqVDcy35noY
         wkOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AjQwO8wviPzTyqnqo9pD+Eau9aX3yRTC3bFkrO7cETg=;
        b=PxK7U9GSdAUXa2iUNJ7qsgqoouWYj+WA5nIHhRjtuYdvYTR886/uRJJa72Kk5hDwbH
         8yIOG+yQ0lVrK8+sCDxw6PnA9TlbEDTk9S7rmYbmhyScAldLdlRMPhs3IgYYVO3ojeCh
         pVt7XVSLEtWf/ZOeQihAR3I+M2Yd3gHivL8DsRhCqmjRzV39a7Gvn736Stc2E76UeY0E
         sjtZcHas1U8ycCb5a9pwDCqRnHMc31IvQ1XG46ciLCCn5+NdUm4jxGGoOANA2A+DQAQQ
         NXqr2kzvBPrYeEQvluUxQVpQG5wOyNgKUfQfWIP0kQ/s+HwvV2cQCLwEjSJiNE0VTy3x
         scDg==
X-Gm-Message-State: AOAM5329cLCHDOt4jHpAujneAoIyuukrgCsdLyP4d0ah99k5N5APpLaB
        vul2sf3WORuB0mzTO1XEzotO5w==
X-Google-Smtp-Source: ABdhPJxx6FZty8D4CoR840M7RXS82Jc1nlcHpVlm40CjUdUPRu7ZAkMqwYB2n3dk2UsnPtVs/n7vEA==
X-Received: by 2002:a1c:66c4:: with SMTP id a187mr3996033wmc.148.1599665810107;
        Wed, 09 Sep 2020 08:36:50 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id 128sm4470602wmz.43.2020.09.09.08.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 08:36:49 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@codeaurora.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org
Cc:     bryan.odonoghue@linaro.org, shawn.guo@linaro.org,
        loic.poulain@linaro.org
Subject: [PATCH v4 2/4] wcn36xx: Convert to VHT parameter structure on wcn3680
Date:   Wed,  9 Sep 2020 16:37:34 +0100
Message-Id: <20200909153736.2905114-3-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200909153736.2905114-1-bryan.odonoghue@linaro.org>
References: <20200909153736.2905114-1-bryan.odonoghue@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In order to send VHT parameters to wcn3680 we need to pass the extended V1
parameter structures to the firmware. These commands need to have the
version number set to 1.

This patch makes the conversion. The conversion consists of

1. Setting the version number for wcn3680 or leaving it at 0 otherwise
2. Setting the size of the packet header lower for wcn3620 and wcn3660

Once done all three chips can continue to use the same code to pass
parameters to their respective firmware. In the case of the wcn3680 the
passed structures will be slightly larger to accommodate communication of
VHT descriptors.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 3adb744b093d..18507b4d3681 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1428,8 +1428,12 @@ static int wcn36xx_smd_config_sta_v1(struct wcn36xx *wcn,
 	struct wcn36xx_hal_config_sta_req_msg_v1 msg_body;
 	struct wcn36xx_hal_config_sta_params_v1 *sta_params;
 
-	INIT_HAL_MSG(msg_body, WCN36XX_HAL_CONFIG_STA_REQ);
-	msg_body.header.len -= WCN36XX_DIFF_STA_PARAMS_V1_NOVHT;
+	if (wcn->rf_id == RF_IRIS_WCN3680) {
+		INIT_HAL_MSG_V1(msg_body, WCN36XX_HAL_CONFIG_STA_REQ);
+	} else {
+		INIT_HAL_MSG(msg_body, WCN36XX_HAL_CONFIG_STA_REQ);
+		msg_body.header.len -= WCN36XX_DIFF_STA_PARAMS_V1_NOVHT;
+	}
 
 	sta_params = &msg_body.sta_params;
 
@@ -1606,8 +1610,12 @@ static int wcn36xx_smd_config_bss_v1(struct wcn36xx *wcn,
 	if (!msg_body)
 		return -ENOMEM;
 
-	INIT_HAL_MSG((*msg_body), WCN36XX_HAL_CONFIG_BSS_REQ);
-	msg_body->header.len -= WCN36XX_DIFF_BSS_PARAMS_V1_NOVHT;
+	if (wcn->rf_id == RF_IRIS_WCN3680) {
+		INIT_HAL_MSG_V1((*msg_body), WCN36XX_HAL_CONFIG_BSS_REQ);
+	} else {
+		INIT_HAL_MSG((*msg_body), WCN36XX_HAL_CONFIG_BSS_REQ);
+		msg_body->header.len -= WCN36XX_DIFF_BSS_PARAMS_V1_NOVHT;
+	}
 
 	bss = &msg_body->bss_params;
 	sta = &bss->sta;
-- 
2.27.0

