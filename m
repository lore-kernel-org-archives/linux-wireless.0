Return-Path: <SRS0=9HFQ=MT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C27C65C30
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 09:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E748C20882
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 09:51:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E748C20882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbeJGQ6L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Oct 2018 12:58:11 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56251 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbeJGQ6L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Oct 2018 12:58:11 -0400
Received: by mail-wm1-f65.google.com with SMTP id 206-v6so5393819wmb.5
        for <linux-wireless@vger.kernel.org>; Sun, 07 Oct 2018 02:51:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TSUkZ/UkKiFOzFSxWwY0YlBmJNagNRR7Ai/7oFtq7zc=;
        b=B+y2Jv/lSLg5ATeP0S4YZTmo7lZLgMp32oPuiuH8OjUjjQqryLvvihWJESwCBgVOrJ
         VVqJ1yQQ3IGCmfW5RRX9XNQySu+j70o9/o1Omcs20YafCgr048PVYyPaTiQ1pkp15zcH
         4Y4gMCaRshP5Q5pSqM1e9hWlUov/iY0PSW3WjcXzqKIiV8wan/CHwG4DlUMSC3XkWH4K
         1FT2jBsWhpcLwJ8LtLKH41HHcgU+7A6QOe+5PpxeBpGn+pqQk6tYBw2ZvnE7Eqb/U2a/
         mW0JamqHx0IQhV1UN2OdFgLvAJmVgosEiGJjaDo+VeHCJhpI29iFvChHP5/AKU0mhFyZ
         H9eQ==
X-Gm-Message-State: ABuFfoh/Caqg7rpplQnDkfVhymPARl+ZCJP6E2cjaTcH5VnXTePnc/u8
        dv9bmldWh2YY6TGPXQsId4dq3g==
X-Google-Smtp-Source: ACcGV6166I8yiti8cD97p8bakcuplGYqIOFIk8K5lYDDQcKLsGm/KWfDU5FCqUzS6HXfsn7XUcG8QQ==
X-Received: by 2002:a1c:710:: with SMTP id 16-v6mr12581987wmh.22.1538905885993;
        Sun, 07 Oct 2018 02:51:25 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id z4-v6sm13014082wrt.13.2018.10.07.02.51.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Oct 2018 02:51:25 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2] mt76x0: pci: report firmware version using ethtool
Date:   Sun,  7 Oct 2018 11:51:16 +0200
Message-Id: <20181007095116.13342-1-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Report via ethtool fw_ver and build_ver members of mt76x02_fw_header
data structure similarly to what is reported in the syslog

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
Changes since v1:
- rebase on top of 'mt76x02_dev data structure cleanup' series
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
2.19.0

