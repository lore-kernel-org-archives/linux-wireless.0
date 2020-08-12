Return-Path: <SRS0=580q=BW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F328C433E0
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Aug 2020 10:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 287592083B
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Aug 2020 10:23:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Dn/4IMgw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgHLKXi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Aug 2020 06:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgHLKXi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Aug 2020 06:23:38 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8D6C06174A
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2020 03:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tV4xZ1tJ0Siz5lmRXS9nveaD/E2Ff1jKg8KIw6QyBc0=; b=Dn/4IMgwDVZg+vv6pMZ4T+PvUr
        U4cZb0LXbX7WtZV46BwoZtrcpj0e/jESNqrNHYZ7dlLRQuh5JWlGSlT5vtIoehNG0dVbgxMRAHv9Y
        oH+X9wiCE15Z0w/jGa7NCgHNTMRtTm4/wPzAO58goVIDoKLQY0LxDfQpDqlRfgUoPkgw=;
Received: from p54ae996c.dip0.t-ipconnect.de ([84.174.153.108] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1k5nuv-0002AS-Fo; Wed, 12 Aug 2020 12:23:33 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org
Subject: [PATCH 5.9] mt76: mt7615: use v1 MCU API on MT7615 to fix issues with adding/removing stations
Date:   Wed, 12 Aug 2020 12:23:32 +0200
Message-Id: <20200812102332.11812-1-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The implementation of embedding WTBL update inside the STA_REC update is buggy
on the MT7615 v2 firmware. This leads to connection issues after a station has
connected and disconnected again.

Switch to the v1 MCU API ops, since they have received much more testing and
should be more stable.

On MT7622 and later, the v2 API is more actively used, so we should keep using
it as well.

Fixes: 6849e29ed92e ("mt76: mt7615: add starec operating flow for firmware v2")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 6e869b8c5e26..59deca44d977 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -2007,7 +2007,8 @@ static int mt7615_load_n9(struct mt7615_dev *dev, const char *name)
 		 sizeof(dev->mt76.hw->wiphy->fw_version),
 		 "%.10s-%.15s", hdr->fw_ver, hdr->build_date);
 
-	if (!strncmp(hdr->fw_ver, "2.0", sizeof(hdr->fw_ver))) {
+	if (!is_mt7615(&dev->mt76) &&
+	    !strncmp(hdr->fw_ver, "2.0", sizeof(hdr->fw_ver))) {
 		dev->fw_ver = MT7615_FIRMWARE_V2;
 		dev->mcu_ops = &sta_update_ops;
 	} else {
-- 
2.28.0

