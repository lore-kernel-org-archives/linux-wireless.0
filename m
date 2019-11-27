Return-Path: <SRS0=23TN=ZT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C38C33C9B
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Nov 2019 14:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C59B02073F
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Nov 2019 14:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574866030;
	bh=71KvN8DCR94x7xslYbCNrCnuRBb8jesfxVzzsK1oeUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=zzk+H52RkNn+cwpJEuZrQwGlwNFa2Imlim3mXZs8wsgFMbh8HD1uUivsIWWLtD+Wd
	 FEFIT7PZDdJyqNL99bAG+zI7epAlhqzjmHfox55ewgf+eIlsuTB74eV5uBU0HKc//E
	 7qqjL7Fm80WfasL848D9r59QYx6EVubW7fhzsdKE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfK0OrK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:47:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:58168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfK0OrJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Nov 2019 09:47:09 -0500
Received: from localhost.localdomain.com (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF7C6206F0;
        Wed, 27 Nov 2019 14:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574866029;
        bh=71KvN8DCR94x7xslYbCNrCnuRBb8jesfxVzzsK1oeUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gx9LwsMS0smR//8RgMtRntBnV1dnTGlXpNnLIaU1W4+R9S3snZ0Sy4bBBnk7ZZJqz
         WwOStR/w+TEFTZqFhkOZswh6RG7nEKY329KJE52O9FUWcjHNg7HYKSHXg1VMrxklgc
         BfBdechygoGY/nlIc7o8MJxqZogfHfiHeYC1o/tc=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v2 1/2] mt76: eeprom: add support for big endian eeprom partition
Date:   Wed, 27 Nov 2019 16:46:33 +0200
Message-Id: <61e89623446ed8914e5969114c7ae8c623f3e3ba.1574865558.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1574865558.git.lorenzo@kernel.org>
References: <cover.1574865558.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

mt76x0e users reported some devices (e.g TP-Link Archer VR200v) have
been flashed with big endian radio partition. Add the possibility to
specify eeprom endianness using big-endian dts property and in case
covert eeprom data in little endian

Tested-by: Kevin Schmidt <kevin.patrick.schmidt@googlemail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/eeprom.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/eeprom.c b/drivers/net/wireless/mediatek/mt76/eeprom.c
index 804224e81103..33d992d5662a 100644
--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -64,6 +64,16 @@ mt76_get_of_eeprom(struct mt76_dev *dev, int len)
 		goto out_put_node;
 	}
 
+	if (of_property_read_bool(dev->dev->of_node, "big-endian")) {
+		u8 *data = (u8 *)dev->eeprom.data;
+		int i;
+
+		/* convert eeprom data in Little Endian */
+		for (i = 0; i < round_down(len, 2); i += 2)
+			put_unaligned_le16(get_unaligned_be16(&data[i]),
+					   &data[i]);
+	}
+
 out_put_node:
 	of_node_put(np);
 	return ret;
-- 
2.21.0

