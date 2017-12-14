Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:39747 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751799AbdLNMDk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 07:03:40 -0500
Received: by mail-wm0-f66.google.com with SMTP id i11so10905159wmf.4
        for <linux-wireless@vger.kernel.org>; Thu, 14 Dec 2017 04:03:39 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: dan.carpenter@oracle.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mt76: fix possible NULL pointer dereferencing in mt76x2_mac_write_txwi()
Date: Thu, 14 Dec 2017 13:03:17 +0100
Message-Id: <7eafce7c10c2fb570f59931f1febf4d0d9cde12c.1513252573.git.lorenzo.bianconi@redhat.com> (sfid-20171214_130344_712511_E06FA467)
In-Reply-To: <cover.1513252573.git.lorenzo.bianconi@redhat.com>
References: <cover.1513252573.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Verify wcid is not NULL before dereferencing the pointer to initialize
txwi rate/power info

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index 39fc1d7b65ce..a1f695e9b51c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -185,7 +185,7 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
 	txwi->pktid = 1;
 
 	spin_lock_bh(&dev->mt76.lock);
-	if (rate->idx < 0 || !rate->count) {
+	if (wcid && (rate->idx < 0 || !rate->count)) {
 		txwi->rate = wcid->tx_rate;
 		max_txpwr_adj = wcid->max_txpwr_adj;
 		nss = wcid->tx_rate_nss;
-- 
2.13.6
