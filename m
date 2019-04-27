Return-Path: <SRS0=RVLw=S5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4CCC43218
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Apr 2019 13:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2179C208C2
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Apr 2019 13:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556370141;
	bh=SCljN80beqgxPgqHACg5aqGb01m73xDnDBSmJPc/HVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ONY2G2KHq7RN0eUuJR9LHIHKkG38FcylYKTYEAkWGpz3GAYRm/Joisooq3Yc9iQBj
	 CXFkuzS7U6p9QxgbBCGi1EK8iui3yGzuWt5lr2xFK0OjB1CTnPAuOtI6wxqFORSFp2
	 1pbcDSQNQL2ohpJ2J0VaaE5ibEFb41izG68AqaWM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfD0NCU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 27 Apr 2019 09:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbfD0NCU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Apr 2019 09:02:20 -0400
Received: from localhost.localdomain (unknown [151.66.24.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C59F12087C;
        Sat, 27 Apr 2019 13:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556370139;
        bh=SCljN80beqgxPgqHACg5aqGb01m73xDnDBSmJPc/HVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7Hw9TRy+DM6BOaqbEQ3/GGQwN3iPBTE38RrU6cIg/nUOfYgXZXVGTzdMQ9rmrTmY
         dh0U6u/Aw6bj/racfxn854JQGeAkLpG8yNFhle85eDUmfT1r8aWbWcgFBk26xQldx2
         2Iid8OllFAH5SW6Srit4b0ledCbPlhaiS3w3BJI4=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: mt7603: report firmware version using ethtool
Date:   Sat, 27 Apr 2019 15:02:10 +0200
Message-Id: <209575773fd531daf616f2d167f98430997735ec.1556369866.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1556369866.git.lorenzo@kernel.org>
References: <cover.1556369866.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Print fw_ver and build_date members of struct mt7603_fw_trailer
similarly to what appears in the output of 'dmesg' when the MCU firmware
is loaded.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
index 57481012ee47..19b66e9aae45 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
@@ -260,6 +260,9 @@ int mt7603_load_firmware(struct mt7603_dev *dev)
 	mt76_clear(dev, MT_SCH_4, BIT(8));
 
 	dev->mcu_running = true;
+	snprintf(dev->mt76.hw->wiphy->fw_version,
+		 sizeof(dev->mt76.hw->wiphy->fw_version),
+		 "%.10s-%.15s", hdr->fw_ver, hdr->build_date);
 	dev_info(dev->mt76.dev, "firmware init done\n");
 
 out:
-- 
2.20.1

