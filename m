Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E0DC10F0B
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6531B217F5
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:29:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="swATLEZm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbfBZJ3s (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:29:48 -0500
Received: from nbd.name ([46.4.11.11]:60894 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727519AbfBZJ3s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 04:29:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=haUfLu81qERekD0qKdZ9HSiXg06DnijQ7MIxvLGKxEY=; b=swATLEZm2OwUObI30lS+NWkucC
        Y1oIp93C8Nha0k5EQayvFEymPUfW3BNXEyk9sS9En/bVSIcXSlrJZwGZ0k8cCNZo8UATicbW74rrn
        /DzhToYVnxaAF6tpnzpV5jl2kc7cg3WML6DjLHpkWlmB4OvZPpZq34VCWC6HOlNWNels=;
Received: by maeck.lan (Postfix, from userid 501)
        id BCEC15047CF5; Tue, 26 Feb 2019 10:29:45 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 3/8] mt76: mt76x02: fix beacon timer issue
Date:   Tue, 26 Feb 2019 10:29:40 +0100
Message-Id: <20190226092945.54738-3-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190226092945.54738-1-nbd@nbd.name>
References: <20190226092945.54738-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When mt76x0 and mt76x2 beacon code was unified, it changed the order in which
beacon enable and beacon interval are configured.
Configuring beacon enable before beacon interval can in some cases cause
problems with the beacon timer, leading to clients not waking up properly
from powersave mode.
Fix this by changing the order back to interval first, then enable.

Fixes: cc726268e4dce ("mt76: move mt76x02_bss_info_changed in mt76x02-lib module")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 7b9b1956111b..2e899d30e00d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -704,9 +704,6 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_BSSID)
 		mt76x02_mac_set_bssid(dev, mvif->idx, info->bssid);
 
-	if (changed & BSS_CHANGED_BEACON_ENABLED)
-		mt76x02_mac_set_beacon_enable(dev, vif, info->enable_beacon);
-
 	if (changed & BSS_CHANGED_HT || changed & BSS_CHANGED_ERP_CTS_PROT)
 		mt76x02_mac_set_tx_protection(dev, info->use_cts_prot,
 					      info->ht_operation_mode);
@@ -719,6 +716,9 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
 		dev->tbtt_count = 0;
 	}
 
+	if (changed & BSS_CHANGED_BEACON_ENABLED)
+		mt76x02_mac_set_beacon_enable(dev, vif, info->enable_beacon);
+
 	if (changed & BSS_CHANGED_ERP_PREAMBLE)
 		mt76x02_mac_set_short_preamble(dev, info->use_short_preamble);
 
-- 
2.17.0

