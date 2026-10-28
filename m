Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793190258;
	b=YHYLvrjdsurCiCkfZ/WJoxKYA1hMaXA7F4AZFQ/QH8p/o/YGZHVG0LWkIDyGuK3/+qSr
	 7N3/OOraQs0YHmXU7wOZnMR9//y8/0jg5CLQp8OxzmUk0eE942KdsUQBd33xuOLEH39yz
	 QtELJc87BSivKvido59k5Uu9FsDUnruXaRJN1/rPb6Ps4ipJ5F33jMk0+0wsrsgi2fr0W
	 mfOu0Kn3rtqLFApWJTcLdyi73Qp2LYrfbu3KlbbyToES7zhlYv85Yub08/Y82fdsveZTu
	 eZN08XUnZ5jlNl3k9bPQVRjJy4fL9Ufbjs4ce0XTGB31UdcGTt/pjPUoFzaeDn5qf6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793190258;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YDUAf4ivJekhuV8kDqVBq001+yqpK3G08cDwqgIWTdQ=;
	b=xsGqKbsQwIEmuTR3cBIEpugdUSHSHXZntgzTAD7vz9mVtgx83Ix+mXUQOhGKjRS/65MJ
	 gA9XKBX4v0KaZqtbxoOKc+13pgyFlAVAiI0i9nxqkTXLrsgUWbOdSpJWCkDg+MgUiq2ik
	 SCVFcZCwMdc8WQ6ZgYAq3sNBqevreMixdT6p8VkL3bOtnb76gQ0HY9af29T+vovatPLN5
	 ou78SXzQM3IB5s8YEbtScDf2EI+GaJBMromW5nWuUi7QV1IiHVkJGj1b4MzEfC5PRXXs3
	 Al9at9q++CyihOafY1WmNaqN+/u4GivU+rjElfmmKPFvAXNS/nX5b6LeRrA36UMAvyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=hRcYnix4;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D69606A336
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:24:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27D69606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=hRcYnix4
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YDUAf4ivJekhuV8kDqVBq001+yqpK3G08cDwqgIWTdQ=; b=hRcYnix4wh6zAlnq/K14jayOD2
	FDT6VSRRxSAYGA2KioECV66Vp6Y5XtTLRn+L15WFo/5T63xu2VJbRCLwxJ8ZbU+klbCZ3I/lPINPH
	o7dWvouss5VbtZmMwztkcOmMEAeeEeoVh1yV42xr0vgUQn4Br17kLIarOY5/1FUNC6cs=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xM2hN-00C8Bw-3D
	for linux-wireless@vger.kernel.org;
	Wed, 28 Oct 2026 13:24:10 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 23/25] wifi: mt76: check the RX PN of an MLD peer once per peer
Date: Wed, 28 Oct 2026 13:24:01 +0100
Message-ID: <20261028122403.796394-23-nbd@nbd.name>
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

For a frame that the hardware decrypted, mt76_check_ccmp_pn() compares
the PN with the last PN of status->wcid. For an MLD peer, mt7996 reports
each frame on the wcid of the link it arrived on, so every link keeps
its own replay counter, although all links of the MLD share the PN space
of the key. With the IV stripped, the function also sets
RX_FLAG_PN_VALIDATED, so mac80211 skips its own check per key. A frame
received on one link and replayed on another one thus passes the replay
check whenever the second link has seen lower PNs.

Keep the replay counters of a peer on its default wcid (def_wcid), like
the reorder state in mt76_rx_aggr_reorder(). The key check still uses
the wcid of the link. This also applies to mt7925, which sets def_wcid
for the links of an MLD station.

A key install resets these counters to the RX sequence of the key in
mac80211, which frames marked RX_FLAG_PN_VALIDATED never advance. In
mt7996 and mt7925, the key of a station is set up link by link, and in
mt7996 a link that is added later gets the installed keys again. Each
of these setups would reset the counters of the whole peer, so that a
frame of the new key received on one link could be replayed after the
setup of the next one. Seed the counters on the default wcid once per
key install, before the key reaches any link of the station, and only
enable the check on each link.

Fixes: dd82a9e02c05 ("wifi: mt76: mt7996: Rely on mt7996_sta_link in sta_add/sta_remove callbacks")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c  | 18 ++++++++----------
 drivers/net/wireless/mediatek/mt76/mt76.h      |  7 +++++++
 .../net/wireless/mediatek/mt76/mt7925/main.c   | 13 +++++++++++--
 .../net/wireless/mediatek/mt76/mt7996/main.c   | 11 ++++++++++-
 4 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 76908bd835f2..08ed3fc6d386 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1209,16 +1209,10 @@ void mt76_wcid_key_setup(struct mt76_dev *dev, struct mt76_wcid *wcid,
 	struct ieee80211_key_seq seq;
 	int i;
 
-	wcid->rx_check_pn = false;
-
-	if (!key)
+	mt76_wcid_key_link_setup(wcid, key);
+	if (!wcid->rx_check_pn)
 		return;
 
-	if (key->cipher != WLAN_CIPHER_SUITE_CCMP)
-		return;
-
-	wcid->rx_check_pn = true;
-
 	/* data frame */
 	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
 		ieee80211_get_key_rx_seq(key, i, &seq);
@@ -1327,6 +1321,7 @@ mt76_check_ccmp_pn(struct sk_buff *skb)
 	struct mt76_rx_status *status = (struct mt76_rx_status *)skb->cb;
 	struct mt76_wcid *wcid = status->wcid;
 	struct ieee80211_hdr *hdr;
+	struct mt76_wcid *pn_wcid;
 	int security_idx;
 	int ret;
 
@@ -1339,6 +1334,9 @@ mt76_check_ccmp_pn(struct sk_buff *skb)
 	if (!wcid || !wcid->rx_check_pn)
 		return;
 
+	/* the links of an MLD peer share one PN space per key */
+	pn_wcid = mt76_wcid_primary(wcid);
+
 	security_idx = status->qos_ctl & IEEE80211_QOS_CTL_TID_MASK;
 	if (status->flag & RX_FLAG_8023)
 		goto skip_hdr_check;
@@ -1366,14 +1364,14 @@ mt76_check_ccmp_pn(struct sk_buff *skb)
 
 skip_hdr_check:
 	BUILD_BUG_ON(sizeof(status->iv) != sizeof(wcid->rx_key_pn[0]));
-	ret = memcmp(status->iv, wcid->rx_key_pn[security_idx],
+	ret = memcmp(status->iv, pn_wcid->rx_key_pn[security_idx],
 		     sizeof(status->iv));
 	if (ret <= 0) {
 		status->flag |= RX_FLAG_ONLY_MONITOR;
 		return;
 	}
 
-	memcpy(wcid->rx_key_pn[security_idx], status->iv, sizeof(status->iv));
+	memcpy(pn_wcid->rx_key_pn[security_idx], status->iv, sizeof(status->iv));
 
 	if (status->flag & RX_FLAG_IV_STRIPPED)
 		status->flag |= RX_FLAG_PN_VALIDATED;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index fce7bf2f0333..477d33a0022d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1574,6 +1574,13 @@ int mt76_rx_aggr_start(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tid,
 		       u16 ssn, u16 size);
 void mt76_rx_aggr_stop(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tid);
 
+static inline void
+mt76_wcid_key_link_setup(struct mt76_wcid *wcid,
+			 struct ieee80211_key_conf *key)
+{
+	wcid->rx_check_pn = key && key->cipher == WLAN_CIPHER_SUITE_CCMP;
+}
+
 void mt76_wcid_key_setup(struct mt76_dev *dev, struct mt76_wcid *wcid,
 			 struct ieee80211_key_conf *key);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 22cc5b49da0a..ffbc6b954632 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -707,8 +707,11 @@ static int mt7925_set_link_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	else
 		goto out;
 
-	mt76_wcid_key_setup(&dev->mt76, wcid,
-			    cmd == SET_KEY ? key : NULL);
+	if (sta)
+		mt76_wcid_key_link_setup(wcid, cmd == SET_KEY ? key : NULL);
+	else
+		mt76_wcid_key_setup(&dev->mt76, wcid,
+				    cmd == SET_KEY ? key : NULL);
 
 	err = mt7925_mcu_add_key(&dev->mt76, vif, &mlink->bip,
 				 key, MCU_UNI_CMD(STA_REC_UPDATE),
@@ -749,6 +752,12 @@ static int mt7925_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	mt792x_mutex_acquire(dev);
 
+	/* the links of a station share one RX PN state, seeded before the
+	 * key reaches any of them
+	 */
+	if (sta && cmd == SET_KEY)
+		mt76_wcid_key_setup(&dev->mt76, &msta->deflink.wcid, key);
+
 	if (ieee80211_vif_is_mld(vif)) {
 		unsigned int link_id;
 		unsigned long add;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index ec7c5e8f3fda..82143ade1cc0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -268,7 +268,7 @@ mt7996_set_hw_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (cmd != SET_KEY && !is_bigtk)
 		return 0;
 
-	mt76_wcid_key_setup(&dev->mt76, &msta_link->wcid, key);
+	mt76_wcid_key_link_setup(&msta_link->wcid, key);
 
 	err = mt7996_mcu_add_key(&dev->mt76, link, key,
 				 MCU_WMWA_UNI_CMD(STA_REC_UPDATE),
@@ -837,6 +837,15 @@ static int mt7996_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	else
 		links = BIT(0);
 
+	/* the links of a station share one RX PN state, seeded before the
+	 * key reaches any of them
+	 */
+	if (sta && cmd == SET_KEY) {
+		struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+
+		mt76_wcid_key_setup(&dev->mt76, &msta->deflink.wcid, key);
+	}
+
 	for_each_set_bit(link_id, &links, IEEE80211_MLD_MAX_NUM_LINKS) {
 		err = mt7996_set_hw_key(hw, cmd, vif, sta, link_id, key);
 		if (err)
-- 
2.47.3

