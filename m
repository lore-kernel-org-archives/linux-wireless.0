Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1189C282D8
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 14:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD3CE218A4
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 14:08:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="hB9RR8Ii"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbfA3OH7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 09:07:59 -0500
Received: from nbd.name ([46.4.11.11]:40146 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbfA3OH7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 09:07:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OWEawBFo/l/Bb553HzpCddAlf91gnSU2ChYbOlTR/9s=; b=hB9RR8IiMSoCbZKO2OBfupX6l+
        opRQxVzR70ss5WF3e6GKLqRa2JbnFFSemVvLkg2cCzOY6c79PV8wgVIcc313m/OO0MSuWHuCZSt9O
        V4em69osd6wcHSaydWnsfWiWvtPG8Ru5MF8jQO6NRD2xzO/Udra0+mjyDtD+u4NMEi1g=;
Received: by maeck.lan (Postfix, from userid 501)
        id 51E814E25A71; Wed, 30 Jan 2019 15:07:56 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mt76: add driver callback for when a sta is associated
Date:   Wed, 30 Jan 2019 15:07:54 +0100
Message-Id: <20190130140756.91317-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

MT7603 needs this to update the HT/VHT capabilities

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 5 +++++
 drivers/net/wireless/mediatek/mt76/mt76.h     | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index ee3b65a14870..489953a47646 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -709,6 +709,11 @@ int mt76_sta_state(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	    new_state == IEEE80211_STA_NONE)
 		return mt76_sta_add(dev, vif, sta);
 
+	if (old_state == IEEE80211_STA_AUTH &&
+	    new_state == IEEE80211_STA_ASSOC &&
+	    dev->drv->sta_assoc)
+		dev->drv->sta_assoc(dev, vif, sta);
+
 	if (old_state == IEEE80211_STA_NONE &&
 		 new_state == IEEE80211_STA_NOTEXIST)
 		mt76_sta_remove(dev, vif, sta);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 2bb9db4ed80a..71708b111120 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -300,6 +300,9 @@ struct mt76_driver_ops {
 	int (*sta_add)(struct mt76_dev *dev, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta);
 
+	void (*sta_assoc)(struct mt76_dev *dev, struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta);
+
 	void (*sta_remove)(struct mt76_dev *dev, struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta);
 };
-- 
2.17.0

