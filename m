Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F298C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:00:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14A802081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:00:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14A802081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389482AbeKGC0V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:26:21 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46763 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389285AbeKGC0V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:26:21 -0500
Received: by mail-wr1-f67.google.com with SMTP id 74-v6so14335557wrb.13
        for <linux-wireless@vger.kernel.org>; Tue, 06 Nov 2018 09:00:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gDQUstN8ielQYKv4iw7PRV0NeDRDMswtkC8vk+awLq8=;
        b=USiMU5h8/a5BST41h4y7l9v1x76wkRsObs+71Fen4+xLt3VCP10GDwMoFa8TjYILFJ
         v8o8iplnBVPMOSsdeHQDORHgDwrhpizq8a7TUTbdg3m4fEbBMXXiVv3fr3LmqpRI+oXS
         3v/UG9K1zOOCiIrVVkICc7S+ZCcZvFgtO0boOwMuI449emLmQ+Y7PO4D030Km00n1FgC
         euyTBo+05fvJkKiMWLamNuCCw9d8Gh874QrOHMpEYc537HDM/VAqCZcBQOgKlP+SDrqC
         6tLxXgENMfIJsMMxcMxf91ngpfBimVuL92SJlQEnCHhxCxo2CMRHaL/g41wrU4L3cUrP
         iWQQ==
X-Gm-Message-State: AGRZ1gKDb6xexiZW5kadEf+Nbhy3HjHl7ETK+qe14X/Tiv3YNI/eF3I0
        n4QzQgTtjN94yh9pLLYVCK3lyP430YQ=
X-Google-Smtp-Source: AJdET5eXLdg6tRHB/zpzHGTv5RX/9JqPDmuossNJzRyTCCpFTWr7s/9xt8ufCXEQfov/PyCqLeXu1w==
X-Received: by 2002:adf:e406:: with SMTP id g6-v6mr17422552wrm.277.1541523612231;
        Tue, 06 Nov 2018 09:00:12 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id x142-v6sm649271wmd.20.2018.11.06.09.00.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Nov 2018 09:00:11 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] mt76x2u: main: use mt76x02_bss_info_changed utility routine
Date:   Tue,  6 Nov 2018 17:59:47 +0100
Message-Id: <ebaa54c4790fd9072a423f0a0bbdc2de5df15c0d.1541522368.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1541522368.git.lorenzo.bianconi@redhat.com>
References: <cover.1541522368.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Initialize bss_info_changed mac80211 callback to
mt76x02_bss_info_changed utility routine and remove duplicated code.
Use 8 as WCID index for sta interface

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  | 23 +++----------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index cad99715997e..a9ecc92875ae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -50,11 +50,12 @@ static int mt76x2u_add_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif)
 {
 	struct mt76x02_dev *dev = hw->priv;
+	unsigned int idx = 8;
 
 	if (!ether_addr_equal(dev->mt76.macaddr, vif->addr))
 		mt76x02_mac_setaddr(dev, vif->addr);
 
-	mt76x02_vif_init(dev, vif, 0);
+	mt76x02_vif_init(dev, vif, idx);
 	return 0;
 }
 
@@ -83,24 +84,6 @@ mt76x2u_set_channel(struct mt76x02_dev *dev,
 	return err;
 }
 
-static void
-mt76x2u_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			 struct ieee80211_bss_conf *info, u32 changed)
-{
-	struct mt76x02_dev *dev = hw->priv;
-
-	mutex_lock(&dev->mt76.mutex);
-
-	if (changed & BSS_CHANGED_BSSID) {
-		mt76_wr(dev, MT_MAC_BSSID_DW0,
-			get_unaligned_le32(info->bssid));
-		mt76_wr(dev, MT_MAC_BSSID_DW1,
-			get_unaligned_le16(info->bssid + 4));
-	}
-
-	mutex_unlock(&dev->mt76.mutex);
-}
-
 static int
 mt76x2u_config(struct ieee80211_hw *hw, u32 changed)
 {
@@ -150,7 +133,7 @@ const struct ieee80211_ops mt76x2u_ops = {
 	.ampdu_action = mt76x02_ampdu_action,
 	.config = mt76x2u_config,
 	.wake_tx_queue = mt76_wake_tx_queue,
-	.bss_info_changed = mt76x2u_bss_info_changed,
+	.bss_info_changed = mt76x02_bss_info_changed,
 	.configure_filter = mt76x02_configure_filter,
 	.conf_tx = mt76x02_conf_tx,
 	.sw_scan_start = mt76x02_sw_scan,
-- 
2.17.2

