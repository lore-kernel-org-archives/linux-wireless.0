Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73FBC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 16:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70CB320645
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 16:48:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Uovcc5Op"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389207AbfCAQsx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 11:48:53 -0500
Received: from nbd.name ([46.4.11.11]:59604 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728285AbfCAQsx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 11:48:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qSxRb7NG0Hwaf0lwsRjsERkMFSFUSMK4LoYzvL2YuOo=; b=Uovcc5OpirwpvggmLo+Q6EKCQk
        38dI0B6wb57PBd3HgW7HpkBz9a7YzlRa6IDXGPxtbAxZ51zZFznu7IsVyxDMvvhILlEax9g67B9Hj
        tcwdxDO6h0tTJOuLSCTjK0d1+ijbXJFUTESCI10w/c/v0OGj5eV6GnYOebBU8kfswgB0=;
Received: by maeck.lan (Postfix, from userid 501)
        id 72FF550B33CE; Fri,  1 Mar 2019 17:48:51 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     sgruszka@redhat.com
Subject: [PATCH] mt76: mt76x02: only update the base mac address if necessary
Date:   Fri,  1 Mar 2019 17:48:51 +0100
Message-Id: <20190301164851.40809-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Also update the mask first before calculating the vif index.
Fixes an issue where adding back the same interfaces in a different order
fails because of duplicate vif index use

Fixes: 06662264ce2ad ("mt76x02: use mask for vifs")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 28eccb3119d1..cd072ac614f7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -293,6 +293,12 @@ mt76x02_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	struct mt76x02_dev *dev = hw->priv;
 	unsigned int idx = 0;
 
+	/* Allow to change address in HW if we create first interface. */
+	if (!dev->vif_mask &&
+	    (((vif->addr[0] ^ dev->mt76.macaddr[0]) & ~GENMASK(4, 1)) ||
+	     memcmp(vif->addr + 1, dev->mt76.macaddr + 1, ETH_ALEN - 1)))
+		mt76x02_mac_setaddr(dev, vif->addr);
+
 	if (vif->addr[0] & BIT(1))
 		idx = 1 + (((dev->mt76.macaddr[0] ^ vif->addr[0]) >> 2) & 7);
 
@@ -315,10 +321,6 @@ mt76x02_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	if (dev->vif_mask & BIT(idx))
 		return -EBUSY;
 
-	/* Allow to change address in HW if we create first interface. */
-	if (!dev->vif_mask && !ether_addr_equal(dev->mt76.macaddr, vif->addr))
-                mt76x02_mac_setaddr(dev, vif->addr);
-
 	dev->vif_mask |= BIT(idx);
 
 	mt76x02_vif_init(dev, vif, idx);
-- 
2.17.0

