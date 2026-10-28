Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190257;
	b=QGdyH/dcTefnQCmcyStsaJO8BzG2vPx19v9u3HLEOAVhoS4GmZCBx23QliZw2dDQlEao
	 AqW0i9rQuz3ZKM8rJcRUSUds4sUGbNx+seF7XbTrTEAR29P2H1e3711bFdY9agkv5PEuG
	 r7P6lP3BSVSUuAYnr/9e3pXcpyPKDglTXdp3iB6YkV/+tz3ZPa5AyjkH0tBWBqjkWJoxQ
	 aMLcHlwh1NBwwrE1dD/7TwAp5v4STkokpM+A7naV8o21c87DtsChI6te3b3qaADN0WtP9
	 +PFZfwCqXUcJjNljUYxQGB5ZiD7fkA0ktuzyj1+8vHw/OrTss4/GBMUFHCtBeol3tXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190257;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RRnl8cFOKSBva8P3Pu7dln8bWAjmB9/YIaKNIEhVlQY=;
	b=z6mqlIg4w9jVr8GdVvzyvfDUHHZLV7DBQQUuBmv4CHjTzEBLr9EDl8c2vDdQHp90t2oo
	 1GEoR2JwF6tgbjXy3doqf4b442toE78/0z2Stg68Ra2ycZVm+L64WIZSyQ3jMg/BVDldZ
	 HKioFQVZXI75uilS1h096fzFVfZ4JDsor0Yss7MIsVixm4xqXSh7dQOkWGR7diMMvivZR
	 tF2mjcadMR3vB+TigQp0sXwINKxZx5YNOyhmgURx1KfIh5DLJInGRLWwYmik4dh7iEIiA
	 tx65meu51CHcPchA7GaUilVpzhPFMnohLcpJH6ze/61KkaSbmVgNRPnEdFJVd/AYZeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=lJrLpIko;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390DE606A32D
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 390DE606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=lJrLpIko
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RRnl8cFOKSBva8P3Pu7dln8bWAjmB9/YIaKNIEhVlQY=; b=lJrLpIkoN6K/ARJ3OXLvWLgJ4F
	Bo/y8V9kLtY1bx8aHKnWRpdmt3716go9BYWFAlmmJxi2+R7zYiRuPB1MSNibMtNeqFZ0YGEU2RBoF
	dxS3ecgI/z11tqXiYjb2Zoota/XdWa9+MlAjozoM6mn2yFBpHOlwt3+ucPgjfPFuhswg=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hK-00C8Bw-2S;
	Wed, 28 Oct 2026 13:24:06 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: Allen Ye <allen.ye@mediatek.com>
Subject: [PATCH mt76-next 04/25] wifi: mt76: mt7996: pass the puncturing bitmap to the firmware
Date: Wed, 28 Oct 2026 13:23:42 +0100
Message-ID: <20261028122403.796394-4-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028122403.796394-1-nbd@nbd.name>
References: <20261028122403.796394-1-nbd@nbd.name>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_set_channel() programs the channel and the width of a chanctx,
but not chandef->punctured, so the firmware does not know which
subchannels of the channel are punctured.

Send the bitmap of the chandef with the PP_EN_CTRL command on every
channel set, in user mode with the firmware's own puncturing detection
off. The firmware holds one bitmap per band, so stations and APs on the
band use the same command. Do not wait for a response, like the
MediaTek vendor driver, which sends this command with the same
firmware. Skip 2.4 GHz, where an EHT channel is at most 40 MHz wide and
cannot be punctured.

Co-developed-by: Allen Ye <allen.ye@mediatek.com>
Signed-off-by: Allen Ye <allen.ye@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  1 +
 .../net/wireless/mediatek/mt76/mt7996/main.c  |  4 +++
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 32 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7996/mcu.h   |  4 +++
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  1 +
 5 files changed, 42 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 88281733a3df..e9a7542c07dc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1349,6 +1349,7 @@ enum {
 	MCU_UNI_CMD_CHANNEL_SWITCH = 0x34,
 	MCU_UNI_CMD_THERMAL = 0x35,
 	MCU_UNI_CMD_VOW = 0x37,
+	MCU_UNI_CMD_PP = 0x38,
 	MCU_UNI_CMD_FIXED_RATE_TABLE = 0x40,
 	MCU_UNI_CMD_RSSI_MONITOR = 0x41,
 	MCU_UNI_CMD_TESTMODE_CTRL = 0x46,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index e8faa826e037..3a3441951254 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -690,6 +690,10 @@ int mt7996_set_channel(struct mt76_phy *mphy)
 	if (mphy->offchannel)
 		mt7996_mac_update_beacons(phy);
 
+	ret = mt7996_mcu_set_punct(phy);
+	if (ret)
+		goto out;
+
 	ret = mt7996_mcu_set_chan_info(phy, UNI_CHANNEL_SWITCH);
 	if (ret)
 		goto out;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 7e72174bd6b1..f35250430383 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -4255,6 +4255,38 @@ int mt7996_mcu_set_chan_info(struct mt7996_phy *phy, u16 tag)
 				 &req, sizeof(req), true);
 }
 
+int mt7996_mcu_set_punct(struct mt7996_phy *phy)
+{
+	struct cfg80211_chan_def *chandef = &phy->mt76->chandef;
+	struct mt7996_dev *dev = phy->dev;
+	struct {
+		u8 __rsv[4];
+
+		__le16 tag;
+		__le16 len;
+		u8 mgmt_mode;
+		u8 band_idx;
+		u8 force_bitmap_ctrl;
+		u8 auto_mode;
+		__le16 bitmap;
+		u8 csa_enable;
+		u8 __rsv2;
+	} __packed req = {
+		.tag = cpu_to_le16(UNI_CMD_PP_EN_CTRL),
+		.len = cpu_to_le16(sizeof(req) - 4),
+		.mgmt_mode = 1,
+		.band_idx = phy->mt76->band_idx,
+		.force_bitmap_ctrl = 2,
+		.bitmap = cpu_to_le16(chandef->punctured),
+	};
+
+	if (chandef->chan->band == NL80211_BAND_2GHZ)
+		return 0;
+
+	return mt76_mcu_send_msg(&dev->mt76, MCU_WM_UNI_CMD(PP),
+				 &req, sizeof(req), false);
+}
+
 static int
 mt7996_mcu_get_cal_free_data(struct mt7996_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index 6078f8811b1e..70ed57d9bf9a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -1033,6 +1033,10 @@ enum{
 	UNI_CMD_SR_SET_SIGA = 0xd0,
 };
 
+enum {
+	UNI_CMD_PP_EN_CTRL,
+};
+
 enum {
 	UNI_CMD_THERMAL_PROTECT_ENABLE = 0x6,
 	UNI_CMD_THERMAL_PROTECT_DISABLE,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index d30b4d689bac..1f1dff9f6610 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -786,6 +786,7 @@ int mt7996_mcu_add_rate_ctrl(struct mt7996_dev *dev, struct mt7996_sta *msta,
 			     bool changed);
 int mt7996_set_channel(struct mt76_phy *mphy);
 int mt7996_mcu_set_chan_info(struct mt7996_phy *phy, u16 tag);
+int mt7996_mcu_set_punct(struct mt7996_phy *phy);
 int mt7996_mcu_set_tx(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 		      struct ieee80211_bss_conf *link_conf);
 int mt7996_mcu_set_fixed_rate_ctrl(struct mt7996_dev *dev,
-- 
2.47.3

