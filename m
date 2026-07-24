Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35722931D5
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 12:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784897303; cv=none; b=HH9ng2I+oQ21dk6iy8M/4fMIBsbS7TgeFOfjFtK0swPKBFgCpb+DzCiUvpBj/uP6Cd/Y7FDISSNAvao0SCat5ENo+xkvEP33St7wZUMnNlChiJY9hT7e09gOt5XMbmypfg8oUY7TmcAdZO9+uAf8DHYRq0+YogZPt3luE8BeoMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784897303; c=relaxed/simple;
	bh=5hxjgdl9Y8IHtqWM0qruOIbOa5Tvmft+ke3YssanMcg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVNk1+sUrph3v2M0q2YjFQHiWBfJQbTIdp3TEzgwqC6NU/5WE42qq0G1FukBc8Ik6hSVB4NckIDzjvX/6ZKJTNOXta0eKr/vkutAIU7fcydfm9nD+NjtX03znxLUvV9h+vpWhQ8NKezzJtsW3+sIeFmZaz6VdM6hqm2UR9ZP2TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=fwChQoo3; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="fwChQoo3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dFM6cKC3pl49xPM00Gr0jDacmQ7neSOxaY2k2TF2Jd0=; b=fwChQoo3+TpfI3WERn28DmIaN8
	JabDVcf3OdSjKypeEN/zjLFIUf6KbhuQcCY/moj1VkNv+9GkDpTCuePdI+Bzq5Cft1W3eVbFZ59sN
	3jTxz59TiOPBWt7g1BKVzizlxZhg5EpMw5aO1vHLdD/QlZpONxf/Ms7zFIt8aSIJ183o=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wnFK7-006LeO-1i
	for linux-wireless@vger.kernel.org;
	Fri, 24 Jul 2026 14:48:19 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 23/29] wifi: mt76: mt7615: fix NULL deref in mt7615_mac_set_rates
Date: Fri, 24 Jul 2026 12:48:07 +0000
Message-ID: <20260724124813.3961474-23-nbd@nbd.name>
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

mt7615_tx() falls back to the vif BSS wcid when mac80211 hands a frame
over without a station, e.g. while a station is being torn down, and to
the global wcid when there is no vif either. Both tx_prepare_skb
implementations derive a mt7615_sta from that wcid unconditionally and,
if the rate control probe flag is set, pass it to mt7615_mac_set_rates(),
which dereferences the NULL vif backpointer of the per-vif embedded sta:

  Unable to handle kernel read from unreadable memory at virtual
  address 0000000000000002
  ...
  pc : mt7615_mac_set_rates
  lr : mt7615_tx_prepare_skb

Neither entry is rate controlled by mac80211: the embedded sta has an
empty rate set, and for the global wcid the container_of does not yield a
valid mt7615_sta at all. Only resolve the sta for wcids that belong to a
station.

Reported-by: Chad Monroe <chad@monroe.io>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c  | 5 +++--
 drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c
index 53cb1eed1e4f..0aca590f2bae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c
@@ -68,10 +68,11 @@ int mt7615_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	int pid, id;
 	u8 *txwi = (u8 *)txwi_ptr;
 	struct mt76_txwi_cache *t;
-	struct mt7615_sta *msta;
+	struct mt7615_sta *msta = NULL;
 	void *txp;
 
-	msta = wcid ? container_of(wcid, struct mt7615_sta, wcid) : NULL;
+	if (wcid && wcid->sta)
+		msta = container_of(wcid, struct mt7615_sta, wcid);
 	if (!wcid)
 		wcid = &dev->mt76.global_wcid;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c b/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
index f4169de939c4..9525d8062b44 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
@@ -187,10 +187,11 @@ int mt7663_usb_sdio_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	struct sk_buff *skb = tx_info->skb;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_key_conf *key = info->control.hw_key;
-	struct mt7615_sta *msta;
+	struct mt7615_sta *msta = NULL;
 	int pad, err, pktid;
 
-	msta = wcid ? container_of(wcid, struct mt7615_sta, wcid) : NULL;
+	if (wcid && wcid->sta)
+		msta = container_of(wcid, struct mt7615_sta, wcid);
 	if (!wcid)
 		wcid = &dev->mt76.global_wcid;
 
-- 
2.53.0

