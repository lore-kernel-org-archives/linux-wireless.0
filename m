Return-Path: <SRS0=JTkr=53=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFBC3C2BA19
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Apr 2020 23:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9ED50217D8
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Apr 2020 23:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586646614;
	bh=ztDm9bDxQ2F+ABB3s+LOP04FIEWsETgfVZYP/Ofc6Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=k+3gWEa7mFzEWFIQzp7xd0kZZmV1V5bWPvs3H0yDDUip/zlNSporK7ZpL/tVE7vFV
	 vG92voQ0CxNP5ng/49qNSpCu0SotoCqYYlhHtmkEt/w0hHUnBVv/+eoZHuxdw8wgtJ
	 8IEX5R4BsFZv6fVkZRuTydowO2cM58DVyAbjG1UY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgDKXKN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:10:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729460AbgDKXKM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Apr 2020 19:10:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 322DE20757;
        Sat, 11 Apr 2020 23:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646612;
        bh=ztDm9bDxQ2F+ABB3s+LOP04FIEWsETgfVZYP/Ofc6Bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hx3G2+QLWgv/RxlNcNREkDTIY46fAB7Z+L0VMcq7XtcbKucDwgP2Z2bFyMEk8nk0R
         jPUNnsO6xrlibawfbg/OPWlKfJEojQv5wc9UfXNjJ0j6M+gptngHjcitO7ZYUs0kGJ
         J5+f/k29eNjVqZ41ApMaU5lqtL4SV5sEOD84HvZY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yibo Zhao <yiboz@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 023/108] ath10k: fix not registering airtime of 11a station with WMM disable
Date:   Sat, 11 Apr 2020 19:08:18 -0400
Message-Id: <20200411230943.24951-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Yibo Zhao <yiboz@codeaurora.org>

[ Upstream commit f9680c75d187f2d5b9288c02f7a432041d4447b4 ]

The tid of 11a station with WMM disable reported by FW is 0x10 in
tx completion. The tid 16 is mapped to a NULL txq since buffer
MMPDU capbility is not supported. Then 11a station's airtime will
not be registered due to NULL txq check. As a results, airtime of
11a station keeps unchanged in debugfs system.

Mask the tid along with IEEE80211_QOS_CTL_TID_MASK to make it in
the valid range.

Hardwares tested : QCA9984
Firmwares tested : 10.4-3.10-00047

Signed-off-by: Yibo Zhao <yiboz@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 9f0e7b4943ec6..e30160418802f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2732,7 +2732,8 @@ static void ath10k_htt_rx_tx_compl_ind(struct ath10k *ar,
 			continue;
 		}
 
-		tid = FIELD_GET(HTT_TX_PPDU_DUR_INFO0_TID_MASK, info0);
+		tid = FIELD_GET(HTT_TX_PPDU_DUR_INFO0_TID_MASK, info0) &
+						IEEE80211_QOS_CTL_TID_MASK;
 		tx_duration = __le32_to_cpu(ppdu_dur->tx_duration);
 
 		ieee80211_sta_register_airtime(peer->sta, tid, tx_duration, 0);
-- 
2.20.1

