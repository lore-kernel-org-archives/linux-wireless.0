Return-Path: <SRS0=JTkr=53=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1C7C2BBC7
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Apr 2020 23:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C0DB2051A
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Apr 2020 23:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586647785;
	bh=F3GZCkfuTpePzhtk5oZ3eLfLVs1Pby/rMwXEm7QXV5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=p1WFJmAnmTkIYXUflbjWU8xD3zCJ0wfUfFnzhhlCS9xY/OhIloOvnx4h7U1LbCO+x
	 7stksdxD0HqByednW1Qqqx87BC7gXSW2k3KtzOk4V5N9wwq8TlsYu2wuXiMHVc9aVk
	 XGvDmQLANGX5gXSJ96ud3QGZCVu5DIGsyrnmLaEc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729728AbgDKXKz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729721AbgDKXKy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Apr 2020 19:10:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF02D217D8;
        Sat, 11 Apr 2020 23:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646654;
        bh=F3GZCkfuTpePzhtk5oZ3eLfLVs1Pby/rMwXEm7QXV5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYIEwmzyqKKf1XBMfrgHVNZLu9MoxhSXAITuyAqFB4t8igB0gPP2dkcDW6jGJdjVd
         5GOge6zk38pWY6vdVZ5h0jCyDL+mrMCqterHmVBShvpdDRqAD9PHPRTgrO4IWd5M61
         HQl3r1jr9JfALNZifesIoTpGfRuWp4xVkkpK5X6k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 057/108] rsi: fix null pointer dereference during rsi_shutdown()
Date:   Sat, 11 Apr 2020 19:08:52 -0400
Message-Id: <20200411230943.24951-57-sashal@kernel.org>
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
index 1bebba4e85273..5d6143a551877 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1468,12 +1468,15 @@ static void rsi_shutdown(struct device *dev)
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

