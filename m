Return-Path: <SRS0=0VAH=EJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A0CC388F7
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Nov 2020 12:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 377B520714
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Nov 2020 12:16:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eSU8lULd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbgKCMQp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Nov 2020 07:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728168AbgKCMQo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Nov 2020 07:16:44 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02449C0613D1
        for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2020 04:16:43 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id a9so18281236wrg.12
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2020 04:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B1scLjb8IcSGFznlQh5DO/IzLfMPdaRu0HzvgPpPq8k=;
        b=eSU8lULdC7t75XT/meQjIzmdPZKl9bATEW0ZqFenaU+w5PqCp5yXhSIrKeYfua5h6i
         2URqPc8WkR+F1KEN2cc2QrmDe/fKrxoHLw1T4uuxd7OQ9X06eiKy992KZR70GolZImjn
         2egajD+ARiLjjfCqiHi0KwglHmvfQZyMIFexCFJzPMhvoowcgtoqt8XaTpqbZ30pm4hu
         ksU/Nj5aMmkH4PNqmB0Nqj8gApwrDNJZxCk1po1kwiRHI/nzjsyKFxJDf+Ns68dPI2s4
         HebsE3C/hcH1qYBHvY9GbPJ4GuWyteZ02LSQvCF5whqN20u1O46b2/1HXRekQinCFYkP
         R44g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B1scLjb8IcSGFznlQh5DO/IzLfMPdaRu0HzvgPpPq8k=;
        b=nnzYUL65JMRlRLwr44JMy0298YvwVhLxVBFi+sKgIFuVtCmA6S0yL6shM9DfJqe+c1
         TEEl2HgOMnhi2KUv7PqwK+Bs0qjAO/yCCDXKfE1q7wzZmB1oq2HLOR+1DvK79JgGJXXk
         1qLed1xmFdknceQqWONCpqf4qFPHHkzs6JvQ2DxsCY44KYGkRcXeDMmPvNcsX+wX2kdd
         4qh4pvy2Wm6dXfMOq0FXyQYywRStaTxruKFzZOrPeelW8W9mHbc1doTLxXTd2zDWKm6i
         MziX7eqs7nPCXqbCanaA1eLG8Pi4OeoIjo4/nodHfrC60gvbEiw5nUzfucVURs19lQQ/
         f07g==
X-Gm-Message-State: AOAM531+YpngJlvLv+vHAteXTXTZEhtpMMtBbMDP0miOna31H5UXis3S
        BDPe3+h/qY+VztLPzDAuXoR+WQ==
X-Google-Smtp-Source: ABdhPJylNMFN7fvUvVgAL/F85cbTfmchIG2Q1SCfNvqstUOzF8gCQghfybokA9jnCL9mfkH6P+PYGw==
X-Received: by 2002:adf:97cb:: with SMTP id t11mr27734648wrb.292.1604405801741;
        Tue, 03 Nov 2020 04:16:41 -0800 (PST)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id z6sm2678210wmi.1.2020.11.03.04.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 04:16:41 -0800 (PST)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@codeaurora.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org
Cc:     bryan.odonoghue@linaro.org, shawn.guo@linaro.org,
        loic.poulain@linaro.org
Subject: [PATCH v2 3/3] wcn36xx: Enable firmware offloaded keepalive
Date:   Tue,  3 Nov 2020 12:17:35 +0000
Message-Id: <20201103121735.291324-4-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103121735.291324-1-bryan.odonoghue@linaro.org>
References: <20201103121735.291324-1-bryan.odonoghue@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch calls wcn36xx_smd_keep_alive_req() on the STA patch immediately
after associating with an AP.

This will cause the firmware to send a NULL packet out to the AP every 30
seconds, thus offloading keep-alive processing from the SoC to the
firmware.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index e924cc4acde0..5867bd9c2f64 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -910,6 +910,7 @@ static void wcn36xx_bss_info_changed(struct ieee80211_hw *hw,
 			 * place where AID is available.
 			 */
 			wcn36xx_smd_config_sta(wcn, vif, sta);
+			wcn36xx_enable_keep_alive_null_packet(wcn, vif);
 		} else {
 			wcn36xx_dbg(WCN36XX_DBG_MAC,
 				    "disassociated bss %pM vif %pM AID=%d\n",
-- 
2.28.0

