Return-Path: <SRS0=bLdd=TA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C20E8C43219
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Apr 2019 15:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88F4921707
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Apr 2019 15:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556637455;
	bh=Y5djLhtv8ZAsAFHcRjQjfJE+rhBRFhDGrr3rkU+tsqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ss3o8qG3dz+A+kmztzjdnFkrjZQg3J5E32b/gWiWwkFY6t2VeYscQByGOSBcBHZHX
	 EO4Zq/fwIld3Qa8cM0D9KHIyelDPrVGW3RxL/EJG2E5t37S61st3xDZeaGupiBNRrH
	 rx8hIxBeEU/iniBDx1IufIHrvVAFCSk8AvcSzJqo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbfD3PRe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Apr 2019 11:17:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfD3PRe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Apr 2019 11:17:34 -0400
Received: from localhost.localdomain (unknown [151.66.22.155])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4056420835;
        Tue, 30 Apr 2019 15:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556637454;
        bh=Y5djLhtv8ZAsAFHcRjQjfJE+rhBRFhDGrr3rkU+tsqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AeB3pHpRlBXyjdCWk9HSVb0j2C45aPcPZpe+vvE9X4I15Zx2il6bb789hZ6iWhuK2
         ZlwxMmcXpU1dJ8VzMxmzQqVxN280rFphJKZEpd9R4xokVWpDqnSJ4EddOcOYqabAzy
         d5l875mrUxq4kCaAnVWrFRGUa8BT/rx7IEsQKDXY=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: mt7603: dynamically alloc mcu req in mt7603_mcu_set_eeprom
Date:   Tue, 30 Apr 2019 17:17:23 +0200
Message-Id: <3ab690290daabe3a574f9661c6a613eaacc25f6e.1556637012.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1556637012.git.lorenzo@kernel.org>
References: <cover.1556637012.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do not allocate mcu requests on the stack in mt7603_mcu_set_eeprom
in order to avoid the following warning:

Warning: the frame size of 1032 bytes is larger than 1024 bytes
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7603/mcu.c   | 30 ++++++++++++-------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
index 766d968671b3..6357b5658a32 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
@@ -354,24 +354,34 @@ int mt7603_mcu_set_eeprom(struct mt7603_dev *dev)
 		u8 buffer_mode;
 		u8 len;
 		u8 pad[2];
-		struct req_data data[255];
-	} req = {
+	} req_hdr = {
 		.buffer_mode = 1,
 		.len = ARRAY_SIZE(req_fields) - 1,
 	};
-	u8 *eep = (u8 *)dev->mt76.eeprom.data;
-	int i;
+	const int size = 0xff * sizeof(struct req_data);
+	u8 *req, *eep = (u8 *)dev->mt76.eeprom.data;
+	int i, ret, len = sizeof(req_hdr) + size;
+	struct req_data *data;
 
-	BUILD_BUG_ON(ARRAY_SIZE(req_fields) > ARRAY_SIZE(req.data));
+	BUILD_BUG_ON(ARRAY_SIZE(req_fields) * sizeof(*data) > size);
+
+	req = kmalloc(len, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
 
+	memcpy(req, &req_hdr, sizeof(req_hdr));
+	data = (struct req_data *)(req + sizeof(req_hdr));
+	memset(data, 0, size);
 	for (i = 0; i < ARRAY_SIZE(req_fields); i++) {
-		req.data[i].addr = cpu_to_le16(req_fields[i]);
-		req.data[i].val = eep[req_fields[i]];
-		req.data[i].pad = 0;
+		data[i].addr = cpu_to_le16(req_fields[i]);
+		data[i].val = eep[req_fields[i]];
 	}
 
-	return __mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD_EFUSE_BUFFER_MODE,
-				   &req, sizeof(req), true);
+	ret = __mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD_EFUSE_BUFFER_MODE,
+				  req, len, true);
+	kfree(req);
+
+	return ret;
 }
 
 static int mt7603_mcu_set_tx_power(struct mt7603_dev *dev)
-- 
2.20.1

