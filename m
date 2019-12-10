Return-Path: <SRS0=GVYC=2A=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 202CCC2D0BF
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Dec 2019 21:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0A8A246C5
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Dec 2019 21:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576012316;
	bh=pzi1vL0hkyrXR2jUHZDlNfMMLNo4U5WbuJLOK4qOVfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=zQZPrVftGyjIzqubpEj4TtagtCtwCTylwkWr1LHBLPJGl/GHcDwJsbj3ZFkAhmt5F
	 xJHy1PzmLDB7ujGKipITC7cTNBPemeo/mieiSaqJL2vNEY2AZG9nR5rIWtCHFCEjHN
	 CO9WaVfepKsqJldfnxLzLneHL8+tVTE+qX676ITs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbfLJVLz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 Dec 2019 16:11:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728864AbfLJVLy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Dec 2019 16:11:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B09D9246BF;
        Tue, 10 Dec 2019 21:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012313;
        bh=pzi1vL0hkyrXR2jUHZDlNfMMLNo4U5WbuJLOK4qOVfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=esn3ofl/WfHJUCnGFeucCapm5mWIK0ldB6s9/QfYZrJgtCoZsQ8tdU+Nq4UiAh8b0
         BTLoRESN5+gOa8buzIdtQ+XnnXyFHfvgIdVhDJa7SK72CBmDWO5wHC6tMqh9d3bdGq
         4NElyXXtp2vISOTVQDRkmCcrQm3qulaXgxcpzMr8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaoqing Pan <miaoqing@codeaurora.org>,
        Hou Bao Hou <houbao@codeaurora.org>,
        Anilkumar Kolli <akolli@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 248/350] ath10k: fix get invalid tx rate for Mesh metric
Date:   Tue, 10 Dec 2019 16:05:53 -0500
Message-Id: <20191210210735.9077-209-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Miaoqing Pan <miaoqing@codeaurora.org>

[ Upstream commit 05a11003a56507023f18d3249a4d4d119c0a3e9c ]

ath10k does not provide transmit rate info per MSDU
in tx completion, mark that as -1 so mac80211
will ignore the rates. This fixes mac80211 update Mesh
link metric with invalid transmit rate info.

Tested HW: QCA9984
Tested FW: 10.4-3.9.0.2-00035

Signed-off-by: Hou Bao Hou <houbao@codeaurora.org>
Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/txrx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 4102df0169311..39abf8b129035 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -95,6 +95,8 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
 	info = IEEE80211_SKB_CB(msdu);
 	memset(&info->status, 0, sizeof(info->status));
+	info->status.rates[0].idx = -1;
+
 	trace_ath10k_txrx_tx_unref(ar, tx_done->msdu_id);
 
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
-- 
2.20.1

