Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ABF1C64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 21:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59E512084D
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 21:53:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59E512084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbeJEEsu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 00:48:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37161 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbeJEEst (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 00:48:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id y11-v6so747491wrd.4
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2018 14:53:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OrAGwlerF6q+cJlizTdJa6+ZyNVLaLwvqo/AWio2EZM=;
        b=e/dajuJIq/g6yGfT9Y2H/cFauVW/ZQFjmcWyw5ydyky8zj+yf2eDv6QJL4z/az0QRl
         pZa/dssHhfpZFLfAssUgPQYzQyXR5pfRXtSJQ6i090KDxbJOGlW42gocLopub6eA7tCR
         GRxgn7bRXjitUlhvsah0amTeTGgP1PUmeEAnz2Hd7wzb9Ucxfgfyhz3v6yxNvZkiXHh8
         dnObjlASIy4fM4vTl4EJn0LP2Xp0i0T8lsVFPbcqPbOo1BtuoexegkxisqEgA8E6/sEI
         bF2FMm0nP+CEf06hNkiEacxWOPFuzC8hwq7NxCrr3gSIHz5K2NB8ql3nPVNUNgM2D/Ta
         aeBw==
X-Gm-Message-State: ABuFfojTRQOhoBLLN+qd+e6d8imUreqhnnswRu4OGmJhhAYej01tJvYk
        qAfwNQGiStC5IyOwReddVfnCog==
X-Google-Smtp-Source: ACcGV60BlAiq3n6oBMvlnqTfOkEJRtXKMceg9JYVd5GuDkJjO5f8Bpe5qbnJX+cfixn58Ft7gl9e1Q==
X-Received: by 2002:adf:a212:: with SMTP id p18-v6mr6067727wra.47.1538690007089;
        Thu, 04 Oct 2018 14:53:27 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id e6-v6sm5696189wrc.70.2018.10.04.14.53.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Oct 2018 14:53:26 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 05/10] mt76x0: remove hw_atomic_mutex mutex in mt76x0_dev
Date:   Thu,  4 Oct 2018 23:53:07 +0200
Message-Id: <20181004215312.3094-6-lorenzo.bianconi@redhat.com>
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
index c4ea89e61c40..eb41e247a801 100644
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
 
@@ -346,7 +342,6 @@ mt76x0_alloc_device(struct device *pdev,
 
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

