Return-Path: <SRS0=a98u=MM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B6E1C64EB4
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 09:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D82E820685
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 09:57:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D82E820685
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbeI3Q3m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 30 Sep 2018 12:29:42 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50380 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728013AbeI3Q3m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Sep 2018 12:29:42 -0400
Received: by mail-wm1-f65.google.com with SMTP id s12-v6so5930856wmc.0
        for <linux-wireless@vger.kernel.org>; Sun, 30 Sep 2018 02:57:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rexB8jUPLozJKnaXl6sxyVzWxoKag2ezgQS9QaQ4glw=;
        b=japluaLZ61iD3uAiOyI/RkGIqNCvwBcP2N7R84F9A+t3rjXZNThjidotSCpGZJ82pI
         nJKmqNfSWgVZ5F9TpdrRLXNAYXxenoLwdbjlIoYgfAvKgz2W3D66awAzwEfVAubGpEKV
         caQ49kQpjN1BAtov7otqc7ww6GAOT1DNieILTfUDUlDLnkppQIy4nonRMlofcUC6zLOk
         vo+ClZa9okuzdmCapKKIJ61j73K137cBVoXTbvQMfnpl+MqCeSXgFtMiQSuHvTBKtmBs
         Gki49g7crgvj2MlKgAA/eOBGw4qUVk3A3P44IoxC49pPTRFWOzCdu2Sh7EUPVqCwIobd
         mS7Q==
X-Gm-Message-State: ABuFfohCPPQGbHxW28JFZSDqXfw+WI8BAQpogShCFum/tOwIM6YNWHPL
        syiOmYz9cKIP5Bdt1VUarpzdPQ==
X-Google-Smtp-Source: ACcGV62hchMIRnJUAu3ETXEEPYu4Ntj+Pt4BCnl1UGDICaGXLN6TI0IoGBZhzJ6ibdVND0ME2oYEMw==
X-Received: by 2002:a1c:b709:: with SMTP id h9-v6mr5860629wmf.130.1538301439763;
        Sun, 30 Sep 2018 02:57:19 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id 12-v6sm4898375wms.11.2018.09.30.02.57.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Sep 2018 02:57:19 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 05/10] mt76x0: remove hw_atomic_mutex mutex in mt76x0_dev
Date:   Sun, 30 Sep 2018 11:57:01 +0200
Message-Id: <20180930095706.28428-6-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove hw_atomic_mutex mutex in mt76x0_dev data structure
since mt76x0_phy_set_channel is already protected by mt76_dev
mutex while mt76x0_chip_onoff is used just at device probe or
cleanup

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c    |  5 -----
 .../net/wireless/mediatek/mt76/mt76x0/mt76x0.h  |  3 ---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 17 ++---------------
 3 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 07992d59ed09..1e1fb3fa509c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -73,8 +73,6 @@ void mt76x0_chip_onoff(struct mt76x0_dev *dev, bool enable, bool reset)
 {
 	u32 val;
 
-	mutex_lock(&dev->hw_atomic_mutex);
-
 	val = mt76_rr(dev, MT_WLAN_FUN_CTRL);
 
 	if (reset) {
@@ -96,8 +94,6 @@ void mt76x0_chip_onoff(struct mt76x0_dev *dev, bool enable, bool reset)
 	udelay(20);
 
 	mt76x0_set_wlan_state(dev, val, enable);
-
-	mutex_unlock(&dev->hw_atomic_mutex);
 }
 EXPORT_SYMBOL_GPL(mt76x0_chip_onoff);
 
@@ -352,7 +348,6 @@ mt76x0_alloc_device(struct device *pdev,
 
 	dev = container_of(mdev, struct mt76x0_dev, mt76);
 	mutex_init(&dev->reg_atomic_mutex);
-	mutex_init(&dev->hw_atomic_mutex);
 	atomic_set(&dev->avg_ampdu_len, 1);
 
 	return dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 178fb4f085c5..66b5986d78d3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -72,8 +72,6 @@ enum mt_bw {
  * @mutex:		ensures exclusive access from mac80211 callbacks.
  * @reg_atomic_mutex:	ensures atomicity of indirect register accesses
  *			(accesses to RF and BBP).
- * @hw_atomic_mutex:	ensures exclusive access to HW during critical
- *			operations (power management, channel switch).
  */
 struct mt76x0_dev {
 	struct mt76_dev mt76; /* must be first */
@@ -84,7 +82,6 @@ struct mt76x0_dev {
 	struct mt76x0_caldata caldata;
 
 	struct mutex reg_atomic_mutex;
-	struct mutex hw_atomic_mutex;
 
 	atomic_t avg_ampdu_len;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index ee7f071a96f8..661333243052 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -614,9 +614,8 @@ void mt76x0_phy_set_txpower(struct mt76x0_dev *dev)
 	mt76x02_phy_set_txpower(&dev->mt76, info[0], info[1]);
 }
 
-static int
-__mt76x0_phy_set_channel(struct mt76x0_dev *dev,
-		       struct cfg80211_chan_def *chandef)
+int mt76x0_phy_set_channel(struct mt76x0_dev *dev,
+			   struct cfg80211_chan_def *chandef)
 {
 	u32 ext_cca_chan[4] = {
 		[0] = FIELD_PREP(MT_EXT_CCA_CFG_CCA0, 0) |
@@ -713,18 +712,6 @@ __mt76x0_phy_set_channel(struct mt76x0_dev *dev,
 	return 0;
 }
 
-int mt76x0_phy_set_channel(struct mt76x0_dev *dev,
-			   struct cfg80211_chan_def *chandef)
-{
-	int ret;
-
-	mutex_lock(&dev->hw_atomic_mutex);
-	ret = __mt76x0_phy_set_channel(dev, chandef);
-	mutex_unlock(&dev->hw_atomic_mutex);
-
-	return ret;
-}
-
 void mt76x0_phy_recalibrate_after_assoc(struct mt76x0_dev *dev)
 {
 	u32 tx_alc, reg_val;
-- 
2.19.0

