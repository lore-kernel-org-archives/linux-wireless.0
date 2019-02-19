Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F15D0C4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 18:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C298B2089F
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 18:21:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bJaxqV5n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfBSSV0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 13:21:26 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37414 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbfBSSV0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 13:21:26 -0500
Received: by mail-ed1-f65.google.com with SMTP id m12so17579547edv.4;
        Tue, 19 Feb 2019 10:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Uoj/fdArUdiL5Is7n9SVeEEbuXC2oMOgXwzH0SNqBcU=;
        b=bJaxqV5nFf5kxppNI6eUmXbb85kTLr6CM5boFtvSVT0O2w7GZZzJ4+mTp3uYv/a/iP
         jDv3SGuP7ECdPyQ1h51KYiqjlFRuwim9YDXwG/My0aCEdR3VRU6LLclPBUzdLm2+uEg2
         rHz01ZRj9VkktXCVCNTdd00B2iZFh4eHjqD2eoA4/Z0zPMjUFPrQxw2xxvJbpreoRDRw
         IFUPXmn8osNzQcobHnfwM5rGEXZB4Wfj+lxehi6rVD0IwNr51wlAsFxBy3IZrg4LbTfd
         YiyuIxGZo0TraLCqsKrcPSAbavV9yybN7Pg6L6IEBtdGmReBLOHcITpr8XRNQb1pKQ5x
         OLXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Uoj/fdArUdiL5Is7n9SVeEEbuXC2oMOgXwzH0SNqBcU=;
        b=Fot2Q68hZxjgCN1YNMH1T1brEoHwV+U4PZnP2PZri79oEHhQjf2jvz5Nw5pY7lqS+g
         HSHREMPkgeSO+TwZu6OLjXuERTBzpMUUEQEJUDIjyGN2tfLh6K6EuulwywrrpmkIGwh8
         jAfxDBU4Fv1pfkUjcVXypeL/Ws0aaWsVbDMKezTAIsOhJgOMLtmGlVtiPOG7mQM6h2LM
         /zNBRRwofCIn1vsUkfYQ/bdYogTB6UgYXqVZZFlSmN5CuHREY8LwwzFXKyfLVfbONsAF
         9zTrKSfXlzSs0iEwC/GNjht+M0elWZZni6nR0iNGzIesZhL8i6hU+Z6WTT510+OMmcVJ
         Ez9A==
X-Gm-Message-State: AHQUAuaE90kisVxosA7KJFdaKULTVtI1JR+l29lf4x7hWiSKUaCZ4z0I
        5jdGjQ0vWWpE5Sgz74T9Uj8=
X-Google-Smtp-Source: AHgI3Ib7fjLiV6er9S6Yh6FytQ8YA+12PjyB2huff15jlYdZWCe7ibebwdrTHQJBv5AxqyydHYqBkA==
X-Received: by 2002:a17:906:4a53:: with SMTP id a19mr20882479ejv.229.1550600483542;
        Tue, 19 Feb 2019 10:21:23 -0800 (PST)
Received: from localhost.localdomain ([2a01:4f9:2a:1fae::2])
        by smtp.gmail.com with ESMTPSA id e27sm302450eda.52.2019.02.19.10.21.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Feb 2019 10:21:22 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] iwlwifi: mvm: Use div64_s64 instead of do_div in iwl_mvm_debug_range_resp
Date:   Tue, 19 Feb 2019 11:21:05 -0700
Message-Id: <20190219182105.19933-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.21.0.rc1
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

do_div expects an unsigned dividend. Use div64_s64, which expects a
signed dividend.

Fixes: 937b10c0de68 ("iwlwifi: mvm: add debug prints for FTM")
Link: https://github.com/ClangBuiltLinux/linux/issues/372
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index e9822a3ec373..92b22250eb7d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -462,7 +462,7 @@ static void iwl_mvm_debug_range_resp(struct iwl_mvm *mvm, u8 index,
 {
 	s64 rtt_avg = res->ftm.rtt_avg * 100;
 
-	do_div(rtt_avg, 6666);
+	div64_s64(rtt_avg, 6666);
 
 	IWL_DEBUG_INFO(mvm, "entry %d\n", index);
 	IWL_DEBUG_INFO(mvm, "\tstatus: %d\n", res->status);
-- 
2.21.0.rc1

