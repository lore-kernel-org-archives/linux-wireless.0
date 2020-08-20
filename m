Return-Path: <SRS0=RiXY=B6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C489C433E1
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Aug 2020 19:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46DD3207DE
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Aug 2020 19:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597952466;
	bh=3Lsjp1e96C8mu/TL+Rnxj2VWX5AqkHFI6+trsDCXMiI=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=TYT6gmwKcRuiShqyO/+9M7b8bUWLcNboQAyyuEzmvPq3DfIGPOo3n/h0/lGVWFbm1
	 xI0C19l2rOay1y3xrNRWTMgi2WNO7P9MP9R80v2iP4zGPHnDT5y6Spovj3pZYPGuyJ
	 XfEUWAPj24/mcRcniJrjHaU5e2qEGHu08T4iuwL0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgHTTk4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Aug 2020 15:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbgHTTkz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Aug 2020 15:40:55 -0400
Received: from kozik-lap.mshome.net (unknown [194.230.155.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6009A207DE;
        Thu, 20 Aug 2020 19:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597952455;
        bh=3Lsjp1e96C8mu/TL+Rnxj2VWX5AqkHFI6+trsDCXMiI=;
        h=From:To:Cc:Subject:Date:From;
        b=qYktKyEgLOhKAlwk2PazXastWirp+ue0OuDXI6J1jtkaTbOpdTLtApiH+AMfyZa5h
         PS1zLOcxITWkUW3cttfOI2SpLQL0rkjji2xz88g7CiWG5zuv3zWO86OspTnlB45LhD
         rRPHeUcjq04mQWk/Z4Vog/DOd9HIP9/a3/NNpPZI=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH] ath9k: Do not select MAC80211_LEDS by default
Date:   Thu, 20 Aug 2020 21:40:49 +0200
Message-Id: <20200820194049.28055-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The ath9k driver hides all LEDs related code behind CONFIG_MAC80211_LEDS
ifdefs so it does not really require the MAC80211_LEDS.  The code builds
fine.  Convert the "select" into "imply" to allow disabling LED trigger
when not needed.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Not tested on HW.

Continuation of: https://lore.kernel.org/lkml/20200820120444.8809-1-krzk@kernel.org/
---
 drivers/net/wireless/ath/ath9k/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 5effb3886631..a84bb9b6573f 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -22,10 +22,10 @@ config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
 	depends on MAC80211 && HAS_DMA
 	select ATH9K_HW
-	select MAC80211_LEDS
-	select LEDS_CLASS
-	select NEW_LEDS
 	select ATH9K_COMMON
+	imply NEW_LEDS
+	imply LEDS_CLASS
+	imply MAC80211_LEDS
 	help
 	  This module adds support for wireless adapters based on
 	  Atheros IEEE 802.11n AR5008, AR9001 and AR9002 family
-- 
2.17.1

