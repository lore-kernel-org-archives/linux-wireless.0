Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69557C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25FEE20875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:32:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25FEE20875
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbeJEPaE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:30:04 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38912 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727863AbeJEPaE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 11:30:04 -0400
Received: by mail-wm1-f66.google.com with SMTP id q8-v6so1071413wmq.4
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2018 01:32:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4h8UMQWmY+XUhvhUk8evMHbqpiHS032QmD3/7HyV1B0=;
        b=X6IVB93Th4qO3El8BA/RI0bEcxFYHFGQa+8JFyjl4De9ZAbl09Z+3/S0XCe1DNY5PD
         Bg83KQR8kwyQbhrZEy1uKQL+GI149HStr3gIYQ9gXPjO80v5TAiYFop3Bb0bBGun5mTi
         l2GXXARtQcVSSvcI9s8At7PJ8bJBpfkJO5EtqNIdaa1VB+n3CEt/iysNEpW+B50ZqAG8
         7j6RFGZ46v5rDzPpZUU3Y/FgNC9i4ux2ordVLCi754j6Ue1jtlCtyIpG4msipP9a8zJE
         NjfSoL/KaUp1aXV07YlaMdMejxvyeLqHDFDpE+9baQo47euD2baFKlRSaDojIjGWICre
         xhJA==
X-Gm-Message-State: ABuFfoiQ/vuJIXCy8OpzruGyMvxwUZwau7DmedtJ2/nQrToFbsMRFHkF
        NHIBloNrXxDyX7EPNeW0qrUgaA==
X-Google-Smtp-Source: ACcGV60m86vqDe+i0PpUPsl7l8KMfHsRSzF6XNgPTVuUZI9P1ofSbBKz74YH2gvc6j9vSjdHjWygjg==
X-Received: by 2002:a1c:7dd5:: with SMTP id y204-v6mr7472792wmc.63.1538728342915;
        Fri, 05 Oct 2018 01:32:22 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r8-v6sm9085212wrm.14.2018.10.05.01.32.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Oct 2018 01:32:22 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: pci: report firmware version using ethtool
Date:   Fri,  5 Oct 2018 10:32:12 +0200
Message-Id: <43e21bfe8d4b3c24e4130a0631566db771e342a4.1538728254.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538728254.git.lorenzo.bianconi@redhat.com>
References: <cover.1538728254.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Report via ethtool fw_ver and build_ver members of mt76x02_fw_header
data structure similarly to what is reported in the syslog

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
index 6c66656c21f4..569861289aa5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
@@ -116,6 +116,7 @@ static int mt76x0e_load_firmware(struct mt76x02_dev *dev)
 		goto out;
 	}
 
+	mt76x02_set_ethtool_fwver(dev, hdr);
 	dev_dbg(dev->mt76.dev, "Firmware running!\n");
 
 out:
-- 
2.17.1

