Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41994 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbeHTUHI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Aug 2018 16:07:08 -0400
Received: by mail-wr1-f68.google.com with SMTP id e7-v6so13533922wrs.9
        for <linux-wireless@vger.kernel.org>; Mon, 20 Aug 2018 09:50:43 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, dan.carpenter@oracle.com
Subject: [PATCH] mt76x2: fix always true condition warning reported by static checker
Date: Mon, 20 Aug 2018 18:50:19 +0200
Message-Id: <a7bac1a6a98a3b937fdb4bd5de4ae6337817b08d.1534759721.git.lorenzo.bianconi@redhat.com> (sfid-20180820_185047_377015_B86BEF2F)
In-Reply-To: <cover.1534759721.git.lorenzo.bianconi@redhat.com>
References: <cover.1534759721.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix following warning reported by static checker:

drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c:35 mt76x2_tx()
warn: always true condition '(wcid->hw_key_idx != -1) => (0-255 != (-1))'

Fixes: 23405236460b ("mt76: fix transmission of encrypted mgmt frames")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
index 36afb166fa3f..c0ca0df84ed8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
@@ -32,7 +32,7 @@ void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		msta = (struct mt76x2_sta *)control->sta->drv_priv;
 		wcid = &msta->wcid;
 		/* sw encrypted frames */
-		if (!info->control.hw_key && wcid->hw_key_idx != -1)
+		if (!info->control.hw_key && wcid->hw_key_idx != 0xff)
 			control->sta = NULL;
 	}
 
-- 
2.17.1
