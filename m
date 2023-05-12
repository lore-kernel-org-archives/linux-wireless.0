Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF1DC77B7F
	for <linux-wireless@archiver.kernel.org>; Fri, 12 May 2023 13:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241254AbjELNN0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 May 2023 09:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241252AbjELNM5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2023 09:12:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112DC14E4B
        for <linux-wireless@vger.kernel.org>; Fri, 12 May 2023 06:12:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 638B36567A
        for <linux-wireless@vger.kernel.org>; Fri, 12 May 2023 13:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04EAC433AC;
        Fri, 12 May 2023 13:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683897131;
        bh=fdc/NXHyrKxG8k4+YqfA3CFHZ7lsb/yokBkrfAn5nXk=;
        h=From:To:Cc:Subject:Date:From;
        b=HjR8164ukchBgnzCqc/T73++G2UAf9HKKtDQKVJMu6boatnvsvvpRpdrmpfo/dvoh
         sTjhbeM+0EgOh2XAucD7J/05dYqx+UwgZ/JFHYcGNiEcjVCltVXqUWAAbYpSxQT5Y6
         bNzSIgA9kVANAwxvIEEf7coMtEpZIv9fkBo0xL3wp4f4kag/rRvqpdJfMPjVMrfQD+
         UuBy6cSPnlpqInE+HGRWOEr/IEgeNg4IdLd/szA3rhyvzyA8NVB8EhHe7cJi/2xGZR
         8ln3gqQ82A5ADF3Bx8j5XE+wcZZhghnQZJN2MNGt4EVpaGXFuwB+/jaRBufzVh9oh5
         BujDc3bP3Hkyw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] wifi: mt76: mt7921: remove macro duplication in regs.h
Date:   Fri, 12 May 2023 15:11:58 +0200
Message-Id: <78c80c25f8dc40b21b61092ab75f44fd4085c24c.1683897026.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Get rid of MT_MIB_RTS_COUNT_MASK marco duplication in mt7921/regs.h

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
index e52977ff3349..b180142562a2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
@@ -158,7 +158,6 @@
 
 #define MT_MIB_MB_SDR0(_band, n)	MT_WF_MIB(_band, 0x100 + ((n) << 4))
 #define MT_MIB_RTS_RETRIES_COUNT_MASK	GENMASK(31, 16)
-#define MT_MIB_RTS_COUNT_MASK		GENMASK(15, 0)
 
 #define MT_MIB_MB_BSDR0(_band)		MT_WF_MIB(_band, 0x688)
 #define MT_MIB_RTS_COUNT_MASK		GENMASK(15, 0)
-- 
2.40.1

