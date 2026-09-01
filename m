Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E94470E81
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 09:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788254565; cv=none; b=KRk2qovU9V67F+aY/ZmK9W0/Yn65syqp5+gWKcv2LlhSOGa5JldDFHvsIIl9vKVOL6sLO6Toie/jndlfkAxkNuPOrdwqzciRaANAs3yHSFh2e7NmnSkXoDohAxYSxtWzoAd7HRdlsRg8iv81SXBPE7kOn83vfl5rIH2KaG3tqCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788254565; c=relaxed/simple;
	bh=BMiEawLOn/49/4q2/00+IZbZfLIz0tM7W2cWqINpcCQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=kD0DLm92aTYOzTS3qpSL0masnMKE4oLPS5PaEmQ0DOacj+xax8WDVEY5Rd7gWWMQiDmxNrShVZIP+T5aobV5yBnkauUSIbJWVlgYojsMczMlu3TteQLlk3tKtKGEnF/VT2PXsUit4BnEnq+wps4j+MGT/lcAseilxzmwcmGqtBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=kPHs1ZuW; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="kPHs1ZuW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cT0d2TxaVWL9BZRjMZDH5TdJy0gneavRUlBVpQfyznI=; b=kPHs1ZuWS7A8sFWnGwN/5Pw1Ud
	rdDH5sJqnF1wXNf45Y/Qr34aK6VrJbYR3p12tUKD6HWtr6BCp9uEovolWkbJfoNJtbBoyp/7wjJYv
	Do1id7Qnni+X3gs/FeCqn+gWKCdZP82dnvwZ06X4//ttPXz/MNYsXYgxVPAAx/scLt98=;
Received: from p200300cadf14d1000000000000000162.dip0.t-ipconnect.de ([2003:ca:df14:d100::162] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x1KhO-00CF4r-2S
	for linux-wireless@vger.kernel.org;
	Tue, 01 Sep 2026 11:22:34 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-fixes] wifi: mt76: use ALTX queue for packets to disassociated stations
Date: Tue,  1 Sep 2026 11:22:32 +0200
Message-ID: <20260901092232.461379-1-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Running these packets through regular buffering queues could cause them
to hang, especially when the packets were for stations that in disassoc
state.

Fixes: dedf2ec30fe4 ("wifi: mt76: fix queue assignment for deauth packets")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 2 ++
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 1 +
 drivers/net/wireless/mediatek/mt76/tx.c          | 3 ++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index a8286f8becf9..a03d89aabe80 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -805,6 +805,7 @@ __mt7915_drop_sta(void *ptr, u8 *mac, struct ieee80211_vif *vif)
 
 	msta = (struct mt7915_sta *)sta->drv_priv;
 	mt7915_mcu_add_sta(data->dev, vif, sta, CONN_STATE_DISCONNECT, false);
+	msta->wcid.tx_info &= ~MT_WCID_TX_INFO_SET;
 	msta->wcid.sta_disabled = 1;
 	msta->wcid.sta = 0;
 }
@@ -871,6 +872,7 @@ int mt7915_mac_sta_event(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 		mutex_unlock(&dev->mt76.mutex);
 
 		mt7915_mcu_add_sta(dev, vif, sta, CONN_STATE_DISCONNECT, false);
+		msta->wcid.tx_info &= ~MT_WCID_TX_INFO_SET;
 		msta->wcid.sta_disabled = 1;
 		msta->wcid.sta = 0;
 		return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index d17d1dbb2038..dd7a01c02a7c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1433,6 +1433,7 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			else if (sta->mlo && links == BIT(link_id)) /* last link */
 				mt7996_mcu_teardown_mld_sta(dev, link,
 							    msta_link);
+			msta_link->wcid.tx_info &= ~MT_WCID_TX_INFO_SET;
 			msta_link->wcid.sta_disabled = 1;
 			msta_link->wcid.sta = 0;
 			links = links & ~BIT(link_id);
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index b1e894b19cbd..3c623df2e741 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -680,7 +680,8 @@ mt76_txq_schedule_pending_wcid(struct mt76_phy *phy, struct mt76_wcid *wcid,
 		if ((dev->drv->drv_flags & MT_DRV_HW_MGMT_TXQ) &&
 		    !(info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) &&
 		    !ieee80211_is_data_present(hdr->frame_control) &&
-		    (!ieee80211_is_bufferable_mmpdu(skb) ||
+		    (!(wcid->tx_info & MT_WCID_TX_INFO_SET) ||
+		     !ieee80211_is_bufferable_mmpdu(skb) ||
 		     ieee80211_is_deauth(hdr->frame_control) ||
 		     ieee80211_is_disassoc(hdr->frame_control) ||
 		     head == &wcid->tx_offchannel))
-- 
2.47.3

