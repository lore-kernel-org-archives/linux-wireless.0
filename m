Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC534477F1
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 11:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791372282; cv=none; b=ocBASbe5bdNm5gFhYRsF22HsEr+Oek7KQk+usTN6fg16Fv35HXFJ6oOerQNt9nJ2mhaPrAt5AlXYuFAEVyuimrQCaBI9fQLOvqGcepHOqjw0PDLtCESfuY5rXciA0a5rsFLBg6OR6IPc4/KGnE5+gbXL2GJxZ99eirneGaw0TMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791372282; c=relaxed/simple;
	bh=4A8SCeLiR3OzKKv83B3VxCeJZJ4BLTHbI4QYFwJQrj0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sblNYJdVHzHpKEAOc3/jr0mVps2whmEsoWXonVlngo32FKedBb2xS32JIySH+8ajKeW3NA1k/2k4Uw4rxhN1eq+PyKZDFnn0RxDUBo3MRwy3xAQ5OSO96H8VQr5se6lvEe21/Pr2QxedTmLXk7xUs+NrOqVyjVGYqwfJQ14ZPmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=tiXZYjwD; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="tiXZYjwD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VRjLsRBIei81EuA1i93DAK5fRVuzQB6mcNviAtGTz64=; b=tiXZYjwDTUrlCMNG/qirvoHIgS
	j/A4PjwyDXeRjgiPOfFcbz8/Cb0kc0IFxngl4EtXPmBdQHP2au6acM3khQSNSI1CEaJWusUtio2yR
	MBG14FjjFg4uV66pg8KuB3s5ETeuWD9gD27raRvr17j/z21mwVvshMOOSoonlpRe0z9w=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xEPl1-00HY5A-1s
	for linux-wireless@vger.kernel.org;
	Wed, 07 Oct 2026 13:24:23 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 5/9] wifi: mt76: remove the unused signal field from struct mt76_rx_status
Date: Wed,  7 Oct 2026 13:24:15 +0200
Message-ID: <20261007112419.1277594-5-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261007112419.1277594-1-nbd@nbd.name>
References: <20261007112419.1277594-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt76_rx_convert() computes the signal for mac80211 from the chain
signals and overwrites the value of the signal field of struct
mt76_rx_status. Since mt792x_mac_rssi_iter() also uses the chain
signals, no code reads the field. mt7921_mac_fill_rx() is the last
driver that still sets it.

Remove the field and its computation in mt7921_mac_fill_rx().

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c   |  1 -
 drivers/net/wireless/mediatek/mt76/mt76.h       |  1 -
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 11 +----------
 3 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 48349bbc5a8f..2584c0e2a2c9 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1297,7 +1297,6 @@ mt76_rx_convert(struct mt76_dev *dev, struct sk_buff *skb,
 	status->rate_idx = mstat.rate_idx;
 	status->nss = mstat.nss;
 	status->band = mstat.band;
-	status->signal = mstat.signal;
 	status->chains = mstat.chains;
 	status->ampdu_reference = mstat.ampdu_ref;
 	status->device_timestamp = mstat.timestamp;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index e9bbec1269fa..93576472f5af 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -767,7 +767,6 @@ struct mt76_rx_status {
 	u8 amsdu:1, first_amsdu:1, last_amsdu:1;
 	u8 rate_idx;
 	u8 nss:5, band:3;
-	s8 signal;
 	u8 chains;
 	s8 chain_signal[IEEE80211_MAX_CHAINS];
 };
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index ad1352ddf1fc..6f5e31489e2d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -188,7 +188,7 @@ mt7921_mac_fill_rx(struct mt792x_dev *dev, struct sk_buff *skb)
 	u16 seq_ctrl = 0;
 	__le16 fc = 0;
 	u8 mode = 0;
-	int i, idx;
+	int idx;
 
 	memset(status, 0, sizeof(*status));
 
@@ -368,15 +368,6 @@ mt7921_mac_fill_rx(struct mt792x_dev *dev, struct sk_buff *skb)
 		status->chain_signal[1] = to_rssi(MT_PRXV_RCPI1, v1);
 		status->chain_signal[2] = to_rssi(MT_PRXV_RCPI2, v1);
 		status->chain_signal[3] = to_rssi(MT_PRXV_RCPI3, v1);
-		status->signal = -128;
-		for (i = 0; i < hweight8(mphy->antenna_mask); i++) {
-			if (!(status->chains & BIT(i)) ||
-			    status->chain_signal[i] >= 0)
-				continue;
-
-			status->signal = max(status->signal,
-					     status->chain_signal[i]);
-		}
 	}
 
 	amsdu_info = FIELD_GET(MT_RXD4_NORMAL_PAYLOAD_FORMAT, rxd4);
-- 
2.47.3

