Return-Path: <SRS0=7roA=5D=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA70C5ACD6
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Mar 2020 12:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37FE920768
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Mar 2020 12:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584535297;
	bh=lqF7zlnVf6/0NevdwimAGCK2mAe+Unj/eKbq5AcaaTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=SdLETgLc8PWYMRw1sXviElEptmiUG1PoV+TWBQqV6cgv9bby1KB0yD2ftqpfK/I6D
	 WwI+DhLCA3H8Or6yjXP6Jmiy8kYWGEcgv+YcnLjaZ4EZXH6wKcqi5VIL/3OQMIYtmK
	 OuFuxJarLoaGwvV83lERHDC0t0Q/aJEh8lnj8jjg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgCRMlg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Mar 2020 08:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgCRMlg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Mar 2020 08:41:36 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.128.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1798B2076D;
        Wed, 18 Mar 2020 12:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584535295;
        bh=lqF7zlnVf6/0NevdwimAGCK2mAe+Unj/eKbq5AcaaTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0zoBC4DjueVAsTH1srqDMn38jdGTE4SiRcKHsMtsXubaswhnNf7XuRfJm3+Ev9+yP
         26GoqgwOgzN7A3K8NI/iV+ZyamvzjPVGJ5hlxoSx/68xyM72pjsedpDiZNMQ1cdWXz
         tEvPl9SidP1UsqG/jyTs4MkcJvXjmsD8zFCSz4p0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name,
        lorenzo.bianconi@redhat.com, sean.wang@mediatek.com,
        ryder.lee@mediatek.com, linux-mediatek@lists.infradead.org
Subject: [PATCH 1/3] mt76: mt7615: fix mt7663e firmware struct endianness
Date:   Wed, 18 Mar 2020 13:41:03 +0100
Message-Id: <d14dfd7cd91a4dda8c5dcd03e8a70ff11314182e.1584534454.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1584534454.git.lorenzo@kernel.org>
References: <cover.1584534454.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Convert fields in mt7663_fw_trailer and mt7663_fw_buf to little-endian

Reported-by: kbuild test robot <lkp@intel.com>
Fixes: f40ac0f3d3c0 ("mt76: mt7615: introduce mt7663e support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 50c98913d81d..9978f6bb22ab 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -44,16 +44,16 @@ struct mt7663_fw_trailer {
 	u8 reserv[2];
 	char fw_ver[10];
 	char build_date[15];
-	u32 crc;
+	__le32 crc;
 } __packed;
 
 struct mt7663_fw_buf {
-	u32 crc;
-	u32 d_img_size;
-	u32 block_size;
+	__le32 crc;
+	__le32 d_img_size;
+	__le32 block_size;
 	u8 rsv[4];
-	u32 img_dest_addr;
-	u32 img_size;
+	__le32 img_dest_addr;
+	__le32 img_size;
 	u8 feature_set;
 };
 
@@ -1896,7 +1896,7 @@ static int mt7663_load_n9(struct mt7615_dev *dev, const char *name)
 			goto out;
 		}
 
-		offset += buf->img_size;
+		offset += le32_to_cpu(buf->img_size);
 		if (buf->feature_set & DL_MODE_VALID_RAM_ENTRY) {
 			override_addr = le32_to_cpu(buf->img_dest_addr);
 			dev_info(dev->mt76.dev, "Region %d, override_addr = 0x%08x\n",
-- 
2.25.1

