Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA8B5C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 09:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A8FB20880
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 09:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfA1Jbi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 04:31:38 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36754 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfA1Jbi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 04:31:38 -0500
Received: by mail-wr1-f66.google.com with SMTP id u4so17193155wrp.3
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 01:31:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ba7l1hoNzC7r8a9vmicFI+gMHtX6OE7k6p9lNcmyrdo=;
        b=oFAxHm/asFKJ1Hcjh9FV/6rFhgr3GXiiFbThMP1yG+E7VRGC4Om+FW8owegu7FVebi
         N0AC0NKN7mP0QBUCtGJLWenpqB78CdD1xHV6dnsbET/6Lwua9Emff4fS4hnrKvdWVNoj
         jEEr8nIGJxFq/jnEKE/u4ENHbsk3WGgrpYN4s8QfsXyeUJoEIa0z7YMk9TFjqEXvhk2r
         cJ1zIZcTlV6U+GeorJYwVPBdlRXWVu2HENJhMaUUUp33zHB/YT2vw7nVe0Z02cYvGnMn
         jES/PNx95scV5MbCUc2PoINh/tpkEkPcF1hFDFkAbZlN25CqT4tGi7wEvWmavKFjzln9
         1AJw==
X-Gm-Message-State: AJcUukfdiswhMp3icAr27I8sEPpgo8VoivL2tNBkXpZNu4YVpa/L9Ft7
        r1H7Rx5VIC2waR215fMrx5EJyw==
X-Google-Smtp-Source: ALg8bN6uYvkF/zbLvOGkRSUfPLzPM71PYwKy30rZhIsWiAA5nfxNAXtEo1UZR1q5ifFKUpsYzMfKPg==
X-Received: by 2002:adf:80cf:: with SMTP id 73mr20862639wrl.57.1548667896601;
        Mon, 28 Jan 2019 01:31:36 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id h16sm231765642wrb.62.2019.01.28.01.31.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 28 Jan 2019 01:31:36 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 1/2] mt76x0: phy: report target_power in debugfs
Date:   Mon, 28 Jan 2019 10:31:12 +0100
Message-Id: <c777c3bdd126ee51cb9188c9402c38c9e6b1368b.1548667362.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1548667362.git.lorenzo.bianconi@redhat.com>
References: <cover.1548667362.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Initialize target_power variable in mt76x0_phy_set_txpower in order to
report target_power in debugfs

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 1117cdc15b04..3fe2e1e28404 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -855,6 +855,7 @@ void mt76x0_phy_set_txpower(struct mt76x02_dev *dev)
 	dev->mt76.txpower_cur = mt76x02_get_max_rate_power(t);
 	mt76x02_add_rate_power_offset(t, -info);
 
+	dev->target_power = info;
 	mt76x02_phy_set_txpower(dev, info, info);
 }
 
-- 
2.20.1

