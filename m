Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 275CAC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 00:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E963F2081B
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 00:03:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ecjf3r1o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfCHADn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Mar 2019 19:03:43 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44456 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbfCHADn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Mar 2019 19:03:43 -0500
Received: by mail-ed1-f66.google.com with SMTP id b20so14965199edw.11;
        Thu, 07 Mar 2019 16:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c0itl/kabfcQpva9bMOxqZi7A9Q75b5+ipUV2o5Snj0=;
        b=ecjf3r1oNYBJD70KohhbMpD0eAzYhbNWAXi7cXHOTkwL+Q+Y9lOkHWX77Lx3C/kqEA
         xn+TuCnowVMGUfrqnx191+tnBLktasckojiJ91JBPovIAtU/f696+EzRLLSwgB265a1G
         LAUUx51utTgOUYZcRfngdy7mMcnzM7oNnFBQad76fr7jFi/f1vw4zHauMpPf126D48Hb
         ibELvjOFX4+ptiVfVGeaYf8JFpiZnZdcHSW6sX0yAgQWL6ftCc60rUQKw7lbh3HtCJjG
         +tF0NVz3d1b3dIC13rQoGMG73TENWpUZnDge1uu285P7nyNA+UkLqftJR8Dch7BJm9O+
         Igxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c0itl/kabfcQpva9bMOxqZi7A9Q75b5+ipUV2o5Snj0=;
        b=J/xlGmOmsGKIpzBXhD/CVsmNotZQJw5gt4cOK20WlOIkHL1WSZoV1ohKw5r8LUV4TC
         Z8tvGbamNY0WeN+Gbe3lBQVjwvYNSXPI47PAB6nhrqA2JhDsU1FzCTfhO4S2gKdd0yTN
         7uvcqiLWEfaRQVum0TE5NmN0/+m+a3DSM9Rk8HbigDjM2BxiQrrTRdhFadqvMhP1nibl
         XunOTUgGv4onF1pkUI4+qEHAtBVh3t9EXCzg0ySvPN8IDX/i0ME6mlzOlXcPjVaCUojW
         vLAC6naRDseF0gIHkfDaBOP3bCGVmOeuR4ap35iG5j1zYa7Nx77QMzZHlLFKbPyy9EtN
         NkJA==
X-Gm-Message-State: APjAAAVrYlB/hGp8uqE1SJtN0e8LDrUwF+OqkBTTiT+2QqhmB1cCA+QM
        fxP6aon+G8tFbfcQYLw0gZg=
X-Google-Smtp-Source: APXvYqzg5o6pRHnv/iEHXNX5tiIJtkK1uV8Ws3xkM4myX3HCRqd9BESS8c/9WEfowWZHZtdUa1YCnA==
X-Received: by 2002:a50:b16e:: with SMTP id l43mr28698148edd.99.1552003420949;
        Thu, 07 Mar 2019 16:03:40 -0800 (PST)
Received: from localhost.localdomain ([2a01:4f9:2a:1fae::2])
        by smtp.gmail.com with ESMTPSA id z39sm1742849edc.96.2019.03.07.16.03.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 16:03:40 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] iwlwifi: mvm: Change an 'else if' into an 'else' in iwl_mvm_send_add_bcast_sta
Date:   Thu,  7 Mar 2019 17:03:22 -0700
Message-Id: <20190308000322.5379-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When building with -Wsometimes-uninitialized, Clang warns:

drivers/net/wireless/intel/iwlwifi/mvm/sta.c:2114:12: warning: variable
'queue' is used uninitialized whenever 'if' condition is false
[-Wsometimes-uninitialized]

Clang can't evaluate at this point that WARN(1, ...) always returns true
because __ret_warn_on is defined as !!(condition), which isn't
immediately evaluated as 1. Change this branch to else so that it's
clear to Clang that we intend to bail out here.

Link: https://github.com/ClangBuiltLinux/linux/issues/399
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 498c315291cf..360724ec41a6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2111,8 +2111,10 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 			queue = mvm->probe_queue;
 		else if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
 			queue = mvm->p2p_dev_queue;
-		else if (WARN(1, "Missing required TXQ for adding bcast STA\n"))
+		else {
+			WARN(1, "Missing required TXQ for adding bcast STA\n");
 			return -EINVAL;
+		}
 
 		bsta->tfd_queue_msk |= BIT(queue);
 
-- 
2.21.0

