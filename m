Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D0AC10F05
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 08:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9A4F2084B
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 08:34:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="nadKSDBL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730625AbfCZIeZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 04:34:25 -0400
Received: from nbd.name ([46.4.11.11]:38948 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbfCZIeY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 04:34:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oTd+N9QCmb6fPu9R/tGy0W3/v3GahMh+OzIbyP6oNmU=; b=nadKSDBLDkxLm1TsjGkCheXM8x
        HzPcvW25Co/P1IyxENKxLBpjk5CYzTeui/g1PxsHGoHnoaiBYDIjvz+SspAGWlecMikzVcEAiwUNd
        t+ZF/Ng1G/PVTjB4XD00auUuZWgBN0puc5uKPM5lKPUSIDNCfVB3wqobVU2NbrV92Na4=;
Received: from p4ff13338.dip0.t-ipconnect.de ([79.241.51.56] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h8hXK-0000g1-Oh; Tue, 26 Mar 2019 09:34:22 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id EA1B75583F86; Tue, 26 Mar 2019 09:34:21 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org
Subject: [PATCH 5.1 1/3] mt76: mt7603: add missing initialization for dev->ps_lock
Date:   Tue, 26 Mar 2019 09:34:19 +0100
Message-Id: <20190326083421.57998-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes lockdep complaint and a potential race condition

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7603/init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/init.c b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
index d54dda67d036..3af45949e868 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
@@ -510,6 +510,8 @@ int mt7603_register_device(struct mt7603_dev *dev)
 	bus_ops->rmw = mt7603_rmw;
 	dev->mt76.bus = bus_ops;
 
+	spin_lock_init(&dev->ps_lock);
+
 	INIT_DELAYED_WORK(&dev->mac_work, mt7603_mac_work);
 	tasklet_init(&dev->pre_tbtt_tasklet, mt7603_pre_tbtt_tasklet,
 		     (unsigned long)dev);
-- 
2.17.0

