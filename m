Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC74C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80D8A2156B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80D8A2156B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbeI0PTi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:38 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34783 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbeI0PTh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:37 -0400
Received: by mail-wr1-f67.google.com with SMTP id z4-v6so325284wrb.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ny5cdxXj5JvjYY8r7SQY3jfwSKknSqipFC+9S+TtIvg=;
        b=PrUVRo71oUUWhtx9GTjUNSYW59LzthRbHpvb0TM8YVsuC6USA513FngUazYAs5r45H
         NFjJRJqpkjbHA7zyfY2N8CNHpK6pCeMjrqBwvKrXhuy3/pps7UUSo+H2uRzTqM0tdOyn
         n+W+ve2VOYzbQ3YZ0u5v+9XM3dF6M3122RVafX0sL0pyclT3cNCTg43RKFRrEDum0/YK
         iLbDydBKTTGdGFMhSgrMdqEKrFkaadNImiAbOL8B+e+bn+hH06UyrrTz1vRubiI/00bJ
         5YcFlPIS5U8HNs8DAy5jPwaDz4yehlUYkLuaoEHEn3lAxHndprruTYc0D3L8nqMdtan7
         aJLQ==
X-Gm-Message-State: ABuFfohq6stIPzfnBDIVI9PGyeZBfZ6gAj2jkoJE2D9lTLykMc0vnKnm
        gVhGINzNk/+PmWLrp4X1c6lSKw==
X-Google-Smtp-Source: ACcGV61SVDfl6diQUqoenHmEDviANGGehrCmM89lTTUMeba1Gb7mZkI0O16dIzG3sb1QC8Ofwq+MLw==
X-Received: by 2002:adf:81b5:: with SMTP id 50-v6mr8380843wra.10.1538038944278;
        Thu, 27 Sep 2018 02:02:24 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:23 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 23/26] mt76x0: pci: add mt76x0e_start callback
Date:   Thu, 27 Sep 2018 11:01:52 +0200
Message-Id: <5a4ae8e92629ca35d092f18e65682b393646d7c2.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt76x0e_start mac80211 callback to start
device mac opening the netdevice

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c
index 1b25eac66b11..d2b98a773660 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c
@@ -23,6 +23,15 @@
 
 static int mt76x0e_start(struct ieee80211_hw *hw)
 {
+	struct mt76x0_dev *dev = hw->priv;
+
+	mutex_lock(&dev->mt76.mutex);
+
+	mt76x02_mac_start(&dev->mt76);
+	mt76x0_start(dev);
+
+	mutex_unlock(&dev->mt76.mutex);
+
 	return 0;
 }
 
-- 
2.17.1

