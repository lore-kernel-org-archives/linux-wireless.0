Return-Path: <SRS0=opxm=CS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22090C43461
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Sep 2020 15:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2B4721941
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Sep 2020 15:36:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bsHZas5H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbgIIPgH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Sep 2020 11:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730324AbgIIPfv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Sep 2020 11:35:51 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B00C061348
        for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2020 08:35:22 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w2so2725352wmi.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2020 08:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OT/7V+2xByy/9ST9yJhKKgW312HrOX/Xe+N2WUGIkkU=;
        b=bsHZas5H2PogNEUA6W0g82l8+D6alBojgldv7kndyF6dhnS7zVICdOWB2x63LbOvpx
         Sf/9x9WfAYKNaGD2z1Zx639CL3W6BBtuCcrciQxqVmVHWLxbYb8K7a+vdrUjacc6/9wP
         rP3RPbwCKmNTwjRA30X9y8akpVYQL+MEs7Nho79dkUeV8Bf+4qQcCil2LovECX1HBAWE
         3Q5yfX+/oLFKwTNAlu4Wfl9fQbvQjLqlIOFVYe6A8hJy+JpEcRZOQiO6nbw6nMjxLxxv
         EhZbCNeHySRJMLH/3OnOgbSjrkFMZA06ifT+yYTgA2vxGgITVtLIa46vD0BzP+Yr9AqD
         azYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OT/7V+2xByy/9ST9yJhKKgW312HrOX/Xe+N2WUGIkkU=;
        b=uGaOXjeuNnopOKPREFfiMffCEbY4oDadVAcbRoG2Jgepe70wvNXoEP9rhUYj3VhoBV
         z/Aubd2Z4zmTrY7IYK4r9mjLzFkp/e0ZRR+gnLn/nSxE43cn0iKlqgiRjO9CygiXc9Vw
         mlWsrgnTv0BV91pkZsfypNOtEnUjF25GG59R1h72Dv+82ahYOfLBRwtI9u+No0iMjbY3
         YVz8e1eMDRFrLT/jnMDm4J7M5OITB0bGWWKB2dV6jihkrD3upRmuX51sfAUQGtClwCFv
         EbCS6oJXXA/PmhuVp7LOSzORpy+UDbfjxlV5oVbEjWztzF/yOfGETL9ldGKCo3WFx/cl
         LraA==
X-Gm-Message-State: AOAM533xSErFnG/1W20KMeEgDQWAvlSzK4ZLM0EG5/DELZJ1//F7GTFz
        gZGQx1aAT6U/g/PbTKjnoXsebeSZ/n0RLw==
X-Google-Smtp-Source: ABdhPJwxtt/Q/OUfdEjYwKFN9C8X7r33ruY5xIkjs2fHRhxyeFAsdHNl0pQ3QQrneyP+ex53s7Bm8A==
X-Received: by 2002:a05:600c:2146:: with SMTP id v6mr3992097wml.159.1599665720668;
        Wed, 09 Sep 2020 08:35:20 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id s2sm4473335wrw.96.2020.09.09.08.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 08:35:20 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@codeaurora.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org
Cc:     bryan.odonoghue@linaro.org, shawn.guo@linaro.org,
        loic.poulain@linaro.org
Subject: [PATCH v4 1/7] wcn36xx: Add wcn36xx_set_default_rates_v1
Date:   Wed,  9 Sep 2020 16:36:01 +0100
Message-Id: <20200909153607.2904822-2-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200909153607.2904822-1-bryan.odonoghue@linaro.org>
References: <20200909153607.2904822-1-bryan.odonoghue@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add a routine to set some additional default parameters associated with the
V1 data structure.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c    | 8 ++++++++
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index c5e94ba8f941..ab6685dc956b 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -793,6 +793,14 @@ void wcn36xx_set_default_rates(struct wcn36xx_hal_supported_rates *rates)
 		sizeof(*ofdm_rates) * WCN36XX_HAL_NUM_OFDM_RATES);
 	rates->supported_mcs_set[0] = 0xFF;
 }
+
+void wcn36xx_set_default_rates_v1(struct wcn36xx_hal_supported_rates_v1 *rates)
+{
+	rates->op_rate_mode = STA_11ac;
+	rates->vht_rx_mcs_map = IEEE80211_VHT_MCS_SUPPORT_0_9;
+	rates->vht_tx_mcs_map = IEEE80211_VHT_MCS_SUPPORT_0_9;
+}
+
 static void wcn36xx_bss_info_changed(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_bss_conf *bss_conf,
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index d7d349de20e6..2da81d9926c4 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -271,6 +271,7 @@ static inline bool wcn36xx_is_fw_version(struct wcn36xx *wcn,
 		wcn->fw_revision == revision);
 }
 void wcn36xx_set_default_rates(struct wcn36xx_hal_supported_rates *rates);
+void wcn36xx_set_default_rates_v1(struct wcn36xx_hal_supported_rates_v1 *rates);
 
 static inline
 struct ieee80211_sta *wcn36xx_priv_to_sta(struct wcn36xx_sta *sta_priv)
-- 
2.27.0

