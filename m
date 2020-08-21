Return-Path: <SRS0=HZW5=B7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70DA0C433E3
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Aug 2020 07:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E984207DA
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Aug 2020 07:17:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="imjQbPJV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgHUHRM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 21 Aug 2020 03:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbgHUHQy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Aug 2020 03:16:54 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A586C061344
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2020 00:16:53 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id d16so988413wrq.9
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2020 00:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jkJnqXxLKchHWxEQRJwgWXXCncTXSd4DzK09wyk1JRk=;
        b=imjQbPJVVZShA4Q+n/mfzt9cNHPoknvEEchPr3hoZ3sCDTX9LnvxrFnwqSUjtaMJib
         No6IK1zcjccFbBZN3v1Y/L1CN0IReoDTnYEweipYWzPK4GlUUHm1j2bviT9xJry9++Wp
         ksKRo/9pfxPPK69NLV3WeebLFmxi+8Z1K+teNTW2ZfuIqASqjLcIs9LkoaoMi2XqlYhZ
         QV2VW5ET78aYF6CAzVs1rM7ECwu8X5uy2b1r3ExlTtveoarvtIoZ79XhZ3PL8DYNTvVg
         EvzS5Y+VLRh+BIcdEcz6IzW28c/4LVlpfF9LlWJgLiFYQE765HOOr65IQ9IatBYAoDA2
         Oowg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jkJnqXxLKchHWxEQRJwgWXXCncTXSd4DzK09wyk1JRk=;
        b=mcK7p0K2WqHjue5heCSPSRaesdS7VPE4mdXVWdKICD8tahQuDzn41tNvd1fsiRrxTw
         1IzCjlBYilbAizHeUJAuq6C2EtUbWKIVHWRmUMuMxEGdqrgMOHUN4m/ub8ZlKgY/QiKv
         VL1/RxKdo9f/AQeoxNDzNyzo3WRgrk3muvhmAZvJ9LLWSr1Q/ricscGv6/j2Zow0BwBh
         PwUN4pINu8j1PkctC5UlwlKy9+viFILjPHSv6qEc31bOpDV4VfeagSwDGOhlS/Krnyt4
         +hGAWDV3UgcSS8LWy9WhLrv1E3xkYafXqcQIBFQDU+9yymCRPrK8HNip489IGbvVvuDZ
         SHpA==
X-Gm-Message-State: AOAM5325GS+JjnpKhSQqN1LvhwBq7e5rxl/4kQKD/R2yVcJx6zbb3EHW
        ij1UzKpTInO4yXn8YsI9bQXMLw==
X-Google-Smtp-Source: ABdhPJyOVV0ODNrXRXl4GTB1L8JglbkkcmT5s6PLzgeWhThPD84T4n78OmQCtqg3gE+tvn9EzvWdGA==
X-Received: by 2002:adf:e80a:: with SMTP id o10mr492035wrm.312.1597994212188;
        Fri, 21 Aug 2020 00:16:52 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:16:51 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 03/32] wireless: intel: iwlwifi: mvm: ops: Remove unused static struct 'iwl_mvm_debug_names'
Date:   Fri, 21 Aug 2020 08:16:15 +0100
Message-Id: <20200821071644.109970-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Looks as if it's never been used.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlwifi/mvm/ops.c:466:36: warning: ‘iwl_mvm_debug_names’ defined but not used [-Wunused-const-variable=]

Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index d095ff847be92..8e1e9ffbbf59a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -460,15 +460,6 @@ static const struct iwl_hcmd_names iwl_mvm_data_path_names[] = {
 	HCMD_NAME(RX_QUEUES_NOTIFICATION),
 };
 
-/* Please keep this array *SORTED* by hex value.
- * Access is done through binary search
- */
-static const struct iwl_hcmd_names iwl_mvm_debug_names[] = {
-	HCMD_NAME(DBGC_SUSPEND_RESUME),
-	HCMD_NAME(BUFFER_ALLOCATION),
-	HCMD_NAME(MFU_ASSERT_DUMP_NTF),
-};
-
 /* Please keep this array *SORTED* by hex value.
  * Access is done through binary search
  */
-- 
2.25.1

