Return-Path: <SRS0=JTkr=53=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B789EC2BBC7
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Apr 2020 23:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89DAC206F7
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Apr 2020 23:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586648849;
	bh=vr0eU8N+DcfIEeHCMZcV+a3ZvG1NoSo5bc/6p6NwcV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wYfiDkIcvEYFcRaaOh+V1f4PWxBRBBiaZVM71V5QEHO1NCJZVQLEOVquzARiv5V4A
	 IGE2u5oOd9m206y47EomblcJhNPQvEm9VsCjX4bK01Nfj29ceO0hrhxIguN3PQgm+p
	 81VKxmYM70vWl9g/RDKa5xa6AF12riaz/71OxXaE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbgDKXFC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727526AbgDKXFB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Apr 2020 19:05:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3E66216FD;
        Sat, 11 Apr 2020 23:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646301;
        bh=vr0eU8N+DcfIEeHCMZcV+a3ZvG1NoSo5bc/6p6NwcV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0erG1o+q5ty8XN/leqFe+f4PPIbB7S7zcjGNkSVYyd3A7a35uw032jqhPNVRMh3ow
         9wffVw0wzOsHTPvS4pO07ZCk3JW3Hoq/P4D4g+RiFG8eHUY0zc4OnrBfO3D02+C+BC
         a15Wp3V5qppZr2KbiAnVBbtZGL17rYAUrm2PyYak=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 060/149] mt76: mt7615: disable 5 GHz on MT7622
Date:   Sat, 11 Apr 2020 19:02:17 -0400
Message-Id: <20200411230347.22371-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit c3ad5e9d00af19c53dec1d8ae647a78ac377b593 ]

It is not supported by the chip, so avoid issues with potentially wrong
EEPROM configurations.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
index 17e277bf39e0f..cb05a07135a03 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
@@ -111,6 +111,9 @@ static void mt7615_eeprom_parse_hw_cap(struct mt7615_dev *dev)
 		break;
 	}
 
+	if (is_mt7622(&dev->mt76))
+		dev->mt76.cap.has_5ghz = false;
+
 	/* read tx-rx mask from eeprom */
 	val = mt76_rr(dev, MT_TOP_STRAP_STA);
 	max_nss = val & MT_TOP_3NSS ? 3 : 4;
-- 
2.20.1

