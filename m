Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A68E2C46463
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7103F2087D
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7103F2087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbeJKQSt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 12:18:49 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:47085 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727633AbeJKQSs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 12:18:48 -0400
Received: by mail-wr1-f68.google.com with SMTP id n11-v6so8622121wru.13
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2018 01:52:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3ynAmKHhaCLut07COhXSyOAuapRPV6d2juTunQJTZHE=;
        b=X8QleLUKH+vX/lqkOLKWx5dPQSowMnDfemLLCv26GSJpexPG0G9t54NGwcKB3Uv0xy
         9LDa7Jq8s5QoTCuBU7Gb4QJsxy9eFTD+Ax8qApUJwE5+fetWN6kPdRH4GtcSOOuPoUMF
         8z1SPhTKB3gdOnm78iTbnrBlBXAHslBdig+gwP1UfWPeWR8/PUlMxLeXWI3suOOsN6kz
         opPgGC9re8+217FRyBtad1MhXMtZ/V3ROtvl7lvw/uED16NOs5LPcqo5oWjyNODk87Ql
         53JgKHUMS40nl+rl+zWb5bH9x8GzCczPyzpzj2/Aa3/WHVpKpxXxbRUXATglSk3wBaES
         pL3w==
X-Gm-Message-State: ABuFfogFvXvOCNHhzte5AOItfDD7v1pRIU5N/k4VzVDtl3eJRHMnygBC
        r6bTMi3GKUCYRJLdrpBaxdeafK/ieUQ=
X-Google-Smtp-Source: ACcGV63bKHX4iVwd39SLqm6/8X2pEdAV1CPkzLKw0Dby2iZAiWZaFGa2cZFCnJCVlRHD2Bdy1u++NQ==
X-Received: by 2002:adf:9d26:: with SMTP id k38-v6mr747393wre.18.1539247948317;
        Thu, 11 Oct 2018 01:52:28 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v184-v6sm950839wme.3.2018.10.11.01.52.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 01:52:27 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 06/12] mt76x0: eeprom: introduce mt76x0_tssi_enabled routine
Date:   Thu, 11 Oct 2018 10:52:03 +0200
Message-Id: <4237db81486623028825dc4efd59abfea827d2ea.1539247493.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
References: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mt76x0_tssi_enabled in order to check if tssi compensation
is enabled since mt76x0 condition differs from mt76x2 one.
Moreover move back mt76x02_temp_tx_alc_enabled and mt76x02_tssi_enabled
routines in mt76x2/eeprom.h since they are mt76x2 specific

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    |  2 +-
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  6 ++++++
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   | 21 -------------------
 .../wireless/mediatek/mt76/mt76x2/eeprom.c    |  4 ++--
 .../wireless/mediatek/mt76/mt76x2/eeprom.h    | 21 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  4 ++--
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   |  2 +-
 7 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 1defb072ccbf..ab4fd6e0f23a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -135,7 +135,7 @@ static s8 mt76x0_get_delta(struct mt76x02_dev *dev)
 	struct cfg80211_chan_def *chandef = &dev->mt76.chandef;
 	u8 val;
 
-	if (mt76x02_tssi_enabled(dev))
+	if (mt76x0_tssi_enabled(dev))
 		return 0;
 
 	if (chandef->width == NL80211_CHAN_WIDTH_80) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
index 40fd4e61769b..ee9ade9f3c8b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -37,4 +37,10 @@ static inline s8 s6_to_s8(u32 val)
 	return ret;
 }
 
+static inline bool mt76x0_tssi_enabled(struct mt76x02_dev *dev)
+{
+	return (mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_1) &
+		MT_EE_NIC_CONF_1_TX_ALC_EN);
+}
+
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
index 0fba43d569b5..b3ec74835d10 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
@@ -179,27 +179,6 @@ mt76x02_eeprom_get(struct mt76x02_dev *dev,
 	return get_unaligned_le16(dev->mt76.eeprom.data + field);
 }
 
-static inline bool
-mt76x02_temp_tx_alc_enabled(struct mt76x02_dev *dev)
-{
-	u16 val;
-
-	val = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_EXT_PA_5G);
-	if (!(val & BIT(15)))
-		return false;
-
-	return mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_1) &
-	       MT_EE_NIC_CONF_1_TEMP_TX_ALC;
-}
-
-static inline bool
-mt76x02_tssi_enabled(struct mt76x02_dev *dev)
-{
-	return !mt76x02_temp_tx_alc_enabled(dev) &&
-	       (mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_1) &
-		MT_EE_NIC_CONF_1_TX_ALC_EN);
-}
-
 bool mt76x02_ext_pa_enabled(struct mt76x02_dev *dev, enum nl80211_band band);
 int mt76x02_get_efuse_data(struct mt76x02_dev *dev, u16 base, void *buf,
 			   int len, enum mt76x02_eeprom_modes mode);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
index 5fb9532f3eed..f39b622d03f4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
@@ -464,7 +464,7 @@ void mt76x2_get_power_info(struct mt76x02_dev *dev,
 					 MT_EE_TX_POWER_1_START_2G);
 	}
 
-	if (mt76x02_tssi_enabled(dev) ||
+	if (mt76x2_tssi_enabled(dev) ||
 	    !mt76x02_field_valid(t->target_power))
 		t->target_power = t->chain[0].target_power;
 
@@ -481,7 +481,7 @@ int mt76x2_get_temp_comp(struct mt76x02_dev *dev, struct mt76x2_temp_comp *t)
 
 	memset(t, 0, sizeof(*t));
 
-	if (!mt76x02_temp_tx_alc_enabled(dev))
+	if (!mt76x2_temp_tx_alc_enabled(dev))
 		return -EINVAL;
 
 	if (!mt76x02_ext_pa_enabled(dev, band))
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h
index 13bceb6aa5e4..9e735524d367 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h
@@ -70,4 +70,25 @@ mt76x2_has_ext_lna(struct mt76x02_dev *dev)
 		return val & MT_EE_NIC_CONF_1_LNA_EXT_5G;
 }
 
+static inline bool
+mt76x2_temp_tx_alc_enabled(struct mt76x02_dev *dev)
+{
+	u16 val;
+
+	val = mt76x02_eeprom_get(dev, MT_EE_TX_POWER_EXT_PA_5G);
+	if (!(val & BIT(15)))
+		return false;
+
+	return mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_1) &
+	       MT_EE_NIC_CONF_1_TEMP_TX_ALC;
+}
+
+static inline bool
+mt76x2_tssi_enabled(struct mt76x02_dev *dev)
+{
+	return !mt76x2_temp_tx_alc_enabled(dev) &&
+	       (mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_1) &
+		MT_EE_NIC_CONF_1_TX_ALC_EN);
+}
+
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index 5942cc7a98a3..55708b8e6e10 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -26,7 +26,7 @@ mt76x2_phy_tssi_init_cal(struct mt76x02_dev *dev)
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	u32 flag = 0;
 
-	if (!mt76x02_tssi_enabled(dev))
+	if (!mt76x2_tssi_enabled(dev))
 		return false;
 
 	if (mt76x2_channel_silent(dev))
@@ -391,7 +391,7 @@ int mt76x2_phy_set_channel(struct mt76x02_dev *dev,
 	       sizeof(dev->cal.agc_gain_cur));
 
 	/* init default values for temp compensation */
-	if (mt76x02_tssi_enabled(dev)) {
+	if (mt76x2_tssi_enabled(dev)) {
 		mt76_rmw_field(dev, MT_TX_ALC_CFG_1, MT_TX_ALC_CFG_1_TEMP_COMP,
 			       0x38);
 		mt76_rmw_field(dev, MT_TX_ALC_CFG_2, MT_TX_ALC_CFG_2_TEMP_COMP,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
index c0c8c0ad1912..ca96ba60510e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
@@ -202,7 +202,7 @@ int mt76x2u_phy_set_channel(struct mt76x02_dev *dev,
 	if (scan)
 		return 0;
 
-	if (mt76x02_tssi_enabled(dev)) {
+	if (mt76x2_tssi_enabled(dev)) {
 		/* init default values for temp compensation */
 		mt76_rmw_field(dev, MT_TX_ALC_CFG_1, MT_TX_ALC_CFG_1_TEMP_COMP,
 			       0x38);
-- 
2.17.2

