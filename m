Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792826376;
	b=tRVTcTZtjpvqAn/Rg+rAjS32IQu2S8Jt+7HatJvRujbYwbdGysEB79LTLAG8ZQkAZ2g1
	 P6vSgcy+nohsoetMAiEiFF5ZCKE9qvT7lYe8gF8WfwamVlfrUNq7CQFbzXOMJ+ngZz7/R
	 vuzF6twHXa4m0ikJXsBfwJhlaAO2cgwg0KBSCgND9FFZpWRQ01ZqjT8Mjl8OjCJMsrY7v
	 g2Pae6psRAwo0IPw+DRoRiJC4vIxtpu/FS8CtiFYOE35FWWiUt426FEa+jqaWYp/Yd2TU
	 8VhI45z38pbkGBC0Yn7v+/IKTfVmSlmKrkC07IVbPVKNRIL1H/TVMIJxOhwPtAgnndA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792826376;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1QnC0xEGt6Z0dvRPbVycIuHK8dNbmttwG/gqODBDI8A=;
	b=jsGzXQRZEAwYAsiQ+OfYwHUJ4viC/Bp/xeosiMGarZo0DvLEE6WWpFb5QLD+knf6j3H8
	 50zk7co+mpiSPyhLzd67lIFB0zgMeYw1w3uuAMCNezl9RQYQGfJP36U4upBTt3WzrEaPt
	 JEI3r4DIb0yckZI+LvoTtJQHOh+533MJv+b6KzWQhVOzZHpr7dGCI5VpTT5r3WX1Pxszo
	 djOJumyRY7hKO1DxKTO5+hQMDuWi7JJes20jisex5Jyy+Y8GYvEy9tZ8ASzE9OTlYC9kL
	 JVGGbTNCkCXXFJcYCGriEMNx9AlfgDcYfNMDeuPTJUNEIpywVHGMQ3ncMKrGEum016w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=ZzrOkUyW;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE0E606A31B
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 07:19:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EE0E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=ZzrOkUyW
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1QnC0xEGt6Z0dvRPbVycIuHK8dNbmttwG/gqODBDI8A=; b=ZzrOkUyWU4FLi76jegNyPZvDXv
	RUUnqPNfGtJcb/KL7njZpKlMu6Ows6amOTd/BTPIeTOIRQ8q3nRn5mDuy3rHV/vuYfpTdkaPV5CXp
	KLiswjuJGlPugUCbXOJdslrrp5cALYyQvgjWJFM1xnW0pHC/aPK2mc+LsaduxXasBbis=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xKW2P-009vQq-10
	for linux-wireless@vger.kernel.org;
	Sat, 24 Oct 2026 09:19:33 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 02/11] wifi: mt76: mt7921: validate NIC capability TLV payload lengths
Date: Sat, 24 Oct 2026 09:19:18 +0200
Message-ID: <20261024071927.2279668-2-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261024071927.2279668-1-nbd@nbd.name>
References: <20261024071927.2279668-1-nbd@nbd.name>
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

mt7921_mcu_get_nic_capability() checks that each TLV fits in the
response, but not that the TLV is long enough for the fields read from
it. A short TLV at the end of the response causes an out-of-bounds read,
for example of the eight-byte chip capability.

Skip a TLV that is too short for the fields its parser reads.

Fixes: f7d2958ca461 ("mt76: connac: add mt76_connac_mcu_get_nic_capability utility routine")
Fixes: 8c94f0e63bb3 ("mt76: connac: extend mcu_get_nic_capability")
Fixes: 4fc8df50fd41 ("wifi: mt76: mt7921: get regulatory information from the clc event")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 24 +++++++++++++------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 79fead3ccce1..9b2fa1db7642 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -546,7 +546,7 @@ static int mt7921_load_clc(struct mt792x_dev *dev, const char *fw_name)
 }
 
 static void mt7921_mcu_parse_tx_resource(struct mt76_dev *dev,
-					 struct sk_buff *skb)
+					 struct sk_buff *skb, int len)
 {
 	struct mt76_sdio *sdio = &dev->sdio;
 	struct mt7921_tx_resource {
@@ -561,6 +561,9 @@ static void mt7921_mcu_parse_tx_resource(struct mt76_dev *dev,
 		u8 pad[3];
 	} __packed * tx_res;
 
+	if (len < offsetofend(struct mt7921_tx_resource, pp_padding))
+		return;
+
 	tx_res = (struct mt7921_tx_resource *)skb->data;
 	sdio->sched.pse_data_quota = le32_to_cpu(tx_res->pse_data_quota);
 	sdio->pse_mcu_quota_max = le32_to_cpu(tx_res->pse_mcu_quota);
@@ -573,7 +576,7 @@ static void mt7921_mcu_parse_tx_resource(struct mt76_dev *dev,
 }
 
 static void mt7921_mcu_parse_phy_cap(struct mt76_dev *dev,
-				     struct sk_buff *skb)
+				     struct sk_buff *skb, int len)
 {
 	struct mt7921_phy_cap {
 		u8 ht;
@@ -595,6 +598,9 @@ static void mt7921_mcu_parse_phy_cap(struct mt76_dev *dev,
 		WF0_5G
 	};
 
+	if (len < offsetofend(struct mt7921_phy_cap, hw_path))
+		return;
+
 	cap = (struct mt7921_phy_cap *)skb->data;
 
 	dev->phy.antenna_mask = BIT(cap->nss) - 1;
@@ -644,21 +650,25 @@ static int mt7921_mcu_get_nic_capability(struct mt792x_phy *mphy)
 
 		switch (le32_to_cpu(tlv->type)) {
 		case MT_NIC_CAP_6G:
-			phy->cap.has_6ghz = skb->data[0];
+			if (len)
+				phy->cap.has_6ghz = skb->data[0];
 			break;
 		case MT_NIC_CAP_MAC_ADDR:
-			memcpy(phy->macaddr, (void *)skb->data, ETH_ALEN);
+			if (len >= ETH_ALEN)
+				memcpy(phy->macaddr, (void *)skb->data, ETH_ALEN);
 			break;
 		case MT_NIC_CAP_PHY:
-			mt7921_mcu_parse_phy_cap(phy->dev, skb);
+			mt7921_mcu_parse_phy_cap(phy->dev, skb, len);
 			break;
 		case MT_NIC_CAP_TX_RESOURCE:
 			if (mt76_is_sdio(phy->dev))
 				mt7921_mcu_parse_tx_resource(phy->dev,
-							     skb);
+							     skb, len);
 			break;
 		case MT_NIC_CAP_CHIP_CAP:
-			memcpy(&mphy->chip_cap, (void *)skb->data, sizeof(u64));
+			if (len >= sizeof(u64))
+				memcpy(&mphy->chip_cap, (void *)skb->data,
+				       sizeof(u64));
 			break;
 		default:
 			break;
-- 
2.47.3

