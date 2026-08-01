Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6084B394498
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785596027; cv=none; b=QRF8k6oNwrs7vidGqCMgeHqSUIWfIGtMFYVsP0EIf2KWXI20a9W0DlkTeksRZ5TpYRsnYCcZPc4HIoD8qHYGE4euLfoQ1odXMtKlz9qbM5sHE8MWlRThwPuJ/W8cnUOfsD2cs3qm8e45ixmZFoBkLSw0fsTyRFYibCze0KjR7zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785596027; c=relaxed/simple;
	bh=5HSeyvr/8ZhUq+5lb5ANQxAgLteMK+AtFDHxTocefcc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9xiPlA9FDRUWFx8dO6iOKNYv8MpbTILTNF1YzyOqbutg5yfrlbnDqyST1qn7sAsT6plG0QXuVzB6nGk+mZUrTZleIhRtyG8/S9QiZWP2LBjyGvuoVRopTj4yL80DKV2l+Ly/sX7NdOUJ8vddNc7hkrF0iHwDwg/w3ztflCE7gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=VprIV4QQ; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="VprIV4QQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1pmvo+sFfAGAWQ5Z01viTAy76BKhDHt8QRVMft53VwI=; b=VprIV4QQoNYT+lwiTubjAFK5fH
	F7tZJka0FUaV2ZJfdkxsdIzMudB3yUrVHPRSs1+Uhsl8lXoq51jS9RNGxBbXqe3rNoIBam6MAVXo9
	303KZglCS02V3j8sb0hjd2f6PUjAACl02QSK02mJw+dTXcXGTPnhMBUEcRi9DZ9/q/go=;
Received: from p200300cadf14d100000000000000085c.dip0.t-ipconnect.de ([2003:ca:df14:d100::85c] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wqB5l-009znC-1c
	for linux-wireless@vger.kernel.org;
	Sat, 01 Aug 2026 16:53:37 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 02/10] wifi: mt76: mt7915: handle MCU PS sync events
Date: Sat,  1 Aug 2026 14:53:26 +0000
Message-ID: <20260801145334.1166751-2-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260801145334.1166751-1-nbd@nbd.name>
References: <20260801145334.1166751-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable MT_DRV_HW_PS_BUFFERING and handle MCU_EXT_EVENT_PS_SYNC to
track station power-save state via firmware notifications.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7915/mcu.c    | 18 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7915/mcu.h    |  9 +++++++++
 .../net/wireless/mediatek/mt76/mt7915/mmio.c   |  3 ++-
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 88955aed62e2..5bfe0366562f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -402,6 +402,21 @@ mt7915_mcu_rx_bcc_notify(struct mt7915_dev *dev, struct sk_buff *skb)
 			mt7915_mcu_cca_finish, mphy->hw);
 }
 
+static void
+mt7915_mcu_rx_ps_sync(struct mt7915_dev *dev, struct sk_buff *skb)
+{
+	struct mt7915_mcu_ps_notify *p = (void *)skb->data;
+	struct mt76_wcid *wcid;
+	u16 wcid_idx;
+
+	wcid_idx = p->wtbl_lower | (p->wtbl_higher << 8);
+	wcid = mt76_wcid_ptr(dev, wcid_idx);
+	if (!wcid || !wcid_to_sta(wcid))
+		return;
+
+	mt76_sta_ps_transition(&dev->mt76, wcid, !!p->ps_bit);
+}
+
 static void
 mt7915_mcu_rx_ext_event(struct mt7915_dev *dev, struct sk_buff *skb)
 {
@@ -424,6 +439,9 @@ mt7915_mcu_rx_ext_event(struct mt7915_dev *dev, struct sk_buff *skb)
 	case MCU_EXT_EVENT_BCC_NOTIFY:
 		mt7915_mcu_rx_bcc_notify(dev, skb);
 		break;
+	case MCU_EXT_EVENT_PS_SYNC:
+		mt7915_mcu_rx_ps_sync(dev, skb);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
index 7c472062a90e..76e39e899797 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
@@ -54,6 +54,15 @@ struct mt7915_mcu_bcc_notify {
 	u8 rsv;
 } __packed;
 
+struct mt7915_mcu_ps_notify {
+	struct mt76_connac2_mcu_rxd_hdr rxd;
+
+	u8 wtbl_lower;
+	u8 ps_bit;
+	u8 wtbl_higher;
+	u8 rsv;
+} __packed;
+
 struct mt7915_mcu_rdd_report {
 	struct mt76_connac2_mcu_rxd_hdr rxd;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
index 2708b1556f40..28377c964843 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
@@ -921,7 +921,8 @@ struct mt7915_dev *mt7915_mmio_probe(struct device *pdev,
 		/* txwi_size = txd size + txp size */
 		.txwi_size = MT_TXD_SIZE + sizeof(struct mt76_connac_fw_txp),
 		.drv_flags = MT_DRV_TXWI_NO_FREE | MT_DRV_HW_MGMT_TXQ |
-			     MT_DRV_AMSDU_OFFLOAD,
+			     MT_DRV_AMSDU_OFFLOAD |
+			     MT_DRV_HW_PS_BUFFERING,
 		.survey_flags = SURVEY_INFO_TIME_TX |
 				SURVEY_INFO_TIME_RX |
 				SURVEY_INFO_TIME_BSS_RX,
-- 
2.53.0

