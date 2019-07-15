Return-Path: <SRS0=nAss=VM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 929C3C7618F
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Jul 2019 15:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 648332054F
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Jul 2019 15:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563203230;
	bh=lGV2uMNimGPV9nxzkGcnvRJAD5cl8EMe+T+ATROi8Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WrS1QCXqaEeO5quQcythqWXBf6bjFaGdRxcVdzpc9KRnZbit90+VIOTQ/xlrsTn+p
	 bJH40OaWt4I0P3CcIteJEJs88Q2UniVRMd3DSLH69IeTn8PI6p1EY0Kk6t/qOb7uJf
	 LlpawfQ7C5G8tekkoU2Aevf0oSvEDw1DDgLN6qSU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387833AbfGOOEG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Jul 2019 10:04:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730743AbfGOOEF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jul 2019 10:04:05 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69558217D9;
        Mon, 15 Jul 2019 14:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199444;
        bh=lGV2uMNimGPV9nxzkGcnvRJAD5cl8EMe+T+ATROi8Bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAqcMQl+0jS1MVzl6j3BgrRu759XS9AMUNFoA8ho1PrAvX6H9qCPrd5/SqfrTl3ft
         1YUqwLde4cqFALUjFsr+/ze9cJ/SOAvLH1hFl7kTFGc59AH3ppNd5+dx+RJN/1VMFv
         dlWttie6o8RG4H8teG9wT03ubMylFFiTdN1yqvSI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 005/219] wil6210: fix potential out-of-bounds read
Date:   Mon, 15 Jul 2019 10:00:06 -0400
Message-Id: <20190715140341.6443-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

[ Upstream commit bfabdd6997323adbedccb13a3fed1967fb8cf8f5 ]

Notice that *rc* can evaluate to up to 5, include/linux/netdevice.h:

enum gro_result {
        GRO_MERGED,
        GRO_MERGED_FREE,
        GRO_HELD,
        GRO_NORMAL,
        GRO_DROP,
        GRO_CONSUMED,
};
typedef enum gro_result gro_result_t;

In case *rc* evaluates to 5, we end up having an out-of-bounds read
at drivers/net/wireless/ath/wil6210/txrx.c:821:

	wil_dbg_txrx(wil, "Rx complete %d bytes => %s\n",
		     len, gro_res_str[rc]);

Fix this by adding element "GRO_CONSUMED" to array gro_res_str.

Addresses-Coverity-ID: 1444666 ("Out-of-bounds read")
Fixes: 194b482b5055 ("wil6210: Debug print GRO Rx result")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reviewed-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 4ccfd1404458..d74837cce67f 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -750,6 +750,7 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 		[GRO_HELD]		= "GRO_HELD",
 		[GRO_NORMAL]		= "GRO_NORMAL",
 		[GRO_DROP]		= "GRO_DROP",
+		[GRO_CONSUMED]		= "GRO_CONSUMED",
 	};
 
 	wil->txrx_ops.get_netif_rx_params(skb, &cid, &security);
-- 
2.20.1

