Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A57C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 08:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C428A2086C
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 08:08:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t+yTsHml"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbfBUIIc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 03:08:32 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34188 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbfBUIIc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 03:08:32 -0500
Received: by mail-ed1-f67.google.com with SMTP id a16so793230edn.1;
        Thu, 21 Feb 2019 00:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HAbQ6pp9a1D+fzZryE7X99pelSqqxGYLtzUJm1AXnt8=;
        b=t+yTsHmlIiw5yFhM5Ospkv6VMmfB55yFWLl9N9SLMrHQsr7IAnhZTG0DuSuWkuAklp
         vwjBG/05cYEXQxvZZct1QVEQu2M/ThHmQHHDniGH+nJgfmVR8TQVQq6E6xF+rtX9q/j7
         U6mxk3Ll8+vELj7du1aM/So+IwHrVwxej9A6hBguFWHccFEcNbW4EOkhjQrjozynSiBK
         vNWgFg49VjdqCn+L5XngDkAfHhLKQQauJr6MBfuc1H0bC0dScKwgVRprz0KU5c1bQUva
         MBTi0k3iOLcvLioMY8it1vXJwzb7suVskMTmslhooa9WXnse+/xrm2FVYYebTLNWka34
         4yvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HAbQ6pp9a1D+fzZryE7X99pelSqqxGYLtzUJm1AXnt8=;
        b=JKm4oqyCaOoX6TWurfqBWRleGMLnJVNsIkv+wV4ZXcOpvMcwVW8JZOGq7296Bn8xjl
         jJR1XRh29nVE2njghBwVaeTT5tefk4HEf6bwvuGThbOsyXu8wGFW3j0Ab0fnLMjOqFLw
         I5zqy446v+J6Yov0CZH/xB4juMrDv+pKOYjYy7rGHnZsY5dCBa4CWVbRyyTWGe8c+Awt
         LsTI2dFuo/gSHuSbnvRChbIcthrmwFgEn9WvdBcW3CjgQ8Iw+TFx3ne+JYx/G1144X56
         qFVqfXDA4UV4P4Y1R7Y3NXH0yxpXT1Qfp0IqJTALwTa6AFOaOOtjHCTWV6v9ogpBG41k
         /wRw==
X-Gm-Message-State: AHQUAubEW0XhZyXvJxk5Ho534CO41X5WSW9Ldk6hUUNiE94rdnvs6cPP
        wdRSekK+cwVMiB1rEsL2x0I=
X-Google-Smtp-Source: AHgI3IaXLzub0JummNdtxRC1DhDkjL53vbHWgCR5B1Bg0sk6EoIAZZbhNLtRsoYJSBoG/KdTf0P8hQ==
X-Received: by 2002:a50:ac16:: with SMTP id v22mr18145691edc.186.1550736510015;
        Thu, 21 Feb 2019 00:08:30 -0800 (PST)
Received: from localhost.localdomain ([2a01:4f9:2a:1fae::2])
        by smtp.gmail.com with ESMTPSA id t9sm6416404edb.13.2019.02.21.00.08.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 00:08:29 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2] iwlwifi: mvm: Use div_s64 instead of do_div in iwl_mvm_debug_range_resp
Date:   Thu, 21 Feb 2019 01:06:18 -0700
Message-Id: <20190221080617.2795-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.21.0.rc1
In-Reply-To: <20190219182105.19933-1-natechancellor@gmail.com>
References: <20190219182105.19933-1-natechancellor@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Clang warns:

drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c:465:2: warning:
comparison of distinct pointer types ('typeof ((rtt_avg)) *' (aka 'long
long *') and 'uint64_t *' (aka 'unsigned long long *'))
[-Wcompare-distinct-pointer-types]
        do_div(rtt_avg, 6666);
        ^~~~~~~~~~~~~~~~~~~~~
include/asm-generic/div64.h:222:28: note: expanded from macro 'do_div'
        (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
               ~~~~~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~~
1 warning generated.

do_div expects an unsigned dividend. Use div_s64, which expects a signed
dividend.

Fixes: 937b10c0de68 ("iwlwifi: mvm: add debug prints for FTM")
Link: https://github.com/ClangBuiltLinux/linux/issues/372
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

v1 -> v2:

* Fix logic (as the return value of div{,64}_s64 must be used), thanks
  to Arnd for the review.

 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index e9822a3ec373..94132cfd1f56 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -460,9 +460,7 @@ static int iwl_mvm_ftm_range_resp_valid(struct iwl_mvm *mvm, u8 request_id,
 static void iwl_mvm_debug_range_resp(struct iwl_mvm *mvm, u8 index,
 				     struct cfg80211_pmsr_result *res)
 {
-	s64 rtt_avg = res->ftm.rtt_avg * 100;
-
-	do_div(rtt_avg, 6666);
+	s64 rtt_avg = div_s64(res->ftm.rtt_avg * 100, 6666);
 
 	IWL_DEBUG_INFO(mvm, "entry %d\n", index);
 	IWL_DEBUG_INFO(mvm, "\tstatus: %d\n", res->status);
-- 
2.21.0.rc1

