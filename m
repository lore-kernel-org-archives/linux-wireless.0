Return-Path: <SRS0=UQ4x=7K=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF6A1C433E0
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 19:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9D8A207BC
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 19:24:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="I9riZ1kC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406370AbgE1TYL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 May 2020 15:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406376AbgE1TVk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 May 2020 15:21:40 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1E8C08C5C7
        for <linux-wireless@vger.kernel.org>; Thu, 28 May 2020 12:21:40 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id r10so46489pgv.8
        for <linux-wireless@vger.kernel.org>; Thu, 28 May 2020 12:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y6S8UT7fOzgLP5qh6hspSGqd2CboLdcTSP/4m/p79vQ=;
        b=I9riZ1kCTjkAjgZQb6aDNzAbdKeGBwRNOUJ4ULr4c5YCaT0tSFe32xf7r6vTQfi+Yz
         HMmfSquN3oTGCbPb4eaETRVyLNIX4QrM4CpjGjMudXBkCfJlewS0v3NeBkAoiKpw4IYt
         EQUChaK4yvPaG+0SWNOR+DG8Vqt4u13ZuykKY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y6S8UT7fOzgLP5qh6hspSGqd2CboLdcTSP/4m/p79vQ=;
        b=rHyO4XZoOOvsNz50utpg3v3dsUA5llgGcbj8IMZcC2EHUqRqklFELNH16cqnCjdJIs
         vh3m94e3ghauF3fC7ibgNrWLeHCKLgKP/2wB0XP/ib5CM8/2aQyB9Stppw677p7+F4o5
         tFVkjQe7Ihy5JyLE0EwdEnH5CLzhPHEzv/Oj5XDi/iNuZS5RtsvYsHyLyizgtvWSId5H
         4zPJsqgfGWL/JqfcYdNjxwKLZKagiTyI31yvusz4idLPRaE6D9dfAFDnEJIs5ADC6iYJ
         Ze1PvqAy+AAmJOfzzXXWrS/ee/gNLSJULZWSx79yeAo1luxOisVdWePTm1NSGKL0NxFB
         7jGA==
X-Gm-Message-State: AOAM5330LHTbemYaCDSoontlACAbNgGYytOwZ36upgJvfTzU+vRXTMxk
        wX++mtf+vQm80E0/DOzUt4OkPQ==
X-Google-Smtp-Source: ABdhPJye6QMenut6Cdb/aFoZAscfJN27BnFnVZBdVCmU8aOVmFGacFa/HAo0AxTatDB/ZDw6FTNwrw==
X-Received: by 2002:a62:8c15:: with SMTP id m21mr4752243pfd.59.1590693699587;
        Thu, 28 May 2020 12:21:39 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id v12sm5630151pjt.32.2020.05.28.12.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 12:21:39 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Niklas Cassel <niklas.cassel@linaro.org>,
        Brian Norris <briannorris@chromium.org>,
        Govind Singh <govinds@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] ath10k: Remove ath10k_qmi_register_service_notifier() declaration
Date:   Thu, 28 May 2020 12:21:09 -0700
Message-Id: <20200528122105.1.I31937dce728b441fd72cbe23447bc4710fd56ddb@changeid>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The ath10k/qmi.h header file contains a declaration for the function
ath10k_qmi_register_service_notifier().  This function doesn't exist.
Remove the declaration.

This patch is a no-op and was just found by code inspection.

Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
---

 drivers/net/wireless/ath/ath10k/qmi.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.h b/drivers/net/wireless/ath/ath10k/qmi.h
index dc257375f161..e03581182919 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.h
+++ b/drivers/net/wireless/ath/ath10k/qmi.h
@@ -112,7 +112,6 @@ int ath10k_qmi_wlan_enable(struct ath10k *ar,
 			   enum wlfw_driver_mode_enum_v01 mode,
 			   const char *version);
 int ath10k_qmi_wlan_disable(struct ath10k *ar);
-int ath10k_qmi_register_service_notifier(struct notifier_block *nb);
 int ath10k_qmi_init(struct ath10k *ar, u32 msa_size);
 int ath10k_qmi_deinit(struct ath10k *ar);
 int ath10k_qmi_set_fw_log_mode(struct ath10k *ar, u8 fw_log_mode);
-- 
2.27.0.rc0.183.gde8f92d652-goog

