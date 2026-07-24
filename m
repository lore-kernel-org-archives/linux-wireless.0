Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6CE2F8EB5
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897302; cv=none; b=sKOJDHEozBSPbUyxmpTkLASHVeBA5UAOnzkh50YthLKMoiWhBa/Lt6pSVI6Geky4uwe+8deKZUE+ztnNTr1WVkozj8dcizghfYb8zifYhTw42ng3RYfJ8NZg5snUh7jlyw5m/7OQrySRRgnTxZ0ON2buRnQGBOYimmv+q9SgfeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897302; c=relaxed/simple;
	bh=Zg69E+aJuojhPAcZ6k0jLX2N44Vba+AWjAtrnr+f/9s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvMMB4IMUEXIsxj7VAI28myaJnaQ2MqHLj2zKE//ZYXqXb9aIfPWFjpBjHAtxI7lUgryMYWdzm79kYvJ0D8jgfyqsuZFVcayV8ckFZv8/OV4wUwOS2OJw4VRqkyhaEFIIXOOTdPthM67zF0RK6crXmuzTfCn9YLU5uprh0fAS8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=R+ZvtDPu; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="R+ZvtDPu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=X1z+Cry6cQBUfrTCVHjWgAEbLYSl74Pm1e88U6pZ08E=; b=R+ZvtDPuTyR6dF4dS1T0EwI8IY
	O6EknMhxKkfUSWx/7z4xtC23F7E81ItWJsQw6SrSdefDWFK6CqeObUGwB7eR432TSlzH76Ywd+th4
	l8JSzYVxUTWquOQ0thhITPsZ6K85jvYP01MiokmRTyDmEHMLf3An6QurRCyQ6sLS1poY=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK6-006LeO-17
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:18 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 16/29] wifi: mt76: mt7996: leave PS when a 4-address connection is established
Date: Fri, 24 Jul 2026 12:48:00 +0000
Message-ID: <20260724124813.3961474-16-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724124813.3961474-1-nbd@nbd.name>
References: <20260724124813.3961474-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peter Chiu <chui-hao.chiu@mediatek.com>

Because 4 address non-AMSDU packets do not have a bssid field, the
hardware cannot get the bssid. Without the bssid, stations are not
able to leave PS mode due to HW design. Wake up non-setup links when
4-address mode is established to prevent this issue.

mt7992 and mt7990 handle this via the BSSID mapping band config
instead, so restrict the command to mt7996.

Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.h   |  1 +
 .../net/wireless/mediatek/mt76/mt7996/main.c   |  8 ++++++++
 .../net/wireless/mediatek/mt76/mt7996/mcu.c    | 18 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7996/mcu.h    |  6 ++++++
 .../net/wireless/mediatek/mt76/mt7996/mt7996.h |  2 ++
 5 files changed, 35 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 8198efc6c05d..51380849d24e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -867,6 +867,7 @@ enum {
 	STA_REC_HDRT = 0x28,
 	STA_REC_EML_OP = 0x29,
 	STA_REC_HDR_TRANS = 0x2B,
+	STA_REC_PS_LEAVE = 0x45,
 	STA_REC_MAX_NUM
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 57afe4e81666..b6717d4e4dda 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -2067,6 +2067,14 @@ static void mt7996_sta_set_decap_offload(struct ieee80211_hw *hw,
 			continue;
 
 		mt7996_mcu_wtbl_update_hdr_trans(dev, vif, link, msta_link);
+
+		/* HW cannot derive the BSSID from 4-address non-AMSDU frames,
+		 * so PS exit is missed on links other than the setup link.
+		 * Let the firmware wake those links instead.
+		 */
+		if (enabled && msta->deflink_id != link_id &&
+		    is_mt7996(&dev->mt76))
+			mt7996_mcu_ps_leave(dev, link, msta_link);
 	}
 
 	mutex_unlock(&dev->mt76.mutex);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 69676a605549..57117ce69cbb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -5184,6 +5184,24 @@ int mt7996_mcu_wtbl_update_hdr_trans(struct mt7996_dev *dev,
 				     MCU_WMWA_UNI_CMD(STA_REC_UPDATE), true);
 }
 
+int mt7996_mcu_ps_leave(struct mt7996_dev *dev, struct mt7996_vif_link *link,
+			struct mt7996_sta_link *msta_link)
+{
+	struct sk_buff *skb;
+
+	skb = __mt76_connac_mcu_alloc_sta_req(&dev->mt76, &link->mt76,
+					      &msta_link->wcid,
+					      MT7996_STA_UPDATE_MAX_SIZE);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	mt76_connac_mcu_add_tlv(skb, STA_REC_PS_LEAVE,
+				sizeof(struct sta_rec_ps_leave));
+
+	return mt76_mcu_skb_send_msg(&dev->mt76, skb,
+				     MCU_WMWA_UNI_CMD(STA_REC_UPDATE), true);
+}
+
 int mt7996_mcu_set_fixed_rate_table(struct mt7996_phy *phy, u8 table_idx,
 				    u16 rate_idx, bool beacon)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index b53a9e71c281..1487d33a8dbb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -680,6 +680,12 @@ struct sta_rec_hdr_trans {
 	u8 mesh;
 } __packed;
 
+struct sta_rec_ps_leave {
+	__le16 tag;
+	__le16 len;
+	u8 __rsv[4];
+} __packed;
+
 struct sta_rec_mld_setup {
 	__le16 tag;
 	__le16 len;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index dcacc7d06e85..2a0cdb56f822 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -928,6 +928,8 @@ int mt7996_mcu_wtbl_update_hdr_trans(struct mt7996_dev *dev,
 				     struct ieee80211_vif *vif,
 				     struct mt7996_vif_link *link,
 				     struct mt7996_sta_link *msta_link);
+int mt7996_mcu_ps_leave(struct mt7996_dev *dev, struct mt7996_vif_link *link,
+			struct mt7996_sta_link *msta_link);
 int mt7996_mcu_cp_support(struct mt7996_dev *dev, u8 mode);
 int mt7996_mcu_set_emlsr_mode(struct mt7996_dev *dev,
 			      struct ieee80211_vif *vif,
-- 
2.53.0

