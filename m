Return-Path: <SRS0=JTkr=53=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC21C352B6
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Apr 2020 23:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1864321655
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Apr 2020 23:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586647429;
	bh=i9gxExS+y61Jh1kWHem0h4HuFrd8LANVfyJ9gZaCcn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=K/cAIKooXiT0w+0HyfAz4k/p9ZgTW2wGjYV9UuxI+8A63+1ZmOx3p7T0slSCX7Mpn
	 V0Yazubgfq6N9jrtjD3JXoJSgzR0wwCR41sDoifRD9l8jV+WKqNLxccs+NPUU0dC30
	 f20kB9IHkaQJYn6VprjS+lOj1WDg0ZOTMkPoGuJg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbgDKXMu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730255AbgDKXMt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Apr 2020 19:12:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0F9A20CC7;
        Sat, 11 Apr 2020 23:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646769;
        bh=i9gxExS+y61Jh1kWHem0h4HuFrd8LANVfyJ9gZaCcn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ggu85g9OciioGqiHiwvhTyRCMv1EmzGQ/n92s0il4zuRG9sPAwE6srzTTzkGrCG+Q
         ki1l9KsETzdQ++nZhyws2sJGpNa4v1/G/JKRjpmkt6KwJgLATJV/vLo6ET7kxwVRIg
         nVP7kfaJuYRXLeVkW99LTXFQYWQ4wDW7o3Uj8AKM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 38/66] rsi: fix null pointer dereference during rsi_shutdown()
Date:   Sat, 11 Apr 2020 19:11:35 -0400
Message-Id: <20200411231203.25933-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231203.25933-1-sashal@kernel.org>
References: <20200411231203.25933-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Martin Kepplinger <martin.kepplinger@puri.sm>

[ Upstream commit 16bbc3eb83728c03138191a5d23d84d38175fa26 ]

Appearently the hw pointer can be NULL while the module is loaded and
in that case rsi_shutdown() crashes due to the unconditional dereference.

Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 81cc1044532d1..fee43cd882f8f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1357,12 +1357,15 @@ static void rsi_shutdown(struct device *dev)
 	struct rsi_91x_sdiodev *sdev =
 		(struct rsi_91x_sdiodev *)adapter->rsi_dev;
 	struct ieee80211_hw *hw = adapter->hw;
-	struct cfg80211_wowlan *wowlan = hw->wiphy->wowlan_config;
 
 	rsi_dbg(ERR_ZONE, "SDIO Bus shutdown =====>\n");
 
-	if (rsi_config_wowlan(adapter, wowlan))
-		rsi_dbg(ERR_ZONE, "Failed to configure WoWLAN\n");
+	if (hw) {
+		struct cfg80211_wowlan *wowlan = hw->wiphy->wowlan_config;
+
+		if (rsi_config_wowlan(adapter, wowlan))
+			rsi_dbg(ERR_ZONE, "Failed to configure WoWLAN\n");
+	}
 
 	if (IS_ENABLED(CONFIG_RSI_COEX) && adapter->priv->coex_mode > 1 &&
 	    adapter->priv->bt_adapter) {
-- 
2.20.1

