Return-Path: <SRS0=mHGl=2G=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4DDCC2D0BF
	for <linux-wireless@archiver.kernel.org>; Mon, 16 Dec 2019 18:32:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 846D8207FF
	for <linux-wireless@archiver.kernel.org>; Mon, 16 Dec 2019 18:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576521143;
	bh=2Rr7S+BHnMwk5f9jNJ8U1LMGgMiGoUWHfMb/bgKUMJw=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=dMs+yElgtFDyI81Yxw/b2aBvrM/nobATaqmtm5Ano8kdYI2NoHteHIPFZCRz9OTR+
	 +4Wt6yoA1xl7Z9G4Hncj7Kwgigx3ndul5RsEcp5iRwvT/M5XNvyL70UIkKkD3kyncM
	 kugrWtgQ6C3vfH07oEvi5ATtfaZv/mkuIRdmj390=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730661AbfLPScW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 16 Dec 2019 13:32:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727452AbfLPScV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Dec 2019 13:32:21 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB686207FF;
        Mon, 16 Dec 2019 18:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576521140;
        bh=2Rr7S+BHnMwk5f9jNJ8U1LMGgMiGoUWHfMb/bgKUMJw=;
        h=From:To:Cc:Subject:Date:From;
        b=wzdDg/65Q/KqFwvZkyNlxz7UMMhFh1zahPSO5HaQBppiuKdFWm0lN0zQD0ql5xkAH
         4oVVmMpO67trT6jsUUBCCWvc/g0dNdlmTTs7ctEp8CZHyGtk3hkFux5YrT8bUrEZsw
         phNFDeupJLz380bwZMNu4xi8ECqoLdMA/ptCHZyA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        ryder.lee@mediatek.com, shayne.chen@mediatek.com
Subject: [PATCH] mt76: fix compilation warning in mt76_eeprom_override()
Date:   Mon, 16 Dec 2019 19:32:10 +0100
Message-Id: <a64aaf778d3d144a46678f2833db2ec0afa3c58a.1576521036.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix the following compilation warning in mt76_eeprom_override routine
when CONFIG_OF is not set and label 'out' is not actually used

drivers/net/wireless/mediatek/mt76/eeprom.c: In function ‘mt76_eeprom_override’:
drivers/net/wireless/mediatek/mt76/eeprom.c:100:1: warning: label ‘out’ defined but not used [-Wunused-label]

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/eeprom.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/eeprom.c b/drivers/net/wireless/mediatek/mt76/eeprom.c
index 8f2693748faf..c236e303ccfd 100644
--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -87,17 +87,14 @@ mt76_eeprom_override(struct mt76_dev *dev)
 {
 #ifdef CONFIG_OF
 	struct device_node *np = dev->dev->of_node;
-	const u8 *mac;
+	const u8 *mac = NULL;
 
-	if (!np)
-		goto out;
-
-	mac = of_get_mac_address(np);
-	if (!IS_ERR(mac))
+	if (np)
+		mac = of_get_mac_address(np);
+	if (!IS_ERR_OR_NULL(mac))
 		ether_addr_copy(dev->macaddr, mac);
 #endif
 
-out:
 	if (!is_valid_ether_addr(dev->macaddr)) {
 		eth_random_addr(dev->macaddr);
 		dev_info(dev->dev,
-- 
2.21.0

