Return-Path: <SRS0=Ljpw=BN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C04AAC433E0
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Aug 2020 03:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A08A720738
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Aug 2020 03:10:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r/GbBanJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgHCDK7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Aug 2020 23:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbgHCDK5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Aug 2020 23:10:57 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FF1C06174A
        for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2020 20:10:57 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id t14so8892836wmi.3
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2020 20:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EwoIz5oOPNTb/qL6RMRIh7345sC6Mi9TvhmWF2vaLCY=;
        b=r/GbBanJDIYmUaGBv2/7j0+m5rftzO54eXf+YGA8Zw1wyD7pFx7ZQrD1oTH3FyW6gl
         JVelB3Kk/Xcbu0/3oKcpZBnssbGf/PeAjheFU1/mI0C1nTvNv7+MSogwMKq7BKHdApeR
         pYZhAhUbPPU8bXN3vLULG23+WuPncJjD72NzqZ7ntFq6kuDIC+tKpIDIAHgp/4lwQIup
         itnQkYpbKN50O2oaecvUZcuxNEHzoeH0Ams/xUfg2LYfiaUj4Q6+NOfoUbCAe1RM9P9v
         J4kH7vXzEbSI9qB9IoIqbDTvnJa8zEvCQtANqw5YCBiz1clifXBn55AUgdAUimd/z1eM
         lNyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EwoIz5oOPNTb/qL6RMRIh7345sC6Mi9TvhmWF2vaLCY=;
        b=AG7hgvsKbB4qL+z0NSXd7YXFWcjqiPpVmQ20/TrDH+lV1lxdZQNIHaA2yeraFEGjr/
         tpOjlN1XG5hajY43BDaQX0XNCRbyDLY92QjRQrkj1KXnDDClmaf9dhmASklQF/QEqizD
         uwy/gvPhxuWvQKDGjR4a/NA8zkGRDgq7jVWvJSlx8yZXOekZNd7Euy8fThWpueIKw18H
         2GoNebbRET5Tm4Ls/iARKpf648sqS0e0bSizfI5D0TJz9eVyXMGCspjlBrMicyZ6KZ+m
         uapsK1g8KZTxtE3+/fv+J81cdAgCqsATekXZHKs5zDu3UldGPoO36mesv55XPhNKdpUV
         XBlg==
X-Gm-Message-State: AOAM531ACdwhPcnm3xgqUijfDNFI0efhzKOny4fvOF2D/gCYk1RlL5BW
        Lhbq7v02ZsnfRBoFYI92YRvpjDl6FcA=
X-Google-Smtp-Source: ABdhPJwtaty2NX5DY9X9w+LAxXf0BMho6Sr44dDwgj0Tj7vaPEbjjRs7W9kxtY1lixlhlBXuHzM88Q==
X-Received: by 2002:a1c:a9c6:: with SMTP id s189mr13009919wme.166.1596424256086;
        Sun, 02 Aug 2020 20:10:56 -0700 (PDT)
Received: from localhost.localdomain ([176.61.57.127])
        by smtp.gmail.com with ESMTPSA id q2sm21956857wro.8.2020.08.02.20.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2020 20:10:55 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@codeaurora.org
Cc:     wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        bryan.odonoghue@linaro.org, shawn.guo@linaro.org
Subject: [PATCH 09/36] wcn36xx: Add VHT fields to parameter data structures
Date:   Mon,  3 Aug 2020 04:11:05 +0100
Message-Id: <20200803031132.1427063-10-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200803031132.1427063-1-bryan.odonoghue@linaro.org>
References: <20200803031132.1427063-1-bryan.odonoghue@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In order to pass VHT parameters to wcn3680 we need to use a super-set of
the V1 data-structures with additional VHT parameters tacked on.

This patch adds the additional fields to the STA and BSS parameter
structures with some utility macros to make calculation of the structure
size easier.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/hal.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index 5daac448d4e2..10ce05110d11 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -1584,9 +1584,15 @@ struct wcn36xx_hal_config_sta_params_v1 {
 	u8 reserved:4;
 
 	/* These rates are the intersection of peer and self capabilities. */
-	struct wcn36xx_hal_supported_rates supported_rates;
+	struct wcn36xx_hal_supported_rates_v1 supported_rates;
+
+	u8 vht_capable;
+	u8 vht_tx_channel_width_set;
+
 } __packed;
 
+#define WCN36XX_DIFF_STA_PARAMS_V1_NOVHT 10
+
 struct wcn36xx_hal_config_sta_req_msg_v1 {
 	struct wcn36xx_hal_msg_header header;
 	struct wcn36xx_hal_config_sta_params_v1 sta_params;
@@ -2007,8 +2013,14 @@ struct wcn36xx_hal_config_bss_params_v1 {
 	 *  "STA context"
 	 */
 	struct wcn36xx_hal_config_sta_params_v1 sta;
+
+	u8 vht_capable;
+	u8 vht_tx_channel_width_set;
+
 } __packed;
 
+#define WCN36XX_DIFF_BSS_PARAMS_V1_NOVHT (WCN36XX_DIFF_STA_PARAMS_V1_NOVHT + 2)
+
 struct wcn36xx_hal_config_bss_req_msg_v1 {
 	struct wcn36xx_hal_msg_header header;
 	struct wcn36xx_hal_config_bss_params_v1 bss_params;
-- 
2.27.0

