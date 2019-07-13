Return-Path: <SRS0=JK+e=VK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64EF8C742A7
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Jul 2019 15:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31D5E20863
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Jul 2019 15:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563030565;
	bh=9IYx7eid2881mcR0O3CFIj1Tw2LY+RHOdohQlnCnwU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2jnvYw/SuOk+pkD985YU+SObqgAsoVJX3qMLD1mZcnpjmJK3oMFQG/mLGzL9eoGm3
	 q86Un2bQ0Vkaphnyc9q9UVle+3swWD9OIJzWp1PhlPFLllJYdCvzoGpv1xY4OR2PQX
	 6EhcgHE9xcL9+3vomc0bBd/VuWFl2/KXBV+4+Ltg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbfGMPJY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Jul 2019 11:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727626AbfGMPJY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Jul 2019 11:09:24 -0400
Received: from lore-desk-wlan.lan (unknown [151.66.36.246])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16BDB208E4;
        Sat, 13 Jul 2019 15:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563030562;
        bh=9IYx7eid2881mcR0O3CFIj1Tw2LY+RHOdohQlnCnwU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0/UAlgWZZUHa9FpzuiuCy3Bt0320rnoh0evz+27PuG3yuXiGUYvPlteIE1tL81L8
         xka/QKwvABi5OCaeqM+Egc3yr8QKAgwDE1YnRB68rIJbS67zz9NJ3UHn/dbhtwhsqX
         HzXLoWci/ckWcwomftkC1+pQSQ+t5/iPxCAFPLxg=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, ryder.lee@mediatek.com,
        royluo@google.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/7] mt76: mt7615: introduce mt7615_mac_wtbl_set_key routine
Date:   Sat, 13 Jul 2019 17:09:03 +0200
Message-Id: <44db4590764c0498b4103559fcac57e8c8777542.1563029769.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1563029769.git.lorenzo@kernel.org>
References: <cover.1563029769.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mt7615_mac_wtbl_set_key routine to configure wtbl key parameter
directly from host cpu. This is a preliminary patch to add BIP_CMAC_128
hw support. Moreover add static qualifier to mt7615_mac_get_key_info
routine

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/mac.c   | 51 ++++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt7615/mac.h   |  4 --
 .../net/wireless/mediatek/mt76/mt7615/main.c  |  2 +-
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   | 39 --------------
 .../wireless/mediatek/mt76/mt7615/mt7615.h    |  5 +-
 .../net/wireless/mediatek/mt76/mt7615/regs.h  | 10 ++++
 6 files changed, 63 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index fb28f68486fd..1904e1a0a597 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -592,7 +592,7 @@ void mt7615_mac_set_rates(struct mt7615_dev *dev, struct mt7615_sta *sta,
 	sta->wcid.tx_info |= MT_WCID_TX_INFO_SET;
 }
 
-enum mt7615_cipher_type
+static enum mt7615_cipher_type
 mt7615_mac_get_key_info(struct ieee80211_key_conf *key,
 			u8 *key_data)
 {
@@ -626,6 +626,55 @@ mt7615_mac_get_key_info(struct ieee80211_key_conf *key,
 	}
 }
 
+int mt7615_mac_wtbl_set_key(struct mt7615_dev *dev, int wcid,
+			    struct ieee80211_key_conf *key)
+{
+	enum mt7615_cipher_type cipher;
+	u8 key_data[32] = {};
+	u32 addr, w0, w1;
+	int err = 0;
+
+	spin_lock_bh(&dev->mt76.lock);
+	if (!mt76_poll(dev, MT_WTBL_UPDATE, MT_WTBL_UPDATE_BUSY, 0, 5000)) {
+		err = -ETIMEDOUT;
+		goto out;
+	}
+
+	cipher = mt7615_mac_get_key_info(key, key_data);
+	if (cipher == MT_CIPHER_NONE && key) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	addr = mt7615_mac_wtbl_addr(wcid);
+
+	mt76_wr_copy(dev, addr + 30 * 4, key_data, sizeof(key_data));
+
+	mt76_rmw(dev, addr + 2 * 4, MT_WTBL_W2_KEY_TYPE,
+		 FIELD_PREP(MT_WTBL_W2_KEY_TYPE, cipher));
+
+	w0 = mt76_rr(dev, addr);
+	w1 = mt76_rr(dev, addr + 4);
+	w0 &= ~(MT_WTBL_W0_KEY_IDX | MT_WTBL_W0_RX_KEY_VALID);
+	if (key)
+		w0 |= FIELD_PREP(MT_WTBL_W0_KEY_IDX, key->keyidx) |
+		      MT_WTBL_W0_RX_KEY_VALID;
+	mt76_wr(dev, MT_WTBL_RICR0, w0);
+	mt76_wr(dev, MT_WTBL_RICR1, w1);
+
+	mt76_wr(dev, MT_WTBL_UPDATE,
+		FIELD_PREP(MT_WTBL_UPDATE_WLAN_IDX, wcid) |
+		MT_WTBL_UPDATE_RXINFO_UPDATE);
+
+	if (!mt76_poll(dev, MT_WTBL_UPDATE, MT_WTBL_UPDATE_BUSY, 0, 5000))
+		err = -ETIMEDOUT;
+
+out:
+	spin_unlock_bh(&dev->mt76.lock);
+
+	return err;
+}
+
 int mt7615_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 			  enum mt76_txq_id qid, struct mt76_wcid *wcid,
 			  struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.h b/drivers/net/wireless/mediatek/mt76/mt7615/mac.h
index 358ab51270f0..051b540e79fd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.h
@@ -317,8 +317,4 @@ enum mt7615_cipher_type {
 	MT_CIPHER_GCMP_256,
 };
 
-enum mt7615_cipher_type
-mt7615_mac_get_key_info(struct ieee80211_key_conf *key,
-			u8 *key_data);
-
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 2c702b31d55f..17920cb69874 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -204,7 +204,7 @@ static int mt7615_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	}
 	mt76_wcid_key_setup(&dev->mt76, wcid, key);
 
-	return mt7615_mcu_set_wtbl_key(dev, wcid->idx, key, cmd);
+	return mt7615_mac_wtbl_set_key(dev, wcid->idx, key);
 }
 
 static int mt7615_config(struct ieee80211_hw *hw, u32 changed)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index e05ef57441a2..6269abc78606 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -877,45 +877,6 @@ int mt7615_mcu_set_bss_info(struct mt7615_dev *dev,
 	return ret;
 }
 
-int mt7615_mcu_set_wtbl_key(struct mt7615_dev *dev, int wcid,
-			    struct ieee80211_key_conf *key,
-			    enum set_key_cmd cmd)
-{
-	struct {
-		struct wtbl_req_hdr hdr;
-		struct wtbl_sec_key key;
-	} req = {
-		.hdr = {
-			.wlan_idx = wcid,
-			.operation = WTBL_SET,
-			.tlv_num = cpu_to_le16(1),
-		},
-		.key = {
-			.tag = cpu_to_le16(WTBL_SEC_KEY),
-			.len = cpu_to_le16(sizeof(struct wtbl_sec_key)),
-			.add = cmd,
-		},
-	};
-
-	if (cmd == SET_KEY) {
-		u8 cipher;
-
-		cipher = mt7615_mac_get_key_info(key, req.key.key_material);
-		if (cipher == MT_CIPHER_NONE)
-			return -EOPNOTSUPP;
-
-		req.key.rkv = 1;
-		req.key.cipher_id = cipher;
-		req.key.key_id = key->keyidx;
-		req.key.key_len = key->keylen;
-	} else {
-		req.key.key_len = sizeof(req.key.key_material);
-	}
-
-	return __mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD_WTBL_UPDATE,
-				   &req, sizeof(req), true);
-}
-
 static int
 mt7615_mcu_add_wtbl_bmc(struct mt7615_dev *dev,
 			struct mt7615_vif *mvif)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
index 2f43101343c3..e6067c88cbbd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
@@ -157,9 +157,6 @@ int mt7615_mcu_set_dev_info(struct mt7615_dev *dev,
 			    struct ieee80211_vif *vif, bool enable);
 int mt7615_mcu_set_bss_info(struct mt7615_dev *dev, struct ieee80211_vif *vif,
 			    int en);
-int mt7615_mcu_set_wtbl_key(struct mt7615_dev *dev, int wcid,
-			    struct ieee80211_key_conf *key,
-			    enum set_key_cmd cmd);
 void mt7615_mac_set_rates(struct mt7615_dev *dev, struct mt7615_sta *sta,
 			  struct ieee80211_tx_rate *probe_rate,
 			  struct ieee80211_tx_rate *rates);
@@ -222,6 +219,8 @@ int mt7615_mac_write_txwi(struct mt7615_dev *dev, __le32 *txwi,
 int mt7615_mac_fill_rx(struct mt7615_dev *dev, struct sk_buff *skb);
 void mt7615_mac_add_txs(struct mt7615_dev *dev, void *data);
 void mt7615_mac_tx_free(struct mt7615_dev *dev, struct sk_buff *skb);
+int mt7615_mac_wtbl_set_key(struct mt7615_dev *dev, int wcid,
+			    struct ieee80211_key_conf *key);
 
 int mt7615_mcu_set_eeprom(struct mt7615_dev *dev);
 int mt7615_mcu_init_mac(struct mt7615_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/regs.h b/drivers/net/wireless/mediatek/mt76/mt7615/regs.h
index f2cd858730c3..4a66d34063b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/regs.h
@@ -148,8 +148,15 @@
 #define MT_WTBL_OFF_BASE		0x23400
 #define MT_WTBL_OFF(n)			(MT_WTBL_OFF_BASE + (n))
 
+#define MT_WTBL_W0_KEY_IDX		GENMASK(24, 23)
+#define MT_WTBL_W0_RX_KEY_VALID		BIT(26)
+#define MT_WTBL_W0_RX_IK_VALID		BIT(27)
+
+#define MT_WTBL_W2_KEY_TYPE		GENMASK(7, 4)
+
 #define MT_WTBL_UPDATE			MT_WTBL_OFF(0x030)
 #define MT_WTBL_UPDATE_WLAN_IDX		GENMASK(7, 0)
+#define MT_WTBL_UPDATE_RXINFO_UPDATE	BIT(11)
 #define MT_WTBL_UPDATE_RATE_UPDATE	BIT(13)
 #define MT_WTBL_UPDATE_TX_COUNT_CLEAR	BIT(14)
 #define MT_WTBL_UPDATE_BUSY		BIT(31)
@@ -157,6 +164,9 @@
 #define MT_WTBL_ON_BASE			0x23000
 #define MT_WTBL_ON(_n)			(MT_WTBL_ON_BASE + (_n))
 
+#define MT_WTBL_RICR0			MT_WTBL_ON(0x010)
+#define MT_WTBL_RICR1			MT_WTBL_ON(0x014)
+
 #define MT_WTBL_RIUCR0			MT_WTBL_ON(0x020)
 
 #define MT_WTBL_RIUCR1			MT_WTBL_ON(0x024)
-- 
2.21.0

