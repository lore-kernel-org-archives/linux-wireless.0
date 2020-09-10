Return-Path: <SRS0=qoP/=CT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C87C43461
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Sep 2020 19:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D81221D81
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Sep 2020 19:47:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KWF1TE7u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbgIJPYr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Sep 2020 11:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731248AbgIJPF0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Sep 2020 11:05:26 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20050C0617A1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2020 08:05:13 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id x23so370760wmi.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2020 08:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CAsNGz4Cs4vTJ9gk8zApIj6qmRBVcghapi1gG95W8wE=;
        b=KWF1TE7unzAEhs8mBdAaCBqHg8xU0QTmm/1L49vgLG41pjIppgCTYMAuxQXE147tVK
         v+8eS110ObbZb7k0raX1jkSZH1UhLIjImIHJZpgSPlt5zDS9Xk7X8vP5i2XHKeiKhRHM
         n5EsAqCEKxyQigYfdMFfIsjRjVtdh9Wu8v3S7EIjYJwUNat3RCmYP8xfI2IEzfIdzqqF
         HSjf3B3SjiSDM4CdHSJsaFduFAzIAjIZLXVcpLYMZkBTJRa2suyrBJp0kkhBOZp19iI5
         yjOr+HRfz/5pK7wuEBctRXhwMAv+nPGfUUhhaOQZVLqgqSst33oE6o18+qBVhjOTrAZ6
         JbcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CAsNGz4Cs4vTJ9gk8zApIj6qmRBVcghapi1gG95W8wE=;
        b=U+bSGX83WUAvGwgIIsMj+tN+wsm8tDrGI2Fo1ynK3XMNFiPlJygl/UQP/4LJiN4sRs
         LlvRolRNS572oVC5CrhygJaFdR6FHc8enlDBMDmA65rRyzVPbIy5/OluvvcfnUEVqvm7
         W4k80ndt9uMwLgejmsplrA+RSBUf+zFPcyjbU3JMeuATAR5HeXVWQq8o08YVzNBClLpn
         5TK8P5YMD+P/fOesospw92NNe36DP5Kvj+rwlRz5DJ6xT1gFmEdzkg7W8k8Nu0QHHSo3
         0JsRNNUXAiYK0FePRq9PLClTcY72OMHH9QcEMvPax3B1vF6M4AiWLSEMHgcRLZEWfwgD
         AKgA==
X-Gm-Message-State: AOAM531MeslUo0aHYlLtD6C+6CJiBkLVibOFxp7P9l7hUUDnNyI3Jsu4
        TvlH4HaGrCPeDZTf27qIC9BAzA==
X-Google-Smtp-Source: ABdhPJzgPl9pTQz3rN2OGcS68x08jmBI2PTo1MVeEItk1UFjeMzU3tt3amQuONyoRYPwvIy9YP7OcQ==
X-Received: by 2002:a1c:740c:: with SMTP id p12mr435592wmc.176.1599750311807;
        Thu, 10 Sep 2020 08:05:11 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id g8sm3852620wmd.12.2020.09.10.08.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 08:05:11 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@codeaurora.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org
Cc:     bryan.odonoghue@linaro.org, shawn.guo@linaro.org,
        loic.poulain@linaro.org
Subject: [PATCH v5 7/7] wcn36xx: Add wrapper function wcn36xx_smd_set_sta_params_v1()
Date:   Thu, 10 Sep 2020 16:05:52 +0100
Message-Id: <20200910150552.2178882-8-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200910150552.2178882-1-bryan.odonoghue@linaro.org>
References: <20200910150552.2178882-1-bryan.odonoghue@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This commit adds a wrapper function wcn36xx_smd_set_sta_params_v1() which
calls into wcn36xx_smd_set_sta_params() and then subsequently sets
version-1 specific parameters.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 30 ++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index d5089aa382bd..71ecf3ef5ab2 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -1262,6 +1262,36 @@ static void wcn36xx_smd_convert_sta_to_v1(struct wcn36xx *wcn,
 	v1->p2p = orig->p2p;
 }
 
+void
+wcn36xx_smd_set_sta_params_v1(struct wcn36xx *wcn,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta,
+			      struct wcn36xx_hal_config_sta_params_v1 *sta_par);
+void
+wcn36xx_smd_set_sta_params_v1(struct wcn36xx *wcn,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta,
+			      struct wcn36xx_hal_config_sta_params_v1 *sta_par)
+{
+	struct wcn36xx_sta *sta_priv = NULL;
+	struct wcn36xx_hal_config_sta_params sta_par_v0;
+
+	wcn36xx_smd_set_sta_params(wcn, vif, sta, &sta_par_v0);
+	wcn36xx_smd_convert_sta_to_v1(wcn, &sta_par_v0, sta_par);
+
+	if (sta) {
+		sta_priv = wcn36xx_sta_to_priv(sta);
+		wcn36xx_smd_set_sta_vht_params(wcn, sta, sta_par);
+		wcn36xx_smd_set_sta_ht_ldpc_params(sta, sta_par);
+		memcpy(&sta_par->supported_rates, &sta_priv->supported_rates,
+		       sizeof(sta_par->supported_rates));
+	} else {
+		wcn36xx_set_default_rates_v1(&sta_par->supported_rates);
+		wcn36xx_smd_set_sta_default_vht_params(wcn, sta_par);
+		wcn36xx_smd_set_sta_default_ht_ldpc_params(wcn, sta_par);
+	}
+}
+
 static int wcn36xx_smd_config_sta_rsp(struct wcn36xx *wcn,
 				      struct ieee80211_sta *sta,
 				      void *buf,
-- 
2.27.0

