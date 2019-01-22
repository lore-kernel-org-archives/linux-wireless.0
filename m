Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70A08C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18C0A217F4
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:38:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="SYmCm+x/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbfAVPi0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:38:26 -0500
Received: from nbd.name ([46.4.11.11]:51082 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728628AbfAVPi0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:38:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=v8KUgfZhnB9Ee9fdrLOy/T2dft9Ie+R5rU6n0hY9KL0=; b=SYmCm+x/HC8pC9Zuk+LToAOsZD
        RDXEAS/Jr4SgcDhzC2vFi7E1hYauMCieYOh/IXa24cLOv9pltSXMcU7nfGFWbpRGKiT9N7vadebJm
        GCtQVEJV1gl4T3DFLwIMvC+Jd1/X6F2bqFKcM5hW1fVu8DzIX5IkQRMyzr4IMg+HE154=;
Received: by maeck.lan (Postfix, from userid 501)
        id D7A544D26898; Tue, 22 Jan 2019 16:38:23 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mt76: fix per-chain signal strength reporting
Date:   Tue, 22 Jan 2019 16:38:22 +0100
Message-Id: <20190122153823.46270-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix an off-by-one error that resulted in not reporting the signal strength
for the first chain

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index ce9bb702045f..63fa27d2c404 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -648,7 +648,7 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 
 	status->chains = BIT(0);
 	signal = mt76x02_mac_get_rssi(dev, rxwi->rssi[0], 0);
-	for (i = 1; i < nstreams; i++) {
+	for (i = 0; i < nstreams; i++) {
 		status->chains |= BIT(i);
 		status->chain_signal[i] = mt76x02_mac_get_rssi(dev,
 							       rxwi->rssi[i],
-- 
2.17.0

