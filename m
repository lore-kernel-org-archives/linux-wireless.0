Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB694C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86A2F218D0
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:42:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="kujlx6Sj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfCPUm0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 16:42:26 -0400
Received: from 9.mo7.mail-out.ovh.net ([46.105.60.248]:55140 "EHLO
        9.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfCPUm0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 16:42:26 -0400
Received: from player746.ha.ovh.net (unknown [10.109.146.5])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id DD8B6102E5F
        for <linux-wireless@vger.kernel.org>; Sat, 16 Mar 2019 21:42:24 +0100 (CET)
Received: from awhome.eu (p4FF91B93.dip0.t-ipconnect.de [79.249.27.147])
        (Authenticated sender: postmaster@awhome.eu)
        by player746.ha.ovh.net (Postfix) with ESMTPSA id B358F3D706C3;
        Sat, 16 Mar 2019 20:42:23 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1552768941;
        bh=xVpjDvkfCmB7qct8MkcAccM3kMFfOaVLGK3mwYoZbMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=kujlx6Sj4w5azp/sevTRXlgCaT2Kt3nPrf7bZHzHq4QObnp5o79FRwJjr3PfYnzgu
         OJgBmwcN3ohQW9r4m52fM4JjO8zCD9i6qsxtKV/rq200R4UwfPHShxwRaNOsO3eiN0
         syQa5snwfSs9YwzQOQamVFjk3/tGPqsmVF/24MAA=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH 5/5] mac80211_hwsim: Ext Key ID support (NATIVE)
Date:   Sat, 16 Mar 2019 21:42:08 +0100
Message-Id: <20190316204208.16497-6-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190316204208.16497-1-alexander@wetzel-home.de>
References: <20190316204208.16497-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6895011033778822343
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrheejgddugeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenuc
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Driver is not supporting hardware encryption and therefore fully
compatible with Extended Key ID.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0838af04d681..8cbadf825c76 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2799,6 +2799,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	ieee80211_hw_set(hw, SIGNAL_DBM);
 	ieee80211_hw_set(hw, SUPPORTS_PS);
 	ieee80211_hw_set(hw, TDLS_WIDER_BW);
+	ieee80211_hw_set(hw, EXT_KEY_ID_NATIVE);
 	if (rctbl)
 		ieee80211_hw_set(hw, SUPPORTS_RC_TABLE);
 	ieee80211_hw_set(hw, SUPPORTS_MULTI_BSSID);
-- 
2.21.0

