Return-Path: <SRS0=oU4Q=ZI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 432BDC432C3
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Nov 2019 16:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 127652168B
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Nov 2019 16:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573921077;
	bh=9BUY48yvrLMhHqxYllnn6XxLMqRsZnTGF692jic1HTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=fPfqRuL3whgOt4g78e6/+v8+2lBhxeTy8YUDHJSdc1DrrMf2UQI5U3HanesLiZv37
	 HzYeUX2pneAIJM69vAVumSbK+8vZAFnAF35TdW50JbEu4VjUgzArHO+qKDc/DSI82z
	 G+OO6aCfzTZJyBsF2G0rCkxB2SxWV88IqsuL9v+M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbfKPPqg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Nov 2019 10:46:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728775AbfKPPqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:34 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE4F620869;
        Sat, 16 Nov 2019 15:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919194;
        bh=9BUY48yvrLMhHqxYllnn6XxLMqRsZnTGF692jic1HTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHUlFTwlZgLgRKWSRG79p2IUGIqXqsb2biBmcEnNNsg1Bdhu5fPi4cbWWtA8Og6gP
         7223qYvu0qrW5K7dLYzS4DEZInILhVlqHdf66lAxwFAEZL1HDgL/BzNfEm2MHPJhg+
         w7YgGzjMLNQIoUmmbJjR1Ux24G+vUOpcVy6E2qH4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 202/237] rtl8xxxu: Fix missing break in switch
Date:   Sat, 16 Nov 2019 10:40:37 -0500
Message-Id: <20191116154113.7417-202-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

[ Upstream commit 307b00c5e695857ca92fc6a4b8ab6c48f988a1b1 ]

Add missing break statement in order to prevent the code from falling
through to the default case.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 505ab1b055ff4..2b4fcdf4ec5bb 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5691,6 +5691,7 @@ static int rtl8xxxu_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.20.1

