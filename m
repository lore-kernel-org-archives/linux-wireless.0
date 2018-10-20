Return-Path: <SRS0=EPmr=NA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C83ECDE44
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 214E52150F
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:14:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 214E52150F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbeJTSYC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 14:24:02 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38493 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727470AbeJTSYC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 14:24:02 -0400
Received: by mail-wm1-f68.google.com with SMTP id 193-v6so5817273wme.3
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2018 03:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WskdBPA0jSyndYvhU8icoACNz0l2/qnmjYtBVo46kVM=;
        b=XjTI7CFHjDA7pyVrBr43sCCREQJqparFd3YRWKVVTay0jFL8FLA4pRIoasJUQXZLDx
         p1Elp+JQ9OuUkEqeXOEO5Ke7LcFSTIKscZYYA+uz/arc1g+Z9yfZ2ZJW1eOqQ+dNKOWb
         mAl/zBIXXi6OtybOn1T+Y8X/JurLxOskgrqClfRkBoYLOfr38KF5f2GVZiUaQ5sQRDBJ
         LjE/TMmEjkrT73aDryHT2Hue7zCZE5WPa98XeVqTnWrD7Cm5iuKYgb8bqyAv2hTfgqSx
         tFapujIxA8zKVgrCsJbbu/oj/maH7awuVg/4e8saYBqSGrzk/09KP9ggg72hQZ2q68IP
         aOMg==
X-Gm-Message-State: ABuFfoicx0XuMx9J7ynv3CHK3RBYb1nsDGSiSw98FgM9jyzqd9M2umj3
        3FJ68L0Lff/q87O3aXB2hML41w==
X-Google-Smtp-Source: ACcGV63QOHeHx/5fVVJ4gzigOZPRElaBU9pUDE8TUuMOayederOIos3YY+ZzYQBCeTKo58s9mkaOCA==
X-Received: by 2002:a1c:d4b:: with SMTP id 72-v6mr8925092wmn.102.1540030445613;
        Sat, 20 Oct 2018 03:14:05 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id c2-v6sm19548631wrt.77.2018.10.20.03.14.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Oct 2018 03:14:05 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 6/9] mt76: move mt76x02_get_txpower in mt76x02_util.c
Date:   Sat, 20 Oct 2018 12:13:29 +0200
Message-Id: <dca625a1e2fe0b915d78e09c0d633ae377ab19a9.1540029458.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540029458.git.lorenzo.bianconi@redhat.com>
References: <cover.1540029458.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_get_txpower utility routine in mt76x02-lib module
in order to be reused by mt76x0 and mt76x2u drivers

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/pci.c    |  1 +
 .../net/wireless/mediatek/mt76/mt76x0/usb.c    |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h   |  2 ++
 .../net/wireless/mediatek/mt76/mt76x02_util.c  | 18 ++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x2/pci_main.c   | 15 +--------------
 .../wireless/mediatek/mt76/mt76x2/usb_main.c   |  1 +
 6 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 7f506975c9b9..4d4800d09da6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -86,6 +86,7 @@ static const struct ieee80211_ops mt76x0e_ops = {
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.wake_tx_queue = mt76_wake_tx_queue,
 	.get_survey = mt76_get_survey,
+	.get_txpower = mt76x02_get_txpower,
 };
 
 static int mt76x0e_register_device(struct mt76x02_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 8640ddf0e594..2105e966f745 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -156,6 +156,7 @@ static const struct ieee80211_ops mt76x0u_ops = {
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.set_rts_threshold = mt76x0_set_rts_threshold,
 	.wake_tx_queue = mt76_wake_tx_queue,
+	.get_txpower = mt76x02_get_txpower,
 };
 
 static int mt76x0u_register_device(struct mt76x02_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 0890794c92d7..f830e39b58e7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -151,6 +151,8 @@ void mt76x02_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		     const u8 *mac);
 void mt76x02_sw_scan_complete(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif);
+int mt76x02_get_txpower(struct ieee80211_hw *hw,
+			struct ieee80211_vif *vif, int *dbm);
 
 extern const u16 mt76x02_beacon_offsets[16];
 void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index bbc2cab4ffdc..25f36e333b9b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -508,6 +508,24 @@ void mt76x02_sw_scan_complete(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(mt76x02_sw_scan_complete);
 
+int mt76x02_get_txpower(struct ieee80211_hw *hw,
+			struct ieee80211_vif *vif, int *dbm)
+{
+	struct mt76x02_dev *dev = hw->priv;
+	u8 nstreams = dev->mt76.chainmask & 0xf;
+
+	*dbm = dev->mt76.txpower_cur / 2;
+
+	/* convert from per-chain power to combined
+	 * output on 2x2 devices
+	 */
+	if (nstreams > 1)
+		*dbm += 3;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x02_get_txpower);
+
 const u16 mt76x02_beacon_offsets[16] = {
 	/* 1024 byte per beacon */
 	0xc000,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 36042331e4b2..5dfd06e56636 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -181,19 +181,6 @@ mt76x2_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 }
 
-static int
-mt76x2_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif, int *dbm)
-{
-	struct mt76x02_dev *dev = hw->priv;
-
-	*dbm = dev->mt76.txpower_cur / 2;
-
-	/* convert from per-chain power to combined output on 2x2 devices */
-	*dbm += 3;
-
-	return 0;
-}
-
 static void mt76x2_set_coverage_class(struct ieee80211_hw *hw,
 				      s16 coverage_class)
 {
@@ -277,7 +264,7 @@ const struct ieee80211_ops mt76x2_ops = {
 	.sw_scan_complete = mt76x02_sw_scan_complete,
 	.flush = mt76x2_flush,
 	.ampdu_action = mt76x02_ampdu_action,
-	.get_txpower = mt76x2_get_txpower,
+	.get_txpower = mt76x02_get_txpower,
 	.wake_tx_queue = mt76_wake_tx_queue,
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.release_buffered_frames = mt76_release_buffered_frames,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 5187a5f4832a..c2e0a43082e5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -161,4 +161,5 @@ const struct ieee80211_ops mt76x2u_ops = {
 	.sw_scan_start = mt76x02_sw_scan,
 	.sw_scan_complete = mt76x02_sw_scan_complete,
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
+	.get_txpower = mt76x02_get_txpower,
 };
-- 
2.19.1

