Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB48C282CF
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:28:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70DDE20857
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548696494;
	bh=sGPrnnt4LNGpIXsfQSBa+4zvfJ8mFUE7DDbc95Ih33w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=1Yj5kIU0TbMCcE/CgyuK8aafvCRsLXP8fX8eGo4QozwsmOjzJ3q8/DNICYsahKC6y
	 35cAAHstT6dz+rNCtAFkoQApvHsFNzHyJ0ulUSvhBthzSw+GIDUDBzGbCUHzHy1YRF
	 eCn6QkK35ZWtO/TrgwWSzUMVsAg6Y9XVm1w4drKA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbfA1R2H (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 12:28:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730404AbfA1QAA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 11:00:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB1BA2175B;
        Mon, 28 Jan 2019 15:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548691199;
        bh=sGPrnnt4LNGpIXsfQSBa+4zvfJ8mFUE7DDbc95Ih33w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LocSPK7++5ywdNSRIoxwOswNcTrXx6wcod8xPKqtN0+U/OktXnRMPzbI8FQ+6S6ge
         6Y48e3ewUxLm00rjL0uqWvyDloU7lnES4H+CfGylLoBH5vbXOxbHihE2HmfE+rLVAf
         rrYYsGlsV09KTUqmK7c57Nr9NNiEGJM4d78JDFxg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lior David <liord@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 012/258] wil6210: fix memory leak in wil_find_tx_bcast_2
Date:   Mon, 28 Jan 2019 10:55:18 -0500
Message-Id: <20190128155924.51521-12-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128155924.51521-1-sashal@kernel.org>
References: <20190128155924.51521-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lior David <liord@codeaurora.org>

[ Upstream commit 664497400c89a4d40aee51bcf48bbd2e4dc71104 ]

A successful call to wil_tx_ring takes skb reference so
it will only be freed in wil_tx_complete. Consume the skb
in wil_find_tx_bcast_2 to prevent memory leak.

Signed-off-by: Lior David <liord@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 6a7943e487fb..75c8aa297107 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1313,6 +1313,8 @@ static struct wil_ring *wil_find_tx_bcast_2(struct wil6210_priv *wil,
 			wil_dbg_txrx(wil, "BCAST DUP -> ring %d\n", i);
 			wil_set_da_for_vring(wil, skb2, i);
 			wil_tx_ring(wil, vif, v2, skb2);
+			/* successful call to wil_tx_ring takes skb2 ref */
+			dev_kfree_skb_any(skb2);
 		} else {
 			wil_err(wil, "skb_copy failed\n");
 		}
-- 
2.19.1

