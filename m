Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87465C47082
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jun 2021 11:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B2CE613D8
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jun 2021 11:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhFELwu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jun 2021 07:52:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbhFELwt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jun 2021 07:52:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1EA46120F;
        Sat,  5 Jun 2021 11:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622893861;
        bh=Eilo8NFrwPdpRnnnjrYuFbE9+5zvWrsHhSVToWZxdFA=;
        h=From:To:Cc:Subject:Date:From;
        b=ihOdE62FbQyo3GC146jj9AnyqVmoZFDTDkUK2org6ZtvP5QK1UGZYYIZlGdpnllNz
         c88c206JDVOCXcnueoSRKZi3eu3DSIdVtwl2J0ndzKYXINfpkTsfoEqwSiSvG6nzuq
         ERlpHPiaRSXhghIT/QcQAD2TReZ5CHQN+PEvwpPB9IxiT5pI6hVFq7N3ni1d5T2Vze
         QtZB6rfAqqYlifCAits1K1YWzTbJpDEtVH4lWHrOf6UZtjZu+35IPM6Qk9GPo0+eF/
         9CqiqJVFTJILiHVi2a5Z59fKG6k2m3mRntjhz46kyUmK+USl8n65gYRz8NLLZW/rh0
         1tLPt5PoicU0A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        deren.wu@mediatek.com, sean.wang@mediatek.com
Subject: [PATCH] mt76: connac: check band caps in mt76_connac_mcu_set_rate_txpower
Date:   Sat,  5 Jun 2021 13:50:52 +0200
Message-Id: <b1a79fe193e040b763e71866520f749448ad3fcc.1622893762.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Check device band capabilities before configuring single-sku

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.c    | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 1dfdc90985c6..2325eefbeb2a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1769,11 +1769,20 @@ int mt76_connac_mcu_set_rate_txpower(struct mt76_phy *phy)
 {
 	int err;
 
-	err = mt76_connac_mcu_rate_txpower_band(phy, NL80211_BAND_2GHZ);
-	if (err < 0)
-		return err;
+	if (phy->cap.has_2ghz) {
+		err = mt76_connac_mcu_rate_txpower_band(phy,
+							NL80211_BAND_2GHZ);
+		if (err < 0)
+			return err;
+	}
+	if (phy->cap.has_5ghz) {
+		err = mt76_connac_mcu_rate_txpower_band(phy,
+							NL80211_BAND_5GHZ);
+		if (err < 0)
+			return err;
+	}
 
-	return mt76_connac_mcu_rate_txpower_band(phy, NL80211_BAND_5GHZ);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76_connac_mcu_set_rate_txpower);
 
-- 
2.31.1

