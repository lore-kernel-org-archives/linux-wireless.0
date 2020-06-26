Return-Path: <SRS0=B3tD=AH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C307DC433E2
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jun 2020 21:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1D212100A
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jun 2020 21:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593206756;
	bh=cNm4vevn52MHqQhVmtkazDdt9Txp0Mki2vNXGAapXMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=f4uYB0xQIyS/3/1OkqpxBNH8yKrbcQbMnCspgQD/Mgg3GvvsruFS+b1y0uhy6rJEo
	 UcNuuMMoSffLLJqaX4T3Zx085uJGEDdvJShRRlVaXZT8yrfkgL4To50clKvQm65KjS
	 W/61vIv0BvwXaKFlEMiQC8GefH1SJuFevK1GfpWA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgFZVZz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Jun 2020 17:25:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbgFZVZy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jun 2020 17:25:54 -0400
Received: from localhost.localdomain.com (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C358B20B1F;
        Fri, 26 Jun 2020 21:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593206754;
        bh=cNm4vevn52MHqQhVmtkazDdt9Txp0Mki2vNXGAapXMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SjENw/Te39bMyb1oB0Ze08+Jvd2GghjzIv2bwr8GIlLEkswEMCUSbTbXn1Qs5ODsj
         eAFaIvbx6KhaFIqaCcTfC4735b72L4EjYahmW82DDD2IXkOPwJKLePxeRV1YG+QLzv
         0dTIehGDO97HzHbrT9xF7fD+Nq9loCTlb+t+A36M=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com, ryder.lee@mediatek.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 12/17] mt76: mt7615: check MT76_STATE_PM flag before accessing the device
Date:   Fri, 26 Jun 2020 23:25:12 +0200
Message-Id: <1aeb01ddefdd112ffbabca0f488ca3cd0c4ccd3e.1593204577.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1593204577.git.lorenzo@kernel.org>
References: <cover.1593204577.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Double-check if the device is in low-power state before accessing
registermap in mt7615_sta_rate_tbl_update() and in
mt7615_led_set_config()

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c     | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 32f060014bb7..3ab8e7e9be44 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -652,7 +652,8 @@ static void mt7615_sta_rate_tbl_update(struct ieee80211_hw *hw,
 			break;
 	}
 	msta->n_rates = i;
-	mt7615_mac_set_rates(phy, msta, NULL, msta->rates);
+	if (!test_bit(MT76_STATE_PM, &phy->mt76->state))
+		mt7615_mac_set_rates(phy, msta, NULL, msta->rates);
 	msta->rate_probe = false;
 	spin_unlock_bh(&dev->mt76.lock);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
index 69cba8609edf..7224a0078211 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
@@ -70,6 +70,10 @@ mt7615_led_set_config(struct led_classdev *led_cdev,
 
 	mt76 = container_of(led_cdev, struct mt76_dev, led_cdev);
 	dev = container_of(mt76, struct mt7615_dev, mt76);
+
+	if (test_bit(MT76_STATE_PM, &mt76->phy.state))
+		return;
+
 	val = FIELD_PREP(MT_LED_STATUS_DURATION, 0xffff) |
 	      FIELD_PREP(MT_LED_STATUS_OFF, delay_off) |
 	      FIELD_PREP(MT_LED_STATUS_ON, delay_on);
-- 
2.26.2

