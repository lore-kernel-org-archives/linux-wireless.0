Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A7C3C433B4
	for <linux-wireless@archiver.kernel.org>; Sun, 18 Apr 2021 16:46:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6036361359
	for <linux-wireless@archiver.kernel.org>; Sun, 18 Apr 2021 16:46:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbhDRQqk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 18 Apr 2021 12:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232284AbhDRQqk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Apr 2021 12:46:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E440C613AA;
        Sun, 18 Apr 2021 16:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618764371;
        bh=MVBORasL4C85D65v0E9u0AsjP1dv7j+jSdghNDwL24o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bbJ8D2D+oCQy811WUroJqU08e1BTzeHXwQjLuCuhSxD0+rLuS3xt5WxNie0TjsrCs
         qb5s++vi7IGWcrHyWCgrVf0ua7DPhNFfzWykf5S3PP//z/Yj+K300zzIJ3A32YtzXS
         Jx5yg+2hDzupAMeGly8g8yq9cLcq1GVuHNIF3Q0XxEc+zy8/kCNxZjNmMmGHYJkYiY
         uiXF33LBsXqJQtd3NkiT28hRuifPg87y+tM24/9WZQcV2k+Rxa7r85/qnYANXqofyO
         gS6YlFO2yiWk0HcctmoK96Sdjbkjy6SpTICPjA2aDfeMbTx3H/z1+qBIC7v4Eq4YJv
         FVL5qIGF/SUoQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com
Subject: [PATCH 12/19] mt76: mt7921: get rid of useless MT76_STATE_PM in mt7921_mac_work
Date:   Sun, 18 Apr 2021 18:45:38 +0200
Message-Id: <0641ddea8aa1cf4b04a7b191d48aad1d646bebb6.1618763001.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1618763000.git.lorenzo@kernel.org>
References: <cover.1618763000.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove useless MT76_STATE_PM check in mt7921_mac_work since
mt7921_mutex_acquire will wake up the device if necessary

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index a8247a6d5bc7..5dcb574a2768 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1493,9 +1493,6 @@ void mt7921_mac_work(struct work_struct *work)
 					       mac_work.work);
 	phy = mphy->priv;
 
-	if (test_bit(MT76_STATE_PM, &mphy->state))
-		goto out;
-
 	mt7921_mutex_acquire(phy->dev);
 
 	mt76_update_survey(mphy->dev);
@@ -1510,8 +1507,6 @@ void mt7921_mac_work(struct work_struct *work)
 	}
 
 	mt7921_mutex_release(phy->dev);
-
-out:
 	ieee80211_queue_delayed_work(phy->mt76->hw, &mphy->mac_work,
 				     MT7921_WATCHDOG_TIME);
 }
-- 
2.30.2

