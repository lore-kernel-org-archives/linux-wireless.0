Return-Path: <SRS0=dicy=TW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D4AEC282CE
	for <linux-wireless@archiver.kernel.org>; Wed, 22 May 2019 19:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64F5120862
	for <linux-wireless@archiver.kernel.org>; Wed, 22 May 2019 19:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558554846;
	bh=WRDWdcYe/dmdSqigJ92qRz3Bm1CJW3V6dtXb0v4xKY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=kcGj2xImv0ifJk/Nre4tCd3YPuLsDN6Sc19NKeiEaoTIJ4xy/kjr4Uxo76KuSGzoz
	 v/Mwr8MagXbWxpY9rMKDvozFJldtPWgVaY8kvTMQfdFpqYAFRQzAObF2+5+I5q3PGu
	 CFOxo8F8Hj2WhSSU9iUqu3UG3muj4O06FCFk+TOc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731846AbfEVTx7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 22 May 2019 15:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731722AbfEVTZp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 May 2019 15:25:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04C1D21841;
        Wed, 22 May 2019 19:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553144;
        bh=WRDWdcYe/dmdSqigJ92qRz3Bm1CJW3V6dtXb0v4xKY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JmTrdUjVQHt/tPaomxcmfv2YIklNhcnnuWPjeNInrB0W8WrKRqRHSDsKN8B7QOSyN
         YpZejxh3+vYvQo+FVToIr+ADQaXSWt189wt2lWWOL63LJwUhtm/LZhctAOYmvnGkto
         Cpu0K0BmTA74RbU2xV8fTDQNlBBZ89WUAhASkSW4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 074/317] mwifiex: prevent an array overflow
Date:   Wed, 22 May 2019 15:19:35 -0400
Message-Id: <20190522192338.23715-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b4c35c17227fe437ded17ce683a6927845f8c4a4 ]

The "rate_index" is only used as an index into the phist_data->rx_rate[]
array in the mwifiex_hist_data_set() function.  That array has
MWIFIEX_MAX_AC_RX_RATES (74) elements and it's used to generate some
debugfs information.  The "rate_index" variable comes from the network
skb->data[] and it is a u8 so it's in the 0-255 range.  We need to cap
it to prevent an array overflow.

Fixes: cbf6e05527a7 ("mwifiex: add rx histogram statistics support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/cfp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfp.c b/drivers/net/wireless/marvell/mwifiex/cfp.c
index bfe84e55df776..f1522fb1c1e87 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfp.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfp.c
@@ -531,5 +531,8 @@ u8 mwifiex_adjust_data_rate(struct mwifiex_private *priv,
 		rate_index = (rx_rate > MWIFIEX_RATE_INDEX_OFDM0) ?
 			      rx_rate - 1 : rx_rate;
 
+	if (rate_index >= MWIFIEX_MAX_AC_RX_RATES)
+		rate_index = MWIFIEX_MAX_AC_RX_RATES - 1;
+
 	return rate_index;
 }
-- 
2.20.1

