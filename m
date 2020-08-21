Return-Path: <SRS0=HZW5=B7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA67C433E1
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Aug 2020 07:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 747F120732
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Aug 2020 07:22:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ccXCVJN3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgHUHWU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 21 Aug 2020 03:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728063AbgHUHRF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Aug 2020 03:17:05 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B12C061385
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2020 00:17:03 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f7so1028779wrw.1
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2020 00:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=watylvtavvjnlIiL88AKksk2UODGv6ozdE6QDJoiV0Y=;
        b=ccXCVJN3HujOShRqd2sm2riBRxzwUXnQehkWvlyy6zd6t/C+Izp3ijISrZyQfPlLXZ
         EE0gJ/kYsY0PNYDwlNJ/lslX+2arGY9Fhei9r0OWYtWOvJg27nfUzY4nHqdMu0wdmZQk
         R+b4+kxHqdh9ZqgsabvHLV8o+D01mHnjcRzjx2RmXRgyiBcngrIOOtZOX5avf6m4sJfM
         7BQ3WTVdM6veNj7oAw6dtRjO7rUVYTQGnNc+0BRYbIiPuNTzSJh9u83fcZezs4urdvg2
         tYL7KJESIQdOH52U3VBESna70Jop4Cx0PqAiyJobH/gQuV8LR5T1GgUfzLWL0w0zJby6
         M/yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=watylvtavvjnlIiL88AKksk2UODGv6ozdE6QDJoiV0Y=;
        b=PBOltRr0WKWZUphdaK3JKO8K81stb5oQ1dyE/EDK0nLACAAgWlppiuQnvDC+H6vaar
         V2N8lqYZ8QEOq+wKg+RoL4xSC55CKnhfs+H4gwhZ0JbpRsUCqPd5Pe0fy5cvBnW/VCcr
         WsN4kKBLenCR1W6CVa7GL/iqcwmqEGfD0mf5TT0dZl0m6esSTAFnUQSdALpqGCwO7Mmc
         n0wGjvUcCGceZe8SB8oCSqaOdfWEbBhHBBmp6gw8BElfvxtx0E0MBZYhnRFR6seShh4S
         PsLkTjz/zwOBbgCv0c9M7nYXb05ZLrf0gON4j0ggVRTKv8YAyVUHf3S6ij2xqu/0+x6x
         39iA==
X-Gm-Message-State: AOAM530H37ywdHJrJCs2+VdIIabcrnV1bOGJBNZhpL2zZ5DCfhrTQ22Y
        l1f9xBjDB8PaHp4hscXrDNvZQQ==
X-Google-Smtp-Source: ABdhPJwLxx4gwc9JN5PLV26WbDWjb9vTX8czrpu9nJpTInod73eWQpO9n7f2QWfmRNSwc/mRgwhCQA==
X-Received: by 2002:adf:d849:: with SMTP id k9mr1486668wrl.115.1597994222392;
        Fri, 21 Aug 2020 00:17:02 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:17:01 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 11/32] wireless: intel: iwlwifi: dvm: scan: Demote a few nonconformant kernel-doc headers
Date:   Fri, 21 Aug 2020 08:16:23 +0100
Message-Id: <20200821071644.109970-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

2 of which do not attempt to document their parameters, 1 does a poor job.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlwifi/dvm/scan.c:193: warning: Function parameter or member 'priv' not described in 'iwl_scan_cancel'
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c:205: warning: Function parameter or member 'priv' not described in 'iwl_scan_cancel_timeout'
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c:570: warning: Function parameter or member 'frame' not described in 'iwl_fill_probe_req'
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c:570: warning: Function parameter or member 'ta' not described in 'iwl_fill_probe_req'
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c:570: warning: Function parameter or member 'ies' not described in 'iwl_fill_probe_req'
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c:570: warning: Function parameter or member 'ie_len' not described in 'iwl_fill_probe_req'
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c:570: warning: Function parameter or member 'ssid' not described in 'iwl_fill_probe_req'
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c:570: warning: Function parameter or member 'ssid_len' not described in 'iwl_fill_probe_req'
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c:570: warning: Function parameter or member 'left' not described in 'iwl_fill_probe_req'

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
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
index 1d8590046ff7d..832fcbb787e98 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/scan.c
@@ -186,7 +186,7 @@ static void iwl_do_scan_abort(struct iwl_priv *priv)
 		IWL_DEBUG_SCAN(priv, "Successfully send scan abort\n");
 }
 
-/**
+/*
  * iwl_scan_cancel - Cancel any currently executing HW scan
  */
 int iwl_scan_cancel(struct iwl_priv *priv)
@@ -196,10 +196,9 @@ int iwl_scan_cancel(struct iwl_priv *priv)
 	return 0;
 }
 
-/**
+/*
  * iwl_scan_cancel_timeout - Cancel any currently executing HW scan
  * @ms: amount of time to wait (in milliseconds) for scan to abort
- *
  */
 void iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 {
@@ -560,10 +559,9 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 	return added;
 }
 
-/**
+/*
  * iwl_fill_probe_req - fill in all required fields and IE for probe request
  */
-
 static u16 iwl_fill_probe_req(struct ieee80211_mgmt *frame, const u8 *ta,
 			      const u8 *ies, int ie_len, const u8 *ssid,
 			      u8 ssid_len, int left)
-- 
2.25.1

