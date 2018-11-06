Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E5BC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 22:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCA1C2081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 22:55:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DCA1C2081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730782AbeKGIWd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Nov 2018 03:22:33 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45198 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbeKGIWd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Nov 2018 03:22:33 -0500
Received: by mail-wr1-f65.google.com with SMTP id k15-v6so12403345wre.12
        for <linux-wireless@vger.kernel.org>; Tue, 06 Nov 2018 14:55:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1vj4F8SRl5OPapZQTjNMrM6iPcygtg8u57TK0uEZLGU=;
        b=cmtKeQDMcMWD//TkEd4Kx8hSpMrgJsPaUo9rBQ2eGHNS7zx3Vfm2rL7+Y9az23Utv2
         4zUAPQ2uBAWxqqa4MRN8EHSV/90a1YLyfLLA8u6mgZ20h+A9hKBQ21HcPugUjOe83c7G
         Ndo9fx9TVPWH7EZlv65kAXZCCy1mKXkVv1NhA5aTRlMWsTHb2WQmZynWFWfyFYDVquuN
         fneTEIwSSiiCvXYEnx15mwyDuea37/EoVipY7ydIJA/+DAwJMtXbyZfIMzTQjhKwvxon
         uK7juRz0Ai8PHO4kjVHKPwRpYaeCrMSsYSRO1ZRg2Sa7HpMHqN/dQtjEE4bOyVehZnAd
         rirA==
X-Gm-Message-State: AGRZ1gLuZsewTWndYam+DFSrnoVJiro3w2mv3Ov9VEpuiAJ9Pb85tY99
        571sWeNO/mqNKnbhCLblqa8HJg==
X-Google-Smtp-Source: AJdET5c7KEFmPKridNopFU89Zjhp7kWVDbHyTvBECYZioMsGueLtFDd4DBWXOjzaDj0kM96ZRJbCzA==
X-Received: by 2002:adf:aa05:: with SMTP id p5-v6mr26972985wrd.56.1541544899777;
        Tue, 06 Nov 2018 14:54:59 -0800 (PST)
Received: from localhost.localdomain ([151.66.25.206])
        by smtp.gmail.com with ESMTPSA id j189-v6sm5149033wmf.18.2018.11.06.14.54.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Nov 2018 14:54:58 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: pci: enable VHT rates in IBSS mode
Date:   Tue,  6 Nov 2018 23:54:49 +0100
Message-Id: <8c804773aee7cc2d99bacc8facd62c0e39d6a100.1541544682.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1541544682.git.lorenzo.bianconi@redhat.com>
References: <cover.1541544682.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Enable VHT tx rates in ad-hoc mode for mt76x0e driver.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
This patch is based on top of 'mt76: introduce mt76x02_config_mac_addr_list
routine'
https://patchwork.kernel.org/patch/10671591/
---
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c    | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c | 3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index a52db63c3c68..48f2f5382b57 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -105,6 +105,8 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
 			BIT(NL80211_IFTYPE_MESH_POINT) |
 #endif
 			BIT(NL80211_IFTYPE_ADHOC);
+
+		wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
 	}
 
 	hw->sta_data_size = sizeof(struct mt76x02_sta);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 80b4e11ea28e..843dda261cf8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -388,8 +388,6 @@ static void mt76x2_led_set_brightness(struct led_classdev *led_cdev,
 
 int mt76x2_register_device(struct mt76x02_dev *dev)
 {
-	struct ieee80211_hw *hw = mt76_hw(dev);
-	struct wiphy *wiphy = hw->wiphy;
 	int ret;
 
 	INIT_DELAYED_WORK(&dev->cal_work, mt76x2_phy_calibrate);
@@ -401,7 +399,6 @@ int mt76x2_register_device(struct mt76x02_dev *dev)
 		return ret;
 
 	mt76x02_config_mac_addr_list(dev);
-	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
 
 	/* init led callbacks */
 	dev->mt76.led_cdev.brightness_set = mt76x2_led_set_brightness;
-- 
2.19.1

