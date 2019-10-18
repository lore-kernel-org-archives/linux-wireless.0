Return-Path: <SRS0=fVU0=YL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3981CA9EA0
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Oct 2019 22:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E8D8205C9
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Oct 2019 22:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571437314;
	bh=EkgPa+/bbt0VO+Jpe6yN+mBPY92zQyr3iwOjdFfnoKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2d+lThkaFJKOjdqFW6+/72zJYwBvHBbBuM7rQj04cxeQjRIQN0l0MY18RRz7S8PJ/
	 ShlUi0qX6VBA+hyRkpPLN5MEoN865P3JGCjYn5bjD8mLHNwSN/JWsUxPBi+IURyC4e
	 2bR6Iah8JDvS8Mewykokqx0ROL6iXI4sxVABzmX0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730838AbfJRWGJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Oct 2019 18:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730760AbfJRWGI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADE16205F4;
        Fri, 18 Oct 2019 22:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436367;
        bh=EkgPa+/bbt0VO+Jpe6yN+mBPY92zQyr3iwOjdFfnoKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1r1nQIrbMbr4/+eZXUTxQmsgvZMTlAuCEX1v7m0wYGEn4OHg3Sx3mT0NAWma6IL+H
         yEl/jfQ7eQYTavfTTDshhnnFzSiuorraWJyVEJpvkSXqOJE/Hpk/1Gh7Jp8GQc45Z/
         Q21LNzVReHU8veDChOjV4Cifw4tvL6m1rnwT3bJ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Abhishek Ambure <aambure@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 022/100] ath10k: assign 'n_cipher_suites = 11' for WCN3990 to enable WPA3
Date:   Fri, 18 Oct 2019 18:04:07 -0400
Message-Id: <20191018220525.9042-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Abhishek Ambure <aambure@codeaurora.org>

[ Upstream commit 7ba31e6e0cdc0cc2e60e1fcbf467f3c95aea948e ]

Hostapd uses CCMP, GCMP & GCMP-256 as 'wpa_pairwise' option to run WPA3.
In WCN3990 firmware cipher suite numbers 9 to 11 are for CCMP,
GCMP & GCMP-256.

To enable CCMP, GCMP & GCMP-256 cipher suites in WCN3990 firmware,
host sets 'n_cipher_suites = 11' while initializing hardware parameters.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Signed-off-by: Abhishek Ambure <aambure@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 5210cffb53440..2791ef2fd716c 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -532,7 +532,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.hw_ops = &wcn3990_ops,
 		.decap_align_bytes = 1,
 		.num_peers = TARGET_HL_10_TLV_NUM_PEERS,
-		.n_cipher_suites = 8,
+		.n_cipher_suites = 11,
 		.ast_skid_limit = TARGET_HL_10_TLV_AST_SKID_LIMIT,
 		.num_wds_entries = TARGET_HL_10_TLV_NUM_WDS_ENTRIES,
 		.target_64bit = true,
-- 
2.20.1

