Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57434C4360F
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 19:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 299F2213A2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 19:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552505224;
	bh=1OpTT7UVpeXWArLgvnPQaoCtofbff5FSCGvoiBGGCpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=EYgBeVc2d+mkMBr+BaJWrhu9FYpjzd0mc/h6i+1B2rOtxajaIs5QRK9D9mHY4Of/Y
	 APiu2l35uuVJ4z2Vs/eqnNxpW2uhplq2j/qenvdStxJ9YzRD9n+0vg4twfJCGj6nwx
	 CiT5X0t6Fu++WSWNehgFOwoGPOFElPFEPU2CjePg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbfCMTOl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 15:14:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728243AbfCMTOk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 15:14:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7534E2075C;
        Wed, 13 Mar 2019 19:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552504480;
        bh=1OpTT7UVpeXWArLgvnPQaoCtofbff5FSCGvoiBGGCpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EL/azNcVz5+G03yMRl2tGJcoaClCMgTdfl57WOIWeCIAC7+kd2hkBqz0HUM8e4VMg
         MuRz1cn3mzhHn/u91QQkNBe/AnLXHFW8KJady1I88uK8zNL/6riU6Eb7gfJUJ88CbS
         dlzHr+ec+Hk5sTq2w3fgLbIu0q8iDw5/a2A0fzBY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li RongQing <lirongqing@baidu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 38/48] mac80211_hwsim: propagate genlmsg_reply return code
Date:   Wed, 13 Mar 2019 15:12:40 -0400
Message-Id: <20190313191250.158955-38-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190313191250.158955-1-sashal@kernel.org>
References: <20190313191250.158955-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 17407715240456448e4989bee46ffc93991add83 ]

genlmsg_reply can fail, so propagate its return code

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 4ca6592f5b3a..7cd428c0af43 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3454,7 +3454,7 @@ static int hwsim_get_radio_nl(struct sk_buff *msg, struct genl_info *info)
 			goto out_err;
 		}
 
-		genlmsg_reply(skb, info);
+		res = genlmsg_reply(skb, info);
 		break;
 	}
 
-- 
2.19.1

