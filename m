Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45110 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932415AbeGIKUm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 06:20:42 -0400
Received: by mail-wr1-f66.google.com with SMTP id u7-v6so10376776wrn.12
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2018 03:20:42 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: kubakici@wp.pl
Cc: linux-wireless@vger.kernel.org, dcaratti@redhat.com
Subject: [PATCH 2/2] mt7601u: expose 802.11w support
Date: Mon,  9 Jul 2018 12:20:27 +0200
Message-Id: <c418313a6ac0b08f94c8413ae4315d1f65184578.1531130155.git.lorenzo.bianconi@redhat.com> (sfid-20180709_122046_020787_02073453)
In-Reply-To: <cover.1531130155.git.lorenzo.bianconi@redhat.com>
References: <cover.1531130155.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Davide Caratti <dcaratti@redhat.com>

Set MFP_CAPABLE bit in hw flag capabilities exported by the driver

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt7601u/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt7601u/init.c b/drivers/net/wireless/mediatek/mt7601u/init.c
index d3b611aaf061..faea99b7a445 100644
--- a/drivers/net/wireless/mediatek/mt7601u/init.c
+++ b/drivers/net/wireless/mediatek/mt7601u/init.c
@@ -603,6 +603,7 @@ int mt7601u_register_device(struct mt7601u_dev *dev)
 	ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 	ieee80211_hw_set(hw, SUPPORTS_RC_TABLE);
+	ieee80211_hw_set(hw, MFP_CAPABLE);
 	hw->max_rates = 1;
 	hw->max_report_rates = 7;
 	hw->max_rate_tries = 1;
-- 
2.17.1
